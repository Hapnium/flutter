import 'dart:io' as io;

import '../interface/http_headers.dart';

/// A wrapper for [io.HttpHeaders]
class IoHttpHeaders implements HttpHeaders {
  final io.HttpHeaders _headers;
  IoHttpHeaders({required io.HttpHeaders headers}) : _headers = headers;

  @override
  bool get chunkedTransferEncoding => _headers.chunkedTransferEncoding;

  @override
  int get contentLength => _headers.contentLength;

  @override
  DateTime? get date => _headers.date;

  @override
  DateTime? get expires => _headers.expires;

  @override
  String? get host => _headers.host;

  @override
  DateTime? get ifModifiedSince => _headers.ifModifiedSince;

  @override
  bool get persistentConnection => _headers.persistentConnection;

  @override
  int? get port => _headers.port;

  @override
  List<String>? operator [](String name) {
    return _headers[name];
  }

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers.add(name, value, preserveHeaderCase: preserveHeaderCase);
  }

  @override
  void clear() {
    _headers.clear();
  }

  @override
  void forEach(void Function(String name, List<String> values) action) {
    _headers.forEach(action);
  }

  @override
  void noFolding(String name) {
    _headers.noFolding(name);
  }

  @override
  void remove(String name, Object value) {
    _headers.remove(name, value);
  }

  @override
  void removeAll(String name) {
    _headers.removeAll(name);
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers.set(name, value, preserveHeaderCase: preserveHeaderCase);
  }

  @override
  String? value(String name) {
    return _headers.value(name);
  }

  @override
  set chunkedTransferEncoding(bool chunkedTransferEncoding) {
    _headers.chunkedTransferEncoding = chunkedTransferEncoding;
  }

  @override
  set contentLength(int contentLength) {
    _headers.contentLength = contentLength;
  }

  @override
  set date(DateTime? date) {
    _headers.date = date;
  }

  @override
  set expires(DateTime? expires) {
    _headers.expires = expires;
  }

  @override
  set host(String? host) {
    _headers.host = host;
  }

  @override
  set ifModifiedSince(DateTime? ifModifiedSince) {
    _headers.ifModifiedSince = ifModifiedSince;
  }

  @override
  set persistentConnection(bool persistentConnection) {
    _headers.persistentConnection = persistentConnection;
  }

  @override
  set port(int? port) {
    _headers.port = port;
  }
}