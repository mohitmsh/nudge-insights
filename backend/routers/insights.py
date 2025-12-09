from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime, timedelta, timezone

from database import get_db
from schemas.insight import InsightsResponse, Insight
from crud.transaction import get_transactions
from services.agno_service import analyze_transactions

router = APIRouter(prefix="/insights", tags=["insights"])

# Supported timeframes
TIMEFRAMES = {"week": 7, "month": 30, "year": 365}


@router.get("", response_model=InsightsResponse)
async def get_insights(
    timeframe: str = Query(
        "week", description="Timeframe for insights: week, month, or year"
    ),
    db: Session = Depends(get_db),
):
    """
    Generate AI-powered insights from user's transaction data
    Uses Agno AI agent to analyze spending patterns and provide actionable tips
    Filters transactions based on selected timeframe (week/month/year)
    """
    all_transactions = get_transactions(db)
    if not all_transactions:
        return InsightsResponse(insights=[])

    now = datetime.now(timezone.utc)
    days = TIMEFRAMES.get(timeframe.lower(), 7)
    cutoff_date = now - timedelta(days=days)

    # Filter transactions by timeframe
    transactions = []
    for t in all_transactions:
        try:
            timestamp_str = t.timestamp
            if timestamp_str.endswith("Z"):
                t_datetime = datetime.fromisoformat(
                    timestamp_str.replace("Z", "+00:00")
                )
            elif "+" in timestamp_str or timestamp_str.count("-") > 2:
                t_datetime = datetime.fromisoformat(timestamp_str)
            else:
                t_datetime = datetime.fromisoformat(timestamp_str).replace(
                    tzinfo=timezone.utc
                )
            if t_datetime >= cutoff_date:
                transactions.append(t)
        except Exception:
            transactions.append(t)

    if not transactions:
        return InsightsResponse(insights=[])

    # Convert to dict format for Agno analysis
    transaction_dicts = [
        {
            "id": t.id,
            "amount": t.amount,
            "category": t.category,
            "timestamp": t.timestamp,
        }
        for t in transactions
    ]

    agno_insights = analyze_transactions(transaction_dicts, timeframe)
    insights = [Insight(**i) for i in agno_insights]
    return InsightsResponse(insights=insights)
