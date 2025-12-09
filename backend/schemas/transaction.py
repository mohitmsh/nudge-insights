from pydantic import BaseModel


class TransactionCreate(BaseModel):
    amount: float
    category: str
    timestamp: str


class TransactionResponse(BaseModel):
    id: str
    amount: float
    category: str
    timestamp: str

    class Config:
        from_attributes = True
