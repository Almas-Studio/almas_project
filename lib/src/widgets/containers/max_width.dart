import 'package:flutter/material.dart';

import 'max_width_builder.dart';

class MaxWidth extends StatelessWidget {
  final Widget child;
  const MaxWidth({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaxWidthBuilder(builder: (context, maxWidth){
      return SizedBox(
        width: maxWidth,
        child: child,
      );
    });
  }
}
