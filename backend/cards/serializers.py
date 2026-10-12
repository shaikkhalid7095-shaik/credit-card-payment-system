from datetime import date

from rest_framework import serializers

from .models import Card


class CardSerializer(serializers.ModelSerializer):
    # only used to make the masked number, never saved
    card_number = serializers.CharField(write_only=True, min_length=13, max_length=19)

    class Meta:
        model = Card
        fields = [
            'id',
            'card_type',
            'card_number',
            'masked_card',
            'last_four',
            'expiry_month',
            'expiry_year',
            'created_at',
            'updated_at',
        ]
        read_only_fields = ['id', 'masked_card', 'last_four', 'created_at', 'updated_at']

    def validate_card_number(self, value):
        if not value.isdigit():
            raise serializers.ValidationError("Card number must contain only digits.")

        if not 13 <= len(value) <= 19:
            raise serializers.ValidationError("Card number must contain between 13 and 19 digits.")

        if not self.luhn_check(value):
            raise serializers.ValidationError("Invalid card number.")

        return value

    def validate_expiry_month(self, value):
        if value < 1 or value > 12:
            raise serializers.ValidationError("Expiry month must be between 1 and 12.")
        return value

    def validate_expiry_year(self, value):
        current_year = date.today().year

        if value < current_year:
            raise serializers.ValidationError("Card has expired.")

        if value > current_year + 20:
            raise serializers.ValidationError("Invalid expiry year.")

        return value

    def validate(self, attrs):
        month = attrs.get('expiry_month')
        year = attrs.get('expiry_year')
        today = date.today()

        if month and year and year == today.year and month < today.month:
            raise serializers.ValidationError({"expiry": "Card has expired."})

        return attrs

    @staticmethod
    def luhn_check(card_number):
        # standard Luhn check used by card companies
        digits = [int(d) for d in card_number]
        checksum = 0
        parity = len(digits) % 2

        for index, digit in enumerate(digits):
            if index % 2 == parity:
                digit *= 2
                if digit > 9:
                    digit -= 9
            checksum += digit

        return checksum % 10 == 0

    def create(self, validated_data):
        card_number = validated_data.pop('card_number')
        last_four = card_number[-4:]

        return Card.objects.create(
            user=self.context['request'].user,
            masked_card="**** **** **** " + last_four,
            last_four=last_four,
            **validated_data
        )
