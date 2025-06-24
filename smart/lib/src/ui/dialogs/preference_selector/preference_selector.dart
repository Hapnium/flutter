import 'package:flutter/material.dart';
import 'package:smart/enums.dart';
import 'package:smart/extensions.dart';
import 'package:smart/src/assets/theme_assets.dart';
import 'package:smart/src/styles/colors/common_colors.dart';
import 'package:smart/utilities.dart';
import 'package:hapnium/hapnium.dart';

import '../../export.dart';

part 'preference_selector_state.dart';

/// {@template preference_selector}
/// A modal bottom sheet for selecting preferences.
/// 
/// This widget provides a user-friendly interface for selecting preferences 
/// from a predefined set of options. It supports various preference types 
/// such as gender, theme, schedule, and security settings.
/// 
/// **Parameters:**
/// 
/// * **type:** The type of preference to select. 
///     * Required.
///     * Specifies the category of preferences to be presented to the user.
/// * **gender:** The currently selected gender. 
///     * Defaults to `Gender.none`.
///     * Represents the user's selected gender.
/// * **theme:** The currently selected theme.
///     * Defaults to `ThemeType.light`.
///     * Represents the user's preferred theme for the application.
/// * **schedule:** The currently selected schedule time.
///     * Defaults to `ScheduleTime.thirtyMinutes`.
///     * Represents the user's preferred schedule time for certain actions.
/// * **preference:** The currently selected preference option.
///     * Defaults to `PreferenceOption.none`.
///     * Represents a specific preference option selected by the user.
/// * **security:** The currently selected security level.
///     * Defaults to `SecurityType.none`.
///     * Represents the user's selected security level for certain features.
/// * **header:** The title to be displayed at the top of the sheet.
///     * Required.
///     * The text to be displayed as the header of the modal sheet.
/// * **onChanged:** A callback function that is triggered when a preference is selected.
///     * Required.
///     * This function is called with the newly selected preference value.
/// * **uiConfig:** Optional UI configuration settings.
/// * **useSafeArea:** Whether to include safe area padding at the top of the sheet. 
///     * Defaults to `false`.
///     * Controls whether to include safe area padding at the top of the sheet.
/// * **backgroundColor:** The background color of the modal sheet. 
///     * Defaults to the app's bottomAppBarTheme color.
///     * The background color of the modal sheet.
/// * **custom:** A custom widget to display instead of the default options.
/// * **textColor:** The color of the text in the options.
/// * **selectedIconColor:** The color of the icon for the selected option.
/// * **customSelected:** A custom widget to display for the selected option.
/// * **itemBorderRadius:** The border radius of the option items.
/// * **selectedItemColor:** The background color of the selected option.
/// * **staleItemColor:** The background color of stale options (if applicable).
/// 
/// {@endtemplate}
class PreferenceSelector extends StatefulWidget {
  /// The type of preference to select.
  /// 
  /// Required.
  /// 
  /// Specifies the category of preferences to be presented to the user.
  final PreferenceType type;

  /// The currently selected gender. 
  /// 
  /// Defaults to `Gender.none`.
  /// 
  /// Represents the user's selected gender.
  final Gender gender;

  /// The currently selected theme.
  /// 
  /// Defaults to `ThemeType.light`.
  /// 
  /// Represents the user's preferred theme for the application.
  final ThemeType theme;

  /// The currently selected schedule time.
  /// 
  /// Defaults to `ScheduleTime.thirtyMinutes`.
  /// 
  /// Represents the user's preferred schedule time for certain actions.
  final ScheduleTime schedule;

  /// The currently selected preference option.
  /// 
  /// Defaults to `PreferenceOption.none`.
  /// 
  /// Represents a specific preference option selected by the user.
  final PreferenceOption preference;

  /// The currently selected security level.
  /// 
  /// Defaults to `SecurityType.none`.
  /// 
  /// Represents the user's selected security level for certain features.
  final SecurityType security;

  /// The title to be displayed at the top of the sheet.
  /// 
  /// Required.
  /// 
  /// The text to be displayed as the header of the modal sheet.
  final String header;

  /// A callback function that is triggered when a preference is selected.
  /// 
  /// Required.
  /// 
  /// This function is called with the newly selected preference value.
  final PreferenceSelectorCallback onChanged;

  /// Optional UI configuration settings.
  final UiConfig? uiConfig;

  /// Whether to include safe area padding at the top of the sheet. 
  /// 
  /// Defaults to `false`.
  /// 
  /// Controls whether to include safe area padding at the top of the sheet.
  final SafeAreaConfigBuilder? useSafeArea;

  /// The background color of the modal sheet. 
  /// 
  /// Defaults to the app's bottomAppBarTheme color.
  /// 
  /// The background color of the modal sheet.
  final Color? backgroundColor;

  /// A custom widget to display instead of the default options.
  final Widget? custom;

  /// The color of the text in the options.
  final Color? textColor;

  /// The color of the icon for the selected option.
  final Color? selectedIconColor;

  /// A custom widget to display for the selected option.
  final Widget? customSelected;

  /// The border radius of the option items.
  final double? itemBorderRadius;

  /// The background color of the selected option.
  final Color? selectedItemColor;

  /// The background color of stale options (if applicable).
  final Color? staleItemColor;

  /// Creates a [PreferenceSelector] widget.
  /// 
  /// {@macro preference_selector}
  const PreferenceSelector({
    super.key,
    required this.type,
    this.schedule = ScheduleTime.thirtyMinutes,
    this.gender = Gender.none,
    this.theme = ThemeType.light,
    this.preference = PreferenceOption.none,
    this.security = SecurityType.none,
    required this.header,
    required this.onChanged,
    this.uiConfig,
    this.useSafeArea,
    this.backgroundColor,
    this.custom,
    this.textColor,
    this.selectedIconColor,
    this.customSelected,
    this.itemBorderRadius,
    this.selectedItemColor,
    this.staleItemColor
  });

  @override
  State<PreferenceSelector> createState() => _PreferenceSelectorState();
}