from datetime import timedelta
from decimal import Decimal
from unittest.mock import patch

import requests
from django.contrib.auth.models import User
from django.utils import timezone
from rest_framework import status
from rest_framework.test import APITestCase

from cards.models import Card
from .models import Transaction


# replace the real FastAPI call with a fake one in tests
PAYMENT_CALL = 'transactions.views.process_payment_with_fastapi'


def make_card(user, last_four='4242'):
    return Card.objects.create(
        user=user,
        card_type='CREDIT',
        masked_card='**** **** **** ' + last_four,
        last_four=last_four,
        expiry_month=12,
        expiry_year=2030,
    )


class PaymentTests(APITestCase):

    def setUp(self):
        self.user = User.objects.create_user(
            username='payer', email='payer@example.com', password='StrongPass@2026'
        )
        self.card = make_card(self.user)
        self.client.force_authenticate(user=self.user)

    def pay(self, amount='500.00', card=None):
        card = card or self.card
        return self.client.post(
            '/api/transactions/',
            {'card': card.id, 'amount': amount, 'description': 'Test payment'},
            format='json'
        )

    @patch(PAYMENT_CALL)
    def test_payment_success(self, mock_pay):
        mock_pay.return_value = {'status': 'SUCCESS'}

        response = self.pay()

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        txn = Transaction.objects.get(user=self.user)
        self.assertEqual(txn.status, 'SUCCESS')
        self.assertIsNotNone(txn.completed_at)

    @patch(PAYMENT_CALL)
    def test_payment_failed(self, mock_pay):
        mock_pay.return_value = {'status': 'FAILED', 'failure_reason': 'Declined by bank'}

        response = self.pay()

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        txn = Transaction.objects.get(user=self.user)
        self.assertEqual(txn.status, 'FAILED')
        self.assertEqual(txn.failure_reason, 'Declined by bank')

    @patch(PAYMENT_CALL)
    def test_status_is_pending_first(self, mock_pay):
        seen = {}

        def fake_payment(**kwargs):
            # check the saved status while "FastAPI" is working
            seen['status'] = Transaction.objects.get(user=self.user).status
            return {'status': 'SUCCESS'}

        mock_pay.side_effect = fake_payment
        self.pay()

        self.assertEqual(seen['status'], 'PENDING')

    @patch(PAYMENT_CALL)
    def test_payment_service_down(self, mock_pay):
        mock_pay.side_effect = requests.ConnectionError()

        response = self.pay()

        self.assertEqual(response.status_code, status.HTTP_502_BAD_GATEWAY)
        self.assertEqual(Transaction.objects.get(user=self.user).status, 'FAILED')

    @patch(PAYMENT_CALL)
    def test_cannot_use_other_users_card(self, mock_pay):
        other = User.objects.create_user(
            username='other', email='other@example.com', password='StrongPass@2026'
        )
        response = self.pay(card=make_card(other, '1111'))

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        mock_pay.assert_not_called()

    @patch(PAYMENT_CALL)
    def test_negative_amount(self, mock_pay):
        response = self.pay(amount='-50')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        mock_pay.assert_not_called()

    def test_payment_needs_login(self):
        self.client.force_authenticate(user=None)

        response = self.pay()

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class TransactionHistoryTests(APITestCase):

    def setUp(self):
        self.user = User.objects.create_user(
            username='viewer', email='viewer@example.com', password='StrongPass@2026'
        )
        self.client.force_authenticate(user=self.user)

        self.add('T1', '100.00', 'SUCCESS')
        self.add('T2', '2500.00', 'FAILED')
        old = self.add('T3', '800.00', 'SUCCESS')
        Transaction.objects.filter(pk=old.pk).update(
            created_at=timezone.now() - timedelta(days=10)
        )

    def add(self, txn_id, amount, txn_status):
        return Transaction.objects.create(
            transaction_id=txn_id, user=self.user,
            amount=Decimal(amount), status=txn_status,
        )

    def test_only_my_transactions(self):
        other = User.objects.create_user(
            username='x', email='x@example.com', password='StrongPass@2026'
        )
        Transaction.objects.create(transaction_id='OTHER', user=other, amount=10, status='SUCCESS')

        response = self.client.get('/api/transactions/')

        self.assertEqual(len(response.data), 3)

    def test_filter_status(self):
        response = self.client.get('/api/transactions/', {'status': 'success'})
        self.assertEqual(len(response.data), 2)

    def test_filter_amount(self):
        response = self.client.get(
            '/api/transactions/', {'min_amount': '500', 'max_amount': '1000'}
        )
        self.assertEqual(len(response.data), 1)

    def test_filter_date(self):
        today = timezone.localdate().isoformat()
        response = self.client.get(
            '/api/transactions/', {'date_from': today, 'date_to': today}
        )
        self.assertEqual(len(response.data), 2)

    def test_bad_filter_values(self):
        self.assertEqual(self.client.get('/api/transactions/', {'status': 'abc'}).status_code, 400)
        self.assertEqual(self.client.get('/api/transactions/', {'date_from': '11-10-2026'}).status_code, 400)
        self.assertEqual(self.client.get('/api/transactions/', {'min_amount': 'abc'}).status_code, 400)
