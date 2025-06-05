import 'dart:async';
import 'dart:io' as io;

import '../interface/http_client_response.dart';
import '../interface/http_headers.dart';
import '../interface/redirect_info.dart';
import 'io_http_headers.dart';
import 'io_redirect_info.dart';

/// A `dart:io` implementation of `HttpClientResponse`
class IOHttpResponse implements HttpClientResponse {
  IOHttpResponse({required io.HttpClientResponse response}) : _response = response;
  final io.HttpClientResponse _response;

  @override
  Future<bool> any(bool Function(List<int> element) test) {
    return _response.any(test);
  }

  @override
  Stream<List<int>> asBroadcastStream({
    void Function(StreamSubscription<List<int>> subscription)? onListen,
    void Function(StreamSubscription<List<int>> subscription)? onCancel,
  }) {
    return _response.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(List<int> event) convert) {
    return _response.asyncExpand(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(List<int> event) convert) {
    return _response.asyncMap(convert);
  }

  @override
  Stream<R> cast<R>() {
    return _response.cast<R>();
  }

  @override
  Future<bool> contains(Object? needle) {
    return _response.contains(needle);
  }

  @override
  int get contentLength => _response.contentLength;

  @override
  Stream<List<int>> distinct([bool Function(List<int> previous, List<int> next)? equals]) {
    return _response.distinct(equals);
  }

  @override
  Future<E> drain<E>([E? futureValue]) {
    return _response.drain(futureValue);
  }

  @override
  Future<List<int>> elementAt(int index) {
    return _response.elementAt(index);
  }

  @override
  Future<bool> every(bool Function(List<int> element) test) {
    return _response.every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(List<int> element) convert) {
    return _response.expand(convert);
  }

  @override
  Future<List<int>> get first => _response.first;

  @override
  Future<List<int>> firstWhere(bool Function(List<int> element) test, {List<int> Function()? orElse}) {
    return _response.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(S initialValue, S Function(S previous, List<int> element) combine) {
    return _response.fold(initialValue, combine);
  }

  @override
  Future<void> forEach(void Function(List<int> element) action) {
    return _response.forEach(action);
  }

  @override
  Stream<List<int>> handleError(Function onError, {bool Function(dynamic error)? test}) {
    return _response.handleError(onError, test: test);
  }

  @override
  HttpHeaders get headers => IoHttpHeaders(headers: _response.headers);

  @override
  bool get isBroadcast => _response.isBroadcast;

  @override
  Future<bool> get isEmpty => _response.isEmpty;

  @override
  bool get isRedirect => _response.isRedirect;

  @override
  Future<String> join([String separator = ""]) {
    return _response.join(separator);
  }

  @override
  Future<List<int>> get last => _response.last;

  @override
  Future<List<int>> lastWhere(bool Function(List<int> element) test,
      {List<int> Function()? orElse}) {
    return _response.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => _response.length;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _response.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Stream<S> map<S>(S Function(List<int> event) convert) {
    return _response.map(convert);
  }

  @override
  bool get persistentConnection => _response.persistentConnection;

  @override
  Future pipe(StreamConsumer<List<int>> streamConsumer) {
    return _response.pipe(streamConsumer);
  }

  @override
  String get reasonPhrase => _response.reasonPhrase;

  @override
  Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followLoops]) async {
    final data = await _response.redirect(method, url, followLoops);
    return IOHttpResponse(response: data);
  }

  @override
  List<RedirectInfo> get redirects => _response.redirects
      .map((item) => IoRedirectInfo(redirectInfo: item))
      .toList();

  @override
  Future<List<int>> reduce(List<int> Function(List<int> previous, List<int> element) combine) {
    return _response.reduce(combine);
  }

  @override
  Future<List<int>> get single => _response.single;

  @override
  Future<List<int>> singleWhere(bool Function(List<int> element) test, {List<int> Function()? orElse}) {
    return _response.singleWhere(test, orElse: orElse);
  }

  @override
  Stream<List<int>> skip(int count) {
    return _response.skip(count);
  }

  @override
  Stream<List<int>> skipWhile(bool Function(List<int> element) test) {
    return _response.skipWhile(test);
  }

  @override
  int get statusCode => _response.statusCode;

  @override
  Stream<List<int>> take(int count) {
    return _response.take(count);
  }

  @override
  Stream<List<int>> takeWhile(bool Function(List<int> element) test) {
    return _response.takeWhile(test);
  }

  @override
  Stream<List<int>> timeout(Duration timeLimit,
      {void Function(EventSink<List<int>> sink)? onTimeout}) {
    return _response.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<List<int>>> toList() {
    return _response.toList();
  }

  @override
  Future<Set<List<int>>> toSet() {
    return _response.toSet();
  }

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) {
    return _response.transform(streamTransformer);
  }

  @override
  Stream<List<int>> where(bool Function(List<int> event) test) {
    return _response.where(test);
  }
}