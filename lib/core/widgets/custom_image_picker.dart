import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/custom_colors.dart';
import '../theme/custom_typo.dart';

class ProfileImagePicker extends StatelessWidget {
  final Function onPressed;
  const ProfileImagePicker({
    super.key,
    required this.filePath,
    required this.onPressed,
    required this.imageUrl,
  });

  final String filePath;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        onPressed();
      },
      icon: CircleAvatar(
        radius: 70,
        backgroundColor: CustomColors.primaryLight,
        backgroundImage: filePath.isNotEmpty
            ? FileImage(File(filePath))
            : imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null,
        child: Center(
          child: filePath.isEmpty && imageUrl.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/camera.svg',
                      colorFilter: const ColorFilter.mode(
                        CustomColors.bgLight,
                        BlendMode.srcIn,
                      ),
                      width: 40,
                      height: 40,
                    ),
                    Text('Upload pic', style: CustomTypography.bodyLarge),
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
