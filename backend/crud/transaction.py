from sqlalchemy.orm import Session
from models.transaction import Transaction as TransactionModel
from schemas.transaction import TransactionCreate


def create_transaction(db: Session, transaction: TransactionCreate):
    """Create a new transaction"""
    # Generate ID based on count
    count = db.query(TransactionModel).count()
    transaction_id = str(count + 1)

    db_transaction = TransactionModel(
        id=transaction_id,
        amount=transaction.amount,
        category=transaction.category,
        timestamp=transaction.timestamp,
    )

    db.add(db_transaction)
    db.commit()
    db.refresh(db_transaction)
    return db_transaction


def get_transactions(db: Session):
    """Get all transactions ordered by created_at"""
    return db.query(TransactionModel).order_by(TransactionModel.created_at.desc()).all()


def get_transaction_by_id(db: Session, transaction_id: str):
    """Get a specific transaction by ID"""
    return (
        db.query(TransactionModel).filter(TransactionModel.id == transaction_id).first()
    )
