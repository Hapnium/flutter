/// # Hapnium Library
///
/// `hapnium` is a utility library for Dart that provides various helper classes,
/// extensions, and utilities to enhance and simplify common operations such as
/// string manipulation, list processing, type checks, and optional value handling.
///
/// ## Features
/// - **Classes**: Contains classes for managing optional values.
/// - **Exceptions**: Custom exception classes to handle errors gracefully.
/// - **Extensions**: Adds utility methods to core Dart types like `String`, `int`, `List`, `Map`, `bool`, etc.
/// - **Utils**: Helper functions for working with JSON, instances, type conversion, and more.
library hapnium;

/// CLASSES
export 'src/classes/optional.dart';

/// EXCEPTIONS
export 'src/exceptions/hapnium_exception.dart';

/// EXTENSIONS
export 'src/extensions/primitives/string.dart';
export 'src/extensions/primitives/bool.dart';
export 'src/extensions/primitives/int.dart';
export 'src/extensions/primitives/list.dart';
export 'src/extensions/primitives/map.dart';
export 'src/extensions/primitives/double.dart';
export 'src/extensions/primitives/num.dart';
export 'src/extensions/primitives/iterable.dart';

export 'src/extensions/others/dynamic.dart';
export 'src/extensions/others/t.dart';
export 'src/extensions/others/duration.dart';
export 'src/extensions/others/date_time.dart';

/// UTILS
export 'src/utils/instance.dart';
export 'src/utils/json_utils.dart';
export 'src/utils/type_utils.dart';
export 'src/utils/typedefs.dart';