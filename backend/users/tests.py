from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.test import APITestCase


class AuthenticationTests(APITestCase):

    def setUp(self):
        self.password = 'StrongPass@2026'
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password=self.password
        )

    def login(self):
        return self.client.post(
            '/api/auth/login/',
            {'email': 'test@example.com', 'password': self.password},
            format='json'
        )

    def test_register(self):
        data = {
            'username': 'newuser',
            'email': 'new@example.com',
            'password': 'AnotherPass@2026'
        }
        response = self.client.post('/api/auth/register/', data, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(User.objects.filter(email='new@example.com').exists())

    def test_register_duplicate_email(self):
        data = {
            'username': 'someone',
            'email': 'test@example.com',
            'password': 'AnotherPass@2026'
        }
        response = self.client.post('/api/auth/register/', data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_password_is_hashed(self):
        self.assertNotEqual(self.user.password, self.password)
        self.assertTrue(self.user.check_password(self.password))

    def test_login(self):
        response = self.login()

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_login_wrong_password(self):
        response = self.client.post(
            '/api/auth/login/',
            {'email': 'test@example.com', 'password': 'wrongpass'},
            format='json'
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_profile_needs_token(self):
        response = self.client.get('/api/auth/profile/')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_profile_with_token(self):
        access = self.login().data['access']
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + access)

        response = self.client.get('/api/auth/profile/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['email'], 'test@example.com')

    def test_logout(self):
        tokens = self.login().data
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + tokens['access'])

        response = self.client.post(
            '/api/auth/logout/', {'refresh': tokens['refresh']}, format='json'
        )
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # the refresh token should be dead now
        response = self.client.post(
            '/api/auth/token/refresh/', {'refresh': tokens['refresh']}, format='json'
        )
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
