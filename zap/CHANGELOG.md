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

## 0.0.2

- Fixed session refresh issue in `ZapPulse`
- Added support for custom authentication header builder
- Added support for custom session factory
- Added support for custom session callback

## 0.0.3

- Fixed Uri parameter encoding issue

## 0.0.4

- Fixed response body decoding issue
- Added support for custom response body decoding
- Added support for custom response body encoding
- Added support for custom response body parsing
- Modified `ZapPulse` to support custom response body parsing
- Modified `HttpStatus` to support custom status codes
- Added `ZapParserConfig` to support custom response body parsing

## 0.0.6

- Added `ZapPage` to support paginated responses
- Added `ZapResponseParser` to support custom response body parsing
- Added `ZapResponseParser.forList` to support list responses
- Added `ZapResponseParser.forPaginated` to support paginated responses
- Added `ZapResponseParser.parseAsList` to support list responses
- Added `ZapResponseParser.parseAsPaginated` to support paginated responses
- Added `ZapResponseParser.parseAsSingle` to support single responses

## 0.0.7

- Added `ZapResponseParser.parseAsSingle` to support single responses
- Handled exceptions in `Zap` and `ZapPulse`
- Configured `ZapResponse`, `ZapRequest` and `HttpStatus` to support json decoding and more info

## 0.0.8

- Modified `ApiResponse` to support custom response body parsing
- Added `ApiResponse.copyWith` to support custom response body parsing

## 0.0.9

- Added logging to request headers in `ZapPulse`
- Fixed auth headers in `ZapPulse`
