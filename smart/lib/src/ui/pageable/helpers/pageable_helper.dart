import 'package:flutter/cupertino.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/utilities.dart';

import '../models/pageable_status.dart';

/// A strategy function for determining whether to insert a separator between items in a paginated list.
///
/// This typedef defines a function that takes an item index as a parameter and returns a
/// boolean value indicating whether a separator should be inserted before the item at that index.
///
/// **Parameters:**
///
/// * [index]: The index of the item in the paginated list.
///
/// **Returns:**
///
/// `true` if a separator should be inserted before the item, `false` otherwise.
///
/// **Usage:**
///
/// This typedef is used in conjunction with [PageableBuilderDelegate] to customize the
/// insertion of separators between items in a paginated list. It allows for flexible
/// separator logic, such as inserting separators only between specific types of items
/// or based on certain conditions.
///
/// **Example:**
///
/// ```dart
/// PageableSeparatorStrategy separatorStrategy = (index) {
///   // Insert a separator after every 5th item
///   return index > 0 && index % 5 == 0;
/// };
/// ```
typedef PageableSeparatorStrategy = Boolean Function(int index);

/// A utility class for managing separators and content validation in paged lists and grids.
///
/// This class provides methods to:
/// - Calculate the number of separators in a paged list/grid.
/// - Determine the actual item index when separators are included.
/// - Validate widget content to ensure they have defined dimensions.
/// - Handle default separator strategies and pagination status checks.
class PageableHelper {
  /// Counts the total number of separators required in the list/grid.
  ///
  /// Iterates through the list and applies the given [strategy] to determine
  /// where separators should be placed. Ensures that the [separator] widget
  /// is not null before counting it.
  ///
  /// - [strategy]: A function that returns `true` if a separator should be placed at a given index.
  /// - [separator]: A nullable widget builder for creating separator widgets.
  /// - [context]: The build context used to create separators.
  /// - [itemCount]: The total number of items in the paged list/grid.
  ///
  /// Returns the total count of valid separators that should be inserted.
  static int calculateTotalSeparators(PageableSeparatorStrategy strategy, NullableIndexedWidgetBuilder? separator, BuildContext context, int itemCount) {
    int count = 0;
    for (int i = 1; i < itemCount; i++) {
      if (strategy(i) && separator.isNotNull && separator!(context, i).isNotNull && WidgetUtils.hasContent(separator(context, i)!)) {
        count++;
      }
    }

    return count;
  }

  /// Counts the number of separators that should be placed before a given index.
  ///
  /// This method iterates from `0` to [index] and applies the [strategy] function
  /// to count how many separators should appear before that index.
  ///
  /// - [strategy]: A function that determines whether a separator should be placed.
  /// - [index]: The index before which the separators should be counted.
  ///
  /// Returns the number of separators placed before the specified index.
  static int countSeparatorsBeforeIndex(PageableSeparatorStrategy strategy, int index) {
    int count = 0;
    for (int i = 0; i < index; i++) {
      if (strategy(i)) {
        count++;
      }
    }

    return count;
  }

  /// Calculates the actual item index in the list, adjusting for inserted separators.
  ///
  /// Since separators take up extra indices in the paged view, this method calculates
  /// the correct item index by subtracting the number of separators before it.
  ///
  /// - [strategy]: A function that determines whether a separator should be placed.
  /// - [hasSeparator]: A boolean indicating whether separators are enabled.
  /// - [index]: The displayed index in the list/grid that includes separators.
  ///
  /// Returns the corresponding item index in the original list.
  static int getActualItemIndex(PageableSeparatorStrategy strategy, bool hasSeparator, int index) {
    if (!hasSeparator) {
      return index;
    }

    return index - countSeparatorsBeforeIndex(strategy, index);
  }

  /// The default strategy for inserting separators in a paged list.
  ///
  /// This strategy inserts a separator after every **odd-numbered** item.
  ///
  /// - [index]: The current index in the list.
  ///
  /// Returns `true` if a separator should be inserted at the given index.
  static bool defaultStrategy(int index) => (index + 3) % 2 == 0;

  /// Determines if an extra widget can be added based on the pagination status.
  ///
  /// This method checks if the pagination is ongoing, has an error on a subsequent
  /// page, or has completed. In these cases, an extra widget (such as a loading indicator)
  /// can be added.
  ///
  /// - [status]: The current paged status.
  ///
  /// Returns `true` if an extra widget can be added, otherwise `false`.
  static bool canAddExtra(PageableStatus status) => status.isLoadingMore || status.isLoadingMoreError || status.isCompleted;
}