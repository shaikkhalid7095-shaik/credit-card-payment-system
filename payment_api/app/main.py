from fastapi import FastAPI

from .database import Base, engine
from . import models
from .routes.payment_routes import router as payment_router

# create the payments table if it doesn't exist yet
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Credit Card Payment API",
    description="FastAPI service for payment processing",
    version="1.0.0"
)

app.include_router(payment_router)


@app.get("/")
def root():
    return {"message": "Credit Card Payment API is running"}


@app.get("/health")
def health_check():
    return {"status": "healthy"}