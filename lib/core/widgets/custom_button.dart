import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/custom_colors.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool isLoading;
  final double height;
  final double width;
  final Color? color;
  final String? imageName;
  final bool? isDisabled;
  final Color? textColor;
  final bool? isBold;
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.isLoading,
      required this.height,
      required this.width,
      this.color,
      this.imageName,
      this.isDisabled,
      this.textColor,
      this.isBold});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? CustomColors.bgLight,
        minimumSize: Size(width, height),
        maximumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: () {
        isDisabled != null && isDisabled! ? null : onPressed();
      },
      child: isLoading
          ? const SizedBox(
              height: 36,
              width: 36,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primary),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageName != null)
                  SvgPicture.asset(
                    imageName!,
                    color: color != null ? Colors.white : CustomColors.bgLight,
                  ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: isBold != null && isBold!
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
    );
  }
}
