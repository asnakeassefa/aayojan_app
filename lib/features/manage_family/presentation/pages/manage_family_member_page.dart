import 'dart:developer';

import 'package:aayojan/core/utility/constants.dart';
import 'package:aayojan/core/widgets/custom_dropdown_button.dart';
import 'package:aayojan/core/widgets/error_text.dart';
import 'package:aayojan/features/manage_family/presentation/bloc/famil_state.dart';
import 'package:aayojan/features/manage_family/presentation/bloc/family_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/utility/image_picker.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_image_picker.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ManageFamilyMember extends StatefulWidget {
  static const String routeName = '/manage-family-member';
  final bool isEdit;
  final int? relation_id;
  final int? category_id;
  final String? first_name;
  final String? last_name;
  final int? state;
  final int? city;
  final String? town;
  final String? email;
  final int? age;
  final String? phone;
  final String? gender;
  final String? address;
  final String? altPhone;
  final String? image;
  final int? id;
  const ManageFamilyMember(
      {super.key,
      required this.isEdit,
      this.relation_id,
      this.category_id,
      this.first_name,
      this.last_name,
      this.image,
      this.age,
      this.phone,
      this.gender,
      this.id,
      this.state,
      this.city,
      this.town,
      this.email,
      this.address,
      this.altPhone});

  @override
  State<ManageFamilyMember> createState() => _ManageFamilyMemberState();
}

class _ManageFamilyMemberState extends State<ManageFamilyMember> {
  String image = '';
  List<DropdownMenuItem> states = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "State *",
        color: CustomColors.info,
      ),
    )
  ];
  List<DropdownMenuItem> cityDistrict = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "City/District *",
        color: CustomColors.info,
      ),
    )
  ];
  List<DropdownMenuItem> category = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "Category *",
        color: CustomColors.info,
      ),
    )
  ];
  List<DropdownMenuItem> relations = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "Relation *",
        color: CustomColors.info,
      ),
    )
  ];

  String gender = "-1";
  bool yes = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int? selectedCityDistrict = -1;

  // define text editing controller
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alternatephoneController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController ageController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  int selectedState = -1;
  int categoryVal = 5;
  int relationVal = -1;

  bool expand = false;

  String filePath = '';
  bool imageIsEmpty = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      firstnameController.text = widget.first_name ?? "";
      lastnameController.text = widget.last_name ?? "";
      phoneController.text = widget.phone ?? "";
      ageController.text = widget.age.toString();
      addressController.text = widget.address ?? "";
      townController.text = widget.town ?? "";
      alternatephoneController.text = widget.altPhone ?? "";
      image = widget.image ?? "";
      if (image.isNotEmpty) {
        image = Endpoints.imageUrl + image;
      }
      emailController.text = widget.email ?? "";
      // check if the gender is in genderlist
      if (genderlist.map((e) => e.value).contains(widget.gender ?? "-1")) {
        gender = widget.gender ?? '-1';
      } else {
        gender = "-1";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FamilyCubit>()..getRelations(),
      child: BlocConsumer<FamilyCubit, FamilyState>(
        listener: (context, state) {
          if (state is FamilySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.success,
              ),
            );
            Navigator.pop(context, true);
          }

          // if (state is CityLoaded) {
          //   setState(() {
          //     final newCities = state.cities.data?.map((e) {
          //           return DropdownMenuItem(
          //             value: e.id,
          //             child: CustomText(e.name ?? ''),
          //           );
          //         }).toList() ??
          //         [];
          //     // if (newCities
          //     //     .map((e) => e.value)
          //     //     .contains(int.parse(widget.city ?? '-1'))) {
          //     //   selectedCityDistrict = int.parse(widget.city ?? "-1");
          //     // }
          //     cityDistrict = [
          //       const DropdownMenuItem(
          //         value: -1,
          //         child: CustomText(
          //           "City/District *",
          //           color: CustomColors.info,
          //         ),
          //       ),
          //       ...newCities
          //     ];
          //   });
          // }

          if (state is CityLoaded) {
            final newCities = state.cities.data?.map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: CustomText(e.name ?? ''),
                  );
                }).toList() ??
                [];

            // check if the city id is in the list
            if (newCities.map((e) => e.value).contains(widget.city ?? -1)) {
              log('city id is in the list');
              setState(() {
                selectedCityDistrict = widget.city ?? -1;
              });
            }
            cityDistrict = [
              const DropdownMenuItem(
                value: -1,
                child: CustomText(
                  "City/District *",
                  color: CustomColors.info,
                ),
              ),
              ...newCities
            ];
          }

          if (state is RelationsLoaded) {
            setState(() {
              // final newCategory = state.relationCategories.data?.map((e) {
              //       return DropdownMenuItem(
              //         value: e.id,
              //         child: CustomText(e.name ?? ''),
              //       );
              //     }).toList() ??
              //     [];

              // // check if the category id is in the list
              // if (newCategory
              //     .map((e) => e.value)
              //     .contains(widget.category_id)) {
              //   log('category id is in the list');
              //   setState(() {
              //     categoryVal = widget.category_id ?? -1;
              //   });
              // }

              // category = [
              //   const DropdownMenuItem(
              //     value: -1,
              //     child: CustomText(
              //       "Category *",
              //       color: CustomColors.info,
              //     ),
              //   ),
              //   ...newCategory
              // ];

              final newRelations = state.relations.data?.map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: CustomText(e.name ?? ''),
                    );
                  }).toList() ??
                  [];
              // check for relation id
              if (newRelations
                  .map((e) => e.value)
                  .contains(widget.relation_id)) {
                log('relation id is in the list');
                setState(() {
                  relationVal = widget.relation_id ?? -1;
                });
              }
              relations = [
                const DropdownMenuItem(
                  value: -1,
                  child: CustomText(
                    "Relation *",
                    color: CustomColors.info,
                  ),
                ),
                ...newRelations
              ];

              // relations.add(DropdownMenuItem(
              //   value: -1,
              //   child: CustomText('Relation'),
              // ));

              final newStates = state.states.data?.map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: CustomText(e.name ?? ''),
                    );
                  }).toList() ??
                  [];

              // check for state id
              if (newStates.map((e) => e.value).contains(widget.state ?? -1)) {
                log('state id is in the list');
                setState(() {
                  selectedState = widget.state ?? -1;
                });
                context.read<FamilyCubit>().getCities(selectedState.toString());
              }

              states = [
                const DropdownMenuItem(
                  value: -1,
                  child: CustomText(
                    "State *",
                    color: CustomColors.info,
                  ),
                ),
                ...newStates
              ];

              // states.add(DropdownMenuItem(
              //   value: -1,
              //   child: CustomText('State'),
              // ));

              // try {
              //   if (states
              //       .map((e) => e.value)
              //       .contains(int.parse(widget.state ?? "-1"))) {
              //     context
              //         .read<FamilyCubit>()
              //         .getCities(widget.state.toString());

              //     stateVal = int.parse(widget.state ?? "-1");
              //   }
              // } catch (e) {
              //   log(widget.state.toString());
              //   log(e.toString());
              // }

              // try {
              //   if (relations
              //       .map((e) => e.value)
              //       .contains(widget.relation_id)) {
              //     relationVal = widget.relation_id ?? -1;
              //   }
              // } catch (e) {
              //   log(e.toString());
              // }

              // try {
              //   if (category.map((e) => e.value).contains(widget.category_id)) {
              //     categoryVal = widget.category_id ?? -1;
              //   }
              // } catch (e) {
              //   log(e.toString());
              // }

              // selectedCityDistrict = -1;
              // for (var item in state.relations.data!) {
              //   relationMap[item.id!] = item.name!;
              // }
            });
          }

          if (state is FamilyFailure) {
            // show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text(
                widget.isEdit ? "Update Family Member" : "Add Family Member",
                style: CustomTypography.titleMedium,
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    SizedBox(
                      child: Text(
                          "By adding your family members will help you in confirming your availability to the Invitation(s)",
                          textAlign: TextAlign.center,
                          style: CustomTypography.bodyLarge.copyWith(
                              color: CustomColors.bgLight,
                              fontFamily: GoogleFonts.poppins().fontFamily)),
                    ),
                    const SizedBox(height: 16),
                    // Container(
                    //   color: Colors.black.withOpacity(0.3),
                    //   padding: const EdgeInsets.symmetric(horizontal: 24),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Family Members',
                    //         style: CustomTypography.bodyMedium
                    //             .copyWith(color: CustomColors.bgLight),
                    //       ),
                    //       CustomButton(
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //           },
                    //           text: 'View',
                    //           isLoading: false,
                    //           height: 34,
                    //           width: 90)
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 24),
                    state is FamilyLoading
                        ? SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.6,
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
                        : Form(
                            key: formKey,
                            child: Column(
                              children: [
                                ProfileImagePicker(
                                  filePath: filePath,
                                  imageUrl: image,
                                  onPressed: () async {
                                    final file = await imagePicker();
                                    setState(
                                      () {
                                        filePath = file;
                                      },
                                    );
                                  },
                                ),

                                if (imageIsEmpty)
                                  const ErrorText(
                                      errorText: "Please select an image"),
                                const SizedBox(height: 16),

                                CustomDropdownButton(
                                  items: relations,
                                  title: "Relation *",
                                  initVal: relationVal,
                                  onChanged: (value) {
                                    setState(() {
                                      relationVal = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  isObscure: false,
                                  headerText: "",
                                  hintText: "First name *",
                                  inputFormatter: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  maxLength: 30,
                                  controller: firstnameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your first name.";
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  isObscure: false,
                                  headerText: "",
                                  hintText: "Last name *",
                                  inputFormatter: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  maxLength: 30,
                                  controller: lastnameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your last name.";
                                    }
                                    return null;
                                  },
                                ),
                                CustomTextField(
                                  isObscure: false,
                                  keyboardType: TextInputType.phone,
                                  headerText: "",
                                  hintText: "Age *",
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  maxLength: 3,
                                  controller: ageController,
                                  validator: (value) {
                                    if (value!.toString().isEmpty) {
                                      return "Please enter your age.";
                                    }
                                    return null;
                                  },
                                ),
                                CustomDropdownButton(
                                  items: genderlist,
                                  title: "Gender *",
                                  initVal: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value!;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value == -1) {
                                      return "Select your gender.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),
                                CustomDropdownButton(
                                  items: states,
                                  title: "State *",
                                  initVal: selectedState,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedState = value!;
                                      cityDistrict = [
                                        const DropdownMenuItem(
                                          value: -1,
                                          child: CustomText(
                                            "City/District *",
                                            color: CustomColors.info,
                                          ),
                                        )
                                      ];
                                      selectedCityDistrict = -1;
                                      context
                                          .read<FamilyCubit>()
                                          .getCities(selectedState!.toString());
                                      // unselect values from city dropdown
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value == -1) {
                                      return "Select your state.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),
                                CustomDropdownButton(
                                  items: cityDistrict,
                                  initVal: selectedCityDistrict,
                                  title: "City/District *",
                                  onChanged: (value) {
                                    selectedCityDistrict = value!;
                                  },
                                  validator: (value) {
                                    if (value == null || value == -1) {
                                      return "Select your city or district.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),
                                // add customtext filed for address
                                CustomTextField(
                                  isObscure: false,
                                  headerText: "",
                                  hintText: "Address *",
                                  inputFormatter: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z0-9 ]')),
                                  ],
                                  maxLength: 100,
                                  controller: addressController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your address.";
                                    }
                                    return null;
                                  },
                                ),

                                CustomTextField(
                                  isObscure: false,
                                  headerText: "",
                                  hintText: "Contact Number *",
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  maxLength: 15,
                                  keyboardType: TextInputType.phone,
                                  controller: phoneController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your phone number.";
                                    }
                                    return null;
                                  },
                                ),

                                CustomTextField(
                                  isObscure: false,
                                  headerText: "",
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  maxLength: 15,
                                  hintText: "Alternate Number",
                                  keyboardType: TextInputType.phone,
                                  controller: alternatephoneController,
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

                                CustomTextField(
                                  isObscure: false,
                                  headerText: "",
                                  hintText: "Village/Town",
                                  controller: townController,
                                ),
                                CustomTextField(
                                  isObscure: false,
                                  headerText: "",
                                  hintText: "Email",
                                  controller: emailController,
                                ),
                                // CustomTextField(
                                //   isObscure: false,
                                //   headerText: "",
                                //   hintText:
                                //       "109,Regency Pride, Anand Bazar",
                                //   controller: townController,
                                //   validator: (value) {
                                //     if (value!.isEmpty) {
                                //       return "town cannot be empty";
                                //     }
                                //     return null;
                                //   },
                                // ),
                                if (state is FamilyCreateFailure)
                                  ErrorText(errorText: state.message),
                                const SizedBox(height: 16),
                                CustomButton(
                                  onPressed: () {
                                    // check if the image is empty
                                    if (filePath.isEmpty && image.isEmpty) {
                                      log('in image');
                                      setState(() {
                                        imageIsEmpty = true;
                                      });
                                    } else {
                                      log('image is visible');
                                      setState(() {
                                        imageIsEmpty = false;
                                      });
                                    }
                                    if (formKey.currentState!.validate()) {
                                      //profile
                                      // relation_id
                                      //relation_category_id
                                      //first_name
                                      // last_name
                                      // age
                                      // gender
                                      // phone
                                      if (widget.isEdit) {
                                        if (filePath.isEmpty && image.isEmpty) {
                                          return;
                                        }
                                        context
                                            .read<FamilyCubit>()
                                            .updateFamily({
                                          "first_name":
                                              firstnameController.text,
                                          "last_name": lastnameController.text,
                                          "phone": phoneController.text,
                                          'alt_phone':
                                              alternatephoneController.text,
                                          "age": ageController.text,
                                          "gender": gender,
                                          "town": townController.text,
                                          "state": selectedState,
                                          "city": selectedCityDistrict,
                                          "address": addressController.text,
                                          "relation": relationVal,
                                          "category": categoryVal,
                                          if (filePath.isNotEmpty)
                                            "profile": filePath,
                                          "email": emailController.text,
                                        }, widget.id.toString());
                                      } else {
                                        if (filePath.isEmpty && image.isEmpty) {
                                          return;
                                        }
                                        context.read<FamilyCubit>().addFamily(
                                          {
                                            "first_name":
                                                firstnameController.text,
                                            "last_name":
                                                lastnameController.text,
                                            "phone": phoneController.text,
                                            'alt_phone':
                                                alternatephoneController.text,
                                            "age": ageController.text,
                                            "gender": gender,
                                            "town": townController.text,
                                            "state": selectedState,
                                            "city": selectedCityDistrict,
                                            "address": addressController.text,
                                            "relation": relationVal,
                                            "category": categoryVal,
                                            if (filePath.isNotEmpty)
                                              "profile": filePath,
                                            "email": emailController.text,
                                          },
                                        );
                                      }
                                    }
                                  },
                                  text: "Save",
                                  isLoading: state is FamilySaveLoading,
                                  height: 54,
                                  width: MediaQuery.sizeOf(context).width,
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                  ],
                ),
              )),
            ),
          );
        },
      ),
    );
  }
}
