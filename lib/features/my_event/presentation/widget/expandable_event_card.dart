import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';

class ExpandableEventCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String totalInvities;
  final String totalAttendees;
  final String attending;
  final String notAttending;
  final String time;
  final Function()? onTap;
  final Function()? onDelete;
  const ExpandableEventCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.totalInvities,
    required this.attending,
    required this.notAttending,
    required this.totalAttendees,
    required this.date,
    required this.time,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(15),
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
                color: CustomColors.bgSecondary,
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
                  date,
                  style: CustomTypography.bodyMedium,
                ),
                Text(
                  time,
                  style: CustomTypography.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ExpandChild(
              indicatorBuilder: (context, onTap, isExpanded) {
                return IconButton(
                  onPressed: onTap,
                  icon: Row(
                    children: [
                      isExpanded
                          ? Text(
                              'SeeLess',
                              style: CustomTypography.bodyLarge.copyWith(
                                color: CustomColors.primary,
                              ),
                            )
                          : Text(
                              'SeeMore',
                              style: CustomTypography.bodyLarge.copyWith(
                                color: CustomColors.primary,
                              ),
                            ),
                      isExpanded
                          ? const Icon(
                              Icons.arrow_drop_up,
                              color: CustomColors.primary,
                              size: 30,
                            )
                          : const Icon(
                              Icons.arrow_drop_down,
                              color: CustomColors.primary,
                              size: 30,
                            ),
                    ],
                  ),
                );
              },
              indicatorAlignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Event",
                        style: CustomTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primary),
                      ),
                      Text(
                        "Total Members",
                        style: CustomTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primary),
                      ),
                    ],
                  ),
                  const Divider(
                    color: CustomColors.primary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Invitees",
                        style: CustomTypography.bodyLarge.copyWith(
                          color: CustomColors.primary,
                        ),
                      ),
                      Text(
                        totalInvities,
                        style: CustomTypography.bodyLarge
                            .copyWith(color: CustomColors.primary),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Attendees",
                        style: CustomTypography.bodyLarge.copyWith(
                          color: CustomColors.primary,
                        ),
                      ),
                      Text(
                        totalAttendees,
                        style: CustomTypography.bodyLarge
                            .copyWith(color: CustomColors.primary),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Attending (Yes)",
                        style: CustomTypography.bodyLarge.copyWith(
                          color: CustomColors.primary,
                        ),
                      ),
                      Text(
                        attending,
                        style: CustomTypography.bodyLarge
                            .copyWith(color: CustomColors.primary),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Not Attending (No)",
                        style: CustomTypography.bodyLarge.copyWith(
                          color: CustomColors.primary,
                        ),
                      ),
                      Text(
                        notAttending,
                        style: CustomTypography.bodyLarge
                            .copyWith(color: CustomColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
