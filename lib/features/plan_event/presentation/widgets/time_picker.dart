import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';

class TimePicker extends StatelessWidget {
  final TextEditingController timeController;
  final String title;
  final Function() onTap;
  final String? errorText;
  final bool? isError;
  const TimePicker({
    super.key,
    required this.timeController,
    required this.title,
    required this.onTap,
    this.errorText,
    this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: CustomColors.ligthPrimary.withOpacity(.3),
              border: Border.all(
                color: (isError ?? false)
                    ? CustomColors.error
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.access_time, color: CustomColors.bgLight),
                const SizedBox(width: 16),
                Text(
                  timeController.text.isNotEmpty
                      ? timeController.text
                      : "Time *",
                  style: CustomTypography.bodyMedium.copyWith(
                    color: timeController.text.isEmpty
                        ? CustomColors.info
                        : CustomColors.bgLight,
                  ),
                ),
              ],
            ),
          ),
        ),
        if ((isError ?? false) && errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 6),
            child: Text(
              errorText!,
              style: CustomTypography.bodySmall.copyWith(
                color: CustomColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
