import uuid
from datetime import datetime, time, timedelta
from decimal import Decimal, InvalidOperation

import requests
from django.utils import timezone
from django.utils.dateparse import parse_date
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Transaction
from .payment_service import process_payment_with_fastapi
from .serializers import TransactionSerializer


VALID_STATUSES = ['PENDING', 'SUCCESS', 'FAILED']


def start_of_day(value):
    day = parse_date(value)
    if day is None:
        raise ValueError('bad date')
    return timezone.make_aware(datetime.combine(day, time.min))

class TransactionListCreateView(APIView):
    serializer_class = TransactionSerializer
    permission_classes = [IsAuthenticated]

    def get(self, request):
        transactions = Transaction.objects.filter(user=request.user).order_by('-created_at')
        params = request.query_params

        # status filter
        status_param = params.get('status')
        if status_param:
            status_param = status_param.upper()
            if status_param not in VALID_STATUSES:
                return Response({'detail': 'Invalid status.'}, status=status.HTTP_400_BAD_REQUEST)
            transactions = transactions.filter(status=status_param)

        # date and amount filters
        try:
            if params.get('date_from'):
                transactions = transactions.filter(
                    created_at__gte=start_of_day(params['date_from'])
                )
            if params.get('date_to'):
                # +1 day so the whole "to" day is included
                transactions = transactions.filter(
                    created_at__lt=start_of_day(params['date_to']) + timedelta(days=1)
                )
            if params.get('min_amount'):
                transactions = transactions.filter(amount__gte=Decimal(params['min_amount']))
            if params.get('max_amount'):
                transactions = transactions.filter(amount__lte=Decimal(params['max_amount']))
        except (ValueError, InvalidOperation):
            return Response(
                {'detail': 'Invalid date (use YYYY-MM-DD) or amount.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        serializer = TransactionSerializer(transactions, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = TransactionSerializer(data=request.data, context={'request': request})

        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        data = serializer.validated_data

        if data['amount'] <= 0:
            return Response(
                {'amount': ['Amount must be greater than zero.']},
                status=status.HTTP_400_BAD_REQUEST
            )

        card = data.get('card')
        if card is None or card.user_id != request.user.id:
            return Response(
                {'detail': 'Card not found or does not belong to you.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # step 1: save as PENDING
        transaction = serializer.save(
            user=request.user,
            transaction_id='TXN' + uuid.uuid4().hex[:12].upper(),
            status='PENDING',
        )

        # step 2: ask FastAPI to process it
        try:
            result = process_payment_with_fastapi(
                user_id=request.user.id,
                card_id=card.id,
                amount=data['amount'],
                currency=data.get('currency', 'INR'),
                payment_method=data.get('payment_method', 'CARD'),
                description=data.get('description'),
            )
        except (requests.RequestException, ValueError):
            transaction.status = 'FAILED'
            transaction.failure_reason = 'Payment service unavailable.'
            transaction.save()
            return Response(
                {
                    'detail': 'Payment processing failed. Please try again.',
                    'transaction': TransactionSerializer(transaction).data,
                },
                status=status.HTTP_502_BAD_GATEWAY
            )

        # step 3: save the final status
        if result.get('status') == 'SUCCESS':
            transaction.status = 'SUCCESS'
            transaction.failure_reason = None
            transaction.completed_at = timezone.now()
        else:
            transaction.status = 'FAILED'
            transaction.failure_reason = result.get('failure_reason') or 'Payment declined.'

        transaction.save()

        return Response(TransactionSerializer(transaction).data, status=status.HTTP_201_CREATED)

class TransactionDetailView(APIView):
    serializer_class = TransactionSerializer
    permission_classes = [IsAuthenticated]
    
    def get(self, request, transaction_id):
        try:
            transaction = Transaction.objects.get(
                transaction_id=transaction_id, user=request.user
            )
        except Transaction.DoesNotExist:
            return Response({'detail': 'Transaction not found.'}, status=status.HTTP_404_NOT_FOUND)

        return Response(TransactionSerializer(transaction).data)

