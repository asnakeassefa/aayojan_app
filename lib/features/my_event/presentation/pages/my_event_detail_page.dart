import 'dart:developer';

import 'package:aayojan/core/network/endpoints.dart';
import 'package:aayojan/core/utility/date_formater.dart';
import 'package:aayojan/core/widgets/calendar.dart';
import 'package:aayojan/features/plan_sub_event/presentation/pages/plan_sub_event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../guest/presentation/pages/parent_list_page.dart';
import '../../data/model/event_model.dart';
import '../../data/model/sub_event_model.dart';
import '../bloc/my_event_cubit.dart';
import '../bloc/my_event_state.dart';
import '../widget/expandable_event_card.dart';

class MyEventDetailPage extends StatefulWidget {
  static const String routeName = '/my_event_detail';

  final InData event;

  const MyEventDetailPage({super.key, required this.event});

  @override
  State<MyEventDetailPage> createState() => _MyEventDetailPageState();
}

class _MyEventDetailPageState extends State<MyEventDetailPage> {
  List<SubData> events = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            getIt<MyEventCubit>()..getSubEvents(widget.event.id.toString()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.event.venue ?? "title",
              style: CustomTypography.titleMedium.copyWith(
                color: CustomColors.bgLight,
              ),
            ),
            automaticallyImplyLeading: true,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocConsumer<MyEventCubit, MyEventState>(
              listener: (context, state) {
                if (state is MySubEventLoaded) {
                  events = state.response.data?.data ?? [];
                  // log("event length" + events.length.toString());
                  // log(events.toString());
                }

                if (state is MySubEventDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context
                      .read<MyEventCubit>()
                      .getSubEvents(widget.event.id.toString());
                  // Return true on successful deletion
                }

                if (state is MyEventDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(
                      context, true); // Return true on successful deletion
                }

                if (state is MyEventFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      widget.event.startDate == null
                          ? const SizedBox()
                          : CustomWeekCalender(
                              startData: DateTime.parse(
                                widget.event.startDate ??
                                    DateTime.now().toString(),
                              ),
                              endDate: DateTime.parse(
                                widget.event.endDate ??
                                    DateTime.now().toString(),
                              ),
                            ),
                      const SizedBox(height: 24),
                      if (state is MyeventLoading)
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.7,
                          child: const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: CustomColors.bgLight,
                              ),
                            ),
                          ),
                        ),
                      events.isEmpty && state is MySubEventLoaded
                          ? Center(
                              child: Text(
                                'No events found',
                                style: CustomTypography.bodyLarge.copyWith(
                                  color: CustomColors.bgLight,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.6,
                              child: ListView.separated(
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  log(events[index].title.toString());
                                  return ExpandableEventCard(
                                    title:
                                        events[index].title ?? "Untitled Event",
                                    imagePath:
                                        "${Endpoints.imageUrl}${events[index].document}",
                                    attending: events[index]
                                        .acceptWithThanksCount
                                        .toString(),
                                    notAttending:
                                        (events[index].unableToAttendCount)
                                            .toString(),
                                    totalInvities: events[index].invitedGuestCount == null
                                        ? "0"
                                        : events[index].invitedGuestCount.toString(),
                                    totalAttendees:
                                        events[index].totalAttendees.toString(),
                                    date: formatDate(
                                        events[index].startDate ?? ""),
                                    // formatTime
                                    time: formatTime(
                                        events[index].time ?? "00:00:00"),
                                    onDelete: () {
                                      context
                                          .read<MyEventCubit>()
                                          .deleteSubEvent(
                                            events[index].id.toString(),
                                          );
                                    },

                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlanSubEventPage(
                                            id: events[index].id.toString(),
                                            mainEventId: events[index]
                                                .mainEventId as int?,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 10);
                                },
                              ),
                            ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                // showDialog(
                                //   context: context,
                                //   builder: (context) {
                                //     return BlocProvider(
                                //       create: (context) =>
                                //           getIt<MyEventCubit>(),
                                //       child: BlocConsumer<MyEventCubit,
                                //           MyEventState>(
                                //         listener: (context, state) {
                                //           if (state is MyEventDeleted) {
                                //             ScaffoldMessenger.of(context)
                                //                 .showSnackBar(
                                //               SnackBar(
                                //                 content: Text(state.message),
                                //                 backgroundColor: Colors.green,
                                //               ),
                                //             );

                                //             Navigator.pop(context,
                                //                 true); // Return true on successful deletion
                                //           }

                                //           if (state is MyEventFailure) {
                                //             ScaffoldMessenger.of(context)
                                //                 .showSnackBar(
                                //               SnackBar(
                                //                 content: Text(state.message),
                                //                 backgroundColor: Colors.red,
                                //               ),
                                //             );
                                //           }
                                //         },
                                //         builder: (context, state) {
                                //           return AlertDialog(
                                //             title: const Text('Delete Event'),
                                //             content: state is MyeventLoading
                                //                 ? const Text('Deleting...')
                                //                 : const Text(
                                //                     'Are you sure you want to delete this event?'),
                                //             actions: [
                                //               TextButton(
                                //                 onPressed: () =>
                                //                     Navigator.pop(context),
                                //                 child: const Text('Cancel'),
                                //               ),
                                //               TextButton(
                                //                 onPressed: state
                                //                         is MyeventLoading
                                //                     ? null
                                //                     : () {
                                //                         context
                                //                             .read<
                                //                                 MyEventCubit>()
                                //                             .deleteEvent(
                                //                               widget.event.id
                                //                                   .toString(),
                                //                             );
                                //                       },
                                //                 child: const Text('Delete'),
                                //               ),
                                //             ],
                                //           );
                                //         },
                                //       ),
                                //     );
                                //   },
                                // ).then((value) {
                                //   if (value == true) {
                                //     Navigator.pop(context, true);
                                //   }
                                // });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PlanSubEventPage(
                                        mainEventId: widget.event.id,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Ionicons.add_sharp,
                                    color: CustomColors.bgLight,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Plan Sub Event',
                                    style: CustomTypography.bodyLarge.copyWith(
                                      color: CustomColors.bgLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // TextButton(
                      //   onPressed: () {

                      //   },
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset('assets/icons/edit.svg'),
                      //       const SizedBox(width: 8),
                      //       Text(
                      //         'Edit Guest List',
                      //         style: CustomTypography.bodyLarge.copyWith(
                      //           color: CustomColors.bgLight,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}
