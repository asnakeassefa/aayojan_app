import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/custom_colors.dart';

class MenuButton extends StatelessWidget {
  final double height;
  final double width;
  final String svgPath;
  final String title;
  final Function onTap;
  const MenuButton({
    super.key,
    required this.height,
    required this.width,
    required this.svgPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              CustomColors.primary,
              CustomColors.primaryLight,
            ],
          ),
        ),
        height: height,
        width: width,
        child: Center(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  child: SvgPicture.asset(
                    height: 28,
                    width: 34,
                    svgPath,
                    color: CustomColors.bgLight,
                    // colorFilter: const ColorFilter.mode(
                    //     CustomColors.bgLight, BlendMode.src),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTypography.bodyLarge
                      .copyWith(color: CustomColors.bgLight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
