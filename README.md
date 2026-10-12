# Credit Card Payment System

Backend for a credit card payment system.

- **Django + Django REST Framework**: users, JWT login, cards, transactions, admin panel
- **FastAPI**: separate service that processes (simulates) payments
- **MySQL**: database

## How it works

```
Client (Postman)
      |
      v
Django (port 8000) ---- POST /payments/ ----> FastAPI (port 8001)
      |                                           |
      +------------------ MySQL <-----------------+
```

1. User calls `POST /api/transactions/` on Django
2. Django saves the transaction with status **PENDING**
3. Django sends the payment to FastAPI (with a secret `X-Internal-Key` header)
4. FastAPI simulates the bank and returns **SUCCESS** or **FAILED**
5. Django updates the transaction with the final status

How the simulation decides:
- amount above 50,000 -> FAILED ("Amount exceeds card limit")
- otherwise about 80% SUCCESS, 20% FAILED ("Declined by bank")

If FastAPI is not running, the transaction is marked FAILED.

## Tech used

- Python, Django, Django REST Framework
- djangorestframework-simplejwt (JWT)
- FastAPI, Uvicorn, SQLAlchemy
- MySQL (mysqlclient for Django, PyMySQL for FastAPI)

## Modules

| Module | Done |
|---|---|
| 1. Authentication | Register, login with JWT, logout (refresh token blacklisted), hashed passwords, protected routes |
| 2. Cards | Add, view, delete. Full card number is never saved, only masked number and last 4 digits. No CVV |
| 3. Payments (FastAPI) | Make payment, simulated success/failure, PENDING -> SUCCESS / FAILED |
| 4. Transactions | History, filter by date, amount and status, CSV export from admin |
| 5. Admin panel | Manage users, view cards, view transactions, daily payment summary |
| 6. Database | users, cards, transactions tables + admin logs (MySQL) |

## Folder structure

```
credit-card-payment-system/
|-- backend/                 Django project
|   |-- django_core/         settings, urls
|   |-- users/               register, login, logout, profile
|   |-- cards/               card management
|   |-- transactions/        payments, history, filters, CSV export, daily summary
|   |-- postman/             Postman collection
|   |-- screenshots/
|   |-- manage.py
|   `-- requirements.txt
|-- payment_api/             FastAPI payment service
|   |-- app/
|   |   |-- routes/payment_routes.py
|   |   |-- crud.py
|   |   |-- database.py
|   |   |-- models.py
|   |   |-- schemas.py
|   |   `-- main.py
|   `-- requirements.txt
|-- db_dump.sql
`-- README.md
```

## Setup

Needs Python 3.11+ and MySQL 8+.

### 1. Database

```sql
CREATE DATABASE credit_card_payment_db;
```

To load the sample data instead:

```
mysql -u root -p credit_card_payment_db < db_dump.sql
```

### 2. Django

```
cd backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

Create `backend/.env`:

```
FASTAPI_INTERNAL_KEY=some-secret-key
```

Put your MySQL username and password in `django_core/settings.py` under `DATABASES`, then:

```
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

### 3. FastAPI (second terminal)

```
cd payment_api
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

Create `payment_api/.env` with the **same key** as Django:

```
FASTAPI_INTERNAL_KEY=some-secret-key
```

```
uvicorn app.main:app --reload --port 8001
```

Both servers must be running for payments to work.

### 4. Links

| What | URL |
|---|---|
| Django API | http://127.0.0.1:8000/api/ |
| Admin panel | http://127.0.0.1:8000/admin/ |
| Daily payment summary | http://127.0.0.1:8000/admin/transactions/transaction/daily-summary/ |
| FastAPI Swagger docs | http://127.0.0.1:8001/docs |

## API documentation

Postman collection: `backend/postman/credit_card_payment_system.postman_collection.json`.
Import it and run **Login** first. The token, card id and transaction id get saved
automatically for the other requests.

For protected endpoints send the access token as: `Authorization: Bearer <access token>`

### Auth

| Method | URL | Auth | Body / notes |
|---|---|---|---|
| POST | `/api/auth/register/` | No | `username`, `email`, `password` |
| POST | `/api/auth/login/` | No | `email`, `password` -> returns `access`, `refresh` |
| POST | `/api/auth/token/refresh/` | No | `refresh` -> new `access` |
| GET | `/api/auth/profile/` | Yes | logged in user's details |
| POST | `/api/auth/logout/` | Yes | `refresh` -> token is blacklisted |

### Cards

| Method | URL | Auth | Body / notes |
|---|---|---|---|
| POST | `/api/cards/` | Yes | `card_number`, `card_type`, `expiry_month`, `expiry_year` |
| GET | `/api/cards/` | Yes | my saved cards |
| GET | `/api/cards/<id>/` | Yes | one card |
| DELETE | `/api/cards/<id>/` | Yes | returns 204 |

Example response (card number is masked):

```json
{
  "id": 1,
  "card_type": "CREDIT",
  "masked_card": "**** **** **** 4242",
  "last_four": "4242",
  "expiry_month": 12,
  "expiry_year": 2030
}
```

### Transactions

| Method | URL | Auth | Body / notes |
|---|---|---|---|
| POST | `/api/transactions/` | Yes | `card`, `amount`, `description` (optional) |
| GET | `/api/transactions/` | Yes | my transactions, newest first |
| GET | `/api/transactions/<transaction_id>/` | Yes | one transaction |

Filters for `GET /api/transactions/`:

| Param | Example |
|---|---|
| `status` | `SUCCESS`, `FAILED`, `PENDING` |
| `date_from`, `date_to` | `2026-10-01` (YYYY-MM-DD) |
| `min_amount`, `max_amount` | `100`, `5000` |

```
GET /api/transactions/?status=SUCCESS&date_from=2026-10-01&min_amount=100
```

### FastAPI (internal, called by Django)

Needs header `X-Internal-Key`. Full docs at http://127.0.0.1:8001/docs

| Method | URL | Notes |
|---|---|---|
| POST | `/payments/` | process payment, returns SUCCESS or FAILED |
| GET | `/payments/<transaction_id>` | payment details |
| GET | `/payments/user/<user_id>` | payments of a user |
| GET | `/health` | health check |

## Database schema

### auth_user (Django's built-in users table)

| Column | Type | Notes |
|---|---|---|
| id | int | primary key |
| username | varchar(150) | unique |
| email | varchar(254) | used for login, unique |
| password | varchar(128) | hashed (PBKDF2), never plain text |
| is_staff, is_superuser | bool | admin access |
| date_joined | datetime | |

### cards_card

| Column | Type | Notes |
|---|---|---|
| id | bigint | primary key |
| user_id | FK -> auth_user | card owner |
| card_type | varchar | CREDIT / DEBIT |
| masked_card | varchar | `**** **** **** 4242` |
| last_four | varchar(4) | |
| expiry_month | int | |
| expiry_year | int | |
| created_at, updated_at | datetime | |

### transactions_transaction

| Column | Type | Notes |
|---|---|---|
| id | bigint | primary key |
| transaction_id | varchar(50) | unique |
| user_id | FK -> auth_user | |
| card_id | FK -> cards_card | set to NULL if the card is deleted |
| amount | decimal(12,2) | must be more than 0 |
| currency | varchar(3) | INR |
| payment_method | varchar(20) | CARD |
| status | varchar(10) | PENDING / SUCCESS / FAILED |
| description | varchar(255) | optional |
| failure_reason | varchar(255) | filled when FAILED |
| created_at, updated_at | datetime | |
| completed_at | datetime | filled when SUCCESS |

### django_admin_log (admin logs)

Django saves every add / edit / delete done in the admin panel here (who, when, what).

### Other tables

- `token_blacklist_outstandingtoken`, `token_blacklist_blacklistedtoken`: used for logout
- `payments`: FastAPI's own record of each payment

Relations:

```
auth_user 1 ---- * cards_card
auth_user 1 ---- * transactions_transaction
cards_card 1 --- * transactions_transaction
```

## Security

- Passwords hashed by Django
- JWT for all card and transaction APIs
- No CVV field at all, card number only used to make the masked value
- Input validation: amount > 0, valid dates, unique email, password strength
- Only Django ORM / SQLAlchemy queries, no raw SQL (protects against SQL injection)
- Users can only see and use their own cards and transactions
- FastAPI only accepts requests that have the secret internal key
- Secrets kept in `.env` files (not pushed to GitHub)

## Tests

```
cd backend
python manage.py test
```

Tests cover:
- Authentication: register, duplicate email, password hashing, login, wrong password, protected route, logout
- Cards: add, list, delete
- Payments: success, failure, PENDING before FastAPI responds, FastAPI down, other user's card, negative amount
- Transactions: own transactions only, filters by status / date / amount

The FastAPI call is mocked in tests, so FastAPI doesn't need to be running.

## Screenshots

**Login API (Postman)**
![Login](backend/screenshots/01-login.png)

**Add card (Postman)**
![Add card](backend/screenshots/02-add-card.png)

**Payment SUCCESS**
![Payment success](backend/screenshots/03-payment-success.png)

**Payment FAILED**
![Payment failed](backend/screenshots/04-payment-failed.png)

**Transaction filters**
![Filters](backend/screenshots/05-filters.png)

**Admin panel**
![Admin](backend/screenshots/06-admin.png)

**Daily payment summary**
![Daily summary](backend/screenshots/07-daily-summary.png)

**FastAPI Swagger**
![FastAPI docs](backend/screenshots/08-fastapi-docs.png)

## Admin login

Admin credentials are shared separately with the submission.
