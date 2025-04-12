## Overview

`sedat` is a Flutter package designed to provide a secure and efficient local database solution for Hapnium platforms. It leverages Hive for secure storage, offering encryption and other security features. The package emphasizes the repository pattern, making data access clean and maintainable.

**Key Features:**

* **Repository Pattern:** Offers abstract classes and implementations for defining repositories, simplifying data access and management.
* **Secure Storage:** Utilizes Hive for local storage, supporting encryption and other security measures.
* **Database Configuration:** Provides a structured way to configure your database, including opening boxes and setting up repositories.
* **Type Safety:** Supports various data storage formats and provides mechanisms for data encoding and decoding.
* **Customizable:** Easily extendable to fit diverse application needs.

## Getting Started

### Authentication

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

### Installation

Install `logging` using Flutter:

```yaml
dependencies:
  sedat:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: sedat
```

Then, run `flutter pub get`.

### 2\. Usage

Here's a step-by-step guide to using the `sedat` package:

**1. Define your data models:**

Create Dart classes representing the data you want to store. Ensure these classes have `toJson` and `fromJson` methods for serialization and deserialization.

```dart
class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  Map<String, dynamic> toJson() => {'name': name, 'age': age};
  factory User.fromJson(Map<String, dynamic> json) => User(name: json['name'], age: json['age']);
}
```

**2. Implement a repository:**

Extend `JsonRepository<T>` to create a repository for your data type. Register your decoder, encoder, and default value.

```dart
import 'package:sedat/sedat.dart';

class UserRepository extends JsonRepository<User> {
  UserRepository() : super('users') {
    registerDecoder(User.fromJson);
    registerDefault(User(name: 'Unknown', age: 0));
    registerEncoder((user) => user.toJson());
  }
}
```

**3. Create a configurer:**

Extend `AbstractSecureDatabaseConfigurer` to set up your database. Override `prefix` and `repositories` methods.

```dart
import 'package:sedat/sedat.dart';

class MyAppDatabaseConfigurer extends AbstractSecureDatabaseConfigurer {
  @override
  String get prefix => 'myApp';

  @override
  List<BaseRepository> repositories() => [UserRepository()];

  @override
  Future<void> setup() async {
    print("Database setup complete.");
  }
}
```

**4. Initialize the database:**

In your `main` function, initialize the database using your configurer.

```dart
import 'package:flutter/material.dart';
import 'package:sedat/sedat.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Ensure you have this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveFlutter.initFlutter(); // Initialize Hive for Flutter

  final configurer = MyAppDatabaseConfigurer();
  await configurer.initialize();

  // ... rest of your code
}
```

**5. Use your repositories:**

Access your data through the repository methods.

```dart
void main() async {
  // ... (Initialization from previous step)

  final userRepository = UserRepository();

  final newUser = User(name: 'Alice', age: 30);
  await userRepository.save(newUser);
  print('User saved: ${newUser.name}');

  final retrievedUser = userRepository.get();
  print('Retrieved user: ${retrievedUser.name}, ${retrievedUser.age}');

  final anotherUser = User(name: 'Bob', age: 25);
  await userRepository.save(anotherUser);
  print('User saved: ${anotherUser.name}');
}
```

## API Reference

**Core:**

* `AbstractSecureDatabaseConfigurer`: Base class for database configuration.

**Exceptions:**

* `SecureDatabaseException`: Custom exception for database errors.

**Repository:**

* `BaseRepository`: Base class for repositories.
* `JsonRepository<T>`: Repository class for JSON-serializable data.
* `RepositoryService`: Interface for repository operations.
* `types.dart`: Contains type definitions for repositories.

**Typedefs:**

* `typedefs.dart`: Contains common typedefs.

## Contributing

Contributions are welcome\! Please feel free to submit issues or pull requests on the GitHub repository.

## License

This package is released under the [MIT License](https://www.google.com/url?sa=E&source=gmail&q=LICENSE).