import 'package:tracing/tracing.dart';
import 'package:secure/secure.dart';

void main() {
  console.log("::::::::::::::::::::::::::::::::::: RSASecureMessaging Example ::::::::::::::::::::::::::::::::::::::::");
  _showRSAMessagingExample();

  console.log("::::::::::::::::::::::::::::::::::: ECSecureMessaging Example ::::::::::::::::::::::::::::::::::::::::");
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

  String encryptedUserMessage = messaging.encrypt(message: message, publicKey: user.publicKey);
  MessagingResponse decryptedUserMessage = messaging.decrypt(message: encryptedUserMessage, privateKey: user.privateKey);
  console.log(decryptedUserMessage.toString(), from: "RSASecureMessaging | Decrypted User Message");
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

  String encryptedUserMessage = messaging.encrypt(message: message, publicKey: user.publicKey);
  MessagingResponse decryptedUserMessage = messaging.decrypt(message: encryptedUserMessage, privateKey: user.privateKey);
  console.log(decryptedUserMessage.toString(), from: "ECSecureMessaging | Decrypted User Message");
}