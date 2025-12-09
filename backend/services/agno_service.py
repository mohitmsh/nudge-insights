"""
Simple AI-powered spending insights using Agno
"""

import warnings

warnings.filterwarnings("ignore", category=UserWarning, module="pydantic")

from agno.agent import Agent
from agno.models.openai import OpenAIChat
from typing import List, Dict, Any
from collections import defaultdict
import json
import hashlib
from datetime import datetime, timedelta

# Initialize Agno Agent
agent = Agent(
    model=OpenAIChat(id="gpt-4o-mini"),
    instructions=[
        "You are a financial advisor. Analyze spending and return JSON array with 'insight' and 'tip' fields.",
        "Be concise and actionable. Focus on patterns and savings opportunities.",
    ],
    markdown=False,
)

# Simple in-memory cache
_cache = {}
_cache_ttl = timedelta(minutes=10)  # Cache for 10 minutes


def _get_cache_key(transactions: List[Dict[str, Any]], timeframe: str) -> str:
    """Generate cache key based on transactions and timeframe"""
    # Create a hash of transaction IDs and amounts
    data = f"{timeframe}_{len(transactions)}"
    for t in transactions[:10]:  # Use first 10 for speed
        data += f"_{t.get('id', '')}_{t.get('amount', 0)}"
    return hashlib.md5(data.encode()).hexdigest()


def analyze_transactions(
    transactions: List[Dict[str, Any]], timeframe: str = "week"
) -> List[Dict[str, str]]:
    """Generate AI insights from transactions"""
    if not transactions:
        return []

    # Check cache first
    cache_key = _get_cache_key(transactions, timeframe)
    if cache_key in _cache:
        cached_data, cached_time = _cache[cache_key]
        if datetime.now() - cached_time < _cache_ttl:
            return cached_data

    # Build simple summary
    by_category = defaultdict(float)
    total = 0.0

    for t in transactions:
        amount = float(t.get("amount", 0))
        by_category[t.get("category", "Other")] += amount
        total += amount

    # Determine timeframe description
    timeframe_desc = {
        "week": "this week",
        "month": "this month",
        "year": "this year",
    }.get(timeframe.lower(), "this period")

    summary = f"Total spent {timeframe_desc}: ${total:.2f}\n"
    summary += "By category:\n"
    for cat, amt in sorted(by_category.items(), key=lambda x: x[1], reverse=True):
        summary += f"  {cat}: ${amt:.2f}\n"

    prompt = f"{summary}\n\nProvide 3-5 concise insights for spending {timeframe_desc} as JSON array with 'insight' and 'tip' fields. Be brief."

    try:
        response = agent.run(prompt)
        content = response.content if hasattr(response, "content") else str(response)

        # Clean and parse JSON
        content = content.strip()
        if "```" in content:
            content = content.split("```")[1].strip("json").strip()

        insights = json.loads(content)
        result = insights if isinstance(insights, list) else []

        # Cache the result
        _cache[cache_key] = (result, datetime.now())

        return result

    except Exception as e:
        # Simple fallback
        top_cat = max(by_category.items(), key=lambda x: x[1])
        return [
            {
                "insight": f"Your top spending {timeframe_desc} is {top_cat[0]} at ${top_cat[1]:.2f}",
                "tip": f"Consider setting a budget for {top_cat[0]}",
            }
        ]
