import 'package:flutter/material.dart';

import 'status_indicator.dart';

class PagedFirstPageErrorIndicator extends StatelessWidget {
  final VoidCallback? onTryAgain;

  const PagedFirstPageErrorIndicator({super.key, this.onTryAgain});

  @override
  Widget build(BuildContext context) => PagedStatusIndicator(
    title: 'Something went wrong',
    message: 'The application has encountered an unknown error.\n'
        'Please try again later.',
    onTryAgain: onTryAgain,
  );
}

class PagedFirstPageProgressIndicator extends StatelessWidget {
  const PagedFirstPageProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(32),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}