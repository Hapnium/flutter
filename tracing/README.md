# LoggerFlutter

**A private logging library for Flutter applications within SearchService Inc.**

This package offers a convenient and flexible logging solution for Flutter projects. It leverages the `logger` package to provide structured and informative logging tailored to the needs of SearchService Inc.

---

## **Key Features**

- **Consistent Logging**: Enforces a uniform logging style across all projects.
- **Structured Logging**: Supports various data types, including strings, numbers, lists, maps, and more.
- **Customizable**: Allows customization of log levels, prefixes, and output destinations.
- **Readable Format**: Outputs well-structured log messages with timestamps and log levels.
- **Internal Use**: Specifically designed for internal use within SearchService Inc.

---


## Authentication

For local development, leverage the `.netrc` file for secure credential storage. This eliminates the need to embed credentials directly in URLs.

**Steps:**

1. **Create a `.netrc` File:**
    - In your home directory (e.g., `~/.netrc`), create a file with the following content:

   ```bash
   machine github.com
   login your_username
   password your_personal_access_token
   ```

2. **Set Permissions:**
    - Ensure the file is not readable by others for security:

   ```bash
   chmod 600 ~/.netrc
   ```

## Installation

Install `logging` using Flutter:

```yaml
dependencies:
  logging:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: logging
```

Run `flutter pub get` to install the package.

---

## **Usage**

### 1. Import the package:

```dart
import 'package:logger/logger.dart';
```

### 2. Create a `LogManager` instance:

```dart
final logManager = LogManager();
```

### 3. Log messages:

```dart
// Log a simple string message
String message = 'Initializing location services...';
logManager.log(message);

// Log a JSON object
Map<String, dynamic> user = {
  'id': 123,
  'name': 'John Doe',
  'email': 'john.doe@example.com'
};
logManager.log(user);

// Log a list of strings
List<String> messages = ['Message 1', 'Message 2', 'Message 3'];
logManager.log(messages);

// Log with a custom prefix and source
logManager.log(
  "Network request successful",
  prefix: "Network",
  from: "NetworkService"
);
```

---

## **Available Log Levels**

- `LogMode.TRACE`: For highly detailed logs.
- `LogMode.DEBUG`: For debugging information.
- `LogMode.INFO`: For informational messages.
- `LogMode.WARN`: For warnings.
- `LogMode.ERROR`: For error messages.
- `LogMode.FATAL`: For critical errors.

---

## **Customization**

- **Log Level**: Control the verbosity by adjusting the `LogMode` parameter in the `log()` method.
- **Prefix**: Add a custom prefix to log messages for better identification.
- **Source Identifier**: Include a source identifier (e.g., class or service name) to provide additional context.

---

## **Internal Use Only**

This package is intended for internal use within SearchService Inc. It is not designed for external projects and may include features or configurations specific to the company's requirements.

---

## **Contributing**

Contributions are welcome from employees of SearchService Inc. Please adhere to the company's standard contribution guidelines when submitting updates or enhancements to this package.

---

## **Disclaimer**

This package is provided "as is," without any warranty. SearchService Inc. assumes no responsibility for any issues or damages arising from the use of this package.

---

### **Notes**

This README provides an overview of the `logger` package, including its purpose, features, usage examples, and internal usage guidelines. It has been tailored for internal documentation purposes and can be adapted further to meet specific project requirements.# logger
