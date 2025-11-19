import 'dart:developer';
import 'dart:io';

import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/utility/date_formater.dart';
import 'package:aayojan/core/widgets/custom_button.dart';
import 'package:aayojan/core/widgets/custom_button2.dart';
import 'package:aayojan/core/widgets/custom_dropdown_button.dart';
import 'package:aayojan/core/widgets/custom_text_field.dart';
import 'package:aayojan/features/guest/presentation/pages/guest_page.dart';
import 'package:aayojan/features/plan_event/presentation/bloc/plan_event_cubit.dart';
import 'package:aayojan/features/plan_event/presentation/bloc/plan_event_state.dart';
import 'package:aayojan/features/plan_event/presentation/pages/plan_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/network/endpoints.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/utility/constants.dart';
import '../../../../core/utility/file_picker.dart';
import '../../../guest/presentation/pages/parent_list_page.dart';
import '../../../my_event/presentation/pages/my_event_page.dart';
import '../../../plan_sub_event/presentation/pages/plan_sub_event_page.dart';
import '../widgets/date_picker.dart';
import '../widgets/time_picker.dart';

class PlanEventPage extends StatefulWidget {
  static const String routeName = '/plan-event';
  final int? id;
  final bool? isUpdate;
  const PlanEventPage({super.key, this.id, this.isUpdate});

  @override
  State<PlanEventPage> createState() => _PlanEventPageState();
}

class _PlanEventPageState extends State<PlanEventPage> {
  // list all text editing controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String startDate = '';
  String endDate = '';
  bool endIsEmpty = false;
  bool startIsEmpty = false;
  bool timeIsNotEmpty = false;
  String time = '';
  String event = "-1";
  String filePath = '';
  String imagePath = '';
  List guestList = [];
  bool imageValidation = false;
  int familyCount = 0;

  bool selected = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan a New Event',
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<PlanEventCubit, PlanEventState>(
        listener: (context, state) {
          if (state is EventLoaded) {
            setState(() {
              try {
                titleController.text = state.event.data?.title ?? '';
                startDateController.text =
                    formatDate(state.event.data?.startDate ?? '');
                endDateController.text =
                    formatDate(state.event.data?.endDate ?? '');
                timeController.text = formatTime(state.event.data?.time ?? '');
                venueController.text = state.event.data?.venue ?? '';
                detailController.text = state.event.data?.description ?? '';
                imagePath =
                    "${Endpoints.imageUrl}${state.event.data?.document}";
                if (state.event.data?.eventType != null &&
                    eventType
                        .map((e) => e.value)
                        .contains(state.event.data?.eventType)) {
                  event = state.event.data?.eventType ?? '-1';
                }
                // event = state.event.data?.eventType ?? '-1';
                startDate = state.event.data?.startDate ?? '';
                endDate = state.event.data?.endDate ?? '';
                time = state.event.data?.time ?? '';
              } catch (e) {
                log(e.toString());
              }
              // filePath = state.event.data?.document ?? '';
            });
          }

          if (state is PlanEventSuccess) {
            Navigator.pushReplacementNamed(context, MyEventPage.routeName);
          }

          if (state is PlanEventFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.error,
              ),
            );
          }
          if (state is PlanEventSuccessWithSubEvent) {
            // show snackbar
            log(state.id.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.success,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PlanSubEventPage(
                    mainEventId: state.id.toInt(),
                  );
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: CustomColors.bgLight,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    // upload event PDF/image
                    IconButton(
                      onPressed: () async {
                        // hello
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
                              image: filePath.isNotEmpty
                                  ? FileImage(File(filePath))
                                  : NetworkImage(imagePath),
                              fit: BoxFit.contain,
                            )),
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
                                        CustomColors.bgLight, BlendMode.srcIn),
                                  )
                                : SizedBox(),
                            filePath.isEmpty && imagePath.isEmpty
                                ? Text(
                                    'Upload Event PDF/Image',
                                    style: CustomTypography.bodyLarge.copyWith(
                                      color: CustomColors.bgLight,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    //title
                    CustomTextField(
                      isObscure: false,
                      headerText: "",
                      hintText: "Title*",
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9 ]'),
                        ),
                      ],
                      maxLength: 30,
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),

                    //Event type
                    CustomDropdownButton(
                      items: eventType,
                      title: "Event Type",
                      initVal: event,
                      onChanged: ((value) {
                        setState(() {
                          event = value!;
                        });
                      }),
                      validator: (value) {
                        if (value == null || value == "-1") {
                          return 'select an event type';
                        }
                        return null;
                      },
                    ),
                    // Venue
                    const SizedBox(height: 8),
                    CustomTextField(
                      isObscure: false,
                      headerText: "",
                      hintText: "Venue*",
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9 ]'),
                        ),
                      ],
                      maxLength: 30,
                      controller: venueController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Venue is required';
                        }
                        return null;
                      },
                    ),

                    // time
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
                    const SizedBox(
                      height: 8,
                    ),
                    // start Date
                    DatePicker(
                      dateController: startDateController,
                      endDate: startDate,
                      title: "Start Date*",
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        ).then(
                          (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              startDate = value.toString();
                              startDateController.text = formatDate(startDate);
                            });
                            setState(() {
                              startIsEmpty = false;
                            });
                          },
                        );
                      },
                      isError: startIsEmpty,
                      errorText: "Start date is required",
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // end Date
                    DatePicker(
                      dateController: endDateController,
                      endDate: endDate,
                      title: "End Date*",
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        ).then(
                          (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              endDate = value.toString();
                              endDateController.text = formatDate(endDate);
                            });
                            setState(() {
                              endIsEmpty = false;
                            });
                          },
                        );
                      },
                      isError: endIsEmpty,
                      errorText: "End date is required",
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    // detail
                    CustomTextField(
                      isObscure: false,
                      headerText: "",
                      hintText: "Details goes here...",
                      maxLength: 255,
                      maxLines: 4,
                      borderRadius: 24,
                      controller: detailController,
                    ),

                    CustomButtonOut(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return GuestPage(
                            isForEvent: true,
                            eventId: widget.id,
                          );
                        })).then(
                          (value) {
                            if (value != null) {
                              log(value.toString());
                              // change this to list from set
                              List guests = [];
                              for (var val in value[0]) {
                                guests.add(val);
                              }
                              setState(() {
                                familyCount = value[1].length;
                                guestList = guests;
                              });
                            }
                          },
                        );
                      },
                      content: Text(
                        "Select Guest's (${guestList.length + familyCount})",
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

                    const SizedBox(
                      height: 8,
                    ),

                    Row(
                      children: [
                        Checkbox(
                          // don't remove the border when checked
                          checkColor: CustomColors.bgLight,
                          fillColor: WidgetStateProperty.all(
                              CustomColors.bgLight.withOpacity(0.2)),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(
                              color: CustomColors.bgLight,
                            ),
                          ),
                          value: selected,

                          onChanged: (value) {
                            setState(() {
                              selected = value!;
                            });
                          },
                          side: const BorderSide(
                            color: CustomColors.bgLight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Save Guest List",
                          style: CustomTypography.bodyMedium.copyWith(
                            color: CustomColors.bgLight,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    CustomButtonOut(
                      onPressed: () {
                        if (time.isEmpty ||
                            startDate.isEmpty ||
                            endDate.isEmpty ||
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

                          if (startDate.isEmpty) {
                            setState(() {
                              startIsEmpty = true;
                            });
                          }
                          if (endDate.isEmpty) {
                            setState(() {
                              endIsEmpty = true;
                            });
                          }
                        } else if (formKey.currentState!.validate()) {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return PlanPreviewPage(
                          //         document: filePath,
                          //         data: date,
                          //         time: timeController.text,
                          //         title: titleController.text,
                          //         venue: venueController.text,
                          //         event: event,
                          //         details: detailController.text,
                          //         reqTime: time,
                          //         id: widget.id,
                          //       );
                          //     },
                          //   ),
                          // );
                          if (widget.isUpdate != null && widget.isUpdate!) {
                            context.read<PlanEventCubit>().updateEvent(
                              {
                                "title": titleController.text,
                                'event_type': event,
                                'details': detailController.text,
                                "time": time,
                                "start_date": startDate,
                                "end_date": endDate,
                                "venue": venueController.text,
                                if (filePath.isNotEmpty) 'document': filePath,
                                'document': filePath,
                                'guests': guestList,
                                'save': selected == true ? 1 : 0,
                              },
                              widget.id!,
                              true,
                            );
                          } else {
                            context.read<PlanEventCubit>().createEvent(
                              {
                                "title": titleController.text,
                                'event_type': event,
                                'details': detailController.text,
                                "time": time,
                                "start_date": startDate,
                                "end_date": endDate,
                                "venue": venueController.text,
                                if (filePath.isNotEmpty) 'document': filePath,
                                'guests': guestList,
                                'save': selected == true ? 1 : 0,
                              },
                              true,
                            );
                          }
                        }
                      },
                      content: Text(
                        "Plan sub event",
                        style: CustomTypography.bodyMedium.copyWith(
                          color: CustomColors.bgLight,
                        ),
                      ),
                      loadingColor: CustomColors.bgLight,
                      backgroundColor: CustomColors.primary,
                      borderColor: CustomColors.bgLight,
                      isLoading: state is PlanEventLoadingWithSubEvent,
                      height: 54,
                      width: double.infinity,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // cancel button
                    CustomButtonOut(
                      onPressed: () {
                        if (time.isEmpty ||
                            startDate.isEmpty ||
                            endDate.isEmpty ||
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
                          if (startDate.isEmpty) {
                            setState(() {
                              startIsEmpty = true;
                            });
                          }
                          if (endDate.isEmpty) {
                            setState(() {
                              endIsEmpty = true;
                            });
                          }
                        } else if (formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PlanPreviewPage(
                                  document: filePath,
                                  img: imagePath,
                                  startDate: startDate,
                                  endDate: endDate,
                                  time: timeController.text,
                                  title: titleController.text,
                                  venue: venueController.text,
                                  event: event,
                                  details: detailController.text,
                                  reqTime: time,
                                  id: widget.id,
                                  save: selected == true ? 1 : 0,
                                  guestList: guestList,
                                );
                              },
                            ),
                          );
                        }
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
        },
      ),
    );
  }
}
