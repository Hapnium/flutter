import 'package:sedat/sedat.dart';
import 'package:hapnium/hapnium.dart';

/// A repository class specialized for storing data as `JsonMap` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `JsonMap` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class JsonRepository<Data> extends Repository<Data, JsonMap> {
  /// Creates a new [JsonRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  JsonRepository(super.boxName);
}

/// A repository class specialized for storing data as `JsonMapCollection` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `JsonMapCollection` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class CollectionRepository<Data> extends Repository<Data, JsonMapCollection> {
  /// Creates a new [CollectionRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  CollectionRepository(super.boxName);
}

/// A repository class specialized for storing data as `String` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `String` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class StringRepository<Data> extends Repository<Data, String> {
  /// Creates a new [StringRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  StringRepository(super.boxName);
}

/// A repository class specialized for storing data as `int` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `int` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class IntRepository<Data> extends Repository<Data, int> {
  /// Creates a new [IntRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  IntRepository(super.boxName);
}

/// A repository class specialized for storing data as `double` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `double` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class DoubleRepository<Data> extends Repository<Data, double> {
  /// Creates a new [DoubleRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  DoubleRepository(super.boxName);
}

/// A repository class specialized for storing data as `bool` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `bool` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class BoolRepository<Data> extends Repository<Data, bool> {
  /// Creates a new [BoolRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  BoolRepository(super.boxName);
}

/// A repository class specialized for storing data as `DateTime` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `DateTime` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class DateTimeRepository<Data> extends Repository<Data, DateTime> {
  /// Creates a new [DateTimeRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  DateTimeRepository(super.boxName);
}

/// A repository class specialized for storing data as `Duration` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `Duration` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class DurationRepository<Data> extends Repository<Data, Duration> {
  /// Creates a new [DurationRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  DurationRepository(super.boxName);
}

/// A repository class specialized for storing data as `List<dynamic>` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `List<dynamic>` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class ListRepository<Data> extends Repository<Data, List<dynamic>> {
  /// Creates a new [ListRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  ListRepository(super.boxName);
}

/// A repository class specialized for storing data as `Set<dynamic>` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `Set<dynamic>` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class SetRepository<Data> extends Repository<Data, Set<dynamic>> {
  /// Creates a new [SetRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  SetRepository(super.boxName);
}

/// A repository class specialized for storing data as `Map<dynamic, dynamic>` objects.
///
/// This abstract class extends [Repository] and simplifies the creation
/// of repositories that store data in the form of `Map<dynamic, dynamic>` objects.
///
/// Type parameter:
///
/// * [Data]: The type of the domain model data.
abstract class DynamicMapRepository<Data> extends Repository<Data, Map<dynamic, dynamic>> {
  /// Creates a new [DynamicMapRepository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  DynamicMapRepository(super.boxName);
}