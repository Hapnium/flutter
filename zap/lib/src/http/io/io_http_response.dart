import 'dart:async';
import 'dart:io' as io;

import '../../definitions.dart';
import '../interface/http_client_response.dart';
import '../utils/http_headers.dart';
import '../interface/redirect_info.dart';
import 'io_http_headers.dart';
import 'io_redirect_info.dart';

/// {@template io_http_response}
/// A `dart:io` implementation of `HttpClientResponse`
/// 
/// This class is used to wrap [io.HttpClientResponse] to implement [HttpClientResponse].
/// 
/// {@endtemplate}
class IOHttpResponse implements HttpClientResponse {
  /// The wrapped [io.HttpClientResponse].
  final io.HttpClientResponse _response;

  /// {@macro io_http_response}
  IOHttpResponse({required io.HttpClientResponse response}) : _response = response;

  @override
  Future<bool> any(bool Function(BodyBytes element) test) {
    return _response.any(test);
  }

  @override
  BodyByteStream asBroadcastStream({
    void Function(StreamSubscription<BodyBytes> subscription)? onListen,
    void Function(StreamSubscription<BodyBytes> subscription)? onCancel,
  }) {
    return _response.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(BodyBytes event) convert) {
    return _response.asyncExpand(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(BodyBytes event) convert) {
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
  BodyByteStream distinct([bool Function(BodyBytes previous, BodyBytes next)? equals]) {
    return _response.distinct(equals);
  }

  @override
  Future<E> drain<E>([E? futureValue]) {
    return _response.drain(futureValue);
  }

  @override
  Future<BodyBytes> elementAt(int index) {
    return _response.elementAt(index);
  }

  @override
  Future<bool> every(bool Function(BodyBytes element) test) {
    return _response.every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(BodyBytes element) convert) {
    return _response.expand(convert);
  }

  @override
  Future<BodyBytes> get first => _response.first;

  @override
  Future<BodyBytes> firstWhere(bool Function(BodyBytes element) test, {BodyBytes Function()? orElse}) {
    return _response.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(S initialValue, S Function(S previous, BodyBytes element) combine) {
    return _response.fold(initialValue, combine);
  }

  @override
  Future<void> forEach(void Function(BodyBytes element) action) {
    return _response.forEach(action);
  }

  @override
  BodyByteStream handleError(Function onError, {bool Function(dynamic error)? test}) {
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
  Future<BodyBytes> get last => _response.last;

  @override
  Future<BodyBytes> lastWhere(bool Function(BodyBytes element) test,
      {BodyBytes Function()? orElse}) {
    return _response.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => _response.length;

  @override
  StreamSubscription<BodyBytes> listen(void Function(BodyBytes event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _response.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Stream<S> map<S>(S Function(BodyBytes event) convert) {
    return _response.map(convert);
  }

  @override
  bool get persistentConnection => _response.persistentConnection;

  @override
  Future pipe(StreamConsumer<BodyBytes> streamConsumer) {
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
  Future<BodyBytes> reduce(BodyBytes Function(BodyBytes previous, BodyBytes element) combine) {
    return _response.reduce(combine);
  }

  @override
  Future<BodyBytes> get single => _response.single;

  @override
  Future<BodyBytes> singleWhere(bool Function(BodyBytes element) test, {BodyBytes Function()? orElse}) {
    return _response.singleWhere(test, orElse: orElse);
  }

  @override
  BodyByteStream skip(int count) {
    return _response.skip(count);
  }

  @override
  BodyByteStream skipWhile(bool Function(BodyBytes element) test) {
    return _response.skipWhile(test);
  }

  @override
  int get statusCode => _response.statusCode;

  @override
  BodyByteStream take(int count) {
    return _response.take(count);
  }

  @override
  BodyByteStream takeWhile(bool Function(BodyBytes element) test) {
    return _response.takeWhile(test);
  }

  @override
  BodyByteStream timeout(Duration timeLimit,
      {void Function(EventSink<BodyBytes> sink)? onTimeout}) {
    return _response.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<BodyBytes>> toList() {
    return _response.toList();
  }

  @override
  Future<Set<BodyBytes>> toSet() {
    return _response.toSet();
  }

  @override
  Stream<S> transform<S>(StreamTransformer<BodyBytes, S> streamTransformer) {
    return _response.transform(streamTransformer);
  }

  @override
  BodyByteStream where(bool Function(BodyBytes event) test) {
    return _response.where(test);
  }
}