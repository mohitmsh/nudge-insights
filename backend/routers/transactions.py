from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from database import get_db
from schemas.transaction import TransactionCreate, TransactionResponse
from crud.transaction import create_transaction, get_transactions

router = APIRouter(prefix="/transactions", tags=["transactions"])


@router.post("", response_model=TransactionResponse, status_code=201)
async def create(transaction: TransactionCreate, db: Session = Depends(get_db)):
    """Create a new transaction"""
    try:
        db_transaction = create_transaction(db, transaction)
        return db_transaction
    except Exception as e:
         raise HTTPException(status_code=500, detail=str(e))


@router.get("", response_model=List[TransactionResponse])
async def list_all(db: Session = Depends(get_db)):
    """Get all transactions"""
    try:
        transactions = get_transactions(db)
        return transactions
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
