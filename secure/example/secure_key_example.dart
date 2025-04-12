import 'package:tracing/tracing.dart';
import 'package:secure/secure.dart';

void main() {
  SecureKey service = SecureKey.factory();

  SecureKeyResponse user = service.generate("@Evastorm1");
  SecureKeyResponse recipient = service.generate("@UserTesting1");

  String message = "Welcome to Hapnium";
  console.log(message, from: "Secure Messaging | Initial Message");

  String encryptedMessage = service.encrypt(message: message, publicKey: recipient.publicKey);
  console.log(encryptedMessage);
  String decryptedMessage = service.decrypt(message: encryptedMessage, privateKey: recipient.privateKey);
  console.log(decryptedMessage, from: "Secure Messaging | Decrypted Recipient Message");

  String encryptedUserMessage = service.encrypt(message: message, publicKey: user.publicKey);
  String decryptedUserMessage = service.decrypt(message: encryptedUserMessage, privateKey: user.privateKey);
  console.log(decryptedUserMessage, from: "Secure Messaging | Decrypted User Message");
}