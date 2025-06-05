## 0.0.1

- Initial release of the Zap networking library for Flutter
- Core HTTP client (`Zap`) with support for GET, POST, PUT, PATCH, DELETE methods
- Request cancellation support via `CancelToken`
- Enhanced HTTP client (`ZapPulse`) with authentication and session management
- Singleton pattern implementation for `ZapPulse` for app-wide access
- WebSocket client (`ZapSocket`) with event-based callbacks
- Advanced WebSocket client (`ZapRealtime`) with subscription and event management
- Automatic reconnection and connection state management for WebSockets
- Utility functions (`ZapUtils`) for common networking tasks:

- IP address fetching
- Image downloading
- Location information retrieval
- Distance and travel time calculation



- Comprehensive error handling across all components
- Customizable authentication header management
- Stream-based API for real-time data and connection state monitoring
- Full documentation and usage examples