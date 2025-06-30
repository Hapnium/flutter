import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'status_indicator.dart';

class PagedNoItemsFoundIndicator extends StatelessWidget {
  const PagedNoItemsFoundIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const PagedStatusIndicator(
    title: 'No items found',
    message: 'The list is currently empty.',
  );
}