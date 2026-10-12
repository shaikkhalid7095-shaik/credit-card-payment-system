from datetime import datetime

from sqlalchemy import Column, DateTime, Integer, Numeric, String

from .database import Base


class Payment(Base):
    __tablename__ = "payments"

    id = Column(Integer, primary_key=True, index=True)

    transaction_id = Column(
        String(50),
        unique=True,
        nullable=False,
        index=True
    )

    user_id = Column(
        Integer,
        nullable=False,
        index=True
    )

    card_id = Column(
        Integer,
        nullable=False
    )

    amount = Column(
        Numeric(12, 2),
        nullable=False
    )

    currency = Column(
        String(3),
        default="INR",
        nullable=False
    )

    payment_method = Column(
        String(20),
        default="CARD",
        nullable=False
    )

    status = Column(
        String(20),
        default="PENDING",
        nullable=False
    )

    description = Column(
        String(255),
        nullable=True
    )

    failure_reason = Column(
        String(255),
        nullable=True
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
        nullable=False
    )

    updated_at = Column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False
    )

    completed_at = Column(
        DateTime,
        nullable=True
    )