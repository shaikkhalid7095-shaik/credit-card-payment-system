from datetime import datetime
from decimal import Decimal
from typing import Optional

from pydantic import BaseModel, ConfigDict, Field, field_validator


class PaymentCreate(BaseModel):
    user_id: int = Field(gt=0)
    card_id: int = Field(gt=0)
    amount: Decimal = Field(gt=0)
    currency: str = "INR"
    payment_method: str = "CARD"
    description: Optional[str] = None

    @field_validator("currency")
    @classmethod
    def validate_currency(cls, value):
        value = value.upper()
        if len(value) != 3:
            raise ValueError("Currency must contain exactly 3 characters.")
        return value

    @field_validator("payment_method")
    @classmethod
    def validate_payment_method(cls, value):
        value = value.upper()
        if value != "CARD":
            raise ValueError("Only CARD payment method is supported.")
        return value


class PaymentResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    transaction_id: str
    user_id: int
    card_id: int
    amount: Decimal
    currency: str
    payment_method: str
    status: str
    description: Optional[str] = None
    failure_reason: Optional[str] = None
    created_at: datetime
    updated_at: datetime
    completed_at: Optional[datetime] = None
