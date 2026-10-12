import os

import requests
from dotenv import load_dotenv

load_dotenv()

FASTAPI_PAYMENT_URL = "http://127.0.0.1:8001/payments/"
FASTAPI_INTERNAL_KEY = os.getenv("FASTAPI_INTERNAL_KEY")


def process_payment_with_fastapi(user_id, card_id, amount, currency="INR",
                                 payment_method="CARD", description=None):
    """Send the payment to the FastAPI service and return its JSON reply."""
    payload = {
        "user_id": user_id,
        "card_id": card_id,
        "amount": str(amount),
        "currency": currency,
        "payment_method": payment_method,
        "description": description,
    }
    headers = {"X-Internal-Key": FASTAPI_INTERNAL_KEY}

    response = requests.post(FASTAPI_PAYMENT_URL, json=payload, headers=headers, timeout=10)
    response.raise_for_status()

    return response.json()
