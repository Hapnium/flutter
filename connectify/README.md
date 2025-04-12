# **Connectify**

`connectify` is a comprehensive networking package for Flutter, offering REST API integration, token-based authentication, and streamlined connectivity utilities.

---

## **Authentication**

For local development, use the `.netrc` file for secure credential storage. This ensures credentials are not embedded directly in URLs.

### Steps:

1. **Create a `.netrc` File:**
    ```bash
    machine github.com
    login your_username
    password your_personal_access_token
    ```

2. **Set Permissions:**
    ```bash
    chmod 600 ~/.netrc
    ```

---

## **Installation**

Install `connectify` using Flutter:

```yaml
dependencies:
  connectify:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: connectify
```

Run `flutter pub get` to install the package.

---

## **Usage**

### **Example Implementation**

```dart
import 'package:connectify/connectify.dart';
import 'package:tracing/tracing.dart';

void main() {
  ConnectifyService _connect = Connectify(
    config: ConnectifyConfig(
      useToken: false,
      showErrorLogs: true,
      showResponseLogs: true,
      showRequestLogs: true,
      mode: Server.SANDBOX,
    ),
  );

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
```

---

### **Features**

| Feature                        | Description                                                                   |
|--------------------------------|-------------------------------------------------------------------------------|
| **REST API Integration**       | Simplified methods for `GET`, `POST`, `PUT`, and `DELETE` requests.           |
| **Token Authentication**       | Support for token-based authentication when `useToken` is enabled.            |
| **Error Logging**              | Built-in error logging for easier debugging.                                  |
| **Flexible Configurations**    | Adjustable logging, token usage, and server mode (`SANDBOX` or `PRODUCTION`). |
| **Utilities**                  | Handy utilities for location fetching and data parsing.                       |

---

## **License**

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.