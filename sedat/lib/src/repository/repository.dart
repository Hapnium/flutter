import 'package:meta/meta.dart';
import 'package:sedat/sedat.dart';
import 'package:hapnium/hapnium.dart';

/// A simplified repository class that uses type adapters for data conversion.
///
/// This abstract class extends [BaseRepository] and provides a simplified way to
/// manage data conversion using type adapters. It allows you to register
/// decoder and encoder functions for converting between the domain model [Data]
/// and the storage format [DataType].
///
/// Type parameters:
///
/// * [Data]: The type of the domain model data.
/// * [DataType]: The type of the data as stored in the database.
abstract class Repository<Data, DataType> extends BaseRepository<Data, DataType> {
  /// Creates a new [Repository] instance.
  ///
  /// The [boxName] parameter is the name of the Hive box to use.
  Repository(super.boxName);

  /// The adapter function for decoding data from [DataType] to [Data].
  RepositoryAdapter<Data, DataType>? _adapter;

  /// The default value to return if the data is null.
  late Data _defaultValue;

  /// The adapter function for encoding data from [Data] to [DataType].
  RepositoryAdapter<DataType, Data>? _encoder;

  /// Whether the default value has been registered.
  bool _isDefaultRegistered = false;

  /// Registers a type adapter for decoding data from [DataType] to [Data].
  ///
  /// This method sets the decoder function that will be used to convert data
  /// retrieved from the database into the domain model.
  ///
  /// **Parameters:**
  ///
  /// * `decoder`: The adapter function to register.
  ///
  /// **Returns:**
  ///
  /// The [Repository] instance for method chaining.
  Repository<Data, DataType> registerDecoder(RepositoryAdapter<Data, DataType> decoder) {
    _adapter = decoder;

    return this;
  }

  /// Registers a default value to be returned if the data is null.
  ///
  /// This method sets the default value that will be returned when data is
  /// retrieved from the database and found to be null.
  ///
  /// **Parameters:**
  ///
  /// * `value`: The default value to register.
  ///
  /// **Returns:**
  ///
  /// The [Repository] instance for method chaining.
  Repository<Data, DataType> registerDefault(Data value) {
    _defaultValue = value;
    _isDefaultRegistered = true;

    return this;
  }

  /// Registers a type adapter for encoding data from [Data] to [DataType].
  ///
  /// This method sets the encoder function that will be used to convert data
  /// from the domain model into the storage format.
  ///
  /// **Parameters:**
  ///
  /// * `encoder`: The adapter function to register.
  ///
  /// **Returns:**
  ///
  /// The [Repository] instance for method chaining.
  Repository<Data, DataType> registerEncoder(RepositoryAdapter<DataType, Data> encoder) {
    _encoder = encoder;

    return this;
  }

  /// Registers all necessary adapters and the default value in one call.
  ///
  /// This method registers the decoder, encoder, and default value in a single
  /// call, simplifying the setup process.
  ///
  /// **Parameters:**
  ///
  /// * `decoder`: The adapter function for decoding data.
  /// * `encoder`: The adapter function for encoding data.
  /// * `defaultValue`: The default value to register.
  ///
  /// **Returns:**
  ///
  /// The [Repository] instance for method chaining.
  Repository<Data, DataType> registerAll({
    required RepositoryAdapter<Data, DataType> decoder,
    required RepositoryAdapter<DataType, Data> encoder,
    required Data defaultValue,
  }) {
    registerDecoder(decoder);
    registerEncoder(encoder);
    registerDefault(defaultValue);
    return this;
  }

  /// Converts the storage format [DataType] to the domain model [Data].
  ///
  /// This method is called by the [BaseRepository] class to convert data retrieved
  /// from the database into the domain model. It uses the registered decoder
  /// function, if any, or returns the default value if the data is null.
  ///
  /// **Parameters:**
  ///
  /// * `data`: The data retrieved from the database.
  ///
  /// **Returns:**
  ///
  /// An instance of the domain model [Data].
  ///
  /// **Throws:**
  ///
  /// * [SecureDatabaseException] if a default value or decoder is not registered.
  @override
  @nonVirtual
  Data fromStore(DataType? data) {
    if (_isDefaultRegistered.isFalse) {
      throw SecureDatabaseException("[SD-EXCEPTION] Default value must be provided");
    }

    if (data == null && _isDefaultRegistered) {
      return _defaultValue;
    }

    if (_adapter.isNotNull) {
      return _adapter!(data!);
    }

    throw SecureDatabaseException("[SD-EXCEPTION] You must call `registerAdapter`");
  }

  /// Converts the domain model [Data] to the storage format [DataType].
  ///
  /// This method is called by the [BaseRepository] class to convert data from the
  /// domain model into the storage format. It uses the registered encoder
  /// function, if any.
  ///
  /// **Parameters:**
  ///
  /// * `item`: The domain model data to convert.
  ///
  /// **Returns:**
  ///
  /// The data in the storage format [DataType].
  ///
  /// **Throws:**
  ///
  /// * [SecureDatabaseException] if an encoder is not registered.
  @override
  @nonVirtual
  DataType toStore(Data item) {
    if (_encoder.isNotNull) {
      return _encoder!(item);
    }

    throw SecureDatabaseException("[SD-EXCEPTION] You must call `registerAdapter`");
  }
}