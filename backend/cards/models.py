from django.contrib.auth.models import User
from django.db import models


class Card(models.Model):

    CARD_TYPE_CHOICES = [
        ('CREDIT', 'Credit Card'),
        ('DEBIT', 'Debit Card'),
    ]

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='cards'
    )

    card_type = models.CharField(
        max_length=10,
        choices=CARD_TYPE_CHOICES
    )

    masked_card = models.CharField(
        max_length=25,
        blank=True,
        default=''
    )

    last_four = models.CharField(
        max_length=4,
        blank=True,
        default=''
    )

    expiry_month = models.PositiveSmallIntegerField(
        default=1
    )

    expiry_year = models.PositiveSmallIntegerField(
        default=2030
    )

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    updated_at = models.DateTimeField(
        auto_now=True
    )

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.card_type} ****{self.last_four}"