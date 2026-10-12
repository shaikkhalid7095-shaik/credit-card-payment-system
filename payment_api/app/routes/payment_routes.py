import os

from fastapi import APIRouter, Depends, Header, HTTPException, status
from sqlalchemy.orm import Session

from ..crud import (
    create_payment,
    get_payment,
    get_user_payments,
    process_payment,
)
from ..database import get_db
from ..schemas import PaymentCreate, PaymentResponse

router = APIRouter(
    prefix="/payments",
    tags=["Payments"]
)


def verify_internal_key(
    x_internal_key: str = Header(...)
):
    expected_key = os.getenv("FASTAPI_INTERNAL_KEY")

    if not expected_key:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal API key is not configured."
        )

    if x_internal_key != expected_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid internal API key."
        )

    return True


@router.post(
    "/",
    response_model=PaymentResponse,
    status_code=status.HTTP_201_CREATED,
    dependencies=[Depends(verify_internal_key)]
)
def make_payment(
    payment_data: PaymentCreate,
    db: Session = Depends(get_db)
):
    payment = create_payment(db, payment_data)
    payment = process_payment(db, payment)

    return payment


@router.get(
    "/user/{user_id}",
    response_model=list[PaymentResponse],
    dependencies=[Depends(verify_internal_key)]
)
def get_user_payment_history(
    user_id: int,
    db: Session = Depends(get_db)
):
    return get_user_payments(db, user_id)


@router.get(
    "/{transaction_id}",
    response_model=PaymentResponse,
    dependencies=[Depends(verify_internal_key)]
)
def get_payment_details(
    transaction_id: str,
    db: Session = Depends(get_db)
):
    payment = get_payment(db, transaction_id)

    if payment is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Payment not found."
        )

    return payment