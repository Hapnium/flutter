part of '../pin.dart';

/// A class that represents the state of a pin item.
class PinItem {
  /// Creates a new instance of [PinItem].
  const PinItem({
    required this.value,
    required this.index,
    required this.type,
  });

  /// The value of the individual pin item.
  final String value;

  /// The index of the individual pin item.
  final int index;

  /// The state of the individual pin item.
  final PinItemState type;
}