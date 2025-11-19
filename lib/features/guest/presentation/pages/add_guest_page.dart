import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/utility/constants.dart';
import '../../../../core/utility/image_picker.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dropdown_button.dart';
import '../../../../core/widgets/custom_image_picker.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/type_ahead.dart';
import '../../../manage_family/presentation/pages/familiy_member_page.dart';
import '../bloc/guest_cubit.dart';
import '../bloc/guest_state.dart';
import 'parent_list_page.dart';

class AddGuestPage extends StatefulWidget {
  static const routeName = '/add_guest_page';
  final bool? isEdit;
  final String? id;
  const AddGuestPage({super.key, this.isEdit, this.id});

  @override
  State<AddGuestPage> createState() => _AddGuestPageState();
}

class _AddGuestPageState extends State<AddGuestPage> {
  String filePath = "";
  String profileImage = "";
  int? tempCityId;
  List<DropdownMenuItem> relation = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "Relation",
        color: CustomColors.info,
      ),
    )
  ];
  List<DropdownMenuItem> states = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "State",
        color: CustomColors.info,
      ),
    )
  ];
  List<DropdownMenuItem> city = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "City",
        color: CustomColors.info,
      ),
    )
  ];

  List<DropdownMenuItem> category = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "Category",
        color: CustomColors.info,
      ),
    )
  ];

  // list all text editing contorller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  final TextEditingController samajController = TextEditingController();

  int? categoryVal = -1;
  int religionVal = 1;
  int communityVal = 1;
  int relationId = -1;
  int stateVal = -1;
  int cityVal = -1;
  String samajVal = "";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GuestCubit>()..getRelations(),
      child: BlocConsumer<GuestCubit, GuestState>(
        listener: (context, state) {
          FocusScope.of(context).unfocus();
          if (state is GuestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.error,
              ),
            );
          }

          if (state is RelationLoaded) {
            // final newRelation = state..data
            //         ?.map(
            //           (e) => DropdownMenuItem(
            //             value: e.id,
            //             child: CustomText(e.name ?? ""),
            //           ),
            //         )
            //         .toList() ??
            //     [];

            // relation = [
            //   const DropdownMenuItem(
            //     value: -1,
            //     child: CustomText(
            //       "Relation",
            //       color: CustomColors.info,
            //     ),
            //   ),
            //   ...newRelation
            // ];

            // final newReligion = state.religion.data
            //         ?.map(
            //           (e) => DropdownMenuItem(
            //             value: e.id,
            //             child: CustomText(e.title ?? ""),
            //           ),
            //         )
            //         .toList() ??
            //     [];

            // religion = [
            //   const DropdownMenuItem(
            //     value: -1,
            //     child: CustomText(
            //       "Religion",
            //       color: CustomColors.info,
            //     ),
            //   ),
            //   ...newReligion
            // ];

            final newState = state.state.data
                    ?.map(
                      (e) => DropdownMenuItem(
                        value: e.id,
                        child: CustomText(e.name ?? ""),
                      ),
                    )
                    .toList() ??
                [];
            if (newState.map((e) => e.value).toList().contains(stateVal)) {
              context.read<GuestCubit>().getCity(stateVal.toString());
            }
            states = [
              const DropdownMenuItem(
                value: -1,
                child: CustomText(
                  "State",
                  color: CustomColors.info,
                ),
              ),
              ...newState
            ];

            final newCategory = state.catagory.data
                    ?.map(
                      (e) => DropdownMenuItem(
                        value: e.id,
                        child: CustomText(e.name ?? ""),
                      ),
                    )
                    .toList() ??
                [];

            category = [
              const DropdownMenuItem(
                value: -1,
                child: CustomText(
                  "Category",
                  color: CustomColors.info,
                ),
              ),
              ...newCategory
            ];
            if (widget.isEdit == true && widget.id != null) {
              // Add a small delay to ensure states are properly set
              log('here in add guest page');
              Future.delayed(const Duration(milliseconds: 100), () {
                context.read<GuestCubit>().getGuest(widget.id.toString());
              });
            }
          }

          if (state is CityLoaded) {
            setState(() {
              final newCities = state.city.data
                      ?.map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: CustomText(e.name ?? ""),
                        ),
                      )
                      .toList() ??
                  [];
              if (newCities.map((e) => e.value).toList().contains(cityVal)) {
                setState(() {
                  cityVal = cityVal;
                });
              } else {
                cityVal = -1;
              }
              city = [
                const DropdownMenuItem(
                  value: -1,
                  child: CustomText(
                    "City",
                    color: CustomColors.info,
                  ),
                ),
                ...newCities
              ];

              if (tempCityId != null &&
                  newCities.map((e) => e.value).contains(tempCityId)) {
                cityVal = tempCityId!;
                tempCityId = null; // Clear the temporary ID
              }
            });
          }

          if (state is GuestSingleLoaded) {
            log('here in guest single loaded');

            final guest = state.guest.data;
            nameController.text = guest?.fullName ?? "";
            ageController.text = guest?.age.toString() ?? "";
            phoneController.text = guest?.phoneNumber ?? "";
            
            altPhoneController.text = guest?.alternatePhoneNumber ?? "";
            samajController.text = guest?.samaj ?? "";
            religionVal = guest?.religionId ?? -1;
            communityVal = guest?.communityId ?? -1;
            final guestCityId = guest?.cityId;

            log(religionVal.toString());
            log(communityVal.toString());

            // try {
            //   final comVal = guest?.communityId as int;
            //   if (city.map((e) => e.value).toList().contains(comVal)) {
            //     communityVal = comVal;
            //   }
            // } catch (e) {
            //   log(e.toString());
            //   communityVal = -1;
            // }

            // try {
            //   final relVal = guest?.religionId as int;
            //   if (religion.map((e) => e.value).contains(relVal)) {
            //     religionVal = relVal;
            //   }
            // } catch (e) {
            //   log(e.toString());
            //   religionVal = -1;
            // }

            // categoryVal = guest?.relationCategoryId as int;
            try {
              final rela = guest?.relationId ?? -1;
              if (relation.map((e) => e.value).contains(rela)) {
                relationId = rela;
              }
            } catch (e) {
              // log(e.toString());
              relationId = -1;
            }

            try {
              final remoteState = guest?.stateId ?? -1;
              if (states.map((e) => e.value).contains(remoteState)) {
                log('remoteState $remoteState');
                setState(() {
                  stateVal = remoteState;
                  // Reset city when state changes
                  cityVal = -1;
                  city = [
                    const DropdownMenuItem(
                      value: -1,
                      child: CustomText(
                        "City",
                        color: CustomColors.info,
                      ),
                    )
                  ];
                });
                // Store the city ID to be set after cities are loaded
                tempCityId = guestCityId;
                // Load cities for the state
                log('before get city');
                context.read<GuestCubit>().getCity(remoteState.toString());
              }
            } catch (e) {
              log(e.toString());
              setState(() {
                stateVal = -1;
                cityVal = -1;
                tempCityId = null;
              });
            }

            // try {
            //   final remoteState = guest?.stateId as int;
            //   if (states.map((e) => e.value).contains(remoteState)) {
            //     stateVal = remoteState;
            //   }
            //   // call city cubit
            // } catch (e) {
            //   log(e.toString());
            //   stateVal = -1;
            // }

            // try {
            //   final remoteCity = guest?.cityId as int;
            //   if (city.map((e) => e.value).contains(remoteCity)) {
            //     setState(() {
            //       cityVal = remoteCity;
            //     });
            //   }
            // } catch (e) {
            //   log(e.toString());
            //   cityVal = -1;
            // }

            try {
              final cata = guest?.relationCategoryId as int;
              if (category.map((e) => e.value).contains(cata)) {
                categoryVal = cata;
              }
            } catch (e) {
              // log(e.toString());
              categoryVal = -1;
            }

            log('here in guest single loaded');
            // communityVal = guest?. as int;
            // religionVal = guest?.casteId as int;
            // if stateVal is in states then call get city
            if (stateVal != -1) {
              log('stateVal $stateVal');
              context.read<GuestCubit>().getCity(stateVal.toString());
            }
          }

          if (state is GuestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.success,
              ),
            );
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: widget.isEdit != null && widget.isEdit == true
                    ? const Text('Edit Guest')
                    : const Text('Add Guests Manually'),
                centerTitle: true,
                automaticallyImplyLeading: true,
              ),
              // if (state is SingleGuestLoading) {
              //   bottomSheet: Text('fetching event....'),
              // }

              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // Container(
                        //   color: Colors.black.withOpacity(0.3),
                        //   padding: const EdgeInsets.symmetric(horizontal: 24),
                        //   height: 50,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Family Members',
                        //         style: CustomTypography.bodyLarge
                        //             .copyWith(color: CustomColors.bgLight),
                        //       ),
                        //       CustomButton(
                        //         onPressed: () {
                        //           Navigator.pushNamed(
                        //               context, FamiliyMemberPage.routeName);
                        //         },
                        //         text: 'View',
                        //         isLoading: false,
                        //         height: 32,
                        //         width: 90,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 32),
                        // ProfileImagePicker(
                        //     filePath: filePath,
                        //     imageUrl: profileImage,
                        //     onPressed: () async {
                        //       final file = await imagePicker();
                        //       setState(() {
                        //         filePath = file;
                        //       });
                        //     }),
                        // const SizedBox(height: 16),
                        CustomTextField(
                          isObscure: false,
                          headerText: "",
                          hintText: "Full Name *",
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z ]')),
                          ],
                          maxLength: 30,
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter full name.";
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          isObscure: false,
                          headerText: "",
                          keyboardType: TextInputType.number,
                          hintText: "Age *",
                          maxLength: 3,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: ageController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Age cannot be empty";
                            }
                            // if age is < 18 then show error
                            if (int.parse(value) < 18) {
                              return "Age must be greater than 18";
                            }
                            return null;
                          },
                        ),
                        CustomDropdownButton(
                          title: 'Category *',
                          items: category,
                          initVal: categoryVal,
                          onChanged: (value) {
                            (categoryVal = value);
                          },
                          validator: (value) {
                            if (categoryVal == -1 || categoryVal == null) {
                              return "Category cannot be empty";
                            }
                            return null;
                          },
                        ),
                        // const SizedBox(height: 8),
                        // CustomDropdownButton(
                        //   title: 'Relation',
                        //   items: relation,
                        //   initVal: relationId,
                        //   onChanged: (value) {
                        //     relationId = 1;
                        //   },
                        // ),
                        const SizedBox(height: 8),
                        // CustomTextField(
                        //   isObscure: false,
                        //   headerText: "",
                        //   hintText: "Contact Number *",
                        //   inputFormatter: [
                        //     FilteringTextInputFormatter.digitsOnly,
                        //   ],
                        //   maxLength: 10,
                        //   keyboardType: TextInputType.phone,
                        //   controller: phoneController,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return "Contact number cannot be empty";
                        //     }
                        //     return null;
                        //   },
                        // ),

                        CustomTypeAhead(
                          phoneController: phoneController,
                          onSelected: (user) {
                            nameController.text =
                                '${user.firstName ?? ''} ${user.lastName ?? ''}';
                            ageController.text = user.age.toString();
                            phoneController.text = user.phone ?? "";
                            altPhoneController.text = user.alternatePhone ?? "";
                            samajController.text = user.samaj ?? "";

                            if (user.stateId != null &&
                                states
                                    .map((e) => e.value)
                                    .contains(user.stateId)) {
                              stateVal = user.stateId ?? -1;
                              tempCityId = user.cityId;
                              // cityVal = -1;
                              city = [
                                const DropdownMenuItem(
                                  value: -1,
                                  child: CustomText(
                                    "City",
                                    color: CustomColors.info,
                                  ),
                                )
                              ];
                              context
                                  .read<GuestCubit>()
                                  .getCity(stateVal.toString());
                            } else {
                              stateVal = -1;
                              tempCityId = null;
                            }

                            // if (user.cityId != null &&
                            //     city
                            //         .map((e) => e.value)
                            //         .contains(user.cityId)) {
                            //   cityVal = user.cityId ?? -1;
                            // } else {
                            //   cityVal = -1;
                            // }
                          },
                        ),

                        CustomTextField(
                          isObscure: false,
                          headerText: "",
                          hintText: "Alternate Number",
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          controller: altPhoneController,
                          validator: (value) {
                            if (value == null) {
                              return null;
                            }
                            if (value.isNotEmpty &&
                                value == phoneController.text) {
                              return "Alternate phone number cannot be same as phone number";
                            }
                            return null;
                          },
                        ),

                        // state

                        // city

                        CustomDropdownButton(
                          title: 'State',
                          items: states,
                          initVal: stateVal,
                          onChanged: (value) {
                            setState(() {
                              stateVal = value;
                              cityVal = -1;
                              city = [
                                const DropdownMenuItem(
                                  value: -1,
                                  child: CustomText(
                                    "City",
                                    color: CustomColors.info,
                                  ),
                                )
                              ];
                              context
                                  .read<GuestCubit>()
                                  .getCity(stateVal.toString());
                            });
                          },
                          validator: (value) {
                            if (stateVal == -1 || stateVal == null) {
                              return "Select state";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomDropdownButton(
                          items: city,
                          initVal: cityVal,
                          title: "City",
                          onChanged: (value) {
                            cityVal = value!;
                          },
                          validator: (value) {
                            if (cityVal == -1 || cityVal == null) {
                              return "Select city";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        // CustomDropdownButton(
                        //   title: 'Samaj',
                        //   items: samaj,
                        //   onChanged: (value) {
                        //     samajVal = value!;
                        //   },
                        // ),
                        // const SizedBox(height: 8),

                        // CustomTextField(
                        //   isObscure: false,
                        //   headerText: "",
                        //   hintText: "Samaj *",
                        //   maxLength: 30,
                        //   controller: samajController,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return "Samaj cannot be empty";
                        //     }
                        //     return null;
                        //   },
                        // ),
                        CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (widget.isEdit == true) {
                                context.read<GuestCubit>().editGuest(
                                  {
                                    "full_name": nameController.text,
                                    "age": ageController.text,
                                    if (categoryVal != -1)
                                      "relation_category_id": categoryVal,
                                    // if (relationId != -1)
                                    //   "relation_id": relationId,
                                    "phone_number": phoneController.text,
                                    "alternate_phone_number":
                                        altPhoneController.text,
                                    'religion_id': 1,
                                    'community_id': 1,
                                    if (stateVal != -1) "state_id": stateVal,
                                    if (cityVal != -1) "city_id": cityVal,
                                    // "samaj": samajController
                                  },
                                  widget.id ?? "",
                                );
                              } else {
                                context.read<GuestCubit>().addGuest(
                                  {
                                    "full_name": nameController.text,
                                    "age": ageController.text,
                                    if (categoryVal != -1)
                                      "relation_category_id": categoryVal,
                                    if (relationId != -1)
                                      "relation_id": relationId,
                                    "phone_number": phoneController.text,
                                    "alternate_phone_number":
                                        altPhoneController.text,
                                    'religion_id': 1,
                                    'community_id': 1,
                                    if (stateVal != -1) "state_id": stateVal,
                                    if (cityVal != -1) "city_id": cityVal,
                                    // "samaj": samajController.text
                                  },
                                );
                              }
                            }
                          },
                          text: widget.isEdit != null && widget.isEdit == true
                              ? 'Save'
                              : '+ Add Guest',
                          isLoading: state is GuestAddLoading,
                          height: 54,
                          width: double.infinity,
                        )
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
