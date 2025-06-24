import 'package:sedat/sedat.dart';
import 'package:hapnium/hapnium.dart';

/// {@template json_repository}
/// A generic repository for storing domain model data as JSON-compatible map structures (`JsonMap`).
///
/// Designed for models that serialize to and from `Map<String, dynamic>`.
///
/// ## Example
/// ```dart
/// class UserRepository extends JsonRepository<User> {
///   UserRepository() : super('userBox');
/// }
/// ```
/// {@endtemplate}
abstract class JsonRepository<Data> extends Repository<Data, JsonMap> {
  /// {@macro json_repository}
  JsonRepository(super.boxName);
}

/// {@template collection_repository}
/// A generic repository for storing domain model data as collections of maps (`JsonMapCollection`).
///
/// Useful when the model represents multiple grouped items or structured JSON arrays.
///
/// ## Example
/// ```dart
/// class OrderRepository extends CollectionRepository<Order> {
///   OrderRepository() : super('orderBox');
/// }
/// ```
/// {@endtemplate}
abstract class CollectionRepository<Data> extends Repository<Data, JsonMapCollection> {
  /// {@macro collection_repository}
  CollectionRepository(super.boxName);
}

/// {@template string_repository}
/// A generic repository for storing domain model data as raw `String` values.
///
/// Ideal for storing data like tokens, messages, and serialized strings.
///
/// ## Example
/// ```dart
/// class TokenRepository extends StringRepository<String> {
///   TokenRepository() : super('tokenBox');
/// }
/// ```
/// {@endtemplate}
abstract class StringRepository<Data> extends Repository<Data, String> {
  /// {@macro string_repository}
  StringRepository(super.boxName);
}

/// {@template int_repository}
/// A generic repository for storing domain model data as `int` values.
///
/// Useful for counters, timestamps, and other numeric representations.
///
/// ## Example
/// ```dart
/// class ScoreRepository extends IntRepository<int> {
///   ScoreRepository() : super('scoreBox');
/// }
/// ```
/// {@endtemplate}
abstract class IntRepository<Data> extends Repository<Data, int> {
  /// {@macro int_repository}
  IntRepository(super.boxName);
}

/// {@template double_repository}
/// A generic repository for storing domain model data as `double` values.
///
/// Useful for floating-point values like prices, percentages, or ratings.
///
/// ## Example
/// ```dart
/// class RatingRepository extends DoubleRepository<double> {
///   RatingRepository() : super('ratingBox');
/// }
/// ```
/// {@endtemplate}
abstract class DoubleRepository<Data> extends Repository<Data, double> {
  /// {@macro double_repository}
  DoubleRepository(super.boxName);
}

/// {@template bool_repository}
/// A generic repository for storing domain model data as `bool` values.
///
/// Ideal for toggle states, flags, and conditions.
///
/// ## Example
/// ```dart
/// class PreferenceRepository extends BoolRepository<bool> {
///   PreferenceRepository() : super('prefsBox');
/// }
/// ```
/// {@endtemplate}
abstract class BoolRepository<Data> extends Repository<Data, bool> {
  /// {@macro bool_repository}
  BoolRepository(super.boxName);
}

/// {@template datetime_repository}
/// A generic repository for storing domain model data as `DateTime` values.
///
/// Suitable for timestamps, scheduling, or temporal logs.
///
/// ## Example
/// ```dart
/// class LogRepository extends DateTimeRepository<DateTime> {
///   LogRepository() : super('logBox');
/// }
/// ```
/// {@endtemplate}
abstract class DateTimeRepository<Data> extends Repository<Data, DateTime> {
  /// {@macro datetime_repository}
  DateTimeRepository(super.boxName);
}

/// {@template duration_repository}
/// A generic repository for storing domain model data as `Duration` values.
///
/// Ideal for timers, delays, or performance benchmarks.
///
/// ## Example
/// ```dart
/// class TimerRepository extends DurationRepository<Duration> {
///   TimerRepository() : super('timerBox');
/// }
/// ```
/// {@endtemplate}
abstract class DurationRepository<Data> extends Repository<Data, Duration> {
  /// {@macro duration_repository}
  DurationRepository(super.boxName);
}

/// {@template list_repository}
/// A generic repository for storing domain model data as `List<dynamic>` values.
///
/// Commonly used for caching, logs, or history tracking.
///
/// ## Example
/// ```dart
/// class HistoryRepository extends ListRepository<List<dynamic>> {
///   HistoryRepository() : super('historyBox');
/// }
/// ```
/// {@endtemplate}
abstract class ListRepository<Data> extends Repository<Data, List<dynamic>> {
  /// {@macro list_repository}
  ListRepository(super.boxName);
}

/// {@template set_repository}
/// A generic repository for storing domain model data as `Set<dynamic>` values.
///
/// Useful for managing collections without duplicates.
///
/// ## Example
/// ```dart
/// class TagRepository extends SetRepository<Set<dynamic>> {
///   TagRepository() : super('tagBox');
/// }
/// ```
/// {@endtemplate}
abstract class SetRepository<Data> extends Repository<Data, Set<dynamic>> {
  /// {@macro set_repository}
  SetRepository(super.boxName);
}

/// {@template dynamic_map_repository}
/// A generic repository for storing domain model data as `Map<dynamic, dynamic>` values.
///
/// Useful when the value and key types are not strictly defined and can vary dynamically.
///
/// ## Example
/// ```dart
/// class CacheRepository extends DynamicMapRepository<Map<dynamic, dynamic>> {
///   CacheRepository() : super('cacheBox');
/// }
/// ```
/// {@endtemplate}
abstract class DynamicMapRepository<Data> extends Repository<Data, Map<dynamic, dynamic>> {
  /// {@macro dynamic_map_repository}
  DynamicMapRepository(super.boxName);
}