import 'package:aayojan/core/utility/date_formater.dart';
import 'package:aayojan/features/plan_event/presentation/pages/plan_event_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';

class EventCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String time;
  final Function? onTap;
  final Function? onDelete;
  const EventCard(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.date,
      required this.time,
      this.onTap,
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height * .30,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomColors.bgTeritary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(
                onTap: () {
                  onTap != null ? onTap!() : () {};
                },
                child: Row(
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(width: 5),
                    Text(
                      "Edit Event ",
                      style: CustomTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  onDelete != null ? onDelete!() : () {};
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete,
                      color: CustomColors.error,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Delete Event ",
                      style: CustomTypography.bodyMedium.copyWith(
                        color: CustomColors.error,
                      ),
                    ),
                  ],
                ),
              )
            ]),
            const SizedBox(height: 8),
            Container(
              height: MediaQuery.of(context).size.height * .15,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CustomColors.bgLight,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    imagePath,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: CustomTypography.bodyLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(date),
                  style: CustomTypography.bodyMedium,
                ),
                Text(
                  time,
                  style: CustomTypography.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
