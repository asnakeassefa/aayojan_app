import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/utility/date_formater.dart';
import 'package:aayojan/core/widgets/custom_button2.dart';
import 'package:aayojan/features/invitation/presentation/bloc/invitation_cubit.dart';
import 'package:aayojan/features/invitation/presentation/bloc/invitation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/widgets/calendar.dart';
import '../../data/model/invitation_model.dart';
import 'accepted_event_page.dart';

class EventDetailPage extends StatefulWidget {
  static const routeName = '/event_detail_page';
  final String id;
  final String title;
  List<EventData> subEvents;
  // PageController should be managed by the State, not the Widget
  // as it needs to be disposed.
  // We'll move its initialization to initState in _EventDetailPageState.
  final CalendarWeekController calendarController = CalendarWeekController();

  EventDetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.subEvents,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  late ValueNotifier<int> _currentPageNotifier;
  late PageController _pageController; // Managed by the State
  String? _currentImageUrl; // State variable for the image URL

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        viewportFraction: 0.9,
        initialPage: 0); // Initialize PageController here
    _currentPageNotifier =
        ValueNotifier<int>(0); // Start at the first sub-event

    // Set initial image URL
    if (widget.subEvents.isNotEmpty) {
      _currentImageUrl = widget.subEvents[0].subEvent?.document;
    }

    // Listen to page changes and update the notifier and image
    _pageController.addListener(() {
      if (_pageController.page != null) {
        final newPageIndex = _pageController.page!.round();
        if (_currentPageNotifier.value != newPageIndex) {
          _currentPageNotifier.value = newPageIndex;
          // Update image based on the new page index
          if (newPageIndex < widget.subEvents.length) {
            setState(() {
              _currentImageUrl =
                  widget.subEvents[newPageIndex].subEvent?.document;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.title[0].toUpperCase()}${widget.title.substring(1)}',
          style: CustomTypography.titleLarge.copyWith(
            color: CustomColors.bgLight,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<InvitationCubit>(),
        child: BlocConsumer<InvitationCubit, InvitationState>(
          listener: (context, state) {
            if (state is InvitationAccepted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: CustomColors.success,
                ),
              );
              Navigator.pop(context);
            }

            if (state is InvitationRejected) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    backgroundColor: CustomColors.primary,
                    contentPadding: const EdgeInsets.all(8),
                    title: Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 150,
                        width: MediaQuery.sizeOf(context).width * .8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "We understand that you can't make it to the event.",
                              textAlign: TextAlign.center,
                              style: CustomTypography.bodyLarge.copyWith(
                                color: CustomColors.bgLight,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "You still have the option to confirm your attendance until the day before.",
                              textAlign: TextAlign.center,
                              style: CustomTypography.bodyLarge.copyWith(
                                color: CustomColors.bgLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).then((_) {
                Navigator.pop(context);
              });
            }

            if (state is InvitationPending) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    backgroundColor: CustomColors.primary,
                    contentPadding: const EdgeInsets.all(8),
                    title: Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "We completely understand if you're unable to attend.",
                              textAlign: TextAlign.center,
                              style: CustomTypography.bodyLarge
                                  .copyWith(color: CustomColors.bgLight),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Your presence is important, but your well-being comes first.",
                              textAlign: TextAlign.center,
                              style: CustomTypography.bodyLarge.copyWith(
                                color: CustomColors.bgLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).then((_) {
                Navigator.pop(context);
              });
            }

            if (state is InvitationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: CustomColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // --- CustomWeekCalender (Updates based on current sub-event) ---
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPageNotifier,
                    builder: (context, currentPageIndex, child) {
                      // Ensure subEvents list is not empty and index is valid
                      if (widget.subEvents.isEmpty ||
                          currentPageIndex >= widget.subEvents.length) {
                        return CustomWeekCalender(
                          startData: DateTime.now(),
                          endDate: DateTime.now(),
                        );
                      }
                      final currentSubEvent =
                          widget.subEvents[currentPageIndex].subEvent;
                      return CustomWeekCalender(
                        startData: DateTime.parse(currentSubEvent?.startDate ??
                            DateTime.now().toString()),
                        endDate: DateTime.parse(currentSubEvent?.endDate ??
                            DateTime.now().toString()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- Image Display (Updates based on _currentImageUrl) ---
                  SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width * .7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        // Fallback color
                        image: _currentImageUrl != null &&
                                _currentImageUrl!.isNotEmpty
                            ? DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  "${Endpoints.imageUrl}$_currentImageUrl",
                                ),
                              )
                            : null, // Handle case where no image is available
                      ),
                      child:
                          _currentImageUrl == null || _currentImageUrl!.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Image Available',
                                    style: CustomTypography.bodyLarge.copyWith(
                                      color: CustomColors.bgLight,
                                    ),
                                  ),
                                )
                              : null,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Page Indicator ---
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController, // Use the state's controller
                      count: widget.subEvents.length,
                      effect: const WormEffect(
                        dotWidth: 10,
                        dotHeight: 10,
                        activeDotColor: CustomColors.bgLight,
                        dotColor: CustomColors.info,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Event Details PageView (Controls image and calendar updates) ---
                  SizedBox(
                    height: 270,
                    child: PageView.builder(
                      controller: _pageController, // Use the state's controller
                      itemCount: widget.subEvents.length,
                      // The onPageChanged callback is crucial here for updating the image and calendar
                      onPageChanged: (index) {
                        // This updates the _currentPageNotifier which CustomWeekCalender listens to
                        _currentPageNotifier.value = index;
                        // This updates the _currentImageUrl which the image container listens to via setState
                        setState(() {
                          _currentImageUrl =
                              widget.subEvents[index].subEvent?.document;
                        });
                      },
                      itemBuilder: (context, index) {
                        final subEvent = widget.subEvents[index].subEvent;
                        // Defensive check for null subEvent
                        if (subEvent == null) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: CustomColors.bgLight.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'No event details available for this sub-event.',
                                textAlign: TextAlign.center,
                                style: CustomTypography.bodyMedium
                                    .copyWith(color: CustomColors.bgLight),
                              ),
                            ),
                          );
                        }

                        return Container(
                          height: 300,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: CustomColors.bgLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                  image: subEvent.document != null &&
                                          subEvent.document!.isNotEmpty
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          opacity: 0.4,
                                          image: NetworkImage(
                                              "${Endpoints.imageUrl}${subEvent.document}"),
                                        )
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      subEvent.title ?? widget.title,
                                      style: CustomTypography.titleMedium
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formatTime(subEvent.time ?? ''),
                                      style:
                                          CustomTypography.bodyMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formatDate(subEvent.startDate ?? ''),
                                      style:
                                          CustomTypography.bodyMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    CustomButtonOut(
                                      onPressed: () {
                                        if (widget.subEvents[index]
                                                .guestResponsePreferences ==
                                            "Accept with thanks") {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                content: Text(
                                                    "You have already accepted this invitation."),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          // return;
                                          return;
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                // if the event is already accepted, show a pop-up that says you have already accepted ....

                                                return AcceptedEventPage(
                                                  id: widget.subEvents[index].id
                                                      .toString(),
                                                  title: subEvent.title ?? "",
                                                  date:
                                                      subEvent.startDate ?? "",
                                                  time: subEvent.time ?? "",
                                                  venue: subEvent.venue ?? "",
                                                  imgUrl:
                                                      "${Endpoints.imageUrl}${subEvent.document ?? ''}",
                                                );
                                              },
                                            ),
                                          ).then((value) {
                                            if (value != null &&
                                                value is bool &&
                                                value) {
                                              Navigator.pop(context, true);
                                            }
                                          });
                                        }
                                      },
                                      backgroundColor: Color(0xff816189),
                                      borderColor: CustomColors.bgLight,
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/tick.svg',
                                            colorFilter: const ColorFilter.mode(
                                                Colors.green, BlendMode.srcIn),
                                          ),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            child: Text(
                                              'Accept with thanks',
                                              style: CustomTypography.bodyMedium
                                                  .copyWith(
                                                      color:
                                                          CustomColors.bgLight),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      isLoading: false,
                                      height: 40,
                                      width: double.infinity,
                                    ),
                                    CustomButtonOut(
                                      onPressed: () {
                                        context
                                            .read<InvitationCubit>()
                                            .pendingInvitation(
                                                widget.subEvents[index].id
                                                    .toString(),
                                                1);
                                      },
                                      backgroundColor: Color(0xff816189),
                                      borderColor: CustomColors.bgLight,
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/not_sure.svg',
                                            colorFilter: const ColorFilter.mode(
                                                Colors.yellow, BlendMode.srcIn),
                                          ),
                                          const SizedBox(width: 8),
                                          Text('Not sure to attend',
                                              style: CustomTypography.bodyMedium
                                                  .copyWith(
                                                      color: CustomColors
                                                          .bgLight)),
                                        ],
                                      ),
                                      isLoading: false,
                                      height: 40,
                                      width: double.infinity,
                                    ),
                                    CustomButtonOut(
                                      onPressed: () {
                                        context
                                            .read<InvitationCubit>()
                                            .rejectInvitation(
                                                widget.subEvents[index].id
                                                    .toString(),
                                                1);
                                      },
                                      backgroundColor: const Color(0xff816189),
                                      borderColor: CustomColors.bgLight,
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/cancel.svg',
                                            colorFilter: const ColorFilter.mode(
                                                Colors.red, BlendMode.srcIn),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Not able to attend',
                                            style: CustomTypography.bodyMedium
                                                .copyWith(
                                                    color:
                                                        CustomColors.bgLight),
                                          ),
                                        ],
                                      ),
                                      isLoading: false,
                                      height: 40,
                                      width: double.infinity,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
