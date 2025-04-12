import 'package:connectify/connectify.dart';
import 'package:tracing/tracing.dart';

void main() {
  ConnectifyService _connect = Connectify(config: ConnectifyConfig(
    useToken: false,
    showErrorLogs: true,
    showResponseLogs: true,
    showRequestLogs: true,
    mode: Server.SANDBOX,
  ));

  _testAuthentication(_connect).then((value) {
    console.log("Checking email returned $value", from: "Email Checker Authentication");
  });

  _testCategoryListFetch(_connect).then((value) {
    console.log(value.toJson(), from: "Category List Fetching");
  });

  _testPopularCategoryListFetch(_connect).then((value) {
    console.log(value.toJson(), from: "Popular Category List Fetching");
  });

  _testSpecialtyListFetch(_connect).then((value) {
    console.log(value.toJson(), from: "Specialty List Fetching");
  });

  _testLocationInformationFetch(9.056254748560415, 7.498512053685307).then((value) {
    console.log(value.toJson(), from: "Location Information Fetching");
  });
}

Future<bool> _testAuthentication(ConnectifyService connect) async {
  const endpoint = '/auth/email/check?email=user.testing@hapnium.com';
  var response = await connect.get(endpoint: endpoint);

  return response.code == 400;
}

Future<ApiResponse> _testCategoryListFetch(ConnectifyService connect) async {
  const endpoint = '/category/all';
  return await connect.get(endpoint: endpoint);
}

Future<ApiResponse> _testPopularCategoryListFetch(ConnectifyService connect) async {
  const endpoint = '/category/popular';
  return await connect.get(endpoint: endpoint);
}

Future<ApiResponse> _testSpecialtyListFetch(ConnectifyService connect) async {
  const endpoint = "/specialty/all";
  return await connect.get(endpoint: endpoint);
}

Future<LocationInformation> _testLocationInformationFetch(double latitude, double longitude) async {
  return await ConnectifyUtils.instance.getLocationInformation(latitude, longitude);
}