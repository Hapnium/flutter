extension DateTimeExtensions on DateTime {
  /// Checks if two DateTime objects represent the same date (year, month, and day).
  bool equals(DateTime date) => this.year == date.year && this.month == date.month && this.day == date.day;
}