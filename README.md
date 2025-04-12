# Flutter

The **Flutter** repository serves as the central hub for all Flutter packages developed by **Hapnium Inc.**.
It provides a unified location for managing reusable libraries, tools, and components tailored to simplify Flutter development.

---

## 📦 Packages

This repository includes the following packages:

### 1. **connectify**
- Manages connection handling with retries, pooling, and error resilience.
- [Repository Link](https://github.com/Hapnium/flutter/connectify)

### 2. **websocket_flutter**
- Facilitates real-time communication through WebSocket integration.
- [Repository Link](https://github.com/Hapnium/flutter/websocket_flutter)

### 3. **logger**
- Provides advanced logging utilities for structured and detailed logs.
- [Repository Link](https://github.com/Hapnium/flutter/logger)

### 4. **secure**
- Focuses on encryption, secure storage, and authentication mechanisms.
- [Repository Link](https://github.com/Hapnium/flutter/secure)

### 5. **Additional Modules**
- More modules will be added as needed to support Flutter projects.

---

## 🚀 Getting Started

### Prerequisites
Ensure the following tools are installed:
- **Flutter SDK** (version `3.x.x` or later)
- **Dart** (version `2.x.x` or later)
- IDE such as Android Studio or Visual Studio Code.

---

### 🔐 Authentication: Special Configuration for Accessing Private Packages

To access any of the Flutter packages in this repository, you need to set up authentication using a `.netrc` file. This file ensures secure access to the private packages hosted on GitHub.

Steps to Configure Authentication:

1. Create a `.netrc` file in your home directory (e.g., `~/.netrc` on Linux/macOS or `%USERPROFILE%\.netrc` on Windows) with the following content:

   ```bash
   machine github.com
   login your_username
   password your_personal_access_token
   ```

2. Replace `your_username` with your GitHub username and `your_personal_access_token` with a GitHub personal access token that has the necessary scopes to access private repositories.

   > **Note:** The recommended scopes for the token are:
   > - `repo`
   > - `read:packages`

3. Set the appropriate permissions for the `.netrc` file to ensure security. Run the following command on Linux/macOS:
   ```bash
   chmod 600 ~/.netrc
   ```

### Installation
The **Flutter** repository is located at:
[https://github.com/Hapnium/flutter.git](https://github.com/Hapnium/flutter.git)

To use any of the included packages, you must reference them as submodules in the repository. Update your `pubspec.yaml` as follows:

```yaml
dependencies:
  connectify:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: connectify
  websocket_flutter:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: websocket_flutter
  logger:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: logger
  secure:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: secure
```

Run the following command to fetch the packages:
```bash
flutter pub get
```

---

## 🛠 Usage

Each module can be imported and used in your Flutter project. For example:

```dart
import 'package:connectify/connectify.dart';
import 'package:logger/logger.dart';
import 'package:secure/secure.dart';
```

Refer to the specific module documentation for detailed usage examples.

---

## 🌟 Features

- Modular architecture for easy integration.
- Focused on reusability and performance optimization.
- Regularly maintained and compatible with the latest Flutter/Dart versions.

---

## 🧩 Contributing

We welcome contributions! Follow these steps:
1. Fork the repository.
2. Clone your fork: `git clone https://github.com/your-username/flutter.git`.
3. Make your changes in a feature branch.
4. Open a pull request to the `main` branch.

Please adhere to **Hapnium Inc.** coding standards and include tests where applicable.

---

## 📝 License

This repository is licensed under the [MIT License](LICENSE). Use the code within the terms of the license.

---

## 📧 Contact

For support or inquiries, contact **Hapnium Inc.**:
- Email: [developer@hapnium.com](mailto:developer@hapnium.com)
- Website: [www.hapnium.com](https://www.hapnium.com)

---

## 🔮 Roadmap

- Add analytics and notification modules.
- Improve example applications for included modules.
- Enhance CI/CD workflows for module testing.

---# flutter
# flutter
