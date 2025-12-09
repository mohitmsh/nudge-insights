# Nudge Backend API

FastAPI-based REST API for the Nudge expense tracking app with Agno AI-powered behavioral insights.

## Setup

1. **Install dependencies:**

```bash
pip3 install -r requirements.txt
```

2. **Set up environment variables:**

```bash
cp .env.example .env
```

Edit `.env` and add your Agno API key:

```
AGNO_API_KEY=your-actual-agno-api-key
```

3. **Run the development server:**

```bash
python3 app.py
```

Or with uvicorn directly:

```bash
uvicorn app:app --reload --host 0.0.0.0 --port 5001
```

The API will be available at `http://localhost:5001`

## API Endpoints

### Health Check

- **GET** `/health` - Check if the API is running

### Transactions

- **POST** `/transactions` - Create a new transaction

  - Body:

  ```json
  {
    "amount": 24.5,
    "category": "Food Delivery",
    "timestamp": "2025-06-01T18:20:34"
  }
  ```

  - Response: Transaction object with auto-generated ID

- **GET** `/transactions` - Get all transactions
  - Response: Array of all transaction objects

### Insights (AI-Powered)

- **GET** `/insights` - Get behavioral insights using Agno AI agent
  - Computes transaction summary programmatically
  - Uses Agno AI to generate personalized insights and tips
  - Response:
  ```json
  [
    {
      "insight": "You spend the most on Fridays around 6 PM.",
      "tip": "Try preparing dinner earlier on Fridays to avoid ordering food delivery."
    }
  ]
  ```

## Data Storage

Currently using JSON file storage (`transactions.json`). In production, migrate to Postgres/Supabase.

## Agno AI Integration

The `/insights` endpoint uses the Agno framework to generate behavioral insights:

1. **Programmatic Summary**: Computes statistics like:

   - Top spending category
   - Category breakdown
   - Spending peak times (day + hour analysis)
   - Monthly totals and averages

2. **AI Agent**: Passes summary to Agno AI agent which returns:
   - Personalized insights about spending patterns
   - Actionable tips to improve financial habits

## Testing

### Interactive API Documentation

FastAPI provides automatic interactive documentation:

- Swagger UI: `http://localhost:5001/docs`
- ReDoc: `http://localhost:5001/redoc`

### cURL Examples

```bash
# Health check
curl http://localhost:5001/health

# Create a transaction
curl -X POST http://localhost:5001/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 24.50,
    "category": "Food Delivery",
    "timestamp": "2025-06-01T18:20:34"
  }'

# Get all transactions
curl http://localhost:5001/transactions

# Get AI-powered insights
curl http://localhost:5001/insights
```

### Load Test Data

Copy the test transactions to your data file:

```bash
cp test_transactions.json transactions.json
```

## Connect to iOS App

Update the `NetworkService.swift` in your iOS app to point to:

- Local: `http://localhost:5001`
- Network: `http://YOUR_IP_ADDRESS:5001` (for testing on device)

## Architecture

- **FastAPI**: Modern, fast Python web framework with automatic OpenAPI documentation
- **Pydantic**: Data validation using Python type hints
- **Agno**: AI agent framework for generating personalized financial insights
- **Uvicorn**: ASGI server for running the application
