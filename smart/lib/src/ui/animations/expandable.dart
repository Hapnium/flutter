import 'package:flutter/material.dart';

/// A widget that provides an expandable/collapsible section with a header and content.
///
/// The [Expandable] widget allows users to toggle between an expanded and collapsed state,
/// revealing or hiding the content below a customizable header.
///
/// ### Example Usage:
/// ```dart
/// Expandable(
///   header: Text("Tap to Expand"),
///   content: Text("This is the expanded content."),
///   mainColor: Colors.grey[200],
///   iconColor: Colors.blue,
///   splashColor: Colors.grey[300],
///   borderRadius: BorderRadius.circular(12),
/// )
/// ```
class Expandable extends StatefulWidget {
  /// The widget displayed as the header (always visible).
  ///
  /// Typically a `Text` or any other widget that represents the title of the expandable section.
  final Widget header;

  /// The widget displayed as the expandable content (hidden when collapsed).
  ///
  /// This can be any widget that appears when the section expands.
  final Widget content;

  /// The background color of the container wrapping the expandable section.
  ///
  /// If not provided, it defaults to the scaffold background color.
  final Color? mainColor;

  /// The color of the expand/collapse icon.
  ///
  /// If not provided, it defaults to the theme's primary color.
  final Color? iconColor;

  /// The splash effect color when tapping the expandable section.
  ///
  /// If not provided, it defaults to `Colors.transparent`.
  final Color? splashColor;

  /// The icon displayed when the section is expanded.
  ///
  /// Defaults to [Icons.keyboard_arrow_up_rounded].
  final IconData expandedIcon;

  /// The icon displayed when the section is collapsed.
  ///
  /// Defaults to [Icons.keyboard_arrow_down_rounded].
  final IconData collapsedIcon;

  /// The border radius of the header section.
  ///
  /// If not provided, it defaults to `BorderRadius.circular(16)` when [mainColor] is null.
  final BorderRadius? borderRadius;

  /// The padding applied around the entire expandable section.
  ///
  /// If not provided, it defaults to `EdgeInsets.all(6)` when [mainColor] is set,
  /// otherwise `EdgeInsets.all(2)`.
  final EdgeInsetsGeometry? contentPadding;

  /// The padding applied inside the header section.
  ///
  /// If not provided, it defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsetsGeometry? bodyPadding;

  /// Creates an instance of [Expandable].
  const Expandable({
    super.key,
    required this.header,
    required this.content,
    this.mainColor,
    this.iconColor,
    this.splashColor,
    this.expandedIcon = Icons.keyboard_arrow_up_rounded,
    this.collapsedIcon = Icons.keyboard_arrow_down_rounded,
    this.borderRadius,
    this.contentPadding,
    this.bodyPadding,
  });

  @override
  State<Expandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  /// Toggles the expansion state of the widget.
  ///
  /// If the section is expanded, it collapses; if it's collapsed, it expands.
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine padding and border radius based on the mainColor property
    EdgeInsetsGeometry padding = widget.mainColor != null ? EdgeInsets.all(6) : EdgeInsets.all(2);
    BorderRadius borderRadius = widget.mainColor == null ? BorderRadius.circular(16) : BorderRadius.zero;

    return Container(
      padding: widget.contentPadding ?? padding,
      color: widget.mainColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: widget.borderRadius ?? borderRadius,
            child: Material(
              color: widget.splashColor ?? Colors.transparent,
              child: InkWell(
                onTap: _toggleExpanded,
                child: Padding(
                  padding: widget.bodyPadding ?? EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: widget.header),
                      Icon(
                        _isExpanded ? widget.expandedIcon : widget.collapsedIcon,
                        color: widget.iconColor ?? Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: widget.content,
          ),
        ],
      ),
    );
  }
}