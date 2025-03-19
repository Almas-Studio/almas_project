import 'package:flutter/material.dart';

// [PageRouteBuilder]
class SimpleRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  SimpleRoute({
    super.settings,
    required this.builder,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    this.transitionDuration = Duration.zero,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
  });

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final bool maintainState;

  @override
  final Duration transitionDuration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }
}
