/// Configuration for an item within a list.
///
/// This class provides metadata about an item’s position in the list,
/// such as whether it is the first or last item. It can be extended
/// to support additional list-related configurations.
class ItemMetadata<T> {
  /// Indicates whether the item is the last in the list.
  final bool isLast;

  /// Indicates whether the item is the first in the list.
  final bool isFirst;

  /// The index of the item in the list.
  final int index;

  /// The total number of items in the list.
  final int totalItems;

  /// Whether the current item is selected
  final bool isSelected;

  /// The current item
  final T item;

  /// Creates a configuration instance for a list item.
  ///
  /// - [isFirst] determines if this is the first item in the list.
  /// - [isLast] determines if this is the last item in the list.
  /// - [index] specifies the position of the item in the list (zero-based).
  /// - [totalItems] indicates the total number of items in the list.
  const ItemMetadata({
    required this.isFirst,
    required this.isLast,
    required this.index,
    required this.totalItems,
    this.isSelected = false,
    required this.item
  });

  /// Returns `true` if the item is neither the first nor the last.
  bool get isMiddle => !isFirst && !isLast;
}