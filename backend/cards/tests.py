from django.contrib.auth.models import User

from rest_framework import status
from rest_framework.test import APITestCase

from .models import Card


class CardManagementTests(APITestCase):

    def setUp(self):

        self.user = User.objects.create_user(
            username='carduser',
            email='carduser@example.com',
            password='Password123'
        )

        self.client.force_authenticate(
            user=self.user
        )

        self.card_url = '/api/cards/'

    def test_add_card(self):

        data = {
            'card_type': 'CREDIT',
            'card_number': '4111111111111111',
            'expiry_month': 12,
            'expiry_year': 2030
        }

        response = self.client.post(
            self.card_url,
            data,
            format='json'
        )

        self.assertEqual(
            response.status_code,
            status.HTTP_201_CREATED
        )

        card = Card.objects.get(
            user=self.user
        )

        self.assertEqual(
            card.last_four,
            '1111'
        )

        self.assertEqual(
            card.masked_card,
            '**** **** **** 1111'
        )

    def test_full_card_number_is_not_stored(self):

        data = {
            'card_type': 'CREDIT',
            'card_number': '4111111111111111',
            'expiry_month': 12,
            'expiry_year': 2030
        }

        self.client.post(
            self.card_url,
            data,
            format='json'
        )

        card = Card.objects.get(
            user=self.user
        )

        self.assertFalse(
            hasattr(card, 'card_number')
        )

    def test_view_cards(self):

        Card.objects.create(
            user=self.user,
            card_type='CREDIT',
            masked_card='**** **** **** 1111',
            last_four='1111',
            expiry_month=12,
            expiry_year=2030
        )

        response = self.client.get(
            self.card_url
        )

        self.assertEqual(
            response.status_code,
            status.HTTP_200_OK
        )

        self.assertEqual(
            len(response.data),
            1
        )

    def test_delete_card(self):

        card = Card.objects.create(
            user=self.user,
            card_type='DEBIT',
            masked_card='**** **** **** 2222',
            last_four='2222',
            expiry_month=12,
            expiry_year=2030
        )

        response = self.client.delete(
            f'{self.card_url}{card.id}/'
        )

        self.assertEqual(
            response.status_code,
            status.HTTP_204_NO_CONTENT
        )

        self.assertFalse(
            Card.objects.filter(
                id=card.id
            ).exists()
        )