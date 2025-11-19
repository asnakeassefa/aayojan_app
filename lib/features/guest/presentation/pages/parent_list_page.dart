import 'dart:developer';

import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/widgets/custom_button.dart';
import 'package:aayojan/features/guest/data/model/guest_model.dart';
import 'package:aayojan/features/guest/presentation/bloc/guest_cubit.dart';
import 'package:aayojan/features/guest/presentation/bloc/guest_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'add_guest_page.dart';

class FamilyListPage extends StatefulWidget {
  static const String routeName = '/family-list';
  final String category;
  final bool? isForEvent;
  final int? id;

  const FamilyListPage(
      {super.key, required this.category, this.isForEvent, this.id});

  @override
  State<FamilyListPage> createState() => _FamilyListPageState();
}

class _FamilyListPageState extends State<FamilyListPage> {
  bool familySelected = false;
  List<Guest> guestList = [];
  Set selectedList = {};
  Set existingGuests = {}; // this will hold guests which is new
  List nonInvitees = [];
  Map<String, String> guestUserIdMap = {};
  Set selectedFamily = {};
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GuestCubit>()..getGuests(widget.id),
      child: BlocConsumer<GuestCubit, GuestState>(
        listener: (context, state) {
          if (state is GuestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.success,
              ),
            );
            context.read<GuestCubit>().getGuests(widget.id);
          }

          if (state is GuestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.error,
              ),
            );
          }

          if (state is GuestLoaded) {
            guestList = [];
            selectedList = {};
            nonInvitees = [];

            if (state.guestList != null) {
              // Assuming state.guestList.data is a List<Guest> and you want their IDs
              selectedList =
                  state.guestList?.data?.map((e) => e.id).toSet() ?? {};
              existingGuests = Set.from(selectedList);
            }

            // --- Dynamic Approach Starts Here ---
            final Map<String, List<Guest>>? allGuestCategories =
                state.guest.data?.guestCategories;

            if (allGuestCategories != null && widget.category != null) {
              // Get the list of guests for the current widget.category
              List<Guest>? categoryGuests = allGuestCategories[widget.category];

              if (categoryGuests != null) {
                // add all to guestUserId map
                guestUserIdMap = {
                  for (var guest in categoryGuests)
                    guest.id.toString(): guest.userId.toString()
                };
                guestList = categoryGuests
                    .where((element) => selectedList.contains(element.id))
                    .toList();

                nonInvitees = categoryGuests
                    .where((element) => !selectedList.contains(element.id))
                    .toList();

                log('${widget.category}: ${guestList.length}'); // Dynamic logging
              } else {
                // Handle the case where the category from widget.category doesn't exist
                // in the fetched data. You might want to log this or display a message.
                log('Warning: Category "${widget.category}" not found in guest data.');
              }
            }

            // --- Dynamic Approach for 'All' category ---
            // This section should now iterate through all available categories dynamically
            if (widget.category == 'All') {
              guestList = []; // Reset guestList for 'All'
              if (allGuestCategories != null) {
                allGuestCategories.forEach((categoryName, guests) {
                  guestList.addAll(
                      guests); // Add all guests from each dynamic category
                });
              }
              // For 'All' category, you might want to consider how 'nonInvitees' should behave.
              // If 'nonInvitees' means guests not selected across ALL categories, you'd calculate it here.
              // For simplicity, I'm omitting a complex 'nonInvitees' calculation for 'All' here.
              // You'd likely re-filter the combined guestList for 'All' for selected/non-selected.
              // Example for 'All' nonInvitees:
              nonInvitees = guestList
                  .where((element) => !selectedList.contains(element.id))
                  .toList();
              guestList = guestList
                  .where((element) => selectedList.contains(element.id))
                  .toList();
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "${widget.category} Family",
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
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       fillColor: WidgetStateProperty.all(
                    //           CustomColors.bgLight.withOpacity(0.2)),
                    //       value: familySelected,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           familySelected = value!;
                    //           if (value) {
                    //             selectedList = guestList
                    //                 .map((e) => e.id.toString())
                    //                 .toList();
                    //           } else {
                    //             selectedList = [];
                    //           }
                    //         });
                    //       },
                    //       side: const BorderSide(
                    //         color: CustomColors.bgLight,
                    //       ),
                    //     ),
                    //     Text(
                    //       'Select All',
                    //       style: CustomTypography.bodyLarge.copyWith(
                    //         color: CustomColors.bgLight,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    state is GuestLoading
                        ? SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.8,
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
                            child: Column(
                              children: [
                                // add container with bg color and says inviteees
                                widget.id != null
                                    ? Container(
                                        height: 35,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: CustomColors.ligthPrimary,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Invitees",
                                              style: CustomTypography.bodyLarge
                                                  .copyWith(
                                                color: CustomColors.bgLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 8,
                                ),
                                if (guestList.isEmpty &&
                                    nonInvitees.isEmpty &&
                                    existingGuests.isEmpty &&
                                    selectedList.isEmpty)
                                  // show center message that says not guest found
                                  Center(
                                    child: Text(
                                      'No guests found',
                                      style:
                                          CustomTypography.bodyLarge.copyWith(
                                        color: CustomColors.bgLight,
                                      ),
                                    ),
                                  ),
                                if (guestList.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: guestList.length,
                                    itemBuilder: (context, index) {
                                      return FamilyMember(
                                        name: guestList[index].fullName ?? "",
                                        isSelectable: widget.isForEvent == true,
                                        selected: true,
                                        onDelete: () {
                                          // show a dialog to confirm the delete
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Delete Guest'),
                                                content: const Text(
                                                    'Are you sure you want to delete this guest?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      // delete the family member
                                                      // context
                                                      //     .read<GuestCubit>()
                                                      //     .deleteGuest(
                                                      //         guestList[index]
                                                      //             .id
                                                      //             .toString());

                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).then((value) {
                                            if (value) {
                                              context
                                                  .read<GuestCubit>()
                                                  .deleteGuest(guestList[index]
                                                      .id
                                                      .toString());
                                            }
                                          });
                                        },
                                        onEdit: () {
                                          // edit the family member
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return AddGuestPage(
                                                id: guestList[index]
                                                    .id
                                                    .toString(),
                                                isEdit: true,
                                              );
                                            },
                                          ));
                                        },
                                        onFamilySelected: (value) {
                                          // add it on selected lists
                                          setState(
                                            () {
                                              final temp = guestList[index];
                                              guestList
                                                  .remove(guestList[index]);
                                              nonInvitees.add(temp);
                                              selectedList.remove(temp.id);
                                              // this dialog box will allow user to select family members and register only the count
                                              // showDialog(
                                              //   context: context,
                                              //   builder: (context) {
                                              //     return Dialog(
                                              //       backgroundColor:
                                              //           CustomColors.primary,
                                              //       child: Container(
                                              //         constraints: BoxConstraints(
                                              //           maxWidth:
                                              //               MediaQuery.of(context)
                                              //                       .size
                                              //                       .width *
                                              //                   0.9,
                                              //           minWidth:
                                              //               MediaQuery.of(context)
                                              //                       .size
                                              //                       .width *
                                              //                   0.9,
                                              //           maxHeight:
                                              //               MediaQuery.of(context)
                                              //                       .size
                                              //                       .height *
                                              //                   0.5,
                                              //           minHeight:
                                              //               MediaQuery.of(context)
                                              //                       .size
                                              //                       .height *
                                              //                   0.2,
                                              //         ),
                                              //         padding:
                                              //             const EdgeInsets.all(16),
                                              //         child: Column(
                                              //           mainAxisSize:
                                              //               MainAxisSize.min,
                                              //           crossAxisAlignment:
                                              //               CrossAxisAlignment
                                              //                   .start,
                                              //           children: [
                                              //             Text(
                                              //               'Choose Your Family Member',
                                              //               style: CustomTypography
                                              //                   .headLineLarge
                                              //                   .copyWith(
                                              //                 color: CustomColors
                                              //                     .bgLight,
                                              //               ),
                                              //             ),
                                              //             const SizedBox(
                                              //                 height: 16),
                                              //             GuestFamilies(
                                              //               name: 'User 1',
                                              //               onFamilySelected:
                                              //                   (selected) {},
                                              //               selected: false,
                                              //               notViewImage: false,
                                              //             ),
                                              //             const SizedBox(height: 8),
                                              //             GuestFamilies(
                                              //               name: 'User 2',
                                              //               onFamilySelected:
                                              //                   (selected) {},
                                              //               selected: false,
                                              //               notViewImage: false,
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //     );
                                              //   },
                                              // );

                                              // before
                                              // showDialog(
                                              // context: context,
                                              // builder: (context) {
                                              //   return AlertDialog(
                                              //   title: const Text('Family Member Details'),
                                              //   content: BlocProvider(
                                              //   create: (context) => getIt<GuestCubit>()..getFamilyByGuestId(guestList[index].id.toString()),
                                              //   child: BlocBuilder<GuestCubit, GuestState>(
                                              //   builder: (context, state) {
                                              //     if (state is GuestLoading) {
                                              //     return const Center(
                                              //     child: CircularProgressIndicator(),
                                              //     );
                                              //     } else if (state is FamilyLoaded) {
                                              //     final familyMembers = state.familyMembers;
                                              //     return Column(
                                              //     mainAxisSize: MainAxisSize.min,
                                              //     children: familyMembers.map((member) => Text('Name: ${member.fullName}')).toList(),
                                              //     );
                                              //     } else if (state is GuestFailure) {
                                              //     return Text('Error: ${state.message}');
                                              //     } else {
                                              //     return const Text('No data available');
                                              //     }
                                              //   },
                                              //   ),
                                              //   ),
                                              //   actions: [
                                              //   TextButton(
                                              //   onPressed: () {
                                              //     Navigator.pop(context);
                                              //   },
                                              //   child: const Text('Close'),
                                              //   ),
                                              //   ],
                                              //   );
                                              // },
                                              // );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                // add container with bg color and says non invitees
                                widget.id != null
                                    ? Container(
                                        height: 35,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: const BoxDecoration(
                                          color: CustomColors.ligthPrimary,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Non Invitees",
                                              style: CustomTypography.bodyLarge
                                                  .copyWith(
                                                color: CustomColors.bgLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),

                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: nonInvitees.length,
                                  itemBuilder: (context, index) {
                                    return FamilyMember(
                                      name: nonInvitees[index].fullName ?? "",
                                      isSelectable: widget.isForEvent == true,
                                      selected: false,
                                      onDelete: () {
                                        // show a dialog to confirm the delete
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Delete Guest'),
                                              content: const Text(
                                                  'Are you sure you want to delete this guest?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // delete the family member
                                                    // context
                                                    //     .read<GuestCubit>()
                                                    //     .deleteGuest(
                                                    //         guestList[index]
                                                    //             .id
                                                    //             .toString());

                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((value) {
                                          if (value) {
                                            context
                                                .read<GuestCubit>()
                                                .deleteGuest(nonInvitees[index]
                                                    .id
                                                    .toString());
                                          }
                                        });
                                      },
                                      onEdit: () {
                                        // edit the family member
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return AddGuestPage(
                                              id: nonInvitees[index]
                                                  .id
                                                  .toString(),
                                              isEdit: true,
                                            );
                                          },
                                        ));
                                      },
                                      onFamilySelected: (value) {
                                        // add it on selected lists
                                        log('in here ');
                                        setState(
                                          () {
                                            final temp = nonInvitees[index];
                                            final userId = guestUserIdMap[
                                                temp.id.toString()];
                                            nonInvitees
                                                .remove(nonInvitees[index]);
                                            guestList.add(temp);
                                            selectedList
                                                .add(temp.id.toString());
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return BlocProvider(
                                                  create: (context) => getIt<
                                                      GuestCubit>()
                                                    ..getFamilyMembers(userId
                                                        .toString()), // Initialize and call the cubit
                                                  child: StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          CustomColors.primary,
                                                      child: Container(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          minWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          maxHeight:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.5,
                                                          minHeight:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.2,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Choose Your Family Member',
                                                              style: CustomTypography
                                                                  .headLineLarge
                                                                  .copyWith(
                                                                color:
                                                                    CustomColors
                                                                        .bgLight,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 16),
                                                            Expanded(
                                                              // Use Expanded to allow the list to take available space
                                                              child: BlocBuilder<
                                                                  GuestCubit,
                                                                  GuestState>(
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                                  if (state
                                                                      is FamilyMembersLoading) {
                                                                    return const Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: CustomColors
                                                                            .bgLight,
                                                                      ),
                                                                    );
                                                                  } else if (state
                                                                      is FamilyMembersLoaded) {
                                                                    if (state
                                                                            .familyModel
                                                                            .data
                                                                            ?.isEmpty ??
                                                                        false) {
                                                                      return const Center(
                                                                        child:
                                                                            Text(
                                                                          'No family members found.',
                                                                          style:
                                                                              TextStyle(color: CustomColors.bgLight),
                                                                        ),
                                                                      );
                                                                    }
                                                                    return ListView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true, // Important for ListView inside Column
                                                                      itemCount: state
                                                                          .familyModel
                                                                          .data
                                                                          ?.length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        final familyMember = state
                                                                            .familyModel
                                                                            .data
                                                                            ?.first
                                                                            .members?[index];
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 8.0),
                                                                          child:
                                                                              GuestFamilies(
                                                                            name:
                                                                                '${familyMember?.firstName ?? ''} ${familyMember?.lastName ?? ''}',
                                                                            onFamilySelected:
                                                                                (selected) {
                                                                              setState(() {
                                                                                final id = familyMember?.id.toString() ?? '';
                                                                                if (selectedFamily.contains(id)) {
                                                                                  selectedFamily.remove(id);
                                                                                } else {
                                                                                  selectedFamily.add(id);
                                                                                }
                                                                              });
                                                                            },
                                                                            selected:
                                                                                selectedFamily.contains(familyMember?.id.toString() ?? ''),
                                                                            notViewImage:
                                                                                false,
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  } else if (state
                                                                      is FamilyMembersFailure) {
                                                                    return Center(
                                                                      child:
                                                                          Text(
                                                                        'Error: ${state.message}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                CustomColors.error),
                                                                      ),
                                                                    );
                                                                  }
                                                                  return const SizedBox
                                                                      .shrink(); // Initial or unhandled state
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              },
                                            );

                                            // before
                                            // showDialog(
                                            // context: context,
                                            // builder: (context) {
                                            //   return AlertDialog(
                                            //   title: const Text('Family Member Details'),
                                            //   content: BlocProvider(
                                            //   create: (context) => getIt<GuestCubit>()..getFamilyByGuestId(guestList[index].id.toString()),
                                            //   child: BlocBuilder<GuestCubit, GuestState>(
                                            //   builder: (context, state) {
                                            //     if (state is GuestLoading) {
                                            //     return const Center(
                                            //     child: CircularProgressIndicator(),
                                            //     );
                                            //     } else if (state is FamilyLoaded) {
                                            //     final familyMembers = state.familyMembers;
                                            //     return Column(
                                            //     mainAxisSize: MainAxisSize.min,
                                            //     children: familyMembers.map((member) => Text('Name: ${member.fullName}')).toList(),
                                            //     );
                                            //     } else if (state is GuestFailure) {
                                            //     return Text('Error: ${state.message}');
                                            //     } else {
                                            //     return const Text('No data available');
                                            //     }
                                            //   },
                                            //   ),
                                            //   ),
                                            //   actions: [
                                            //   TextButton(
                                            //   onPressed: () {
                                            //     Navigator.pop(context);
                                            //   },
                                            //   child: const Text('Close'),
                                            //   ),
                                            //   ],
                                            //   );
                                            // },
                                            // );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 16),
                    if (widget.isForEvent == true)
                      CustomButton(
                        onPressed: () {
                          // send list excluding existing guests
                          final newGuests = selectedList
                              .where((id) => !existingGuests.contains(id))
                              .toSet();
                          Navigator.pop(context, [newGuests,selectedFamily]);
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
