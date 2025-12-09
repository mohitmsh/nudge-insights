# Nudge - Expense Tracking App

A modern iOS expense tracking application with AI-powered insights, built with SwiftUI and FastAPI.

## Overview

Nudge helps users track their spending with beautiful visualizations and AI-generated financial insights. The app features a clean, card-based interface with spending charts, category breakdowns, and personalized tips.

## Features

- **Transaction Tracking**: Add and view all your purchases with categories
- **AI-Powered Insights**: Get personalized spending insights powered by Agno AI
- **Visual Analytics**: Interactive charts showing spending patterns over time
- **Timeframe Filtering**: View data by Week, Month, or Year
- **Category Breakdown**: See top spending categories at a glance
- **Real-time Sync**: All data synced with backend API

## Tech Stack

### iOS App

- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for data flow
- **Swift Charts**: Native charting for spending visualization
- **MVVM Architecture**: Clean separation of concerns

### Backend

- **FastAPI**: Modern Python web framework
- **SQLite**: Lightweight database for transaction storage
- **SQLAlchemy**: ORM for database operations
- **Agno AI**: AI agent for generating financial insights
- **OpenAI GPT-4**: Powering intelligent spending analysis

## Project Structure

```
Nudge/
├── App/                        # App configuration and entry point
│   ├── NudgeApp.swift         # Main app file
│   ├── ContentView.swift      # Root view
│   └── AppStyle.swift         # App-wide styling
├── Models/                     # Data models
│   ├── Purchase.swift         # Transaction model
│   ├── Insight.swift          # AI insight model
│   ├── Category.swift         # Spending categories
│   └── NetworkError.swift     # Error handling
├── ViewModels/                 # Business logic
│   ├── InsightsViewModel.swift
│   └── AddPurchaseViewModel.swift
├── Views/                      # UI components
│   ├── Insights/              # Insights tab
│   └── AddPurchase/           # Add purchase flow
├── Services/                   # Network layer
│   └── NetworkService.swift   # API client
└── Utilities/                  # Helpers
    └── Formatters.swift       # Currency/date formatting

backend/
├── main.py                     # FastAPI app setup
├── database.py                 # Database configuration
├── routers/                    # API endpoints
│   ├── transactions.py        # Transaction CRUD
│   └── insights.py            # AI insights endpoint
├── services/                   # Business logic
│   └── agno_service.py        # Agno AI integration
├── models/                     # Database models
├── schemas/                    # Pydantic schemas
└── crud/                       # Database operations
```

## API Endpoints

### Transactions

- `POST /transactions` - Create a new transaction
- `GET /transactions` - Get all transactions

### Insights

- `GET /insights?timeframe={week|month|year}` - Get AI-powered insights for specified timeframe

### Health

- `GET /health` - Health check endpoint

## Setup Instructions

### Backend Setup

1. Navigate to the backend directory:

```bash
cd backend
```

2. Create and activate virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # On macOS/Linux
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

4. Set up environment variables:

```bash
export OPENAI_API_KEY="your-openai-api-key"
export AGNO_API_KEY="your-agno-api-key"
```

5. Run the server:

```bash
python main.py
```

The server will start on `http://localhost:5001`

### iOS App Setup

1. Open `Nudge.xcodeproj` in Xcode

2. Update the API base URL in `NetworkService.swift` if needed:

```swift
private let baseURL = "http://localhost:5001"
```

3. Build and run the project (Cmd+R)

## Configuration

### Network Configuration

The app connects to the backend at `http://localhost:5001` by default. Update `NetworkService.swift` to change this.

### AI Insights

Insights are cached for 10 minutes to reduce API calls. Modify the cache TTL in `backend/services/agno_service.py`:

```python
_cache_ttl = timedelta(minutes=10)
```

### Timeframes

The app supports three timeframes:

- Week: Last 7 days
- Month: Last 30 days
- Year: Last 365 days

## Development

### Adding New Categories

Edit the `Category` enum in `Models/Category.swift`

### Customizing Insights

Modify the AI agent instructions in `backend/services/agno_service.py`

### Styling

App-wide colors and fonts are defined in `App/AppStyle.swift`

## Database

The backend uses SQLite for data persistence. The database file (`nudge.db`) is created automatically in the backend directory on first run.

### Schema

- **transactions**: id, amount, category, timestamp

## Error Handling

The app includes comprehensive error handling:

- Network errors are displayed to users
- Failed API calls show retry options
- Loading states prevent user confusion

## Performance

- Insights are cached per timeframe for 10 minutes
- Chart data is calculated locally from transactions
- Lazy loading for transaction lists
- Efficient data filtering on timeframe changes

## License

This project is for personal use.

## Author

Mohit Sharma
