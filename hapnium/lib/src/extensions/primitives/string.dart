import './iterable.dart';
import './int.dart';

/// credits to "ReCase" package.
final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');

final Set<String> _symbolSet = {' ', '.', '/', '_', '\\', '-'};

List<String> _groupIntoWords(String text) {
  StringBuffer sb = StringBuffer();
  List<String> words = <String>[];
  bool isAllCaps = text.toUpperCase() == text;

  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    String? nextChar = i + 1 == text.length ? null : text[i + 1];
    if (_symbolSet.contains(char)) {
      continue;
    }

    sb.write(char);
    bool isEndOfWord = nextChar == null || (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) || _symbolSet.contains(nextChar);

    if (isEndOfWord) {
      words.add('$sb');
      sb.clear();
    }
  }

  return words;
}

extension StringExtensions on String {
  /// Case-insensitive equality check.
  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();

  /// Case-insensitive in-equality check.
  bool notEqualsIgnoreCase(String other) => toLowerCase() != other.toLowerCase();

  /// Case equality check.
  bool equals(String other) => this == other;

  /// Case in-equality check.
  bool notEquals(String other) => this != other;

  /// Checks if string equals any item in the list
  /// 
  /// Adds extra value checkers like `lowercase`, `uppercase`, `ignorecase`
  bool equalsAny(List<String> values, {bool isLowerCase = false, bool isUpperCase = false, bool isIgnoreCase = false}) {
    if(isUpperCase) {
      return values.any((v) => v.toUpperCase().equals(toUpperCase()));
    }

    return values.any((v) => equalsIgnoreCase(v));
  }

  /// Checks if string does not equals any item in the list
  /// 
  /// Adds extra value checkers like `lowercase`, `uppercase`, `ignorecase`
  bool notEqualsAny(List<String> values, {bool isLowerCase = false, bool isUpperCase = false, bool isIgnoreCase = false}) {
    if(isUpperCase) {
      return !values.any((v) => v.toUpperCase().equals(toUpperCase()));
    }

    return !values.any((v) => equalsIgnoreCase(v));
  }

  /// Checks if string equals all items in the list
  /// 
  /// Adds extra value checkers like `lowercase`, `uppercase`, `ignorecase`
  bool equalsAll(List<String> values, {bool isLowerCase = false, bool isUpperCase = false, bool isIgnoreCase = false}) {
    if(isUpperCase) {
      return values.all((v) => v.toUpperCase().equals(toUpperCase()));
    }

    return values.all((v) => equalsIgnoreCase(v));
  }

  /// Checks if string does not equals all items in the list
  /// 
  /// Adds extra value checkers like `lowercase`, `uppercase`, `ignorecase`
  bool notEqualsAll(List<String> values, {bool isLowerCase = false, bool isUpperCase = false, bool isIgnoreCase = false}) {
    if(isUpperCase) {
      return !values.all((v) => v.toUpperCase().equals(toUpperCase()));
    }

    return !values.all((v) => equalsIgnoreCase(v));
  }

  /// Contains [value] with case-insensitive
  bool containsIgnoreCase(String value) => toLowerCase().contains(value.toLowerCase());

  /// Checks if string is a number type of `double` or `int`
  bool get isNumeric => isNotEmpty && (double.tryParse(this) != null || int.tryParse(this) != null);

  /// Returns "an" before the string if it starts with a vowel, otherwise "a".
  String get withAorAn {
    return startsWith(RegExp('[aeiouAEIOU]')) ? "an ${toLowerCase()}" : "a ${toLowerCase()}";
  }

  /// Capitalizes the first letter of the string.
  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of each word in the string.
  String get capitalizeEach {
    if (isEmpty) return this;

    return split(' ').map((String word) {
      return word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : word;
    }).join(' ');
  }

  /// Capitalizes the first letter of each word in the string.
  @Deprecated('Use `capitalizeEach` instead')
  String get capitalize => capitalizeEach;

  /// Checks if the string contains any emojis.
  bool get hasEmojis {
    RegExp emojiRegExp = RegExp(
      r'[\u{1F600}-\u{1F64F}' // Emoticons
      r'\u{1F300}-\u{1F5FF}' // Miscellaneous Symbols and Pictographs
      r'\u{1F680}-\u{1F6FF}' // Transport and Map Symbols
      r'\u{2600}-\u{26FF}' // Miscellaneous Symbols
      r'\u{2700}-\u{27BF}' // Dingbats
      r'\u{1F900}-\u{1F9FF}' // Supplemental Symbols and Pictographs
      r'\u{1F1E0}-\u{1F1FF}' // Flags (iOS flags are represented by two characters)
      ']+',
      unicode: true,
    );

    return emojiRegExp.hasMatch(this);
  }

  /// Checks if the string contains only emojis.
  bool get containsOnlyEmojis {
    RegExp emojiPattern = RegExp(
      r'[^\x00-\x7F]|(?:[.]{3})|[\uD83C-\uD83E][\uDDE0-\uDDFF]|[\uD83C-\uD83E][\uDC00-\uDFFF]'
      '|[\uD83F-\uD87F][\uDC00-\uDFFF]|[\u2600-\u26FF]|[\u2700-\u27BF]'
    );

    String textWithoutEmojis = replaceAll(emojiPattern, '');
    return textWithoutEmojis.isEmpty;
  }

  /// Checks if the string contains only one emoji.
  bool get containsOnlyOneEmoji {
    RegExp emojiPattern = RegExp(
        r'[^\x00-\x7F]|(?:[.]{3})|[\uD83C-\uD83E][\uDDE0-\uDDFF]|[\uD83C-\uD83E]'
        '[\uDC00-\uDFFF]|[\uD83F-\uD87F][\uDC00-\uDFFF]|[\u2600-\u26FF]|[\u2700-\u27BF]'
    );

    String textWithoutEmojis = replaceAll(emojiPattern, '');
    return textWithoutEmojis.isEmpty && emojiPattern.allMatches(this).length == 1;
  }

  /// Checks if string is int or double.
  bool get isNum {
    if (isEmpty) {
      return false;
    }

    return num.tryParse(this) is num;
  }

  /// Checks if string consist only numeric.
  /// Numeric only doesn't accepting "." which double data type have
  bool get isNumericOnly => matchesRegex(r'^\d+$');

  /// Checks if string consist only Alphabet. (No Whitespace)
  bool get isAlphabetOnly => matchesRegex(r'^[a-zA-Z]+$');

  /// Checks if string contains at least one Capital Letter
  bool get hasCapitalLetter => matchesRegex(r'[A-Z]');

  /// Checks if string is boolean.
  bool get isBool {
    if (isEmpty) {
      return false;
    }

    return (equalsIgnoreCase('true') || equalsIgnoreCase('false'));
  }

  /// Checks if string is an video file.
  bool get isVideo {
    String ext = toLowerCase();

    return ext.endsWith(".mp4") ||
        ext.endsWith(".avi") ||
        ext.endsWith(".wmv") ||
        ext.endsWith(".rmvb") ||
        ext.endsWith(".mpg") ||
        ext.endsWith(".mpeg") ||
        ext.endsWith(".3gp");
  }

  /// Checks if string is an image file.
  bool get isImage {
    String ext = toLowerCase();

    return ext.endsWith(".jpg") ||
        ext.endsWith(".jpeg") ||
        ext.endsWith(".png") ||
        ext.endsWith(".gif") ||
        ext.endsWith(".bmp");
  }

  /// Checks if string is an audio file.
  bool get isAudio {
    String ext = toLowerCase();

    return ext.endsWith(".mp3") ||
        ext.endsWith(".wav") ||
        ext.endsWith(".wma") ||
        ext.endsWith(".amr") ||
        ext.endsWith(".ogg");
  }

  /// Checks if string is an powerpoint file.
  bool get isPPT {
    String ext = toLowerCase();

    return ext.endsWith(".ppt") || ext.endsWith(".pptx");
  }

  /// Checks if string is an word file.
  bool get isWord {
    String ext = toLowerCase();

    return ext.endsWith(".doc") || ext.endsWith(".docx");
  }

  /// Checks if string is an excel file.
  bool get isExcel {
    String ext = toLowerCase();

    return ext.endsWith(".xls") || ext.endsWith(".xlsx");
  }

  /// Checks if string is an apk file.
  bool get isAPK => toLowerCase().endsWith(".apk");

  /// Checks if string is an pdf file.
  bool get isPDF => toLowerCase().endsWith(".pdf");

  /// Checks if string is an txt file.
  bool get isTxt => toLowerCase().endsWith(".txt");

  /// Checks if string is an chm file.
  bool get isChm => toLowerCase().endsWith(".chm");

  /// Checks if string is a vector file.
  bool get isVector => toLowerCase().endsWith(".svg");

  /// Checks if string is an html file.
  bool get isHTML => toLowerCase().endsWith(".html");

  /// Checks if string is a valid username.
  bool get isUsername => matchesRegex(r'^[a-zA-Z0-9][a-zA-Z0-9_.]+[a-zA-Z0-9]$');

  /// Checks if string is URL.
  bool get isURL => matchesRegex(r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,7}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$");

  /// Checks if string is email.
  bool get isEmail => matchesRegex(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /// Checks if string is phone number.
  bool get isPhoneNumber {
    if (this.length > 16 || this.length < 9) {
      return false;
    }

    return matchesRegex(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  }

  /// Checks if string is DateTime (UTC or Iso8601).
  bool get isDateTime => matchesRegex(r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}Z?$');

  /// Checks if string is MD5 hash.
  bool get isMD5 => matchesRegex(r'^[a-f0-9]{32}$');

  /// Checks if string is SHA1 hash.
  bool get isSHA1 => matchesRegex(r'(([A-Fa-f0-9]{2}\:){19}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{40})');

  /// Checks if string is SHA256 hash.
  bool get isSHA256 => matchesRegex(r'([A-Fa-f0-9]{2}\:){31}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{64}');

  /// Checks if string is SSN (Social Security Number).
  bool get isSSN => matchesRegex(r'^(?!0{3}|6{3}|9[0-9]{2})[0-9]{3}-?(?!0{2})[0-9]{2}-?(?!0{4})[0-9]{4}$');

  /// Checks if string is binary.
  bool get isBinary => matchesRegex(r'^[0-1]+$');

  /// Checks if string is IPv4.
  bool get isIPv4 => matchesRegex(r'^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$');

  /// Checks if string is IPv6.
  bool get isIPv6 => matchesRegex(r'^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$');

  /// Checks if string is hexadecimal.
  /// Example: HexColor => #12F
  bool get isHexadecimal => matchesRegex(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  /// Checks if string is Palindrome.
  bool get isPalindrome {
    String cleanString = toLowerCase()
        .replaceAll(RegExp(r"\s+"), '')
        .replaceAll(RegExp(r"[^0-9a-zA-Z]+"), "");

    for (int i = 0; i < cleanString.length; i++) {
      if (cleanString[i] != cleanString[cleanString.length - i - 1]) {
        return false;
      }
    }

    return true;
  }

  /// Checks if string is Passport No.
  bool get isPassport => this.matchesRegex(r'^(?!^0+$)[a-zA-Z0-9]{6,9}$');

  /// Checks if string is Currency.
  bool get isCurrency => this.matchesRegex(r'^(S?\$|\₩|Rp|\¥|\€|\₹|\₽|fr|R\$|R)?[ ]?[-]?([0-9]{1,3}[,.]([0-9]{3}[,.])*[0-9]{3}|[0-9]+)([,.][0-9]{1,2})?( ?(USD?|AUD|NZD|CAD|CHF|GBP|CNY|EUR|JPY|IDR|MXN|NOK|KRW|TRY|INR|RUB|BRL|ZAR|SGD|MYR))?$');

  /// Checks if a contains b (Treating or interpreting upper- and lowercase
  /// letters as being the same).
  bool isCaseInsensitiveContains(String b) => toLowerCase().contains(b.toLowerCase());

  /// Checks if a contains b or b contains a (Treating or
  /// interpreting upper- and lowercase letters as being the same).
  bool isCaseInsensitiveContainsAny(String b) {
    String lowA = toLowerCase();
    String lowB = b.toLowerCase();

    return lowA.contains(lowB) || lowB.contains(lowA);
  }

  // Checks if num is a cnpj
  bool get isCnpj {
    // Get only the numbers from the CNPJ
    String numbers = replaceAll(RegExp(r'[^0-9]'), '');

    // Test if the CNPJ has 14 digits
    if (numbers.length != 14) {
      return false;
    }

    // Test if all digits of the CNPJ are the same
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return false;
    }

    // Divide digits
    List<int> digits = numbers.split('').map(int.parse).toList();

    // Calculate the first check digit
    int calcDv1 = 0;
    int j = 0;
    for (int i in Iterable<int>.generate(12, (int i) => i < 4 ? 5 - i : 13 - i)) {
      calcDv1 += digits[j++] * i;
    }
    calcDv1 %= 11;
    int dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Test the first check digit
    if (digits[12] != dv1) {
      return false;
    }

    // Calculate the second check digit
    int calcDv2 = 0;
    j = 0;
    for (int i in Iterable<int>.generate(13, (int i) => i < 5 ? 6 - i : 14 - i)) {
      calcDv2 += digits[j++] * i;
    }
    calcDv2 %= 11;
    int dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Test the second check digit
    if (digits[13] != dv2) {
      return false;
    }

    return true;
  }

  /// Checks if the cpf is valid.
  bool get isCpf {
    // get only the numbers
    String numbers = replaceAll(RegExp(r'[^0-9]'), '');
    // Test if the CPF has 11 digits
    if (numbers.length != 11) {
      return false;
    }

    // Test if all CPF digits are the same
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return false;
    }

    // split the digits
    List<int> digits = numbers.split('').map(int.parse).toList();

    // Calculate the first verifier digit
    int calcDv1 = 0;
    for (int i in Iterable<int>.generate(9, (int i) => 10 - i)) {
      calcDv1 += digits[10 - i] * i;
    }
    calcDv1 %= 11;

    int dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Tests the first verifier digit
    if (digits[9] != dv1) {
      return false;
    }

    // Calculate the second verifier digit
    int calcDv2 = 0;
    for (int i in Iterable<int>.generate(10, (int i) => 11 - i)) {
      calcDv2 += digits[11 - i] * i;
    }
    calcDv2 %= 11;

    int dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Test the second verifier digit
    if (digits[10] != dv2) {
      return false;
    }

    return true;
  }

  /// Remove all whitespace inside string
  String get removeAllWhitespace => replaceAll(' ', '');

  /// camelCase string
  /// Example: your name => yourName
  String? get camelCase {
    if (isEmpty) {
      return null;
    }

    List<String> separatedWords = split(RegExp(r'[!@#<>?":`~;[\]\\|=+)(*&^%-\s_]+'));
    String newString = '';

    for (String word in separatedWords) {
      newString += word[0].toUpperCase() + word.substring(1).toLowerCase();
    }

    return newString[0].toLowerCase() + newString.substring(1);
  }

  /// snake_case
  String snakeCase({String separator = '_'}) {
    if (isEmpty) {
      return "";
    }

    return _groupIntoWords(this).map((String word) => word.toLowerCase()).join(separator);
  }

  /// param-case
  String get paramCase => snakeCase(separator: '-');

  /// Extract numeric value of string
  /// Example: OTP 12312 27/04/2020 => 1231227042020ß
  /// If firstWordOnly is true, then the example return is "12312"
  /// (first found numeric word)
  String numericOnly({bool firstWordOnly = false}) {
    String numericOnlyStr = '';

    for (int i = 0; i < this.length; i++) {
      if (this[i].isNumericOnly) {
        numericOnlyStr += this[i];
      }
      if (firstWordOnly && numericOnlyStr.isNotEmpty && this[i] == " ") {
        break;
      }
    }

    return numericOnlyStr;
  }

  /// Capitalize only the first letter of each word in a string
  String get capitalizeAllWordsFirstLetter {
    String lowerCasedString = toLowerCase();
    String stringWithoutExtraSpaces = lowerCasedString.trim();

    if (stringWithoutExtraSpaces.isEmpty) {
      return "";
    }
    if (stringWithoutExtraSpaces.length == 1) {
      return stringWithoutExtraSpaces.toUpperCase();
    }

    List<String> stringWordsList = stringWithoutExtraSpaces.split(" ");
    List<String> capitalizedWordsFirstLetter = stringWordsList.map((String word) {
      if (word.trim().isEmpty) {
        return "";
      }
      return word.trim();
    }).where((String word) => word != "").map((String word) {
      if (word.startsWith(RegExp(r'[\n\t\r]'))) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String finalResult = capitalizedWordsFirstLetter.join(" ");
    return finalResult;
  }

  bool matchesRegex(String pattern) => RegExp(pattern).hasMatch(this);

  /// Create a path with the given segments.
  String createPath([Iterable? segments]) {
    if (segments == null || segments.isEmpty) {
      return this;
    }

    Iterable<String> list = segments.map((dynamic e) => '/$e');
    return this + list.join();
  }

  /// Checks if all data have same value.
  bool get isOneAKind {
    if(isEmpty) {
      return false;
    } else {
      String first = this[0];
      int len = length;

      for (int i = 0; i < len; i++) {
        if (this[i] != first) {
          return false;
        }
      }

      return true;
    }
  }

  /// Replaces all occurrences of the given pattern with the specified replacement
  /// and returns the result as a String.
  String replaceAllWithOriginalCase(Pattern pattern, String replace) {
    return replaceAll(pattern, replace);
  }

  /// Replaces all occurrences of the given pattern with the specified replacement
  /// and returns the result in lowercase.
  String replaceAllToLowerCase(Pattern pattern, String replace) {
    return replaceAll(pattern, replace).toLowerCase();
  }

  /// Replaces all occurrences of the given pattern with the specified replacement
  /// and returns the result in uppercase.
  String replaceAllToUpperCase(Pattern pattern, String replace) {
    return replaceAll(pattern, replace).toUpperCase();
  }

  /// Replaces the first occurrence of the given pattern with the specified replacement
  /// and returns the result as a String.
  String replaceWithOriginalCase(Pattern pattern, String replace) {
    return replaceFirst(pattern, replace);
  }

  /// Replaces the first occurrence of the given pattern with the specified replacement
  /// and returns the result in lowercase.
  String replaceToLowerCase(Pattern pattern, String replace) {
    return replaceFirst(pattern, replace).toLowerCase();
  }

  /// Replaces the first occurrence of the given pattern with the specified replacement
  /// and returns the result in uppercase.
  String replaceToUpperCase(Pattern pattern, String replace) {
    return replaceFirst(pattern, replace).toUpperCase();
  }

  /// Determines the MIME type of the file based on its extension.
  /// 
  /// This extension method analyzes the file extension of the given string 
  /// and returns the corresponding MIME type. 
  /// 
  /// **Returns:**
  /// 
  /// The MIME type of the file. 
  /// 
  /// Returns 'application/octet-stream' if the extension is not recognized.
  String get mimeType {
    final extension = split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'avi':
        return 'video/x-msvideo';
      case 'mov':
        return 'video/quicktime';
      case 'mkv':
        return 'video/x-matroska';
      case 'webm': 
        return 'video/webm'; 
      case '3gp': 
        return 'video/3gpp'; 
      case 'wmv': 
        return 'video/x-ms-wmv'; 
      case 'flv': 
        return 'video/x-flv'; 
      case 'mpeg': 
        return 'video/mpeg'; 
      case 'mpg': 
        return 'video/mpeg'; 
      case 'm4v': 
        return 'video/mp4'; 
      case 'ts': 
        return 'video/mp2t'; 
      case '3g2': 
        return 'video/3gpp2'; 
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'aac':
        return 'audio/aac';
      case 'flac':
        return 'audio/flac';
      case 'ogg':
        return 'audio/ogg';
      case 'm4a':
        return 'audio/m4a';
      case 'amr':
        return 'audio/amr';
      default:
        return 'application/octet-stream';
    }
  }

  /// Checks if the string represents a local file path.
  bool get isLocalFile => startsWith('/');

  /// Checks if the string represents a base64 encoded image.
  bool get isMemoryImage => startsWith('data:image');

  /// Extracts the file name from a path, URL, or asset.
  ///
  /// If [withMimeType] is `true`, it returns the name with the MIME type.
  /// If [appendMimeType] is `true`, it will return the name with .mimeType
  String getFileName({bool withMimeType = false, bool appendMimeType = true}) {
    // Extract file name from path or URL
    String fileName = split('/').last.split('\\').last;

    if (withMimeType) {
      // Determine MIME type
      String mimeType = fileName.mimeType;
      return appendMimeType ? "$fileName.$mimeType" : "$fileName ($mimeType)";
    }

    return fileName;
  }

  /// Returns the first [count] characters of the string.
  /// If [count] exceeds the string length, it returns the whole string.
  /// If the string is empty or null, it returns an empty string.
  String first([int count = 1]) {
    if (isEmpty || count.isLtOrEt(0)) return '';

    return length.isLtOrEt(count) ? this : substring(0, count);
  }
}