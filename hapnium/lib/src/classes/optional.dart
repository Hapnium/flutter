import '../exceptions/hapnium_exception.dart';

/// A container object which may or may not contain a non-null value.
/// 
/// If a value is present, [isPresent] returns `true`. If no value is present, 
/// the object is considered *empty* and [isPresent] returns `false`.
/// 
/// Additional methods that depend on the presence or absence of a contained
/// value are provided, such as [orElse] (returns a default value if no value 
/// is present) and [ifPresent] (performs an action if a value is present).
/// 
/// ## Usage Examples
/// 
/// ### Basic Creation and Checking
/// ```dart
/// // Create an Optional with a value
/// Optional<String> name = Optional.of("John");
/// print(name.isPresent()); // true
/// print(name.get()); // "John"
/// 
/// // Create an empty Optional
/// Optional<String> empty = Optional.empty();
/// print(empty.isPresent()); // false
/// print(empty.isEmpty()); // true
/// 
/// // Create Optional from nullable value
/// String? nullableValue = null;
/// Optional<String> fromNullable = Optional.ofNullable(nullableValue);
/// print(fromNullable.isEmpty()); // true
/// ```
/// 
/// ### Safe Value Retrieval
/// ```dart
/// Optional<String> name = Optional.of("Alice");
/// Optional<String> empty = Optional.empty();
/// 
/// // Using orElse for default values
/// print(name.orElse("Unknown")); // "Alice"
/// print(empty.orElse("Unknown")); // "Unknown"
/// 
/// // Using orElseGet with a supplier function
/// print(empty.orElseGet(() => "Generated default")); // "Generated default"
/// 
/// // Using orElseThrow
/// try {
///   print(empty.orElseThrow(() => Exception("No value present")));
/// } catch (e) {
///   print("Caught: $e"); // Caught: Exception: No value present
/// }
/// ```
/// 
/// ### Conditional Operations
/// ```dart
/// Optional<String> name = Optional.of("Bob");
/// Optional<String> empty = Optional.empty();
/// 
/// // Execute action if value is present
/// name.ifPresent((value) => print("Hello, $value!")); // Hello, Bob!
/// empty.ifPresent((value) => print("This won't print"));
/// 
/// // Execute different actions based on presence
/// name.ifPresentOrElse(
///   (value) => print("Found: $value"), // This executes
///   () => print("No value found")
/// );
/// 
/// empty.ifPresentOrElse(
///   (value) => print("Found: $value"),
///   () => print("No value found") // This executes
/// );
/// ```
/// 
/// ### Transformations and Filtering
/// ```dart
/// Optional<String> name = Optional.of("john doe");
/// 
/// // Transform the value if present
/// Optional<String> upperName = name.map((s) => s.toUpperCase());
/// print(upperName.get()); // "JOHN DOE"
/// 
/// // Chain transformations
/// Optional<int> nameLength = name
///     .map((s) => s.replaceAll(" ", ""))
///     .map((s) => s.length);
/// print(nameLength.get()); // 7
/// 
/// // Filter based on condition
/// Optional<String> longName = name.filter((s) => s.length > 5);
/// print(longName.isPresent()); // true
/// 
/// Optional<String> shortName = name.filter((s) => s.length < 5);
/// print(shortName.isEmpty()); // true
/// 
/// // FlatMap for nested Optionals
/// Optional<String> parseNumber(String s) {
///   try {
///     int.parse(s);
///     return Optional.of(s);
///   } catch (e) {
///     return Optional.empty();
///   }
/// }
/// 
/// Optional<String> input = Optional.of("123");
/// Optional<String> validNumber = input.flatMap(parseNumber);
/// print(validNumber.isPresent()); // true
/// ```
/// 
/// ### Working with Collections
/// ```dart
/// List<Optional<String>> optionals = [
///   Optional.of("apple"),
///   Optional.empty(),
///   Optional.of("banana"),
///   Optional.empty(),
///   Optional.of("cherry")
/// ];
/// 
/// // Filter out empty optionals and get values
/// List<String> fruits = optionals
///     .where((opt) => opt.isPresent())
///     .map((opt) => opt.get())
///     .toList();
/// print(fruits); // [apple, banana, cherry]
/// 
/// // Using stream() method for functional processing
/// List<String> upperFruits = optionals
///     .expand((opt) => opt.stream())
///     .map((fruit) => fruit.toUpperCase())
///     .toList();
/// print(upperFruits); // [APPLE, BANANA, CHERRY]
/// ```
/// 
/// ### Error Handling Patterns
/// ```dart
/// // Safe division function
/// Optional<double> safeDivide(double a, double b) {
///   return b != 0 ? Optional.of(a / b) : Optional.empty();
/// }
/// 
/// // Usage with error handling
/// Optional<double> result = safeDivide(10, 2);
/// result.ifPresentOrElse(
///   (value) => print("Result: $value"), // Result: 5.0
///   () => print("Division by zero!")
/// );
/// 
/// // Chain operations safely
/// Optional<String> formatResult = safeDivide(15, 3)
///     .filter((value) => value > 1)
///     .map((value) => "Result: ${value.toStringAsFixed(2)}");
/// 
/// print(formatResult.orElse("No valid result")); // Result: 5.00
/// ```
/// 
/// ## API Note
/// [Optional] is primarily intended for use as a method return type where
/// there is a clear need to represent "no result," and where using `null`
/// is likely to cause errors. A variable whose type is [Optional] should
/// never itself be `null`; it should always point to an [Optional] instance.
class Optional<T> {
  /// If non-null, the value; if null, indicates no value is present.
  final T? _value;

  /// Private constructor for creating Optional instances.
  /// 
  /// [value] the value to describe; it's the caller's responsibility to
  /// ensure the value is non-null unless creating the singleton
  /// instance returned by [empty].
  const Optional._(this._value);

  /// Returns an empty [Optional] instance. No value is present for this
  /// [Optional].
  /// 
  /// ## API Note
  /// Though it may be tempting to do so, avoid testing if an object is empty
  /// by comparing with `==` against instances returned by [Optional.empty].
  /// There is no guarantee that it is a singleton. Instead, use [isEmpty] or [isPresent].
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> empty = Optional.empty();
  /// print(empty.isEmpty()); // true
  /// print(empty.isPresent()); // false
  /// 
  /// // Don't do this - unreliable
  /// // if (someOptional == Optional.empty()) { ... }
  /// 
  /// // Do this instead
  /// if (someOptional.isEmpty()) { ... }
  /// ```
  /// 
  /// Returns an empty [Optional].
  static Optional<T> empty<T>() => Optional._(null);

  /// Returns an [Optional] describing the given non-null value.
  /// 
  /// [value] the value to describe, which must be non-null
  /// 
  /// Returns an [Optional] with the value present.
  /// 
  /// Throws [HapniumException] if value is null.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Alice");
  /// print(name.get()); // "Alice"
  /// 
  /// // This will throw an HapniumException
  /// try {
  ///   Optional<String> invalid = Optional.of(null);
  /// } catch (e) {
  ///   print("Error: $e"); // Error: Invalid argument(s): value cannot be null
  /// }
  /// ```
  static Optional<T> of<T>(T value) {
    if (value == null) {
      throw HapniumException('value cannot be null');
    }
    return Optional<T>._(value);
  }

  /// Returns an [Optional] describing the given value, if non-null,
  /// otherwise returns an empty [Optional].
  /// 
  /// [value] the possibly-null value to describe
  /// 
  /// Returns an [Optional] with a present value if the specified value
  /// is non-null, otherwise an empty [Optional].
  /// 
  /// ## Example
  /// ```dart
  /// String? nullableValue = "Hello";
  /// Optional<String> opt1 = Optional.ofNullable(nullableValue);
  /// print(opt1.isPresent()); // true
  /// 
  /// nullableValue = null;
  /// Optional<String> opt2 = Optional.ofNullable(nullableValue);
  /// print(opt2.isEmpty()); // true
  /// 
  /// // Useful for method parameters
  /// void processName(String? name) {
  ///   Optional.ofNullable(name)
  ///     .map((n) => n.toUpperCase())
  ///     .ifPresent((n) => print("Processing: $n"));
  /// }
  /// ```
  static Optional<T> ofNullable<T>(T? value) {
    return value == null ? empty<T>() : Optional<T>._(value);
  }

  /// If a value is present, returns the value, otherwise throws [HapniumException].
  /// 
  /// ## API Note
  /// The preferred alternative to this method is [orElseThrow].
  /// 
  /// Returns the non-null value described by this [Optional].
  /// 
  /// Throws [HapniumException] if no value is present.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Bob");
  /// print(name.get()); // "Bob"
  /// 
  /// Optional<String> empty = Optional.empty();
  /// try {
  ///   print(empty.get());
  /// } catch (e) {
  ///   print("Error: $e"); // Error: Bad state: No value present
  /// }
  /// ```
  T get() {
    if (_value == null) {
      throw HapniumException('No value present');
    }
    return _value as T;
  }

  /// If a value is present, returns `true`, otherwise `false`.
  /// 
  /// Returns `true` if a value is present, otherwise `false`.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Charlie");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// print(name.isPresent()); // true
  /// print(empty.isPresent()); // false
  /// 
  /// // Common usage pattern
  /// if (name.isPresent()) {
  ///   print("Name is: ${name.get()}");
  /// }
  /// ```
  bool isPresent() {
    return _value != null;
  }

  /// If a value is not present, returns `true`, otherwise `false`.
  /// 
  /// Returns `true` if a value is not present, otherwise `false`.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Diana");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// print(name.isEmpty()); // false
  /// print(empty.isEmpty()); // true
  /// 
  /// // Useful for guard clauses
  /// if (someOptional.isEmpty()) {
  ///   return "No data available";
  /// }
  /// ```
  bool isEmpty() {
    return _value == null;
  }

  /// If a value is present, performs the given action with the value,
  /// otherwise does nothing.
  /// 
  /// [action] the action to be performed, if a value is present
  /// 
  /// Throws [HapniumException] if value is present and the given action is null.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Eve");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// name.ifPresent((value) => print("Hello, $value!")); // Hello, Eve!
  /// empty.ifPresent((value) => print("This won't print"));
  /// 
  /// // Useful for side effects
  /// Optional<List<String>> items = Optional.of(["a", "b", "c"]);
  /// items.ifPresent((list) => list.add("d"));
  /// ```
  void ifPresent([void Function(T)? action]) {
    if (action == null) {
      throw HapniumException('action cannot be null');
    }
    if (_value != null) {
      action(_value as T);
    }
  }

  /// If a value is present, performs the given action with the value,
  /// otherwise performs the given empty-based action.
  /// 
  /// [action] the action to be performed, if a value is present
  /// [emptyAction] the empty-based action to be performed, if no value is present
  /// 
  /// Throws [HapniumException] if a value is present and the given action
  /// is null, or no value is present and the given empty-based action is null.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Frank");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// name.ifPresentOrElse(
  ///   (value) => print("Found: $value"), // This executes: Found: Frank
  ///   () => print("No value found")
  /// );
  /// 
  /// empty.ifPresentOrElse(
  ///   (value) => print("Found: $value"),
  ///   () => print("No value found") // This executes: No value found
  /// );
  /// 
  /// // Useful for handling both cases
  /// void processOptionalData(Optional<String> data) {
  ///   data.ifPresentOrElse(
  ///     (value) => processData(value),
  ///     () => handleMissingData()
  ///   );
  /// }
  /// ```
  void ifPresentOrElse([void Function(T)? action, void Function()? emptyAction]) {
    if (action == null) {
      throw HapniumException('action cannot be null');
    }
    if (emptyAction == null) {
      throw HapniumException('emptyAction cannot be null');
    }
    if (_value != null) {
      action(_value as T);
    } else {
      emptyAction();
    }
  }

  /// If a value is present, and the value matches the given predicate,
  /// returns an [Optional] describing the value, otherwise returns an
  /// empty [Optional].
  /// 
  /// [predicate] the predicate to apply to a value, if present
  /// 
  /// Returns an [Optional] describing the value of this [Optional],
  /// if a value is present and the value matches the given predicate,
  /// otherwise an empty [Optional].
  /// 
  /// Throws [HapniumException] if the predicate is null.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Grace");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// // Filter based on length
  /// Optional<String> longName = name.filter((s) => s.length > 3);
  /// print(longName.isPresent()); // true (Grace has 5 characters)
  /// 
  /// Optional<String> shortName = name.filter((s) => s.length < 3);
  /// print(shortName.isEmpty()); // true (Grace is not less than 3 characters)
  /// 
  /// // Empty optionals remain empty after filtering
  /// Optional<String> stillEmpty = empty.filter((s) => s.isNotEmpty);
  /// print(stillEmpty.isEmpty()); // true
  /// 
  /// // Chain with other operations
  /// Optional<String> result = Optional.of("hello world")
  ///     .filter((s) => s.contains("world"))
  ///     .map((s) => s.toUpperCase());
  /// print(result.get()); // "HELLO WORLD"
  /// ```
  Optional<T> filter([bool Function(T)? predicate]) {
    if (predicate == null) {
      throw HapniumException('predicate cannot be null');
    }
    if (isEmpty()) {
      return this;
    } else {
      return predicate(_value as T) ? this : empty<T>();
    }
  }

  /// If a value is present, returns an [Optional] describing (as if by
  /// [ofNullable]) the result of applying the given mapping function to
  /// the value, otherwise returns an empty [Optional].
  /// 
  /// If the mapping function returns a null result then this method
  /// returns an empty [Optional].
  /// 
  /// ## API Note
  /// This method supports post-processing on [Optional] values, without
  /// the need to explicitly check for a return status. For example, the
  /// following code processes a list of names, selects one that starts with 'A',
  /// and converts it to uppercase, returning an [Optional<String>]:
  /// 
  /// ```dart
  /// Optional<String> result = names
  ///     .where((name) => name.startsWith('A'))
  ///     .map(Optional.of)
  ///     .firstWhere((opt) => opt.isPresent(), orElse: () => Optional.empty())
  ///     .map((name) => name.toUpperCase());
  /// ```
  /// 
  /// [mapper] the mapping function to apply to a value, if present
  /// 
  /// Returns an [Optional] describing the result of applying a mapping
  /// function to the value of this [Optional], if a value is present,
  /// otherwise an empty [Optional].
  /// 
  /// Throws [HapniumException] if the mapping function is null.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("henry");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// // Transform to uppercase
  /// Optional<String> upperName = name.map((s) => s.toUpperCase());
  /// print(upperName.get()); // "HENRY"
  /// 
  /// // Chain transformations
  /// Optional<int> nameLength = name
  ///     .map((s) => s.trim())
  ///     .map((s) => s.length);
  /// print(nameLength.get()); // 5
  /// 
  /// // Empty optionals remain empty
  /// Optional<String> stillEmpty = empty.map((s) => s.toUpperCase());
  /// print(stillEmpty.isEmpty()); // true
  /// 
  /// // Mapping to null results in empty Optional
  /// Optional<String?> nullResult = name.map((s) => null);
  /// print(nullResult.isEmpty()); // true
  /// 
  /// // Complex transformations
  /// Optional<Map<String, int>> wordCount = Optional.of("hello world hello")
  ///     .map((text) => text.split(' '))
  ///     .map((words) {
  ///       Map<String, int> count = {};
  ///       for (String word in words) {
  ///         count[word] = (count[word] ?? 0) + 1;
  ///       }
  ///       return count;
  ///     });
  /// print(wordCount.get()); // {hello: 2, world: 1}
  /// ```
  Optional<U> map<U>([U? Function(T)? mapper]) {
    if (mapper == null) {
      throw HapniumException('mapper cannot be null');
    }
    if (isEmpty()) {
      return empty<U>();
    } else {
      return Optional.ofNullable(mapper(_value as T));
    }
  }

  /// If a value is present, returns the result of applying the given
  /// [Optional]-bearing mapping function to the value, otherwise returns
  /// an empty [Optional].
  /// 
  /// This method is similar to [map], but the mapping function is one whose
  /// result is already an [Optional], and if invoked, [flatMap] does not wrap
  /// it within an additional [Optional].
  /// 
  /// [mapper] the mapping function to apply to a value, if present
  /// 
  /// Returns the result of applying an [Optional]-bearing mapping
  /// function to the value of this [Optional], if a value is present,
  /// otherwise an empty [Optional].
  /// 
  /// Throws [HapniumException] if the mapping function is null or returns null.
  /// 
  /// ## Example
  /// ```dart
  /// // Helper function that returns Optional
  /// Optional<int> parseInteger(String s) {
  ///   try {
  ///     return Optional.of(int.parse(s));
  ///   } catch (e) {
  ///     return Optional.empty();
  ///   }
  /// }
  /// 
  /// Optional<String> input = Optional.of("123");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// // Using flatMap to avoid nested Optionals
  /// Optional<int> number = input.flatMap(parseInteger);
  /// print(number.get()); // 123
  /// 
  /// // Compare with map (would create Optional<Optional<int>>)
  /// // Optional<Optional<int>> nested = input.map(parseInteger);
  /// 
  /// // Empty input results in empty output
  /// Optional<int> noNumber = empty.flatMap(parseInteger);
  /// print(noNumber.isEmpty()); // true
  /// 
  /// // Chain multiple flatMap operations
  /// Optional<String> result = Optional.of("42")
  ///     .flatMap(parseInteger)
  ///     .filter((n) => n > 0)
  ///     .map((n) => "Number: $n");
  /// print(result.get()); // "Number: 42"
  /// 
  /// // Real-world example: safe navigation
  /// class Person {
  ///   final String name;
  ///   final Address? address;
  ///   Person(this.name, this.address);
  /// }
  /// 
  /// class Address {
  ///   final String street;
  ///   final String? zipCode;
  ///   Address(this.street, this.zipCode);
  /// }
  /// 
  /// Optional<String> getZipCode(Optional<Person> person) {
  ///   return person
  ///       .flatMap((p) => Optional.ofNullable(p.address))
  ///       .flatMap((a) => Optional.ofNullable(a.zipCode));
  /// }
  /// ```
  Optional<U> flatMap<U>([Optional<U> Function(T)? mapper]) {
    if (mapper == null) {
      throw HapniumException('mapper cannot be null');
    }
    if (isEmpty()) {
      return empty<U>();
    } else {
      Optional<U> result = mapper(_value as T);
      if (result.isEmpty()) {
        throw HapniumException('mapper returned null');
      }

      return result;
    }
  }

  /// If a value is present, returns an [Optional] describing the value,
  /// otherwise returns an [Optional] produced by the supplying function.
  /// 
  /// [supplier] the supplying function that produces an [Optional] to be returned
  /// 
  /// Returns an [Optional] describing the value of this [Optional],
  /// if a value is present, otherwise an [Optional] produced by the supplying function.
  /// 
  /// Throws [HapniumException] if the supplying function is null or produces null.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> primary = Optional.of("primary");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// // If primary has value, use it; otherwise use backup
  /// Optional<String> result1 = primary.or(() => Optional.of("backup"));
  /// print(result1.get()); // "primary"
  /// 
  /// Optional<String> result2 = empty.or(() => Optional.of("backup"));
  /// print(result2.get()); // "backup"
  /// 
  /// // Chain multiple fallbacks
  /// Optional<String> config = Optional.empty<String>()
  ///     .or(() => getFromEnvironment())
  ///     .or(() => getFromConfigFile())
  ///     .or(() => Optional.of("default"));
  /// 
  /// // Lazy evaluation - supplier only called when needed
  /// Optional<String> expensive = empty.or(() {
  ///   print("Computing expensive default...");
  ///   return Optional.of("expensive result");
  /// }); // "Computing expensive default..." is printed
  /// ```
  Optional<T> or([Optional<T> Function()? supplier]) {
    if (supplier == null) {
      throw HapniumException('supplier cannot be null');
    }
    if (isPresent()) {
      return this;
    } else {
      Optional<T> result = supplier();
      if (result.isEmpty()) {
        throw HapniumException('supplier returned null');
      }

      return result;
    }
  }

  /// If a value is present, returns an [Iterable] containing only that value,
  /// otherwise returns an empty [Iterable].
  /// 
  /// ## API Note
  /// This method can be used to transform an [Iterable] of optional
  /// elements to an [Iterable] of present value elements:
  /// ```dart
  /// Iterable<Optional<T>> optionals = ...;
  /// Iterable<T> values = optionals.expand((opt) => opt.stream());
  /// ```
  /// 
  /// Returns the optional value as an [Iterable].
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Iris");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// // Convert to iterable
  /// Iterable<String> nameStream = name.stream();
  /// print(nameStream.toList()); // ["Iris"]
  /// 
  /// Iterable<String> emptyStream = empty.stream();
  /// print(emptyStream.toList()); // []
  /// 
  /// // Useful for functional processing
  /// List<Optional<String>> optionals = [
  ///   Optional.of("apple"),
  ///   Optional.empty(),
  ///   Optional.of("banana")
  /// ];
  /// 
  /// List<String> fruits = optionals
  ///     .expand((opt) => opt.stream())
  ///     .toList();
  /// print(fruits); // ["apple", "banana"]
  /// 
  /// // Chain with other stream operations
  /// List<String> upperFruits = optionals
  ///     .expand((opt) => opt.stream())
  ///     .map((fruit) => fruit.toUpperCase())
  ///     .where((fruit) => fruit.startsWith('A'))
  ///     .toList();
  /// print(upperFruits); // ["APPLE"]
  /// ```
  Iterable<T> stream() {
    if (isEmpty()) {
      return <T>[];
    } else {
      return [_value as T];
    }
  }

  /// If a value is present, returns the value, otherwise returns [other].
  /// 
  /// [other] the value to be returned, if no value is present. May be null.
  /// 
  /// Returns the value, if present, otherwise [other].
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Jack");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// print(name.orElse("Unknown")); // "Jack"
  /// print(empty.orElse("Unknown")); // "Unknown"
  /// 
  /// // Can provide null as default
  /// String? result = empty.orElse(null);
  /// print(result); // null
  /// 
  /// // Useful for providing defaults
  /// String getUserName(Optional<String> optionalName) {
  ///   return optionalName.orElse("Guest");
  /// }
  /// 
  /// // With complex objects
  /// class Config {
  ///   final String host;
  ///   final int port;
  ///   Config(this.host, this.port);
  /// }
  /// 
  /// Optional<Config> userConfig = Optional.empty();
  /// Config defaultConfig = Config("localhost", 8080);
  /// Config config = userConfig.orElse(defaultConfig);
  /// ```
  T? orElse(T? other) {
    return _value != null ? _value as T : other;
  }

  /// If a value is present, returns the value, otherwise returns the result
  /// produced by the supplying function.
  /// 
  /// [supplier] the supplying function that produces a value to be returned
  /// 
  /// Returns the value, if present, otherwise the result produced by the
  /// supplying function.
  /// 
  /// Throws [HapniumException] if no value is present and the supplying function is null.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Kate");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// print(name.orElseGet(() => "Generated")); // "Kate"
  /// print(empty.orElseGet(() => "Generated")); // "Generated"
  /// 
  /// // Lazy evaluation - supplier only called when needed
  /// String expensiveDefault() {
  ///   print("Computing expensive default...");
  ///   return "expensive result";
  /// }
  /// 
  /// print(name.orElseGet(expensiveDefault)); // "Kate" (no print)
  /// print(empty.orElseGet(expensiveDefault)); // "expensive result" (prints message)
  /// 
  /// // Useful for expensive computations
  /// Optional<List<String>> cachedData = Optional.empty();
  /// List<String> data = cachedData.orElseGet(() => loadDataFromDatabase());
  /// 
  /// // With random values
  /// import 'dart:math';
  /// Random random = Random();
  /// Optional<int> maybeNumber = Optional.empty();
  /// int number = maybeNumber.orElseGet(() => random.nextInt(100));
  /// ```
  T orElseGet([T Function()? supplier]) {
    if (supplier == null) {
      throw HapniumException('supplier cannot be null');
    }
    return _value != null ? _value as T : supplier();
  }

  /// If a value is present, returns the value, otherwise throws [HapniumException].
  /// 
  /// Returns the non-null value described by this [Optional].
  /// 
  /// Throws [HapniumException] if no value is present.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Liam");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// print(name.orElseThrow()); // "Liam"
  /// 
  /// try {
  ///   print(empty.orElseThrow());
  /// } catch (e) {
  ///   print("Error: $e"); // Error: Bad state: No value present
  /// }
  /// 
  /// // Preferred over get() method
  /// String safeName = name.orElseThrow(); // Clear intent
  /// ```
  T orElseThrow() {
    if (_value == null) {
      throw HapniumException('No value present');
    }
    return _value as T;
  }

  /// If a value is present, returns the value, otherwise throws an exception
  /// produced by the exception supplying function.
  /// 
  /// ## API Note
  /// A function reference to an exception constructor can be used as the supplier.
  /// For example, `() => HapniumException('Custom message')`
  /// 
  /// [exceptionSupplier] the supplying function that produces an exception to be thrown
  /// 
  /// Returns the value, if present.
  /// 
  /// Throws the exception produced by [exceptionSupplier] if no value is present.
  /// Throws [HapniumException] if no value is present and the exception supplying function is null.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Mia");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// // With present value
  /// print(name.orElseThrow(() => HapniumException("Name required"))); // "Mia"
  /// 
  /// // With empty optional
  /// try {
  ///   print(empty.orElseThrow(() => HapniumException("Name is required")));
  /// } catch (e) {
  ///   print("Error: $e"); // Error: Invalid argument(s): Name is required
  /// }
  /// 
  /// // Different exception types
  /// try {
  ///   empty.orElseThrow(() => FormatException("Invalid format"));
  /// } catch (e) {
  ///   print("Format error: $e");
  /// }
  /// 
  /// // Custom exceptions
  /// class UserNotFoundException implements Exception {
  ///   final String message;
  ///   UserNotFoundException(this.message);
  ///   @override
  ///   String toString() => "UserNotFoundException: $message";
  /// }
  /// 
  /// Optional<String> userId = Optional.empty();
  /// try {
  ///   String id = userId.orElseThrow(() => UserNotFoundException("User not found"));
  /// } catch (e) {
  ///   print("Custom error: $e");
  /// }
  /// 
  /// // In validation scenarios
  /// String validateAndGetEmail(Optional<String> email) {
  ///   return email
  ///       .filter((e) => e.contains('@'))
  ///       .orElseThrow(() => HapniumException('Invalid email format'));
  /// }
  /// ```
  T orElseThrowWith<X extends Object>([X Function()? exceptionSupplier]) {
    if (exceptionSupplier == null) {
      throw HapniumException('exceptionSupplier cannot be null');
    }
    if (_value != null) {
      return _value as T;
    } else {
      throw exceptionSupplier();
    }
  }

  /// Indicates whether some other object is "equal to" this [Optional].
  /// 
  /// The other object is considered equal if:
  /// - it is also an [Optional] and;
  /// - both instances have no value present or;
  /// - the present values are "equal to" each other via [==].
  /// 
  /// [obj] an object to be tested for equality
  /// 
  /// Returns `true` if the other object is "equal to" this object otherwise `false`.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> opt1 = Optional.of("hello");
  /// Optional<String> opt2 = Optional.of("hello");
  /// Optional<String> opt3 = Optional.of("world");
  /// Optional<String> empty1 = Optional.empty();
  /// Optional<String> empty2 = Optional.empty();
  /// 
  /// print(opt1 == opt2); // true (same values)
  /// print(opt1 == opt3); // false (different values)
  /// print(empty1 == empty2); // true (both empty)
  /// print(opt1 == empty1); // false (one has value, one doesn't)
  /// 
  /// // Works with complex objects
  /// class Person {
  ///   final String name;
  ///   Person(this.name);
  ///   
  ///   @override
  ///   bool operator ==(Object other) =>
  ///       identical(this, other) ||
  ///       other is Person && name == other.name;
  ///   
  ///   @override
  ///   int get hashCode => name.hashCode;
  /// }
  /// 
  /// Optional<Person> person1 = Optional.of(Person("Alice"));
  /// Optional<Person> person2 = Optional.of(Person("Alice"));
  /// print(person1 == person2); // true
  /// ```
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Optional && _value == other._value;
  }

  /// Returns the hash code of the value, if present, otherwise `0` (zero)
  /// if no value is present.
  /// 
  /// Returns hash code value of the present value or `0` if no value is present.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Noah");
  /// Optional<String> empty = Optional.empty();
  /// 
  /// print(name.hashCode); // Same as "Noah".hashCode
  /// print(empty.hashCode); // 0
  /// 
  /// // Useful for using Optionals as map keys
  /// Map<Optional<String>, int> counts = {};
  /// counts[Optional.of("apple")] = 5;
  /// counts[Optional.empty()] = 0;
  /// 
  /// print(counts[Optional.of("apple")]); // 5
  /// print(counts[Optional.empty()]); // 0
  /// ```
  @override
  int get hashCode {
    return _value?.hashCode ?? 0;
  }

  /// Returns a non-empty string representation of this [Optional]
  /// suitable for debugging.
  /// 
  /// If a value is present the result includes its string representation.
  /// Empty and present [Optional]s are unambiguously differentiable.
  /// 
  /// Returns the string representation of this instance.
  /// 
  /// ## Example
  /// ```dart
  /// Optional<String> name = Optional.of("Olivia");
  /// Optional<String> empty = Optional.empty();
  /// Optional<int> number = Optional.of(42);
  /// 
  /// print(name.toString()); // "Optional[Olivia]"
  /// print(empty.toString()); // "Optional.empty"
  /// print(number.toString()); // "Optional[42]"
  /// 
  /// // Useful for debugging
  /// void debugOptional(Optional<String> opt) {
  ///   print("Debug: $opt");
  /// }
  /// 
  /// debugOptional(name); // Debug: Optional[Olivia]
  /// debugOptional(empty); // Debug: Optional.empty
  /// ```
  @override
  String toString() {
    return _value != null ? 'Optional[$_value]' : 'Optional.empty';
  }
}