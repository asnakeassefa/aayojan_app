import 'package:intl/intl.dart';
import 'package:aayojan/core/utility/horizontal_week_calendar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../theme/custom_colors.dart';
import '../theme/custom_typo.dart';

class CustomWeekCalender extends StatelessWidget {
  final DateTime startData;
  final DateTime endDate;

  CustomWeekCalender({
    super.key,
    required DateTime startData,
    required DateTime endDate,
  })  : startData = startData.isAfter(endDate) ? endDate : startData,
        endDate = startData.isAfter(endDate) ? startData : endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: CustomColors.bgLight.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              // make this like "December 2023"
              DateFormat('MMMM yyyy').format(startData),
              style: CustomTypography.bodyLarge.copyWith(
                color: CustomColors.bgLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: CustomColors.ligthPrimary,
          ),
          child: HorizontalWeekCalendar(
            minDate: endDate.isAfter(DateTime.now())
                ? startData
                : endDate.subtract(const Duration(days: 2)),
            maxDate: endDate.isAfter(startData.add(const Duration(days: 2)))
                ? endDate
                : startData.add(const Duration(days: 2)),
            // Ensure initialDate is strictly after minDate and strictly before maxDate

            initialDate: (() {
              final min = endDate.isAfter(DateTime.now())
                  ? startData
                  : endDate.subtract(const Duration(days: 2));
              final max = endDate.isAfter(startData.add(const Duration(days: 2)))
                  ? endDate
                  : startData.add(const Duration(days: 2));
              final now = DateTime.now();
              if (now.isAfter(min) && now.isBefore(max)) {
                return now;
              } else if (now.isAtSameMomentAs(min)) {
                // If now == min, move to min + 1 day (if before max)
                final nextDay = min.add(const Duration(days: 1));
                return nextDay.isBefore(max) ? nextDay : min;
              } else {
                // If now is before min or after/equal max, use min + 1 day if possible
                final nextDay = min.add(const Duration(days: 1));
                return nextDay.isBefore(max) ? nextDay : min;
              }
            })(),
            showTopNavbar: false,
            monthFormat: "MMMM yyyy",
            showNavigationButtons: true,
            weekStartFrom: WeekStartFrom.Monday,
            borderRadius: BorderRadius.circular(7),
            activeBackgroundColor: CustomColors.primary,
            activeTextColor: Colors.white,
            inactiveBackgroundColor: CustomColors.ligthPrimary,
            inactiveTextColor: Colors.white,
            disabledTextColor: Colors.grey,
            disabledBackgroundColor: CustomColors.ligthPrimary,
            activeNavigatorColor: Colors.deepPurple,
            inactiveNavigatorColor: Colors.grey,
            monthColor: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}
