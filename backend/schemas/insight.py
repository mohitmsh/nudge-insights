from pydantic import BaseModel
from typing import List


class Insight(BaseModel):
    insight: str
    tip: str

    class Config:
        from_attributes = True


class InsightsResponse(BaseModel):
    insights: List[Insight]
