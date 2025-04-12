/// This is used in deciding the type of view to render in the [PreferenceSelectorSheet] widget.
/// 
/// By specifying the desired preference being requested for, the widget can render designs based on the 
/// requirement
enum PreferenceType {
  /// Gender preference view is required
  /// 
  /// Used mainly for `Gender` preferences
  gender,

  /// Schedule preference view is required
  /// 
  /// Used mainly for `ScheduleTime` preferences
  schedule,

  /// Theme preference view is required
  /// 
  /// Used mainly for `ThemeType` preferences
  theme,

  /// Preference preference view is required
  /// 
  /// Used mainly for `PreferenceOption` preferences
  preference,

  /// Security preference view is required
  /// 
  /// Used mainly for `SecurityType` preferences
  security
}