import 'dart:developer';
import 'dart:io';

import 'package:aayojan/core/network/endpoints.dart';
import 'package:aayojan/features/guest/presentation/pages/parent_list_page.dart';
import 'package:aayojan/features/plan_sub_event/presentation/bloc/sub_event_cubit.dart';
import 'package:aayojan/features/plan_sub_event/presentation/bloc/sub_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/utility/constants.dart';
import '../../../../core/utility/date_formater.dart';
import '../../../../core/utility/file_picker.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_button2.dart';
import '../../../../core/widgets/custom_dropdown_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../guest/presentation/pages/guest_page.dart';
import '../../../guest/presentation/pages/sub_event_guests.dart';
import '../../../plan_event/presentation/widgets/date_picker.dart';
import '../../../plan_event/presentation/widgets/time_picker.dart';
import 'plan_sub_event_preview_page.dart';
import 'sub_event_guests.dart';

class PlanSubEventPage extends StatefulWidget {
  static const String routeName = '/plan_sub_event';
  final String? id;
  final int? mainEventId;
  const PlanSubEventPage({super.key, this.id, this.mainEventId});

  @override
  State<PlanSubEventPage> createState() => _PlanSubEventPageState();
}

class _PlanSubEventPageState extends State<PlanSubEventPage> {
  String filePath = "";
  String imagePath = "";
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController venueController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  List<DropdownMenuItem<int>> events = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "Select main event",
        color: CustomColors.info,
      ),
    ),
  ];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int selectedEvent = -1;

  // String timeOfDay = "";
  String timeOfDaySelected = "-1";
  String guestResponse = "";
  String guestResponsePrefernceSelected = "";
  int even = 0;

  String date = '';
  String time = '';
  String? startDate;
  String? endDate;
  bool dateIsEmpty = false;
  bool timeIsNotEmpty = false;
  bool imageValidation = false;
  List guestList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SubEventCubit>()..getEvents(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Plan a Sub Event',
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<SubEventCubit, SubEventState>(
            listener: (context, state) {
          if (state is MyEventLoaded) {
            log('getting events');

            try {
              final newEvents = state.myEvent.data?.data?.map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: CustomText(e.title ?? ""),
                );
              }).toList();
              events = [
                const DropdownMenuItem(
                  value: -1,
                  child: CustomText(
                    "Select main event",
                    color: CustomColors.info,
                  ),
                ),
                ...newEvents ?? [],
              ];
            } catch (e) {
              log(e.toString());
            }
            try {
              context.read<SubEventCubit>().getSubEvents(widget.id!);
            } catch (e) {
              log(e.toString());
            }

            try {
              final value = events.map((e) => e.value).toList();
              log(value.toString());
              if (value.contains(widget.mainEventId)) {
                setState(() {
                  selectedEvent = widget.mainEventId ?? -1;
                  // add date and time
                  startDate = state.myEvent.data?.data
                      ?.firstWhere((e) => e.id == widget.mainEventId)
                      .startDate;
                  endDate = state.myEvent.data?.data
                      ?.firstWhere((e) => e.id == widget.mainEventId)
                      .endDate;
                });
                log('selected event $selectedEvent');
                log('events $events');
              }
            } catch (e) {
              log(e.toString());
            }
          }

          if (state is SubEventLoaded) {
            titleController.text = state.subEvent.data?.title ?? "";
            dateController.text =
                formatDate(state.subEvent.data?.startDate ?? "");
            date = state.subEvent.data?.startDate ?? "";
            time = state.subEvent.data?.time ?? "";
            timeController.text = formatTime(state.subEvent.data?.time ?? "");
            venueController.text = state.subEvent.data?.venue ?? "";
            imagePath = "${Endpoints.imageUrl}${state.subEvent.data?.document}";
            final timeSelected = state.subEvent.data?.timesOfDay ?? "";
            // try {
            //   final value = events.map((e) => e.value).toList();
            //   log(value.toString());
            //   if (value.contains(widget.mainEventId)) {
            //     setState(() {
            //       selectedEvent = widget.mainEventId ?? -1;
            //     });
            //     log('selected event $selectedEvent');
            //     log('events $events');
            //   }
            // } catch (e) {
            //   log(e.toString());
            // }

            if (timeOfDay
                .map((e) => e.value)
                .toList()
                .contains(timeOfDaySelected)) {
              timeOfDaySelected = timeSelected;
            }
          }
        }, builder: (context, state) {
          if (state is SubEventLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: CustomColors.bgLight,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      IconButton(
                        onPressed: () async {
                          File? file = await getFileName();
                          if (file != null) {
                            setState(
                              () {
                                filePath = file.path;
                                imageValidation = false;
                              },
                            );
                          } else {
                            setState(() {
                              if (imagePath.isEmpty) {
                                imageValidation = true;
                              }
                            });
                            log('No file selected or file is not an image');
                          }
                        },
                        icon: Container(
                          height: MediaQuery.sizeOf(context).height * .17,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: CustomColors.ligthPrimary,
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: filePath.isNotEmpty
                                    ? FileImage(
                                        File(filePath),
                                      )
                                    : NetworkImage(
                                        imagePath,
                                      )),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              filePath.isEmpty && imagePath.isEmpty
                                  ? SvgPicture.asset(
                                      'assets/icons/upload.svg',
                                      height: 32,
                                      width: 32,
                                      colorFilter: const ColorFilter.mode(
                                        CustomColors.bgLight,
                                        BlendMode.srcIn,
                                      ),
                                    )
                                  : const SizedBox(),
                              filePath.isEmpty && imagePath.isEmpty
                                  ? Text(
                                      'Upload Event PDF/Image',
                                      style:
                                          CustomTypography.bodyLarge.copyWith(
                                        color: CustomColors.bgLight,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      if ((filePath.isEmpty && imagePath.isEmpty) &&
                          imageValidation)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Please upload a valid image or PDF file.',
                            style: CustomTypography.bodyMedium.copyWith(
                              color: CustomColors.error,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // main event
                      CustomDropdownButton(
                        items: events,
                        title: "Select main event",
                        initVal: selectedEvent,
                        onChanged: (value) {
                          log(value.toString());
                          setState(() {
                            log(value.toString());
                            selectedEvent = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        isObscure: false,
                        headerText: "",
                        hintText: "Sub event name",
                        maxLength: 30,
                        controller: titleController,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9 ]'),
                          )
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Event name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      // //Event type
                      // CustomDropdownButton(
                      //   items: eventType,
                      //   title: "Select Event",
                      // ),

                      TimePicker(
                        timeController: timeController,
                        title: "Time*",
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(
                              () {
                                // Format the selected time to a 12-hour format
                                final localizations =
                                    MaterialLocalizations.of(context);
                                // time in a format like 05:00:00.000000
                                time =
                                    "${picked.hour}:${picked.minute}:00.000000";
                                timeController.text =
                                    localizations.formatTimeOfDay(picked);
                              },
                            );
                            setState(() {
                              timeIsNotEmpty = false;
                            });
                          }
                        },
                        isError: timeIsNotEmpty,
                        errorText: "Time is required",
                      ),

                      // GestureDetector(
                      //   onTap: () async {
                      //     // un focus the text field for ever
                      //     FocusScope.of(context).unfocus();
                      //     final TimeOfDay? picked = await showTimePicker(
                      //       context: context,
                      //       initialTime: TimeOfDay.now(),
                      //     );
                      //     if (picked != null) {
                      //       setState(
                      //         () {
                      //           // Format the selected time to a 12-hour format
                      //           final localizations =
                      //               MaterialLocalizations.of(context);
                      //           time =
                      //               "${picked.hour}:${picked.minute}:00.000000";
                      //           timeController.text =
                      //               localizations.formatTimeOfDay(picked);
                      //         },
                      //       );
                      //     }
                      //   },
                      //   child: Container(
                      //     height: 48,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(50),
                      //       color: CustomColors.ligthPrimary.withOpacity(.3),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         const SizedBox(width: 16),
                      //         const Icon(Icons.access_time,
                      //             color: CustomColors.bgLight),
                      //         const SizedBox(width: 16),
                      //         Text(
                      //           timeController.text.isNotEmpty
                      //               ? timeController.text
                      //               : "Time *",
                      //           style: CustomTypography.bodyMedium.copyWith(
                      //             color: timeController.text.isEmpty
                      //                 ? CustomColors.info
                      //                 : CustomColors.bgLight,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 8),
                      DatePicker(
                        dateController: dateController,
                        endDate: date,
                        title: "Date*",
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: startDate != null
                                ? DateTime.parse(startDate!)
                                : DateTime.now(),
                            firstDate: startDate != null
                                ? DateTime.parse(startDate!)
                                : DateTime.now(),
                            lastDate: endDate != null
                                ? DateTime.parse(endDate!)
                                : DateTime.now().add(
                                    const Duration(days: 365 * 10),
                                  ),
                          ).then(
                            (value) {
                              setState(() {
                                date = value.toString();
                                dateController.text = formatDate(date);
                              });
                              FocusScope.of(context).unfocus();
                            },
                          ).then(
                            (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                date = value.toString();
                                dateController.text = formatDate(date);
                              });
                              setState(() {
                                dateIsEmpty = false;
                              });
                            },
                          );
                        },
                        isError: dateIsEmpty,
                        errorText: "Start date is required",
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     // un focus the text field

                      //     showDatePicker(
                      //       context: context,
                      //       initialDate: startDate != null
                      //           ? DateTime.parse(startDate!)
                      //           : DateTime.now(),
                      //       firstDate: startDate != null
                      //           ? DateTime.parse(startDate!)
                      //           : DateTime.now(),
                      //       lastDate: endDate != null
                      //           ? DateTime.parse(endDate!)
                      //           : DateTime.now().add(
                      //               const Duration(days: 365 * 10),
                      //             ),
                      //     ).then(
                      //       (value) {
                      //         setState(() {
                      //           date = value.toString();
                      //           dateController.text = formatDate(date);
                      //         });
                      //         FocusScope.of(context).unfocus();
                      //       },
                      //     );
                      //   },
                      //   child: Container(
                      //     height: 48,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(50),
                      //       color: CustomColors.ligthPrimary.withOpacity(.3),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         const SizedBox(width: 16),
                      //         const Icon(Icons.calendar_month,
                      //             color: CustomColors.bgLight),
                      //         const SizedBox(width: 16),
                      //         Text(
                      //           dateController.text.isNotEmpty
                      //               ? dateController.text
                      //               : "Date*",
                      //           style: CustomTypography.bodyMedium.copyWith(
                      //             color: dateController.text.isEmpty
                      //                 ? CustomColors.info
                      //                 : CustomColors.bgLight,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      // time

                      // CustomDropdownButton(
                      //   items: timeOfDay,
                      //   title: "Time of day",
                      //   initVal: timeOfDaySelected,
                      //   onChanged: ((value) {
                      //     timeOfDaySelected = value!;
                      //   }),
                      // ),
                      // const SizedBox(height: 8),
                      CustomTextField(
                        isObscure: false,
                        headerText: "",
                        hintText: "Venue",
                        maxLength: 30,
                        controller: venueController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Venue cannot be empty";
                          }
                          return null;
                        },
                      ),
                      // detail
                      // CustomButtonOut(
                      //   onPressed: () {
                      //     // invite with whatapp
                      //   },
                      //   backgroundColor: Colors.green,
                      //   content: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         "Send Invitation via Whatsapp",
                      //         style: CustomTypography.bodyMedium.copyWith(
                      //           color: CustomColors.bgLight,
                      //         ),
                      //       ),
                      //       const SizedBox(width: 8),
                      //       SvgPicture.asset(
                      //         'assets/icons/whatsapp.svg',
                      //         height: 24,
                      //         width: 24,
                      //       ),
                      //     ],
                      //   ),
                      //   isLoading: false,
                      //   height: 54,
                      //   width: double.infinity,
                      // ),
                      // const SizedBox(height: 8),
                      CustomButtonOut(
                        onPressed: () {
                          if (widget.mainEventId == null) {
                            // show snackbar
                            Scaffold.of(context).showBottomSheet(
                              (context) {
                                return const SnackBar(
                                  content:
                                      Text("Sorry, couldn't get the event"),
                                );
                              },
                            );
                          } else {
                            if (widget.id != null) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ExisitngSubEventGuestsPage(
                                    subEventId: widget.id ?? "",
                                    mainEventId: widget.mainEventId.toString());
                              })).then(
                                (value) {
                                  if (value != null) {
                                    setState(() {
                                      log('guest list from last page');
                                      log(value.toString());
                                      guestList = value.toList();
                                    });
                                  }
                                },
                              );
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SubEventGuestsPage(
                                    category: 'All',
                                    id: widget.mainEventId.toString());
                              })).then(
                                (value) {
                                  if (value != null) {
                                    log(value.toString());

                                    setState(() {
                                      guestList = value as List;
                                    });
                                    
                                  }
                                },
                              );
                            }
                          }
                        },
                        content: Text(
                          "Select Guest's (${guestList.length})",
                          style: CustomTypography.bodyMedium.copyWith(
                            color: CustomColors.bgLight,
                          ),
                        ),
                        backgroundColor: CustomColors.primary,
                        borderColor: CustomColors.bgLight,
                        isLoading: false,
                        height: 54,
                        width: double.infinity,
                      ),
                      // button
                      const SizedBox(height: 32),
                      // cancel button
                      CustomButtonOut(
                        onPressed: () {
                          if (time.isEmpty ||
                              date.isEmpty ||
                              (imagePath.isEmpty && filePath.isEmpty)) {
                            formKey.currentState!.validate();

                            if (imagePath.isEmpty && filePath.isEmpty) {
                              setState(() {
                                imageValidation = true;
                              });
                            }
                            if (imagePath.isNotEmpty || filePath.isNotEmpty) {
                              setState(() {
                                imageValidation = false;
                              });
                            }
                            if (time.isEmpty) {
                              setState(() {
                                timeIsNotEmpty = true;
                              });
                            }
                            if (date.isEmpty) {
                              setState(() {
                                dateIsEmpty = true;
                              });
                            }
                          } else if (formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PlanSubEventPreviewPage(
                                    title: titleController.text,
                                    date: date,
                                    reqTime: time,
                                    time: time,
                                    venue: venueController.text,
                                    timeOfDay: timeOfDaySelected,
                                    guestResponse:
                                        guestResponsePrefernceSelected,
                                    eventid: selectedEvent,
                                    details: detailController.text,
                                    documentPath: imagePath,
                                    guestList: guestList,
                                    id: widget.id,
                                    imageUrl: imagePath,
                                    imagePath: filePath,
                                  );
                                },
                              ),
                            );
                          }

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return PlanSubEventPreviewPage(
                          //         title: titleController.text,
                          //         data: date,
                          //         reqTime: time,
                          //         time: timeController.text,
                          //         venue: venueController.text,
                          //         timeOfDay: timeOfDaySelected,
                          //         guestResponse: guestResponsePrefernceSelected,
                          //         eventid: selectedEvent,
                          //         details: detailController.text,
                          //         documentPath: imagePath,
                          //         guestList: guestList,
                          //       );
                          //     },
                          //   ),
                          // );
                        },
                        content: Text(
                          "Save",
                          style: CustomTypography.bodyMedium.copyWith(
                            color: CustomColors.primary,
                          ),
                        ),
                        backgroundColor: CustomColors.bgLight,
                        borderColor: CustomColors.primary,
                        isLoading: false,
                        height: 54,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
