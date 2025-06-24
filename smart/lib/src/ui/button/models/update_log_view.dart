import 'package:hapnium/hapnium.dart';

/// {@template update_log_view}
/// Represents an entry in an update log.
/// 
/// {@endtemplate}
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
  /// 
  /// {@macro update_log_view}
  UpdateLogView({
    required this.header,
    required this.content,
    required this.date,
    required this.index,
  });
}