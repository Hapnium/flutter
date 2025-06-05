import 'package:flutter_test/flutter_test.dart';
import 'package:zap/zap.dart';

void main() {
  late Zap zap;

  setUp(() {
    zap = Zap();
  });

  tearDown(() {
    zap.dispose();
  });

  group('Zap Real HTTP Tests', () {
    test('GET request to JSONPlaceholder API', () async {
      // Act
      final response = await zap.get<Map<String, dynamic>>(
        'https://jsonplaceholder.typicode.com/posts/1',
      );

      // Assert
      expect(response.statusCode, 200);
      expect(response.body, isA<Map<String, dynamic>>());
      expect(response.body?['id'], 1);
      expect(response.body?['title'], isNotEmpty);
      expect(response.body?['userId'], isNotNull);
    });

    test('GET request with query parameters', () async {
      // Act
      final response = await zap.get<List<dynamic>>(
        'https://jsonplaceholder.typicode.com/posts',
        query: {'userId': 1},
      );

      // Assert
      expect(response.statusCode, 200);
      expect(response.body, isA<List<dynamic>>());
      expect(response.body?.isNotEmpty, true);
      
      // Verify all posts are from userId 1
      for (var post in response.body ?? []) {
        expect(post['userId'], 1);
      }
    });

    test('POST request creates new resource', () async {
      // Arrange
      final postData = {
        'title': 'Test Post from Zap',
        'body': 'This is a test post created using Zap HTTP client',
        'userId': 1
      };

      // Act
      final response = await zap.post<Map<String, dynamic>>(
        'https://jsonplaceholder.typicode.com/posts',
        postData,
      );

      // Assert
      expect(response.statusCode, 201);
      expect(response.body, isA<Map<String, dynamic>>());
      expect(response.body?['id'], isNotNull);
      expect(response.body?['title'], postData['title']);
      expect(response.body?['body'], postData['body']);
      expect(response.body?['userId'], postData['userId']);
    });

    test('PUT request updates resource', () async {
      // Arrange
      final updateData = {
        'id': 1,
        'title': 'Updated Post Title',
        'body': 'Updated post body content',
        'userId': 1
      };

      // Act
      final response = await zap.put<Map<String, dynamic>>(
        'https://jsonplaceholder.typicode.com/posts/1',
        updateData,
      );

      // Assert
      expect(response.statusCode, 200);
      expect(response.body, isA<Map<String, dynamic>>());
      expect(response.body?['id'], 1);
      expect(response.body?['title'], updateData['title']);
      expect(response.body?['body'], updateData['body']);
    });

    test('PATCH request partially updates resource', () async {
      // Arrange
      final patchData = {
        'title': 'Patched Title Only'
      };

      // Act
      final response = await zap.patch<Map<String, dynamic>>(
        'https://jsonplaceholder.typicode.com/posts/1',
        patchData,
      );

      // Assert
      expect(response.statusCode, 200);
      expect(response.body, isA<Map<String, dynamic>>());
      expect(response.body?['title'], patchData['title']);
      expect(response.body?['id'], 1); // Should still have original id
    });

    test('DELETE request removes resource', () async {
      // Act
      final response = await zap.delete<Map<String, dynamic>>(
        'https://jsonplaceholder.typicode.com/posts/1',
      );

      // Assert
      expect(response.statusCode, 200);
    });

    test('Request with custom headers', () async {
      // Arrange
      final customHeaders = {
        'X-Custom-Header': 'TestValue',
        'User-Agent': 'Zap-Test-Client/1.0'
      };

      // Act
      final response = await zap.get<Map<String, dynamic>>(
        'https://httpbin.org/headers',
        headers: customHeaders,
      );

      // Assert
      expect(response.statusCode, 200);
      expect(response.body?['headers']?['X-Custom-Header'], 'TestValue');
      expect(response.body?['headers']?['User-Agent'], 'Zap-Test-Client/1.0');
    });

    test('Request cancellation works', () async {
      // Arrange
      final cancelToken = ZapCancelToken();

      // Act
      final futureResponse = zap.get<Map<String, dynamic>>(
        'https://httpbin.org/delay/3', // 3 second delay
        cancelToken: cancelToken,
      );

      // Cancel after 1 second
      Future.delayed(Duration(seconds: 1), () {
        cancelToken.cancel('Test cancellation');
      });

      // Assert
      expect(futureResponse, throwsA(isA<Exception>()));
    });

    test('Error handling for 404 response', () async {
      // Act
      final response = await zap.get<Map<String, dynamic>>(
        'https://jsonplaceholder.typicode.com/posts/999999',
      );

      // Assert
      expect(response.statusCode, 404);
    });

    test('Error handling for invalid URL', () async {
      // Act
      final response = await zap.get<Map<String, dynamic>>(
        'https://invalid-domain-that-does-not-exist-12345.com',
      );

      // Assert
      expect(response.statusCode, 0); // Network error
      expect(response.hasError, true);
    });

    test('Multiple concurrent requests', () async {
      // Arrange
      final futures = <Future<ZapResponse<Map<String, dynamic>>>>[];

      // Act
      for (int i = 1; i <= 5; i++) {
        futures.add(zap.get<Map<String, dynamic>>(
          'https://jsonplaceholder.typicode.com/posts/$i',
        ));
      }

      final responses = await Future.wait(futures);

      // Assert
      expect(responses.length, 5);
      for (int i = 0; i < responses.length; i++) {
        expect(responses[i].statusCode, 200);
        expect(responses[i].body?['id'], i + 1);
      }
    });
  });

  group('Zap Request Cancellation', () {
    test('Cancel all active requests', () async {
      // Arrange
      final futures = <Future<ZapResponse<Map<String, dynamic>>>>[];

      // Act
      for (int i = 1; i <= 3; i++) {
        futures.add(zap.get<Map<String, dynamic>>(
          'https://httpbin.org/delay/2', // 2 second delay
        ));
      }

      // Cancel all requests after 500ms
      Future.delayed(Duration(milliseconds: 500), () {
        zap.cancelAllRequests('Test cancellation');
      });

      // Assert
      for (final future in futures) {
        expect(future, throwsA(isA<Exception>()));
      }
    });
  });
}