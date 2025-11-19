# Real-Time Price Tracker (SwiftUI • Combine • WebSocket • MVVM)

The app uses a **single WebSocket connection**, **real-time data updates**

---

## Features

### Live Stock Price Updates
- Tracks **25 stock symbols** (AAPL, GOOG, TSLA, etc.)
- Every **2 seconds**, a random price is generated for each symbol:
  - Sent to the WebSocket echo server  
  - Echoed back
  - Processed into app state  
  - UI updates instantly  

### WebSocket Integration
- Endpoint: `wss://ws.postman-echo.com/raw`
- Uses `URLSessionWebSocketTask`
- Clean separation via `WebSocketService`
- Single shared WebSocket across the entire app

### SwiftUI UI
- `NavigationStack` with:
  - Feed Screen  
  - Symbol Detail Screen  

### Feed Screen
- Sorted list of symbols (highest price first)
- Price change indicator (↑ green, ↓ red)
- Connection indicator
- Start/Stop toggle controlling:
  - WebSocket connection  
  - Timer events  
  - Price feed  

### Symbol Detail Screen
- Shows:
  - Latest price  
  - Price direction  
  - Symbol description  
  - Real-time binding using shared state
  
### Deeplink
- Redirecting to symbol detail screen (For ex: stocks://symbol/AAPL)

---

## Requirements

- Xcode **15+**
- iOS **17+**
- SwiftUI  
- Combine

---

## Conclusion

This project demonstrates:

- SwiftUI real-time data handling  
- Clean MVVM separation  
- WebSocket communication  
- Unit-tested business logic
