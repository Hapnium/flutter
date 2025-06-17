## 0.0.1

- Initial release of the Zap networking library for Flutter
- Core HTTP client (`Zap`) with support for GET, POST, PUT, PATCH, DELETE methods
- Request cancellation support via `CancelToken`
- Enhanced HTTP client (`Flux`) with authentication and session management
- Singleton pattern implementation for `Flux` for app-wide access
- WebSocket client (`ZapSocket`) with event-based callbacks
- Advanced WebSocket client (`Zync`) with subscription and event management
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

- Fixed session refresh issue in `Flux`
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
- Modified `Flux` to support custom response body parsing
- Modified `HttpStatus` to support custom status codes
- Added `ZapParserConfig` to support custom response body parsing

## 0.0.6

- Added `ZapPage` to support paginated responses
- Added `ResponseParser` to support custom response body parsing
- Added `ResponseParser.forList` to support list responses
- Added `ResponseParser.forPaginated` to support paginated responses
- Added `ResponseParser.parseAsList` to support list responses
- Added `ResponseParser.parseAsPaginated` to support paginated responses
- Added `ResponseParser.parseAsSingle` to support single responses

## 0.0.7

- Added `ResponseParser.parseAsSingle` to support single responses
- Handled exceptions in `Zap` and `Flux`
- Configured `Response`, `Request` and `HttpStatus` to support json decoding and more info

## 0.0.8

- Modified `ApiResponse` to support custom response body parsing
- Added `ApiResponse.copyWith` to support custom response body parsing

## 0.0.9

- Added logging to request headers in `Flux`
- Fixed auth headers in `Flux`

## 0.1.0

- Fixed default headers in `Zap` and `Flux`

## 0.1.1

- Added disposeOnCompleted in `FluxConfig`
- Added useSingleInstance in `FluxConfig`
- Renamed `ZapPulseConfig` to `FluxConfig`
- Renamed `ZapPulse` to `Flux`
- Renamed `ZapPulseInterface` to `FluxInterface`
- Renamed `ZapRealtime` to `Zync`
- Renamed `ZapRealtimeInterface` to `ZyncInterface`
- Renamed `ZapRealtimeConfig` to `ZyncConfig`
- Renamed `ZapRealtimeState` to `ZyncState`
- Renamed `ZapRealtimeErrorResponse` to `ZyncErrorResponse`
- Renamed `ZapRealtimeResponse` to `ZyncResponse`
- Renamed `ZapResponse` to `Response`
- Renamed `ZapRequest` to `Request`
- Renamed `ZapResponseParser` to `ResponseParser`
- Renamed `ZapCancelToken` to `CancelToken`
- Modified `Flux` to use either its own design principles on authentication and authorization or the design principles of [Zap]. It depends on the `useSingleInstance` parameter to decide on which design principles to use.

## 0.1.2

- Added support for custom socket client
- Fixed issues with Socket methods

## 0.1.3

- Fixed issues with `Flux`

## 0.1.4

- Renamed `onRemoveRoute` to `whenUnauthorized`
- Renamed `customAuthHeaderBuilder` to `authHeaderBuilder`

## 0.1.5

- Fixed issues with `Flux`

## 0.1.6

- Added `ControllerAdvice` to `FluxConfig`
- Fixed issues with `HttpClient` on web
- Configured more ways to handle exceptions using types `ExceptionType`