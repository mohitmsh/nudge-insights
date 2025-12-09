"""
Script to migrate transactions from JSON file to SQLite database
"""

import json
from database import SessionLocal
from models.transaction import Transaction


def migrate_transactions():
    """Load transactions from JSON and insert into database"""
    # Read JSON file
    with open("transactions.json", "r") as f:
        transactions_data = json.load(f)

    # Create database session
    db = SessionLocal()

    try:
        # Clear existing transactions (optional - remove if you want to keep existing data)
        db.query(Transaction).delete()
        db.commit()

        # Insert each transaction
        for idx, transaction_data in enumerate(transactions_data, start=1):
            transaction = Transaction(
                id=str(idx),
                amount=transaction_data["amount"],
                category=transaction_data["category"],
                timestamp=transaction_data["timestamp"],
            )
            db.add(transaction)

        # Commit all transactions
        db.commit()

        # Verify count
        count = db.query(Transaction).count()

        # Show some examples
        sample = db.query(Transaction).limit(5).all()
        for t in sample:
            print(
                f"  ID: {t.id}, Amount: ${t.amount}, Category: {t.category}, Date: {t.timestamp}"
            )

    except Exception as e:
        print(e)
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    migrate_transactions()
