import 'dart:developer';
import 'dart:io';

import 'package:aayojan/core/utility/date_formater.dart';
import 'package:aayojan/core/widgets/custom_button.dart';
import 'package:aayojan/features/app.dart';
import 'package:aayojan/features/my_event/presentation/pages/my_event_page.dart';
import 'package:aayojan/features/plan_event/presentation/bloc/plan_event_cubit.dart';
import 'package:aayojan/features/plan_event/presentation/bloc/plan_event_state.dart';
import 'package:aayojan/features/plan_sub_event/presentation/pages/plan_sub_event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';

class PlanPreviewPage extends StatefulWidget {
  static const String routeName = '/plan_preview';
  final String title;
  final String time;
  final String startDate;
  final String endDate;
  final String venue;
  final String event;
  final String details;
  final String document;
  final String? img;
  final String reqTime;
  final int? id;
  final int? save;
  final List<dynamic>? guestList;

  const PlanPreviewPage({
    super.key,
    required this.title,
    required this.time,
    required this.startDate,
    required this.endDate,
    required this.venue,
    required this.event,
    required this.details,
    required this.document,
    required this.img,
    required this.reqTime,
    this.id,
    this.save,
    this.guestList,
  });

  @override
  State<PlanPreviewPage> createState() => _PlanPreviewPageState();
}

class _PlanPreviewPageState extends State<PlanPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlanEventCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<PlanEventCubit, PlanEventState>(
          listener: (context, state) {
            if (state is PlanEventSuccess) {
              // show snackbar
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

            if (state is PlanEventSuccessWithSubEvent) {
              // show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: CustomColors.success,
                ),
              );
              Navigator.pushNamed(context, PlanSubEventPage.routeName);
            }

            if (state is PlanEventFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: CustomColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
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
                          image: widget.document.isEmpty
                              ? DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    widget.img ?? "",
                                  ),
                                )
                              : DecorationImage(
                                  image: FileImage(
                                    File(widget.document),
                                  ),
                                ),
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
                        widget.time,
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
                        formatDate(widget.startDate),
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
                      Text(
                        'Details',
                        style: CustomTypography.titleLarge.copyWith(
                          color: CustomColors.bgLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .8,
                        child: Text(
                          widget.details,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          style: CustomTypography.bodyLarge.copyWith(
                            color: CustomColors.bgLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        onPressed: () {
                          log('here in saving update');
                          log(widget.save.toString());
                          if (widget.id != null) {
                            context.read<PlanEventCubit>().updateEvent(
                              {
                                "title": widget.title,
                                'event_type': widget.event,
                                'details': widget.details,
                                "time": widget.reqTime,
                                "start_date": widget.startDate,
                                "end_date": widget.endDate,
                                "venue": widget.venue,
                                'document': widget.document,
                                'guests': widget.guestList,
                                'save': widget.save,
                              },
                              widget.id!,
                              false,
                            );
                          } else {
                            context.read<PlanEventCubit>().createEvent({
                              "title": widget.title,
                              'event_type': widget.event,
                              'details': widget.details,
                              "time": widget.reqTime,
                              "start_date": widget.startDate,
                              "end_date": widget.endDate,
                              "venue": widget.venue,
                              'document': widget.document,
                              'guests': widget.guestList,
                              'save': widget.save,
                            }, false);
                          }
                        },
                        text: "Save",
                        isLoading: state is PlanEventLoading,
                        height: 54,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
