import random
import uuid
from datetime import datetime

from sqlalchemy.orm import Session

from .models import Payment
from .schemas import PaymentCreate

# payments above this amount are always declined
CARD_LIMIT = 50000


def generate_transaction_id():
    return f"TXN-{uuid.uuid4().hex[:12].upper()}"


def create_payment(db: Session, payment_data: PaymentCreate):
    payment = Payment(
        transaction_id=generate_transaction_id(),
        user_id=payment_data.user_id,
        card_id=payment_data.card_id,
        amount=payment_data.amount,
        currency=payment_data.currency,
        payment_method=payment_data.payment_method,
        description=payment_data.description,
        status="PENDING",
    )

    db.add(payment)
    db.commit()
    db.refresh(payment)

    return payment


def process_payment(db: Session, payment: Payment):
    # fake bank: big amounts fail, and about 1 in 5 payments fail randomly
    if payment.amount > CARD_LIMIT:
        payment.status = "FAILED"
        payment.failure_reason = "Amount exceeds card limit"
    elif random.random() < 0.2:
        payment.status = "FAILED"
        payment.failure_reason = "Declined by bank"
    else:
        payment.status = "SUCCESS"
        payment.failure_reason = None
        payment.completed_at = datetime.utcnow()

    db.commit()
    db.refresh(payment)

    return payment


def get_payment(db: Session, transaction_id: str):
    return db.query(Payment).filter(Payment.transaction_id == transaction_id).first()


def get_user_payments(db: Session, user_id: int):
    return (
        db.query(Payment)
        .filter(Payment.user_id == user_id)
        .order_by(Payment.created_at.desc())
        .all()
    )
