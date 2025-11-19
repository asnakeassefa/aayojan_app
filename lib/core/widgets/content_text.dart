import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class ContentText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  const ContentText(
      {super.key,
      required this.text,
      this.fontFamily,
      this.fontSize,
      this.color,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily ?? 'Poppins',
        fontSize: fontSize ?? 16,
        color: color ?? CustomColors.contentPrimary,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
      maxLines: 100,
      overflow: TextOverflow.ellipsis,
    );
  }
}
