import 'dart:developer';

import 'package:aayojan/features/invitation/data/model/invitation_model.dart';
import 'package:aayojan/features/plan_sub_event/presentation/bloc/sub_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/sub_event_cubit.dart';

class ExisitngSubEventGuestsPage extends StatefulWidget {
  static const String routeName = '/sub-event-guests';
  final String mainEventId;
  final String subEventId;
  const ExisitngSubEventGuestsPage(
      {super.key, required this.mainEventId, required this.subEventId});

  @override
  State<ExisitngSubEventGuestsPage> createState() =>
      _ExisitngSubEventGuestsPageState();
}

class _ExisitngSubEventGuestsPageState
    extends State<ExisitngSubEventGuestsPage> {
  Set selectedList = {};
  Set existingGuests = {}; // this will hold guests which is new
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SubEventCubit>()
        ..getSubEventGuests(widget.mainEventId, widget.subEventId),
      child: BlocConsumer<SubEventCubit, SubEventState>(
        listener: (context, state) {
          if (state is SubEventGuestsLoaded) {
            existingGuests = state.subEventGuests.data?.invitedGuestList
                    ?.map((guest) => guest.id)
                    .toSet() ??
                [].toSet();
            selectedList = state.subEventGuests.data?.invitedGuestList
                    ?.map((guest) => guest.id)
                    .toSet() ??
                [].toSet();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Guests",
              ),
              centerTitle: true,
              automaticallyImplyLeading: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is SubEventGuestLoading)
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        child: const Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: CustomColors.bgLight,
                            ),
                          ),
                        ),
                      )
                    else if (state is SubEventFailure)
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        child: Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(
                              color: CustomColors.error,
                            ),
                          ),
                        ),
                      )
                    else if (state is SubEventGuestsLoaded)
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * .75,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Invitees header
                              Container(
                                height: 35,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: const BoxDecoration(
                                  color: CustomColors.ligthPrimary,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Invitees",
                                      style:
                                          CustomTypography.bodyLarge.copyWith(
                                        color: CustomColors.bgLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Invitees list
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (state.subEventGuests.data
                                            ?.invitedGuestList ??
                                        [])
                                    .length,
                                itemBuilder: (context, index) {
                                  final guest = state.subEventGuests.data
                                      ?.invitedGuestList?[index];
                                  final isSelected =
                                      selectedList.contains(guest?.id);
                                  return FamilyMember(
                                    name: guest?.subEventGuestList?.fullName ??
                                        "",
                                    isSelectable: true,
                                    selected: isSelected,
                                    onFamilySelected: (checked) {
                                      setState(() {
                                        if (!checked) {
                                          selectedList.remove(guest?.id);
                                        } else {
                                          selectedList.add(guest?.id);
                                        }
                                      });
                                    },
                                    onEdit: null,
                                    onDelete: null,
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              // Non Invitees header
                              Container(
                                height: 35,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: const BoxDecoration(
                                  color: CustomColors.ligthPrimary,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Non Invitees",
                                      style:
                                          CustomTypography.bodyLarge.copyWith(
                                        color: CustomColors.bgLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Non Invitees list
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (state.subEventGuests.data
                                            ?.nonInviteGuestList ??
                                        [])
                                    .length,
                                itemBuilder: (context, index) {
                                  final guest = state.subEventGuests.data
                                      ?.nonInviteGuestList?[index];
                                  final isSelected =
                                      selectedList.contains(guest?.id);
                                  return FamilyMember(
                                    name: guest?.fullName ??
                                        "",
                                    isSelectable: true,
                                    selected: isSelected,
                                    onFamilySelected: (checked) {
                                      setState(() {
                                        if (checked) {
                                          selectedList.add(guest?.id);
                                        } else {
                                          selectedList.remove(guest?.id);
                                        }
                                      });
                                    },
                                    onEdit: null,
                                    onDelete: null,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: () {
                        // send list excluding existing guests
                        final newGuests = selectedList
                            .where((id) => !existingGuests.contains(id))
                            .toSet();
                        log('guest list');
                        log(newGuests.toString());
                        Navigator.pop(context, newGuests);
                      },
                      text: "Continue",
                      isLoading: false,
                      height: 54,
                      width: double.infinity,
                    )
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

class FamilyMember extends StatelessWidget {
  final String name;
  final Function(bool)? onFamilySelected;
  final bool selected;
  final bool isSelectable;
  final bool? notViewImage;
  final Function? onEdit;
  final Function? onDelete;
  const FamilyMember(
      {super.key,
      required this.name,
      required this.onFamilySelected,
      required this.selected,
      required this.isSelectable,
      this.onEdit,
      this.onDelete,
      this.notViewImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            notViewImage == null
                ? Image.asset(
                    'assets/icons/person_vector.png',
                    height: 60,
                    width: 60,
                  )
                : const SizedBox(),
            const SizedBox(width: 8),
            Text(
              name,
              style: CustomTypography.bodyLarge.copyWith(
                color: CustomColors.bgLight,
              ),
            ),
          ],
        ),

        // edit button using ionicons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            onEdit != null && !isSelectable
                ? IconButton(
                    onPressed: () {
                      onEdit!();
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: CustomColors.bgLight,
                    ),
                  )
                : const SizedBox(),

            // delete button using ionicons

            onDelete != null && !isSelectable
                ? IconButton(
                    onPressed: () {
                      onDelete!();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: CustomColors.bgLight,
                    ),
                  )
                : const SizedBox(),

            // check box
            if (isSelectable)
              Checkbox(
                // don't remove the border when checked
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
                  onFamilySelected!(value!);
                },
                side: const BorderSide(
                  color: CustomColors.bgLight,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class GuestFamilies extends StatelessWidget {
  final String name;
  final Function(bool)? onFamilySelected;
  final bool selected;
  final bool? notViewImage;
  final Function? onEdit;
  final Function? onDelete;
  const GuestFamilies(
      {super.key,
      required this.name,
      required this.onFamilySelected,
      required this.selected,
      this.onEdit,
      this.onDelete,
      this.notViewImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          // don't remove the border when checked
          fillColor:
              WidgetStateProperty.all(CustomColors.bgLight.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(
              color: CustomColors.bgLight,
            ),
          ),
          value: selected,
          onChanged: (value) {
            onFamilySelected!(value!);
          },
          side: const BorderSide(
            color: CustomColors.bgLight,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          name,
          style: CustomTypography.bodyLarge.copyWith(
            color: CustomColors.bgLight,
          ),
        ),

        // edit button using ionicons
      ],
    );
  }
}
