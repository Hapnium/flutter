/// A function that takes a value of type [T] and returns a boolean.
///
/// Used for testing or filtering values.
typedef Checker<T> = Boolean Function(T value);

/// A function that takes a value of type [T] and returns a value of type [U].
///
/// Used for transforming or mapping values from one type to another.
typedef Mapper<T, U> = U Function(T value);

/// A function that takes a value of type [T] and performs an operation on it.
///
/// Used for side effects or actions that don't return a value.
typedef Consumer<T> = void Function(T value);

/// A function that returns a value of type [T].
///
/// Used for providing default values or generating values on demand.
typedef Supplier<T> = T Function();

/// A function that returns an exception object.
///
/// Used for providing exceptions to be thrown in specific scenarios.
typedef ExceptionSupplier = Object Function();

/// A type alias for structured key-value storage used in repositories.
///
/// This is typically used for storing JSON-like objects in a repository.
typedef JsonMap = Map<String, dynamic>;

/// A type alias for a collection of structured repository data.
///
/// Useful when handling multiple JSON-like objects within a repository.
typedef JsonMapCollection = List<JsonMap>;

/// A collection of strings.
///
/// Represents a list containing multiple string values.
typedef StringCollection = List<String>;

/// A set of unique strings.
///
/// Ensures that no duplicate string values exist within the collection.
typedef StringSet = Set<String>;

/// A JSON-like structure where both keys and values are strings.
///
/// Example:
/// ```json
/// {
///   "name": "Alice",
///   "city": "New York"
/// }
/// ```
typedef JsonString = Map<String, String>;

/// A shorthand for an integer value.
typedef Int = int;

/// A collection of integers using the `Int` alias.
///
/// Represents a list containing multiple `Int` values.
typedef IntCollection = List<Int>;

/// A set of unique integers using the `Int` alias.
///
/// Ensures that no duplicate `Int` values exist within the collection.
typedef IntSet = Set<Int>;

/// An alternative alias for an integer value.
typedef Integer = int;

/// A collection of integers using the `Integer` alias.
///
/// Represents a list containing multiple `Integer` values.
typedef IntegerCollection = List<Integer>;

/// A set of unique integers using the `Integer` alias.
///
/// Ensures that no duplicate `Integer` values exist within the collection.
typedef IntegerSet = Set<Integer>;

/// A shorthand for a boolean value.
typedef Boolean = bool;

/// A collection of boolean values.
///
/// Represents a list containing multiple `Boolean` values.
typedef BooleanCollection = List<Boolean>;

/// A set of unique boolean values.
///
/// Ensures that no duplicate `Boolean` values exist within the collection.
typedef BooleanSet = Set<Boolean>;

/// An alternative alias for a boolean value.
typedef Bool = bool;

/// A collection of boolean values using the `Bool` alias.
///
/// Represents a list containing multiple `Bool` values.
typedef BoolCollection = List<Bool>;

/// A set of unique boolean values using the `Bool` alias.
///
/// Ensures that no duplicate `Bool` values exist within the collection.
typedef BoolSet = Set<Bool>;

/// A shorthand for a double value.
typedef Double = double;

/// A collection of double values.
///
/// Represents a list containing multiple `Double` values.
typedef DoubleCollection = List<Double>;

/// A set of unique double values.
///
/// Ensures that no duplicate `Double` values exist within the collection.
typedef DoubleSet = Set<Double>;

/// A collection of date time values.
///
/// Represents a list containing multiple `DateTime` values.
typedef DateTimeCollection = List<DateTime>;

/// A set of unique date time values.
///
/// Ensures that no duplicate `DateTime` values exist within the collection.
typedef DateTimeSet = Set<DateTime>;

/// A collection of duration values.
///
/// Represents a list containing multiple `Duration` values.
typedef DurationCollection = List<Duration>;

/// Represents a set of unique duration values.
///
/// This typedef defines a set of `Duration` objects, ensuring that no
/// duplicate `Duration` values are included.
typedef DurationSet = Set<Duration>;

/// A typedef for a function that decodes a JSON map into an object of type [T].
///
/// This typedef is commonly used for deserializing JSON data into Dart objects.
/// The function takes a [Map<String, dynamic>] representing the JSON data and
/// returns an instance of type [T] populated with the data from the JSON map.
typedef JsonUtilsDecoder<T> = T Function(JsonMap json);

/// A typedef for a function that tests a condition on a value of type [T].
///
/// This typedef represents a function that takes a value of type [T] as input
/// and returns a boolean value indicating whether the condition is met.
///
/// **Parameters:**
///
/// * `value`: The value of type [T] to test.
///
/// **Returns:**
///
/// `true` if the condition is met, `false` otherwise.
///
/// **Usage:**
///
/// This typedef is commonly used for defining filter or predicate functions
/// that can be applied to collections or streams of data.
///
/// **Example:**
///
/// ```dart
/// typedef IsEven = ConditionTester<int>;
///
/// IsEven isEven = (int number) => number % 2 == 0;
///
/// List<int> numbers =;
///
/// List<int> evenNumbers = numbers.where(isEven).toList();
///
/// print(evenNumbers); // Output:
/// ```
typedef ConditionTester<T> = bool Function(T value);