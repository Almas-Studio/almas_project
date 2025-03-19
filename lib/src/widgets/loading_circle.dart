import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  final String? text;
  final Color? color;

  const LoadingCircle({super.key, this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
          ),
        ),
        if (text != null) const SizedBox(height: 6),
        if (text != null) Text(text!),
        const Row(children: [Spacer()]),
      ],
    );
  }
}
