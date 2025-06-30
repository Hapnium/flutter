import 'package:flutter/material.dart';

/// Displays a full-screen error indicator for the first page of content,
/// typically shown when initial loading fails.
///
/// Shows a title, a descriptive message, and an optional "Try Again" button.
///
/// Example:
/// ```dart
/// FirstPageErrorIndicator(
///   onTryAgain: () {
///     // retry logic here
///   },
/// )
/// ```
class FirstPageErrorIndicator extends StatelessWidget {
  /// Callback invoked when the user taps the "Try Again" button.
  final VoidCallback? onTryAgain;

  const FirstPageErrorIndicator({super.key, this.onTryAgain});

  @override
  Widget build(BuildContext context) => StatusIndicator(
    title: 'Something went wrong',
    message: 'The application has encountered an unknown error.\n'
        'Please try again later.',
    onTryAgain: onTryAgain,
  );
}

/// Displays a centered circular progress indicator with padding,
/// used to indicate loading state for the first page.
///
/// Example:
/// ```dart
/// FirstPageProgressIndicator()
/// ```
class FirstPageProgressIndicator extends StatelessWidget {
  const FirstPageProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(32),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

/// Displays an error indicator for subsequent pages (after the first page),
/// allowing the user to tap to retry loading more content.
///
/// Shows a message and a refresh icon.
///
/// Example:
/// ```dart
/// NewPageErrorIndicator(
///   onTap: () {
///     // retry loading next page
///   },
/// )
/// ```
class NewPageErrorIndicator extends StatelessWidget {
  /// Callback invoked when the user taps on the error indicator.
  final VoidCallback? onTap;

  const NewPageErrorIndicator({super.key, this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: const FooterTile(
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong. Tap to try again.',
            textAlign: TextAlign.center,
          ),
          Icon(Icons.refresh, size: 16),
        ],
      ),
    ),
  );
}

/// Displays a loading indicator for subsequent pages (after the first page),
/// typically shown at the bottom of the list.
///
/// Example:
/// ```dart
/// NewPageProgressIndicator()
/// ```
class NewPageProgressIndicator extends StatelessWidget {
  const NewPageProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => const FooterTile(child: CircularProgressIndicator());
}

/// Displays a message indicating that no items were found,
/// typically used when the list to display is empty.
///
/// Example:
/// ```dart
/// NoItemsFoundIndicator()
/// ```
class NoItemsFoundIndicator extends StatelessWidget {
  const NoItemsFoundIndicator({super.key});

  @override
  Widget build(BuildContext context) => const StatusIndicator(
    title: 'No items found',
    message: 'The list is currently empty.',
  );
}

/// A reusable widget for displaying a centered status message with
/// an optional description and retry button.
///
/// Useful for showing loading, error, or empty states.
///
/// Parameters:
/// - [title]: The main title text to display.
/// - [message]: An optional descriptive message below the title.
/// - [onTryAgain]: Optional callback to show a "Try Again" button.
///
/// Example:
/// ```dart
/// StatusIndicator(
///   title: 'Error',
///   message: 'Failed to load data.',
///   onTryAgain: () {
///     // retry logic
///   },
/// )
/// ```
class StatusIndicator extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onTryAgain;

  const StatusIndicator({
    required this.title,
    this.message,
    this.onTryAgain,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
            if (onTryAgain != null) ...[
              const SizedBox(height: 48),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: onTryAgain,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget providing consistent vertical padding and centering,
/// typically used to wrap footer content like progress or error indicators.
///
/// Parameters:
/// - [child]: The widget to display inside the footer tile.
///
/// Example:
/// ```dart
/// FooterTile(
///   child: CircularProgressIndicator(),
/// )
/// ```
class FooterTile extends StatelessWidget {
  final Widget child;

  const FooterTile({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: 16,
      bottom: 16,
    ),
    child: Center(child: child),
  );
}