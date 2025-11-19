import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class ErrorText extends StatelessWidget {
  final String errorText;
  const ErrorText({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.sizeOf(context).width,
      child: Center(
        child: Text(
          errorText,
          style: const TextStyle(
            color: CustomColors.error,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}


