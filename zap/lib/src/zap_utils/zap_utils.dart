import 'package:flutter/foundation.dart' show Uint8List;
import 'package:tracing/tracing.dart' show console;

import '../definitions.dart';
import '../models/location/location_information.dart';
import '../models/zap_config.dart';
import '../http/utils/http_status.dart';
import '../core/zap.dart';
import '../core/zap_interface.dart';

/// Utility class providing helper methods for interacting with external APIs,
/// including image fetching, IP address retrieval, and Google Maps distance matrix calculations.
/// 
/// This class uses Zap HTTP client for all network requests, providing consistent
/// error handling, logging, and configuration across the application.
final class ZapUtils {
  /// Singleton instance of the [ZapUtils] class
  static final ZapUtils _instance = ZapUtils._internal();

  /// Private constructor to prevent instantiation from outside the class
  ZapUtils._internal();

  /// Returns the singleton instance of the [ZapUtils] class
  static ZapUtils get instance => _instance;
  
  /// Gets the Zap HTTP client, initializing it if necessary
  ZapInterface get _client => Zap(
    zapConfig: ZapConfig(
      timeout: const Duration(seconds: 30),
      followRedirects: true,
      maxRedirects: 3,
    ),
  );

  /// Fetches the public IP address of the user.
  ///
  /// This method makes a network request to a public IP API to retrieve the current public IP address of the user.
  /// Returns the IP address as a string if successful, or an empty string if the request fails.
  ///
  /// ### Returns:
  /// A `Future<String>` containing the public IP address or an empty string on failure.
  ///
  /// ### Example Usage:
  /// ```dart
  /// String ip = await ZapUtils.instance.fetchIpAddress();
  /// if (ip.isNotEmpty) {
  ///   print("Public IP: $ip");
  /// } else {
  ///   print("Failed to fetch IP address");
  /// }
  /// ```
  Future<String> fetchIpAddress([bool log = true]) async {
    try {
      // Make a GET request to a public IP API
      final response = await _client.get<Map<String, dynamic>>(
        "https://api64.ipify.org?format=json",
        decoder: (status, data) => data as Map<String, dynamic>,
      );

      if (response.status == HttpStatus.OK && response.body?['ip'] != null) {
        return response.body!['ip'] as String;
      }
    } catch (e) {
      if (log) {
        console.log('ZapUtils: Failed to fetch IP address - $e');
      }
    }

    return "";
  }

  /// Fetches image data from the specified [url].
  ///
  /// This method performs a network request to the given [url] to retrieve image data in byte format.
  /// If the request is successful (HTTP status code HttpStatus.OK), the [onSuccess] callback is invoked with
  /// the image data (as a `Uint8List`). If the request fails, the [onError] callback is invoked with an
  /// error message.
  ///
  /// ### Parameters:
  ///
  /// - [url]: The URL of the image to fetch.
  /// - [onSuccess]: The callback function to be called with the image data upon a successful fetch.
  /// - [onError]: The callback function to be called with an error message if the fetch fails.
  ///
  /// ### Example Usage:
  /// ```dart
  /// ZapUtils.instance.fetchImageData(
  ///   url: 'https://example.com/image.png',
  ///   onSuccess: (data) {
  ///     // Handle image data (Uint8List)
  ///   },
  ///   onError: (errorMessage) {
  ///     // Handle error
  ///   },
  /// );
  /// ```
  Future<void> fetchImageData({
    required String url,
    required Function(Uint8List) onSuccess,
    required Function(String) onError,
    bool log = true,
  }) async {
    try {
      // Make a GET request expecting binary data
      final response = await _client.get<BodyBytes>(
        url,
        decoder: (status, data) {
          if (data is BodyBytes) {
            return data;
          } else if (data is String) {
            // Handle case where data might be base64 encoded
            return data.codeUnits;
          }
          throw Exception('Unexpected response type for image data');
        },
      );

      if (response.status == HttpStatus.OK && response.body != null) {
        // Convert the response data to a Uint8List (byte array)
        Uint8List imageData = Uint8List.fromList(response.body!);
        onSuccess.call(imageData);
      } else {
        onError.call('Failed to fetch image data: HTTP ${response.status}');
      }
    } catch (error) {
      if (log) {
        console.log('ZapUtils: Error fetching image: $error');
      }
      // Invoke the error callback with the error message in case of an exception
      onError.call('Error fetching image: $error');
    }
  }

  /// Alternative method to fetch image data that returns a Future instead of using callbacks.
  ///
  /// ### Parameters:
  /// - [url]: The URL of the image to fetch.
  ///
  /// ### Returns:
  /// A `Future<Uint8List?>` containing the image data or null if the fetch fails.
  ///
  /// ### Example Usage:
  /// ```dart
  /// Uint8List? imageData = await ZapUtils.instance.fetchImageDataAsync('https://example.com/image.png');
  /// if (imageData != null) {
  ///   // Handle image data
  /// }
  /// ```
  Future<Uint8List?> fetchImageDataAsync(String url, [bool log = true]) async {
    try {
      final response = await _client.get<BodyBytes>(
        url,
        decoder: (status, data) {
          if (data is BodyBytes) {
            return data;
          } else if (data is String) {
            return data.codeUnits;
          }
          throw Exception('Unexpected response type for image data');
        },
      );

      if (response.status == HttpStatus.OK && response.body != null) {
        return Uint8List.fromList(response.body!);
      }
    } catch (e) {
      if (log) {
        console.log('ZapUtils: Failed to fetch image data - $e');
      }
    }
    return null;
  }

  /// Calculates the total distance and travel time between two geographic coordinates using the Google Maps Distance Matrix API.
  ///
  /// This method performs a request to the Google Maps Distance Matrix API to calculate the distance and
  /// travel time between an origin (specified by [originLatitude] and [originLongitude]) and a destination
  /// (specified by [destinationLatitude] and [destinationLongitude]). The request requires a valid [googleMapApiKey].
  ///
  /// ### Parameters:
  ///
  /// - [originLatitude]: The latitude of the starting point (origin).
  /// - [originLongitude]: The longitude of the starting point (origin).
  /// - [destinationLatitude]: The latitude of the destination point.
  /// - [destinationLongitude]: The longitude of the destination point.
  /// - [googleMapApiKey]: The Google Maps API key used for authentication with the API.
  ///
  /// ### Returns:
  /// - A `Future<List<dynamic>>` containing the distance and duration elements between the origin and destination.
  ///
  /// ### Throws:
  /// - Throws an exception if the API request fails or returns an error.
  ///
  /// ### Example Usage:
  /// ```dart
  /// try {
  ///   var result = await ZapUtils.instance.getTotalDistanceAndTime(
  ///     originLatitude: 40.7128,
  ///     originLongitude: -74.0060,
  ///     destinationLatitude: 34.0522,
  ///     destinationLongitude: -118.2437,
  ///     googleMapApiKey: 'YOUR_API_KEY',
  ///   );
  ///   print(result);  // Output: List containing distance and time elements
  /// } catch (e) {
  ///   print('Error calculating distance: $e');
  /// }
  /// ```
  Future<List<dynamic>> getTotalDistanceAndTime({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required String googleMapApiKey,
    bool log = true,
  }) async {
    String origin = "$originLatitude,$originLongitude";
    String destinations = "$destinationLatitude,$destinationLongitude";

    // Prepare the query parameters for the distance matrix request
    final queryParams = {
      'units': 'imperial',
      'origins': origin,
      'destinations': destinations,
      'key': googleMapApiKey,
    };

    try {
      // Perform the GET request to the Google Maps Distance Matrix API
      final response = await _client.get<Map<String, dynamic>>(
        "https://maps.googleapis.com/maps/api/distancematrix/json",
        query: queryParams,
        decoder: (status, data) => data as Map<String, dynamic>,
      );

      if (response.status == HttpStatus.OK && response.body != null) {
        final responseData = response.body!;
        
        // Check if the API returned an error
        if (responseData['status'] != 'OK') {
          throw Exception('Google Maps API error: ${responseData['status']}');
        }

        // Return the distance and duration elements from the response
        final rows = responseData['rows'] as List<dynamic>;
        if (rows.isNotEmpty) {
          final elements = rows[0]['elements'] as List<dynamic>;
          return elements;
        } else {
          throw Exception('No route data found in response');
        }
      } else {
        throw Exception('HTTP ${response.status}: Failed to fetch distance data');
      }
    } catch (e) {
      if (log) {
        console.log('ZapUtils: Error calculating distance and time: $e');
      }
      throw Exception('Error calculating distance and time: $e');
    }
  }

  /// Retrieves location information for a given latitude and longitude.
  ///
  /// This method makes a network request to the Nominatim OpenStreetMap API to retrieve
  /// detailed address information for the specified geographic coordinates. If the API call
  /// is successful, it returns a [LocationInformation] object containing the details.
  /// In case of an error or failure, it falls back to returning a [LocationInformation]
  /// object with only the latitude and longitude.
  ///
  /// ### Parameters:
  /// - [latitude]: The latitude of the location to retrieve information for.
  /// - [longitude]: The longitude of the location to retrieve information for.
  ///
  /// ### Returns:
  /// A `Future<LocationInformation>` containing the retrieved location details or
  /// a fallback with only latitude and longitude.
  ///
  /// ### Example Usage:
  /// ```dart
  /// LocationInformation info = await ZapUtils.instance.getLocationInformation(9.0562, 7.4985);
  /// print(info.displayName);  // Outputs the address or a fallback value.
  /// ```
  ///
  /// ### Notes:
  /// - This method uses the Zap HTTP client for requests.
  /// - The fallback ensures the app remains functional even if the API call fails.
  /// - Includes proper User-Agent header as required by Nominatim API.
  ///
  /// ### API Details:
  /// - Endpoint: `https://nominatim.openstreetmap.org/reverse`
  /// - Response: JSON format
  Future<LocationInformation> getLocationInformation(double latitude, double longitude, [bool log = true]) async {
    try {
      final queryParams = {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'format': 'json',
      };

      // Nominatim requires a User-Agent header
      final headers = {
        'User-Agent': 'ZapUtils/1.0',
      };

      final response = await _client.get<Map<String, dynamic>>(
        "https://nominatim.openstreetmap.org/reverse",
        query: queryParams,
        headers: headers,
        decoder: (status, data) => data as Map<String, dynamic>,
      );

      if (response.status == HttpStatus.OK && response.body != null) {
        return LocationInformation.fromJson(response.body!);
      } else {
        if (log) {
          console.log('ZapUtils: Failed to fetch location information - HTTP ${response.status}');
        }
      }
    } catch (e) {
      if (log) {
        console.log('ZapUtils: Error fetching location information - $e');
      }
    }

    // Fallback to basic location information with just coordinates
    return LocationInformation.fromLatLng(latitude, longitude);
  }

  /// Disposes the Zap client and cleans up resources.
  /// 
  /// Call this method when the ZapUtils instance is no longer needed
  /// to properly clean up network resources.
  void dispose() {
    _client.dispose();
  }
}