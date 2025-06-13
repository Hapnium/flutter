import 'package:flutter_test/flutter_test.dart';
import 'package:zap/zap.dart';

void main() {
  late Flux zapPulse;
  late SessionResponse testSession;

  setUp(() {
    testSession = SessionResponse(
      accessToken: 'test_access_token_12345',
      refreshToken: 'test_refresh_token_12345',
    );

    zapPulse = Flux(
      config: FluxConfig(
        showRequestLogs: true,
        showResponseLogs: true,
        showErrorLogs: true,
      ),
    );
  });

  tearDown(() {
    Flux.dispose();
  });

  group('Flux Real API Tests', () {
    test('GET request with authentication headers', () async {
      // Act
      final response = await zapPulse.get<Map<String, dynamic>>(
        endpoint: 'https://httpbin.org/headers',
        useAuth: true,
      );

      // Assert
      expect(response.isOk, true);
      expect(response.body?.code, 200);
      expect(response.body?.data, isA<Map<String, dynamic>>());
      
      // Verify auth header was sent
      final headers = response.headers;
      expect(headers?['Authorization'], 'Bearer test_access_token_12345');
    });

    test('GET request without authentication', () async {
      // Act
      final response = await zapPulse.get<Map<String, dynamic>>(
        endpoint: 'https://jsonplaceholder.typicode.com/posts/1',
        useAuth: false,
      );

      // Assert
      expect(response.isOk, true);
      expect(response.body?.code, 200);
      expect(response.body?.data, isA<Map<String, dynamic>>());
      expect(response.body?.data?['id'], 1);
      expect(response.body?.data?['title'], isNotEmpty);
    });

    test('POST request with body and authentication', () async {
      // Arrange
      final postData = {
        'title': 'Flux Test Post',
        'body': 'This post was created using Flux',
        'userId': 1
      };

      // Act
      final response = await zapPulse.post<Map<String, dynamic>>(
        endpoint: 'https://jsonplaceholder.typicode.com/posts',
        body: postData,
        useAuth: true,
      );

      // Assert
      expect(response.isOk, true);
      expect(response.body?.code, 201);
      expect(response.body?.data, isA<Map<String, dynamic>>());
      expect(response.body?.data?['title'], postData['title']);
      expect(response.body?.data?['body'], postData['body']);
      expect(response.body?.data?['id'], isNotNull);
    });

    test('PUT request updates resource', () async {
      // Arrange
      final updateData = {
        'id': 1,
        'title': 'Updated via Flux',
        'body': 'This post was updated using Flux',
        'userId': 1
      };

      // Act
      final response = await zapPulse.put<Map<String, dynamic>>(
        endpoint: 'https://jsonplaceholder.typicode.com/posts/1',
        body: updateData,
        useAuth: false,
      );

      // Assert
      expect(response.isOk, true);
      expect(response.body?.code, 200);
      expect(response.body?.data?['title'], updateData['title']);
      expect(response.body?.data?['body'], updateData['body']);
    });

    test('PATCH request with partial update', () async {
      // Arrange
      final patchData = {
        'title': 'Patched via Flux'
      };

      // Act
      final response = await zapPulse.patch<Map<String, dynamic>>(
        endpoint: 'https://jsonplaceholder.typicode.com/posts/1',
        body: patchData,
        useAuth: false,
      );

      // Assert
      expect(response.isOk, true);
      expect(response.body?.code, 200);
      expect(response.body?.data?['title'], patchData['title']);
      expect(response.body?.data?['id'], 1); // Should retain original id
    });

    test('DELETE request removes resource', () async {
      // Act
      final response = await zapPulse.delete<Map<String, dynamic>>(
        endpoint: 'https://jsonplaceholder.typicode.com/posts/1',
        useAuth: false,
      );

      // Assert
      expect(response.isOk, true);
      expect(response.body?.code, 200);
    });

    test('Request with query parameters', () async {
      // Act
      final response = await zapPulse.get<List<dynamic>>(
        endpoint: 'https://jsonplaceholder.typicode.com/posts',
        query: {'userId': 1, '_limit': 5},
        useAuth: false,
      );

      // Assert
      expect(response.isOk, true);
      expect(response.body?.code, 200);
      expect(response.body?.data, isA<List<dynamic>>());
      expect(response.body?.data?.length, lessThanOrEqualTo(5));
      
      // Verify all posts are from userId 1
      for (var post in response.body?.data ?? []) {
        expect(post['userId'], 1);
      }
    });

    test('Custom auth header configuration', () async {
      // Arrange
      Flux.dispose();
      
      zapPulse = Flux(
        config: FluxConfig(
          authHeaderName: 'X-API-Key',
          tokenPrefix: 'Token',
        ),
      );

      // Act
      final response = await zapPulse.get<Map<String, dynamic>>(
        endpoint: 'https://httpbin.org/headers',
        useAuth: true,
      );

      // Assert
      expect(response.isOk, true);
      final headers = response.body?.data?['headers'] as Map<String, dynamic>?;
      expect(headers?['X-Api-Key'], 'Token test_access_token_12345');
    });

    test('Custom auth header builder', () async {
      // Arrange
      Flux.dispose();
      
      zapPulse = Flux(
        config: FluxConfig(
          authHeaderBuilder: (session) => {
            'X-User-Token': 'user_token_${session.accessToken}',
          },
        ),
      );

      // Act
      final response = await zapPulse.get<Map<String, dynamic>>(
        endpoint: 'https://httpbin.org/headers',
        useAuth: true,
      );

      // Assert
      expect(response.isOk, true);
      final headers = response.body?.data?['headers'] as Map<String, dynamic>?;
      expect(headers?['X-User-Token'], 'user_token_test_access_token_12345');
    });

    test('Dynamic session updates', () async {
      // Arrange
      SessionResponse? currentSession = testSession;
      
      Flux.dispose();
      
      zapPulse = Flux(
        config: FluxConfig(
          sessionFactory: () => currentSession!,
        ),
      );

      // Act - First request with initial session
      var response = await zapPulse.get<Map<String, dynamic>>(
        endpoint: 'https://httpbin.org/headers',
        useAuth: true,
      );

      // Assert first request
      expect(response.isOk, true);
      var headers = response.body?.data?['headers'] as Map<String, dynamic>?;
      expect(headers?['Authorization'], 'Bearer test_access_token_12345');

      // Update session
      currentSession = SessionResponse(
        accessToken: 'updated_access_token_67890',
        refreshToken: 'updated_refresh_token_67890',
      );

      // Act - Second request with updated session
      response = await zapPulse.get<Map<String, dynamic>>(
        endpoint: 'https://httpbin.org/headers',
        useAuth: true,
      );

      // Assert second request uses updated token
      expect(response.isOk, true);
      headers = response.body?.data?['headers'] as Map<String, dynamic>?;
      expect(headers?['Authorization'], 'Bearer updated_access_token_67890');
    });

    test('Error handling for 404 response', () async {
      // Act
      final response = await zapPulse.get<Map<String, dynamic>>(
        endpoint: 'https://jsonplaceholder.typicode.com/posts/999999',
        useAuth: false,
      );

      // Assert
      expect(response.isOk, false);
      expect(response.body?.code, 404);
      expect(response.status, 'error');
    });

    test('Error handling when session required but not provided', () async {
      // Arrange
      Flux.dispose();
      
      zapPulse = Flux(
        config: FluxConfig(
          showRequestLogs: true,
          showResponseLogs: true,
          showErrorLogs: true,
        ),
      );

      // Act & Assert
      expect(
        () => zapPulse.get<Map<String, dynamic>>(
          endpoint: 'https://httpbin.org/headers',
          useAuth: true,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Singleton pattern enforcement', () async {
      // Act & Assert
      expect(
        () => Flux(config: FluxConfig()),
        throwsA(isA<Exception>()),
      );
    });

    test('Multiple concurrent requests', () async {
      // Arrange
      final futures = <Future<Response<ApiResponse<Map<String, dynamic>>>>>[];

      // Act
      for (int i = 1; i <= 5; i++) {
        futures.add(zapPulse.get<Map<String, dynamic>>(
          endpoint: 'https://jsonplaceholder.typicode.com/posts/$i',
          useAuth: false,
        ));
      }

      final responses = await Future.wait(futures);

      // Assert
      expect(responses.length, 5);
      for (int i = 0; i < responses.length; i++) {
        expect(responses[i].isOk, true);
        expect(responses[i].body?.data?['id'], i + 1);
      }
    });
  });
}