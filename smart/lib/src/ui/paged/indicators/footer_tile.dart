import 'package:flutter/material.dart';

class PagedFooterTile extends StatelessWidget {
  const PagedFooterTile({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: 16,
      bottom: 16,
    ),
    child: Center(child: child),
  );
}