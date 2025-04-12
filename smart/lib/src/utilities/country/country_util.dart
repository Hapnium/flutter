/// Utility class for country-related operations.
import 'package:flutter/widgets.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/ui.dart';

import 'country.dart';
import 'country_data.dart';

class CountryUtil {
  CountryUtil._internal();

  static CountryUtil instance = CountryUtil._internal();

  List<Country> _list = [];
  set (List<Country> countries) {
    if(countries.isNotEmpty) {
      _list = countries;
    } else {
      _list = CountryData.instance.countries;
    }
  }

  List<Country> get countries => _list.isEmpty ? CountryData.instance.countries : _list;

  /// Finds a country by its name.
  Country findByName(String name) {
    return countries.firstWhere((country) {
      return country.name.equalsIgnoreCase(name);
    }, orElse: () => countries.first);
  }

  /// Finds a country by its country code.
  Country findByCode(String code) {
    return countries.firstWhere((country) {
      return country.code.equalsIgnoreCase(code);
    }, orElse: () => countries.first);
  }

  /// Finds a country by its dial code.
  Country findByDialCode(String dialCode) {
    return countries.firstWhere((country) {
      return country.dialCode.equalsIgnoreCase(dialCode);
    }, orElse: () => countries.first);
  }

  /// Finds a country by its flag.
  Country findByFlag(String flag) {
    return countries.firstWhere((country) {
      return country.flag.equalsIgnoreCase(flag);
    }, orElse: () => countries.first);
  }

  /// Finds a country by its associated image.
  Country findByImage(String image) {
    return countries.firstWhere((country) {
      return country.image.equalsIgnoreCase(image);
    }, orElse: () => countries.first);
  }

  /// Finds a country by either its country code or dial code.
  Country findByCodeOrDialCode(String value) {
    return countries.firstWhere((country) {
      return value.equalsAny([country.dialCode, country.code], isIgnoreCase: true);
    }, orElse: () => countries.first);
  }

  /// Finds a country by either its country code or name.
  Country findByCodeOrName(String value) {
    return countries.firstWhere((country) {
      return value.equalsAny([country.code, country.name], isIgnoreCase: true);
    }, orElse: () => countries.first);
  }

  /// Finds a country by either its country code or flag.
  Country findByCodeOrFlag(String value) {
    return countries.firstWhere((country) {
      return value.equalsAny([country.code, country.flag], isIgnoreCase: true);
    }, orElse: () => countries.first);
  }

  /// Finds a country by either its country code or associated image.
  Country findByCodeOrImage(String value) {
    return countries.firstWhere((country) {
      return value.equalsAny([country.code, country.image], isIgnoreCase: true);
    }, orElse: () => countries.first);
  }

  /// Finds a country by any of its attributes: dial code, code, image, flag, or name.
  Country find(String value) {
    return countries.firstWhere((country) {
      return value.equalsAny([country.dialCode, country.code, country.image, country.flag, country.name], isIgnoreCase: true);
    }, orElse: () => countries.first);
  }

  /// This returns the proper widget for displaying the flag image or flag emoji
  Widget getFlag(Country country, {bool useFlagEmoji = false, double? size}) {
    if(useFlagEmoji.isFalse || country.image.isNotEmpty) {
      return Image.network(country.image, width: size ?? 32);
    } else {
      return TextBuilder(text: country.flag, size: size ?? 18);
    }
  }
}