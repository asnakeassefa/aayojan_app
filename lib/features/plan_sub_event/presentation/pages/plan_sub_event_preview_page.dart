import 'dart:developer';
import 'dart:io';

import 'package:aayojan/core/utility/date_formater.dart';
import 'package:aayojan/features/my_event/presentation/pages/my_event_page.dart';
import 'package:aayojan/features/plan_sub_event/presentation/bloc/sub_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../app.dart';
import '../bloc/sub_event_cubit.dart';

class PlanSubEventPreviewPage extends StatefulWidget {
  static const String routeName = '/plan_sub_event_preview';

  final String title;
  final String time;
  final String reqTime;
  final String date;
  final String venue;
  final int eventid;
  final String details;
  final String documentPath;
  final String imageUrl;
  final String imagePath;
  final String timeOfDay;
  final String guestResponse;
  final List guestList;
  final String? id;
  const PlanSubEventPreviewPage({
    super.key,
    required this.title,
    required this.time,
    required this.date,
    required this.venue,
    required this.eventid,
    required this.details,
    required this.documentPath,
    required this.timeOfDay,
    required this.guestResponse,
    required this.guestList,
    required this.reqTime,
    this.id,
    required this.imageUrl,
    required this.imagePath,
  });

  @override
  State<PlanSubEventPreviewPage> createState() =>
      _PlanSubEventPreviewPageState();
}

class _PlanSubEventPreviewPageState extends State<PlanSubEventPreviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SubEventCubit>(),
      child: BlocConsumer<SubEventCubit, SubEventState>(
        listener: (context, state) {
          if (state is SubEventSuccess) {
            // shwo snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.success,
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(
                  index: 3,
                ),
              ),
              (route) => route.isFirst,
            );
          }

          if (state is SubEventFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .85,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Container(
                        height: MediaQuery.of(context).size.height * .25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: widget.imagePath.isNotEmpty
                                  ? FileImage(
                                      File(widget.imagePath),
                                    )
                                  : NetworkImage(widget.imageUrl)),
                          borderRadius: BorderRadius.circular(10),
                          // color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Time',
                        style: CustomTypography.titleLarge.copyWith(
                          color: CustomColors.bgLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatTime(widget.time),
                        style: CustomTypography.bodyLarge.copyWith(
                          color: CustomColors.bgLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Date',
                        style: CustomTypography.titleLarge.copyWith(
                          color: CustomColors.bgLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatDate(widget.date),
                        style: CustomTypography.bodyLarge.copyWith(
                          color: CustomColors.bgLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Venue',
                        style: CustomTypography.titleLarge.copyWith(
                          color: CustomColors.bgLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.venue,
                        textAlign: TextAlign.center,
                        style: CustomTypography.bodyLarge.copyWith(
                          color: CustomColors.bgLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Text(
                      //   'Details',
                      //   style: CustomTypography.titleLarge.copyWith(
                      //     color: CustomColors.bgLight,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: MediaQuery.sizeOf(context).height * .1,
                      //   width: MediaQuery.sizeOf(context).width * .8,
                      //   child: Text(
                      //     widget.details,
                      //     textAlign: TextAlign.center,
                      //     overflow: TextOverflow.ellipsis,
                      //     maxLines: 10,
                      //     style: CustomTypography.bodyLarge.copyWith(
                      //       color: CustomColors.bgLight,
                      //     ),
                      //   ),
                      // ),
                      CustomButton(
                        onPressed: () {
                          log(widget.guestResponse);

                          if (widget.id != null && widget.id!.isNotEmpty) {
                            log('updateing event');
                            context.read<SubEventCubit>().updateSubEvent({
                              "id": widget.id,
                              "event_name": widget.title,
                              "description": "widget.details",
                              "time": widget.time,
                              "date": widget.date,
                              "venue": widget.venue,
                              "main_event_id": widget.eventid,
                              "document": widget.imagePath,
                              "times_of_day": widget.timeOfDay,
                              "guest_response_preferences": [
                                widget.guestResponse
                              ],
                              "guests_id": widget.guestList
                            }, widget.id!);
                          } else {
                            context.read<SubEventCubit>().addSubEvent({
                              "event_name": widget.title,
                              "description": "widget.details",
                              "time": widget.time,
                              "date": widget.date,
                              "venue": widget.venue,
                              "main_event_id": widget.eventid,
                              "document": widget.imagePath,
                              // "times_of_day": widget.timeOfDay,
                              "guest_response_preferences": [
                                widget.guestResponse
                              ],
                              "guests_id": widget.guestList
                            });
                          }
                        },
                        text: "Continue",
                        isLoading: state is SubEventLoading,
                        height: 54,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
