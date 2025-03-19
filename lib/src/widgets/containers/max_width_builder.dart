import 'package:flutter/material.dart';

class MaxWidthBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, double maxWidth) builder;

  const MaxWidthBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return builder(context, constraint.maxWidth);
    });
  }
}
