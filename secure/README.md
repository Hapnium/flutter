### README for `secure` Package

---

# **Secure**

`secure` is a versatile encryption and decryption library designed for Flutter applications. It supports RSA and EC cryptographic algorithms to ensure secure messaging and data exchange.

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

Install `secure` using Flutter:

```yaml
dependencies:
  secure:
    git:
      url: https://github.com/Hapnium/flutter.git
      ref: main
      path: secure
```

Run `flutter pub get` to install the package.

---

## **Usage**

### **Example Implementation**

```dart
import 'package:tracing/tracing.dart';
import 'package:secure/secure.dart';

void main() {
  console.log(":::::::::::::::::::::::::::: RSASecureMessaging Example ::::::::::::::::::::::::::::::::");
  _showRSAMessagingExample();

  console.log(":::::::::::::::::::::::::::: ECSecureMessaging Example ::::::::::::::::::::::::::::::::");
  _showECMessagingExample();
}

void _showRSAMessagingExample() {
  SecureMessaging messaging = SecureMessaging.rsa();

  SecureKeyResponse user = messaging.generate();
  console.log(user.toJson());
  SecureKeyResponse recipient = messaging.generate();
  console.log(recipient.toJson());

  String message = "Welcome to Hapnium";
  console.log(message, from: "RSASecureMessaging | Initial Message");

  String encryptedMessage = messaging.encrypt(message: message, publicKey: recipient.publicKey);
  MessagingResponse decryptedMessage = messaging.decrypt(message: encryptedMessage, privateKey: recipient.privateKey);
  console.log(decryptedMessage.toJson(), from: "RSASecureMessaging | Decrypted Recipient Message");
}

void _showECMessagingExample() {
  SecureMessaging messaging = SecureMessaging.ec();

  SecureKeyResponse user = messaging.generate();
  console.log(user.toJson());
  SecureKeyResponse recipient = messaging.generate();
  console.log(recipient.toJson());

  String message = "Welcome to Hapnium";
  console.log(message, from: "ECSecureMessaging | Initial Message");

  String encryptedMessage = messaging.encrypt(message: message, publicKey: recipient.publicKey);
  MessagingResponse decryptedMessage = messaging.decrypt(message: encryptedMessage, privateKey: recipient.privateKey);
  console.log(decryptedMessage.toJson(), from: "ECSecureMessaging | Decrypted Recipient Message");
}
```

### **Supported Features**

| Feature                     | Description                                                                  |
|-----------------------------|------------------------------------------------------------------------------|
| **RSA Encryption/Decryption** | Encrypt and decrypt messages using RSA cryptography.                       |
| **EC Encryption/Decryption**  | Encrypt and decrypt messages using Elliptic Curve cryptography.            |
| **Key Generation**            | Generate secure RSA or EC keys for messaging.                              |
| **tracing Support**           | Integrated logging for debugging and monitoring encryption operations.      |

---

## **License**

This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.