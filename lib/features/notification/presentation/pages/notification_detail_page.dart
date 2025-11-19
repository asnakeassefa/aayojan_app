import 'package:aayojan/core/theme/custom_colors.dart';
import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:flutter/material.dart';

import '../../../../core/utility/date_formater.dart';

class NotificationDetailPage extends StatefulWidget {
  final String title;
  final String time;
  final String description;
  final String document;
  const NotificationDetailPage(
      {super.key,
      required this.title,
      required this.time,
      required this.description,
      required this.document});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.title[0].toUpperCase()}${widget.title.substring(1)}",
            style: CustomTypography.titleLarge
                .copyWith(color: CustomColors.bgLight),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        // image: AssetImage(widget.document),
                        image: AssetImage('assets/icons/cake.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // show full titile
                Text(
                  widget.title,
                  style: CustomTypography.titleLarge
                      .copyWith(color: CustomColors.bgLight),
                ),

                const SizedBox(height: 16),

                Text(
                  widget.description,
                  style: CustomTypography.bodyLarge
                      .copyWith(color: CustomColors.bgLight),
                ),
                const SizedBox(height: 16),

                Text(
                  textAlign: TextAlign.end,
                  "At ${formatTimeFromDate(widget.time)}",
                  style: CustomTypography.bodySmall
                      .copyWith(color: CustomColors.info),
                ),

                // show time with
              ],
            ),
          ),
        ));
  }
}
