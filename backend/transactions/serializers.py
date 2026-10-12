from datetime import date

from rest_framework import serializers

from .models import Transaction


class TransactionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Transaction
        fields = [
            'id',
            'transaction_id',
            'user',
            'card',
            'amount',
            'currency',
            'payment_method',
            'status',
            'description',
            'failure_reason',
            'created_at',
            'updated_at',
            'completed_at',
        ]
        read_only_fields = [
            'id',
            'transaction_id',
            'user',
            'status',
            'failure_reason',
            'created_at',
            'updated_at',
            'completed_at',
        ]

    def validate_amount(self, value):
        if value <= 0:
            raise serializers.ValidationError("Transaction amount must be greater than 0.")
        return value

    def validate_currency(self, value):
        value = value.upper()
        if len(value) != 3:
            raise serializers.ValidationError("Currency must contain exactly 3 characters.")
        return value

    def validate_payment_method(self, value):
        if value != 'CARD':
            raise serializers.ValidationError("Only CARD payment method is supported.")
        return value

    def validate_card(self, card):
        request = self.context.get('request')

        if request and card.user != request.user:
            raise serializers.ValidationError("You can only use your own card.")

        today = date.today()
        expired = (
            card.expiry_year < today.year
            or (card.expiry_year == today.year and card.expiry_month < today.month)
        )
        if expired:
            raise serializers.ValidationError("This card has expired.")

        return card
