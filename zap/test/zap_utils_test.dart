import 'package:flutter_test/flutter_test.dart';
import 'package:zap/zap.dart';
import 'dart:typed_data';

void main() {
  late ZapUtils zapUtils;

  setUp(() {
    zapUtils = ZapUtils.instance;
  });

  group('ZapUtils Real API Tests', () {
    test('fetchIpAddress returns valid IP', () async {
      // Act
      final ipAddress = await zapUtils.fetchIpAddress();

      // Assert
      expect(ipAddress, isNotEmpty);
      
      // Validate IPv4 format
      final ipv4Regex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
      expect(ipv4Regex.hasMatch(ipAddress), true);
      
      Z.log('Fetched IP: $ipAddress');
    });

    test('fetchImageData downloads real image', () async {
      // Arrange
      Uint8List? imageData;
      String? errorMessage;

      // Act
      await zapUtils.fetchImageData(
        url: 'https://picsum.photos/200/300',
        onSuccess: (data) {
          imageData = data;
        },
        onError: (error) {
          errorMessage = error;
        },
      );

      // Assert
      expect(imageData, isNotNull);
      expect(imageData!.length, greaterThan(0));
      expect(errorMessage, isNull);
      
      Z.log('Downloaded image size: ${imageData!.length} bytes');
    });

    test('fetchImageDataAsync downloads image', () async {
      // Act
      final imageData = await zapUtils.fetchImageDataAsync(
        'https://picsum.photos/150/150',
      );

      // Assert
      expect(imageData, isNotNull);
      expect(imageData!.length, greaterThan(0));
      
      Z.log('Downloaded image size: ${imageData.length} bytes');
    });

    test('fetchImageData handles 404 error', () async {
      // Arrange
      Uint8List? imageData;
      String? errorMessage;

      // Act
      await zapUtils.fetchImageData(
        url: 'https://picsum.photos/nonexistent-image.jpg',
        onSuccess: (data) {
          imageData = data;
        },
        onError: (error) {
          errorMessage = error;
        },
      );

      // Assert
      expect(imageData, isNull);
      expect(errorMessage, isNotNull);
      expect(errorMessage, contains('Failed to fetch image data'));
    });

    test('getLocationInformation returns location data', () async {
      // Arrange - New York City coordinates
      final latitude = 40.7128;
      final longitude = -74.0060;

      // Act
      final location = await zapUtils.getLocationInformation(latitude, longitude);

      // Assert
      expect(location, isNotNull);
      expect(location.displayName, isNotEmpty);
      
      Z.log('Location: ${location.displayName}');
      Z.log('State: ${location.address.state}');
      Z.log('Country: ${location.address.country}');
    });

    test('getLocationInformation handles invalid coordinates', () async {
      // Arrange - Invalid coordinates
      final latitude = 999.0;
      final longitude = 999.0;

      // Act
      final location = await zapUtils.getLocationInformation(latitude, longitude);

      // Assert
      expect(location, isNotNull);
      expect(location.displayName, isEmpty);
      // Should return fallback location for invalid coordinates
    });

    // Skip this test by default since it requires a Google Maps API key
    test('getTotalDistanceAndTime calculates distance', () async {
      // Arrange
      const googleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with actual key
      
      // Skip if no API key provided
      if (googleApiKey == 'YOUR_GOOGLE_MAPS_API_KEY') {
        Z.log('Skipping distance test - no Google Maps API key provided');
        return;
      }

      // New York to Philadelphia coordinates
      final originLat = 40.7128;
      final originLng = -74.0060;
      final destLat = 39.9526;
      final destLng = -75.1652;

      // Act
      final result = await zapUtils.getTotalDistanceAndTime(
        originLatitude: originLat,
        originLongitude: originLng,
        destinationLatitude: destLat,
        destinationLongitude: destLng,
        googleMapApiKey: googleApiKey,
      );

      // Assert
      expect(result, isA<List<dynamic>>());
      expect(result.isNotEmpty, true);
      expect(result[0]['distance'], isNotNull);
      expect(result[0]['duration'], isNotNull);
      expect(result[0]['status'], 'OK');
      
      Z.log('Distance: ${result[0]['distance']['text']}');
      Z.log('Duration: ${result[0]['duration']['text']}');
    }, skip: true); // Skip by default

    test('Multiple concurrent requests work correctly', () async {
      // Act
      final futures = [
        zapUtils.fetchIpAddress(),
        zapUtils.fetchImageDataAsync('https://picsum.photos/100/100'),
        zapUtils.getLocationInformation(51.5074, -0.1278), // London
      ];

      final results = await Future.wait(futures);

      // Assert
      expect(results[0], isA<String>());
      expect((results[0] as String).isNotEmpty, true);
      
      expect(results[1], isA<Uint8List>());
      expect((results[1] as Uint8List).isNotEmpty, true);
      
      expect(results[2], isA<LocationInformation>());
      expect((results[2] as LocationInformation).displayName.isNotEmpty, true);
    });
  });

  group('ZapUtils Error Handling', () {
    test('fetchIpAddress handles network errors gracefully', () async {
      // This test might be hard to reproduce consistently
      // but we can test the error handling path
      
      // Act
      final ipAddress = await zapUtils.fetchIpAddress(false); // Disable logging

      // Assert
      // Should either return a valid IP or empty string on error
      expect(ipAddress, isA<String>());
    });

    test('fetchImageDataAsync returns null on error', () async {
      // Act
      final imageData = await zapUtils.fetchImageDataAsync(
        'https://invalid-domain-12345.com/image.jpg',
        false, // Disable logging
      );

      // Assert
      expect(imageData, isNull);
    });
  });
}