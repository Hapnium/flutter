import 'package:tracing/tracing.dart';

void main() {
  Tracing tracing = Tracing();

  Map<String, String> json = {
    "public_key": """
      -----BEGIN PUBLIC KEY-----
    MIIBCgKCAQEAoDlI9opmvwaGGDK3G8XDBv75RCm7QEFFWQHcBWRG8yIyb4LYu/1X
    jzgeH6qLC/lJm2e2sHHnxuHCIVpblokg47b3BFmyiD3ZpC9mtHsXvbOZTppQJTF6
    KxkrSZhBotjvp6nz+kXJX/MGF/a0KRfBepd9NSjg98PcI22HW7CEiuykMvSV2YQX
    JufEJ+I71FYqgbMZJ/OJ6AuVGjFKy94YoD6zVMxtfHk92LrRTF5/+9C06BF0CO5Z
    4siJi2cinIb7VXSOxI+gjcvQ8g5rZQojnBlJIh8UfEZ6ZFksqDxNS9CrwpIjWGxS
    1K8LAg++sZLuijuIYVOU2XhBVU46CcZZ8QIDAQAB"
    -----END PUBLIC KEY-----
      """,
    "private_key": """
    -----BEGIN PRIVATE KEY-----
    MIICCQKCAQEAoDlI9opmvwaGGDK3G8XDBv75RCm7QEFFWQHcBWRG8yIyb4LYu/1X
    jzgeH6qLC/lJm2e2sHHnxuHCIVpblokg47b3BFmyiD3ZpC9mtHsXvbOZTppQJTF6
    KxkrSZhBotjvp6nz+kXJX/MGF/a0KRfBepd9NSjg98PcI22HW7CEiuykMvSV2YQX
    JufEJ+I71FYqgbMZJ/OJ6AuVGjFKy94YoD6zVMxtfHk92LrRTF5/+9C06BF0CO5Z
    4siJi2cinIb7VXSOxI+gjcvQ8g5rZQojnBlJIh8UfEZ6ZFksqDxNS9CrwpIjWGxS
    1K8LAg++sZLuijuIYVOU2XhBVU46CcZZ8QKCAQAN8o6ob4ncLSw1JQ0NjNyaWk3G
    oj9bq5Lm2aOWkJEgjySG0oQdcUNTA1aT+RubkjrXHWMo3vGHPZXRo3T/mLZVPFMq
    fMhu1buBcGLnaSO67sx0rDg31KPG5qz+/hMQowPRu5iye6q5AIXSRjaOsTO1gUR0
    ATf8OX+LUfiLgcU39phP5TiJB8seU8eCwW9/DCyf1Z5JB7ogVqpbu1jaWo7Wh2kK
    CHSFwFH1S6AzbWiSyqYPeXL0mvd5sJSk+yc+Thuix/7pdnOuY3lCBkB2preAFIVn
    pVPepjcQMZwLxXrRCLZq9BpEvZxGP7PuA4XTA3g9kJus1d2KNBfdSE73t97x
    -----END PRIVATE KEY-----
    """
  };
  tracing.info(json);

  String hello = "Welcome to Logger Flutter";
  tracing.info(hello);

  List<String> list = [
    "Welcome to Logger Flutter",
    "Welcome to Logger Flutter",
    "Welcome to Logger Flutter"
  ];
  tracing.info(list);
}