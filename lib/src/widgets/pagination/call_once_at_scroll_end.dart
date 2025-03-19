import 'package:flutter/material.dart';

class CallOnceAtScrollEnd extends StatefulWidget {
  final Widget child;
  final String? callbackId;
  final VoidCallback? callback;

  const CallOnceAtScrollEnd({
    super.key,
    required this.child,
    this.callbackId,
    this.callback,
  });

  @override
  State<CallOnceAtScrollEnd> createState() => _CallOnceAtScrollEndState();
}

class _CallOnceAtScrollEndState extends State<CallOnceAtScrollEnd> {
  String? lastCall;
  var requested = DateTime(1);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge && metrics.pixels == metrics.maxScrollExtent) {
          if (widget.callbackId != null && widget.callback != null) {
            if (lastCall != widget.callbackId ||
                DateTime.now().difference(requested) >
                    const Duration(seconds: 2)) {
              widget.callback!();
              lastCall = widget.callbackId;
              requested = DateTime.now();
            }
          }
        }
        return false;
      },
      child: widget.child,
    );
  }
}
