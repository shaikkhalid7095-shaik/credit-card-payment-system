from django.contrib.auth.models import User
from django.db import models

from cards.models import Card


class Transaction(models.Model):

    STATUS_CHOICES = [
        ('PENDING', 'Pending'),
        ('SUCCESS', 'Success'),
        ('FAILED', 'Failed'),
    ]

    PAYMENT_METHOD_CHOICES = [
        ('CARD', 'Card'),
    ]

    transaction_id = models.CharField(max_length=50, unique=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='transactions')
    card = models.ForeignKey(
        Card,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='transactions'
    )
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    currency = models.CharField(max_length=3, default='INR')
    payment_method = models.CharField(
        max_length=20, choices=PAYMENT_METHOD_CHOICES, default='CARD'
    )
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='PENDING')
    description = models.CharField(max_length=255, blank=True, null=True)
    failure_reason = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    completed_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return self.transaction_id
