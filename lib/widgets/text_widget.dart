import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TextWidget(
      {super.key,
      required this.label,
      required this.fontSize,
      required this.color,
      required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style:
          TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
  }
}
