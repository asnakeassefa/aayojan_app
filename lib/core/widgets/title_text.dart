import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  const TitleText({
    super.key,
    required this.text,
    this.fontFamily,
    this.fontSize,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily ?? 'Poppins',
        fontSize: fontSize ?? 18,
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
