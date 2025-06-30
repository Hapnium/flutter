/// Optional logger interface
abstract class PageableLogger {
  void log(String message, {String? tag});
}

/// Default console logger
class ConsolePageableLogger implements PageableLogger {
  @override
  void log(String message, {String? tag}) {
    print('[${tag ?? 'Pageable'}] $message');
  }
}