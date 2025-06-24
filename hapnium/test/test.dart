import 'classes/optional_test.dart' as optional_test;

import 'extensions/bool_extension_test.dart' as bool_extension_test;
import 'extensions/int_extension_test.dart' as int_extension_test;
import 'extensions/double_extension_test.dart' as double_extension_test;
import 'extensions/iterable_extension_test.dart' as iterable_extension_test;
import 'extensions/list_extension_test.dart' as list_extension_test;
import 'extensions/map_extension_test.dart' as map_extension_test;
import 'extensions/num_extension_test.dart' as num_extension_test;
import 'extensions/other_extension_test.dart' as other_extension_test;
import 'extensions/string_extension_test.dart' as string_extension_test;

import 'utils/instance_test.dart' as instance_test;
import 'utils/json_utils_test.dart' as json_utils_test;
import 'utils/regex_utils_test.dart' as regex_utils_test;

void main() {
  optional_test.main();

  bool_extension_test.main();
  int_extension_test.main();
  double_extension_test.main();
  iterable_extension_test.main();
  list_extension_test.main();
  map_extension_test.main();
  num_extension_test.main();
  other_extension_test.main();
  string_extension_test.main();

  instance_test.main();
  json_utils_test.main();
  regex_utils_test.main();
}