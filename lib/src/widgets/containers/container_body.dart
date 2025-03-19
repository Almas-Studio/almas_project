import 'package:flutter/material.dart';

class BodyContainer extends StatelessWidget {
  final Widget child;
  final double breakpoint;
  final bool showVerticalDividers;

  const BodyContainer({
    super.key,
    required this.child,
    this.breakpoint = 680,
    this.showVerticalDividers = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.width < breakpoint) {
      return child;
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          if(showVerticalDividers) const VerticalDivider(width: 1),
          SizedBox(
            width: breakpoint,
            child: child,
          ),
          if(showVerticalDividers) const VerticalDivider(width: 1),
          const Spacer(),
        ],
      );
    }
  }
}
