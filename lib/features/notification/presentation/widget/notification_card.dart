import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/custom_colors.dart';
import '../../../../core/utility/date_formater.dart';

class NotificationCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final String detail;
  final String time;
  final Function onTap;
  const NotificationCard(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.detail,
      required this.time,
      required this.onTap});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      // image: NetworkImage(widget.imagePath),
                      image: AssetImage(widget.imagePath),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .70,
                      child: Text(
                        widget.title,
                        style: CustomTypography.headLineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.bgLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .70,
                      child: Text(
                        widget.detail,
                        style: CustomTypography.bodyMedium.copyWith(
                            color: CustomColors.bgLight.withOpacity(.8)),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * .15,
                  child: Text(
                    textAlign: TextAlign.end,
                    "At ${formatTimeFromDate(widget.time)}",
                    style: CustomTypography.bodySmall
                        .copyWith(color: CustomColors.bgLight),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
