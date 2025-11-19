import 'dart:developer';

import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/widgets/custom_button.dart';
import 'package:aayojan/features/guest/data/model/guest_model.dart';
import 'package:aayojan/features/guest/data/model/sub_event_guest_model.dart';
import 'package:aayojan/features/guest/presentation/bloc/guest_cubit.dart';
import 'package:aayojan/features/guest/presentation/bloc/guest_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SubEventGuestsPage extends StatefulWidget {
  static const String routeName = '/family-list';
  final String category;
  final String id;
  const SubEventGuestsPage(
      {super.key, required this.category, required this.id});

  @override
  State<SubEventGuestsPage> createState() => _SubEventGuestsPageState();
}

class _SubEventGuestsPageState extends State<SubEventGuestsPage> {
  bool familySelected = false;
  List<EventData> guestList = [];
  List selectedList = [];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GuestCubit>()..getEventGuests(widget.id),
      child: BlocConsumer<GuestCubit, GuestState>(
        listener: (context, state) {
          if (state is EventGuestsLoaded) {
            guestList = state.guest.data ?? [];
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Guest List",
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
                    CustomTextField(
                      isObscure: false,
                      headerText: '',
                      prefix: Container(
                        margin: const EdgeInsets.only(left: 16, right: 8),
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          height: 32,
                          width: 32,
                          color: CustomColors.bgLight,
                        ),
                      ),
                      fillColor: Colors.black.withOpacity(0.4),
                      hintText: "Search guests",
                      controller: searchController,
                      onChanged: (value) {
                        // search for the guest
                        context.read<GuestCubit>().searchGuests(value);
                      },
                    ),
                    Row(
                      children: [
                        Checkbox(
                          fillColor: WidgetStateProperty.all(
                              CustomColors.bgLight.withOpacity(0.2)),
                          value: familySelected,
                          onChanged: (value) {
                            setState(() {
                              familySelected = value!;
                              if (value) {
                                selectedList = guestList
                                    .map((e) => e.id.toString())
                                    .toList();
                              } else {
                                selectedList = [];
                              }
                            });
                          },
                          side: const BorderSide(
                            color: CustomColors.bgLight,
                          ),
                        ),
                        Text(
                          'Select All',
                          style: CustomTypography.bodyLarge.copyWith(
                            color: CustomColors.bgLight,
                          ),
                        ),
                      ],
                    ),
                    state is GuestLoading
                        ? SizedBox(
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
                        : // family members
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height * .65,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: guestList.length,
                              itemBuilder: (context, index) {
                                return FamilyMember(
                                  name: guestList[index].fullName ?? "",
                                  selected: selectedList
                                      .contains(guestList[index].id.toString()),
                                  onFamilySelected: (value) {
                                    // add it on selected lists
                                    setState(
                                      () {
                                        if (selectedList.contains(
                                            guestList[index].id.toString())) {
                                          selectedList.remove(
                                              guestList[index].id.toString());
                                        } else {
                                          selectedList.add(
                                              guestList[index].id.toString());
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(context, selectedList);
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
  const FamilyMember({
    super.key,
    required this.name,
    required this.onFamilySelected,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/icons/person_vector.png',
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: CustomTypography.bodyLarge.copyWith(
                color: CustomColors.bgLight,
              ),
            ),
          ],
        ),

        // check box
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
      ],
    );
  }
}
