from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime

from database import engine, Base
from routers import transactions_router, insights_router

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Nudge API",
    version="1.0.0",
    description="Transaction tracking API for Nudge expense tracking app with AI-powered insights",
)

# Enable CORS - Specific origins for credential support
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",  # Local development
        "https://os.agno.com",  # Agno dashboard
        "https://app.agno.com",  # Agno app
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(transactions_router)
app.include_router(insights_router)


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=5001)
