import 'dart:developer';

import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/widgets/custom_button2.dart';
import 'package:aayojan/features/guest/presentation/bloc/guest_cubit.dart';
import 'package:aayojan/features/guest/presentation/bloc/guest_state.dart';
import 'package:aayojan/features/guest/presentation/pages/add_guest_page.dart';
import 'package:aayojan/features/guest/presentation/pages/parent_list_page.dart';
import 'package:aayojan/features/guest/presentation/pages/upload_file_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/model/guest_model.dart'; // Make sure this path is correct for your updated GuestModel

class GuestPage extends StatefulWidget {
  static const routeName = '/guest_page';
  final bool? isForEvent;
  final int? eventId;
  const GuestPage({super.key, this.isForEvent, this.eventId});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  // Use a List<String> to maintain order if desired, otherwise Set<String> is fine.
  // We'll clear it and add new keys on each load.
  List<String> keys = [];
  TextEditingController searchController = TextEditingController();
  Set selectedGuests = {}; // Store IDs of selected guests
  Set selectedFamily = {}; // Track selected family count

  @override
  void initState() {
    super.initState();
    // Initialize search controller listener if needed
    // searchController.addListener(() {
    //   context.read<GuestCubit>().searchGuests(searchController.text);
    // });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GuestCubit>()..getGuests(widget.eventId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Guests'),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: BlocConsumer<GuestCubit, GuestState>(
          listener: (context, state) {
            if (state is GuestLoaded) {
              // Clear keys to prevent duplicates on subsequent loads
              keys.clear();
              final Map<String, List<Guest>>? categories =
                  state.guest.data?.guestCategories;

              if (categories != null) {
                // Get all the keys (category names) from the map
                // Ensure unique keys, though `categories.keys` already provides unique ones.
                keys.addAll(categories.keys.toList());
              }
              // Force a rebuild to reflect the new keys in the UI
              setState(() {});
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomTextField(
                        isObscure: false,
                        headerText: '',
                        hintText: "Search Guests",
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
                        controller: searchController,
                        onChanged: (value) {
                          // Trigger search within the Cubit.
                          // The GuestLoaded state should then ideally provide
                          // filtered guests if search is done on the client side.
                          // If search is server-side, you'll need a new API call here.
                          context.read<GuestCubit>().searchGuests(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state is GuestLoading)
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * .7,
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
                    if (state is! GuestLoading)
                      SizedBox(
                        // Reduced height slightly to accommodate the "Select Guests" text or buttons
                        height: widget.isForEvent == null
                            ? MediaQuery.sizeOf(context).height * .8
                            : MediaQuery.sizeOf(context).height * .7,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (widget.isForEvent == true)
                                const Text(
                                  'Select Guests',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.bgLight,
                                  ),
                                ),
                              if (widget.isForEvent == null)
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 40,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      CustomButtonOut(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                                  AddGuestPage.routeName)
                                              .then((value) {
                                            if (value == true) {
                                              // Refresh guests after adding
                                              context
                                                  .read<GuestCubit>()
                                                  .getGuests(widget.eventId);
                                            }
                                          });
                                        },
                                        content: const Text(
                                          'Add Manually',
                                          style: TextStyle(
                                              color: CustomColors.bgLight),
                                        ),
                                        isLoading: false,
                                        backgroundColor: CustomColors.primary,
                                        borderColor: CustomColors.bgLight,
                                        height: 40,
                                        width: 120,
                                      ),
                                      const SizedBox(width: 8),
                                      CustomButtonOut(
                                          onPressed: () {
                                            // TODO: Implement Existing List functionality
                                          },
                                          content: const Text(
                                            'Existing List',
                                            style: TextStyle(
                                                color: CustomColors.bgLight),
                                          ),
                                          isLoading: false,
                                          backgroundColor:
                                              CustomColors.ligthPrimary,
                                          borderColor: CustomColors.bgLight,
                                          height: 40,
                                          width: 150),
                                      const SizedBox(width: 8),
                                      CustomButtonOut(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                    UploadFilePage.routeName)
                                                .then((value) {
                                              if (value == true) {
                                                // Refresh guests after upload
                                                context
                                                    .read<GuestCubit>()
                                                    .getGuests(widget.eventId);
                                              }
                                            });
                                          },
                                          content: const Text(
                                            'Upload CSV',
                                            style: TextStyle(
                                                color: CustomColors.bgLight),
                                          ),
                                          backgroundColor: CustomColors.primary,
                                          borderColor: CustomColors.bgLight,
                                          isLoading: false,
                                          height: 40,
                                          width: 120),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 8),
                              // Display message if no guests or categories are loaded
                              if (keys.isEmpty && state is GuestLoaded)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '“No Guest Categories Added”',
                                          style: CustomTypography.bodyLarge
                                              .copyWith(
                                            color: CustomColors.bgLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              .4, // Adjusted height
                                      width: MediaQuery.sizeOf(context).width,
                                      child: Center(
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            maxHeight: 180,
                                            maxWidth: 180,
                                          ),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(40),
                                            ),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  'assets/images/logo.png',
                                                ),
                                                opacity: 0.5,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              // Display dynamic category boxes if keys are available
                              if (keys.isNotEmpty)
                                // Wrap is better than ListView for wrapping items
                                // with dynamic width/height and responsive layout.
                                Center(
                                  child: Wrap(
                                    spacing:
                                        24.0, // Horizontal space between boxes
                                    runSpacing:
                                        16.0, // Vertical space between rows of boxes
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: keys.map((categoryName) {
                                      // Replace underscores with spaces and capitalize for display
                                      String displayName =
                                          categoryName.replaceAll('_', ' ');
                                      displayName =
                                          displayName[0].toUpperCase() +
                                              displayName.substring(1);

                                      return FamilyBox(
                                        title:
                                            displayName, // Display the formatted category name
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return FamilyListPage(
                                                  isForEvent: widget.isForEvent,
                                                  category:
                                                      categoryName, // Pass the actual category key
                                                  id: widget.eventId,
                                                );
                                              },
                                            ),
                                          ).then((value) {
                                            log(value.toString());
                                            if (value != null && value[0] is Set) {
                                              setState(() {
                                                // Assuming value returned is a Set of IDs
                                                selectedGuests.addAll(value[0]);
                                                selectedFamily.addAll(value[1]);
                                              });
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (widget.isForEvent == true)
                      CustomButton(
                        onPressed: () {
                          // Navigate back, passing the set of selected guest IDs
                          Navigator.pop(context, [selectedGuests, selectedFamily]);
                        },
                        text: "Continue with ${selectedGuests.length + selectedFamily.length} Guests",
                        isLoading: false,
                        height: 54,
                        width: double.infinity,
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Ensure FamilyBox is also defined or imported correctly
class FamilyBox extends StatelessWidget {
  final String title;
  final Function onPressed;
  const FamilyBox({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Using InkWell for better tap feedback than IconButton here
      onTap: () {
        onPressed();
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: CustomColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.sizeOf(context).width * .38,
            height: 150,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/icons/person_vector.png',
                      height: 70,
                      width: 70,
                    ),
                    Image.asset(
                      'assets/icons/person_vector.png',
                      height: 70,
                      width: 70,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/icons/person_vector.png',
                      height: 70,
                      width: 70,
                    ),
                    Image.asset(
                      'assets/icons/person_vector.png',
                      height: 70,
                      width: 70,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: CustomTypography.bodyLarge
                .copyWith(color: CustomColors.bgLight),
          )
        ],
      ),
    );
  }
}
