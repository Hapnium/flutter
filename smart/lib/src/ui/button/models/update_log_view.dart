import 'package:hapnium/hapnium.dart';

/// Represents an entry in an update log.
class UpdateLogView {
  /// The title or header of the update.
  final String header;

  /// The content list describing the update details.
  final StringCollection content;

  /// The date of the update.
  final String date;

  /// The index of the update in a list.
  final Integer index;

  /// Creates an `UpdateLogView` instance.
  UpdateLogView({
    required this.header,
    required this.content,
    required this.date,
    required this.index,
  });
}