import 'dart:ui';

import 'package:flutter/material.dart';

class WidgetAccessGovener extends StatelessWidget {
  final bool hasAccess;
  final int tier;
  final double blur;
  final Widget child;
  final VoidCallback? onTapWithNoAccess;

  const WidgetAccessGovener({
    super.key,
    required this.hasAccess,
    required this.child,
    this.blur = 1.5,
    this.tier = 2, this.onTapWithNoAccess,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaY: blur, sigmaX: blur),
          enabled: !hasAccess,
          child: AbsorbPointer(
            absorbing: !hasAccess,
            child: child,
          ),
        ),
       if(!hasAccess) IconButton(
          onPressed: onTapWithNoAccess,
          icon: const Icon(Icons.lock_outline_rounded),
        ),
      ],
    );
  }
}
