import 'package:flutter/material.dart';

import 'footer_tile.dart';

class PagedNewPageErrorIndicator extends StatelessWidget {
  final VoidCallback? onTap;

  const PagedNewPageErrorIndicator({super.key, this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: const PagedFooterTile(
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

class PagedNewPageProgressIndicator extends StatelessWidget {
  const PagedNewPageProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => const PagedFooterTile(
    child: CircularProgressIndicator(),
  );
}