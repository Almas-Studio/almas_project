import 'package:flutter/material.dart';

class CallOnce extends StatefulWidget {
  final VoidCallback callback;

  const CallOnce(
    this.callback, {
    super.key,
  });

  @override
  State<CallOnce> createState() => _CallOnceState();
}

class _CallOnceState extends State<CallOnce> {
  @override
  void initState() {
    super.initState();
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return const Offstage();
  }
}
