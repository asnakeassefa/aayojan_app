import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class CustomButtonOut extends StatelessWidget {
  final void Function() onPressed;
  final Widget content;
  final bool isLoading;
  final double height;
  final double width;
  final bool? isDisabled;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? loadingColor;
  const CustomButtonOut({
    super.key,
    required this.onPressed,
    required this.content,
    required this.isLoading,
    required this.height,
    required this.width,
    this.isDisabled,
    this.borderColor,
    this.backgroundColor,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: borderColor ?? CustomColors.primaryLight, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: isDisabled != null && isDisabled! ? null : onPressed,
      child: isLoading
          ? SizedBox(
              height: 36,
              width: 36,
              child: CircularProgressIndicator(
                color: loadingColor ?? CustomColors.primary,
              ),
            )
          : content,
    );
  }
}
