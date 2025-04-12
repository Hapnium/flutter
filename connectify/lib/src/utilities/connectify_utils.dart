import 'dart:typed_data';
import 'package:connectify/connectify.dart';
import 'package:dio/dio.dart';

/// Utility class providing helper methods for interacting with external core,
/// including image fetching, IP address retrieval, and Google Maps distance matrix calculations.
class ConnectifyUtils {
  static final ConnectifyUtils _instance = ConnectifyUtils._internal();
  ConnectifyUtils._internal();

  static ConnectifyUtils get instance => _instance;

  /// Fetches the public IP address of the user.
  ///
  /// This method makes a network request to a public IP API to retrieve the current public IP address of the user.
  /// If the request is successful, the [onSuccess] callback is invoked with the IP address as a string.
  /// If the request fails, the [onError] callback is invoked with an error message.
  ///
  /// ### Parameters:
  ///
  /// - [onSuccess]: The callback function to be called with the IP address upon a successful fetch.
  /// - [onError]: The callback function to be called with an error message if the fetch fails.
  ///
  /// ### Example Usage:
  /// ```dart
  /// ConnectifyUtils.fetchIpAddress(
  ///   onSuccess: (ip) {
  ///     print("Public IP: $ip");
  ///   },
  ///   onError: (error) {
  ///     print("Error: $error");
  ///   },
  /// );
  /// ```
  Future<String> fetchIpAddress() async {
    try {
      Dio dio = Dio();
      // Make a GET request to a public IP API
      var response = await dio.get("https://api64.ipify.org?format=json");

      if (response.statusCode == 200 && response.data['ip'] != null) {
        return response.data['ip']; // Pass the IP address to the success callback
      }
    } catch (_) { }

    return "";
  }

  /// Fetches image data from the specified [url].
  ///
  /// This method performs a network request to the given [url] to retrieve image data in byte format.
  /// If the request is successful (HTTP status code 200), the [onSuccess] callback is invoked with
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
  /// ConnectifyUtils.fetchImageData(
  ///   url: 'https://example.com/image.png',
  ///   onSuccess: (data) {
  ///     // Handle image data (Uint8List)
  ///   },
  ///   onError: (errorMessage) {
  ///     // Handle error
  ///   },
  /// );
  /// ```
  void fetchImageData({required String url, required Function(Uint8List) onSuccess, required Function(String) onError}) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(url, options: Options(responseType: ResponseType.bytes));

      if (response.statusCode == 200) {
        // Convert the response data to a Uint8List (byte array)
        Uint8List imageData = Uint8List.fromList(response.data);
        onSuccess.call(imageData);  // Invoke the success callback with the image data
      } else {
        onError.call('Failed to fetch image data');  // Invoke the error callback with a failure message
      }
    } catch (error) {
      // Invoke the error callback with the error message in case of an exception
      onError.call('Error: $error');
    }
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
  /// ### Example Usage:
  /// ```dart
  /// var result = await ConnectifyUtils.getTotalDistanceAndTime(
  ///   originLatitude: 40.7128,
  ///   originLongitude: -74.0060,
  ///   destinationLatitude: 34.0522,
  ///   destinationLongitude: -118.2437,
  ///   googleMapApiKey: 'YOUR_API_KEY',
  /// );
  ///
  /// print(result);  // Output: List containing distance and time elements
  /// ```
  Future<List<dynamic>> getTotalDistanceAndTime({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required String googleMapApiKey
  }) async {
    String origin = "$originLatitude,$originLongitude";
    String destinations = "$destinationLatitude,$destinationLongitude";

    Dio dio = Dio();
    // Prepare the URL parameters for the distance matrix request
    String params = "units=imperial&origins=$origin&destinations=$destinations&key=$googleMapApiKey";

    // Perform the GET request to the Google Maps Distance Matrix API
    var response = await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?$params");

    // Return the distance and duration elements from the response
    return response.data['rows'][0]['elements'];
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
  /// LocationInformation info = await getLocationInformation(9.0562, 7.4985);
  /// print(info.displayName);  // Outputs the address or a fallback value.
  /// ```
  ///
  /// ### Notes:
  /// - This method uses the [Dio] package for HTTP requests.
  /// - The fallback ensures the app remains functional even if the API call fails.
  ///
  /// ### API Details:
  /// - Endpoint: `https://nominatim.openstreetmap.org/reverse`
  /// - Response: JSON format
  Future<LocationInformation> getLocationInformation(double latitude, double longitude) async {
    try {
      String endpoint = "https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json";

      Dio dio = Dio();
      var response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        return LocationInformation.fromJson(response.data);
      }
    } catch (_) {}

    return LocationInformation.fromLatLng(latitude, longitude);
  }
}
