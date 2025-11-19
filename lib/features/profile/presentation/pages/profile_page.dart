import 'dart:developer';

import 'package:aayojan/core/network/endpoints.dart';
import 'package:aayojan/features/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/utility/constants.dart';
import '../../../../core/utility/image_picker.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dropdown_button.dart';
import '../../../../core/widgets/custom_image_picker.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'package:aayojan/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:aayojan/features/profile/presentation/bloc/profile_state.dart';

import '../../../../core/widgets/error_text.dart';

class UpdateProfile extends StatefulWidget {
  static const String routeName = '/update_profile';
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  bool termsAndConditions = false;
  bool submitCheck = false;
  String gender = "-1";
  int yes = 1;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedValue = 'yes';
  bool isLoading = true;
  String userId = "";

  // define text editing controller
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController familyIdController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController kidsController = TextEditingController();
  final TextEditingController familyNicknameController =
      TextEditingController();

  final TextEditingController familyMembersController = TextEditingController();
  final TextEditingController samajController = TextEditingController();

  List<DropdownMenuItem> religion = [];
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

  List<DropdownMenuItem> religions = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "Religion *",
        color: CustomColors.info,
      ),
    )
  ];

  List<DropdownMenuItem> community = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText(
        "Community *",
        color: CustomColors.info,
      ),
    )
  ];

  String selectedGender = "";
  int selectedState = -1;
  int? selectedCity = -1;
  int? cityFromResponse = -1;
  num? selectedReligion = -1;
  num? selectedRelation = -1;
  int? selectedCommunity = -1;
  int? communityFromResponse = -1;
  String selectedFamilyMembers = "";
  bool expand = false;

  String filePath = "";
  String profileImage = "";

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // Profile Failed.
          if (state is ProfileFailure) {
            isLoading = false;
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.message),
            //     backgroundColor: CustomColors.error,
            //   ),
            // );
          }

          // profile update failure
          if (state is ProfileUpdateFailure) {
            // scroll to bottom
            setState(() {
              scrollController.animateTo(
                scrollController.position.extentTotal,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              isLoading = false;
            });
          }

          // profile update success
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: CustomColors.success,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          }

          if (state is CityLoaded) {
            log('here');
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

              if (newCities.map((e) => e.value).contains(cityFromResponse)) {
                setState(() {
                  selectedCity = cityFromResponse;
                });
              } else {
                selectedCity = -1;
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
              // log(cityDistrict.toString());
              isLoading = false;
            });
          }

          if (state is CommunityLoaded) {
            setState(() {
              final newCommunities = state.community.data
                      ?.map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: CustomText(e.title ?? ""),
                        ),
                      )
                      .toList() ??
                  [];
              selectedCommunity =
                  newCommunities.isNotEmpty ? newCommunities.first.value : -1;
              community = [
                const DropdownMenuItem(
                  value: -1,
                  child: CustomText(
                    "Community *",
                    color: CustomColors.info,
                  ),
                ),
                ...newCommunities
              ];

              isLoading = false;
            });
          }

          if (state is ProfileLoaded) {
            if (state.profile.data?.user?.profile?.isEmpty ?? true) {
              profileImage = "";
            } else {
              profileImage =
                  "${Endpoints.imageUrl}${state.profile.data?.user?.profile}";
            }
            firstnameController.text =
                state.profile.data?.user?.firstName ?? "";
            surnameController.text = state.profile.data?.user?.lastName ?? "";
            phoneController.text = state.profile.data?.user?.phone ?? "";
            altPhoneController.text =
                state.profile.data?.user?.alternatePhone ?? "";
            addressController.text = state.profile.data?.user?.email ?? "";
            ageController.text = state.profile.data?.user?.age.toString() ?? "";
            familyIdController.text = state.profile.data?.user?.familyId == null
                ? ''
                : state.profile.data?.user?.familyId.toString() ?? "";
            // cityController.text =
            //     state.profile.data?.user?.city?.id.toString() ?? "";
            townController.text = state.profile.data?.user?.town ?? "";
            villageController.text = state.profile.data?.user?.village ?? "";
            familyIdController.text = state.profile.data?.user?.familyId == null
                ? ''
                : state.profile.data?.user?.familyId.toString() ?? "";
            selectedGender = state.profile.data?.user?.gender ?? "";
            if (genderlist.map((e) => e.value).contains(selectedGender)) {
              gender = selectedGender;
            } else {
              gender = "-1";
            }
            familyMembersController.text =
                state.profile.data?.user?.familyCount ?? "";
            kidsController.text = state.profile.data?.user?.kids ?? "";
            addressController.text = state.profile.data?.user?.address ?? "";
            phoneController.text = state.profile.data?.user?.phone ?? "";
            altPhoneController.text =
                state.profile.data?.user?.alternatePhone ?? "";

            try {
              selectedState = int.parse(
                  state.profile.data?.user?.state?.id.toString() ?? "-1");
            } catch (e) {
              selectedState = -1;
            }

            selectedReligion = state.profile.data?.user?.religion?.id ?? -1;
            selectedRelation = state.profile.data?.user?.relationId ?? -1;
            try {
              cityFromResponse = int.parse(
                  state.profile.data?.user?.city?.id.toString() ?? "-1");
            } catch (e) {
              cityFromResponse = -1;
            }

            familyNicknameController.text =
                state.profile.data?.user?.familyNickname ?? "";
            if (state.profile.data?.user?.familyId != null) {
              userId = state.profile.data?.user?.familyId.toString() ?? "";
            }

            // selectedCommunity = state.profile.data?.user?.community ;
            samajController.text = state.profile.data?.user?.samaj ?? "";
            // kidsController = state.profile.data?.user?.

            // build religion here
            setState(() {
              final newReligions = state.religion?.data
                      ?.map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: CustomText(e.title ?? ""),
                        ),
                      )
                      .toList() ??
                  [];
              if (newReligions.map((e) => e.value).contains(selectedReligion)) {
                setState(() {
                  context
                      .read<ProfileCubit>()
                      .getCommunites(selectedReligion.toString());
                });
              } else {
                selectedReligion = -1;
              }
              religion = [
                const DropdownMenuItem(
                  value: -1,
                  child: CustomText(
                    "Religion *",
                    color: CustomColors.info,
                  ),
                ),
                ...newReligions
              ];

              isLoading = false;
            });

            setState(() {
              final newStates = state.state?.data
                      ?.map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: CustomText(e.name ?? ""),
                        ),
                      )
                      .toList() ??
                  [];

              if (newStates.map((e) => e.value).contains(selectedState)) {
                context
                    .read<ProfileCubit>()
                    .getCities(selectedState.toString());
              } else {
                selectedState = -1;
              }
              states = [
                const DropdownMenuItem(
                  value: -1,
                  child: CustomText(
                    'State *',
                    color: CustomColors.info,
                  ),
                ),
                ...newStates
              ];

              isLoading = false;
            });

            // // Save the loaded profile data to cache
            // _saveProfileData();
          }
        },
        builder: (context, state) {
          if (isLoading) {
            return const Center(
              child: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: CustomColors.bgLight,
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(
                "My Profile",
                style: CustomTypography.titleMedium.copyWith(
                  color: CustomColors.bgLight,
                ),
              ),
            ),
            body: state is ProfileFailure
                ? Center(
                    child: Scaffold(
                      body: Center(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.2,
                          child: Column(
                            children: [
                              Text(
                                state.message,
                                style: CustomTypography.bodyLarge.copyWith(
                                  color: CustomColors.error,
                                ),
                              ),
                              // add button for retry
                              const SizedBox(height: 16),
                              CustomButton(
                                onPressed: () {
                                  context.read<ProfileCubit>().getProfile();
                                },
                                text: "Retry",
                                isLoading: false,
                                height: 40,
                                width: 128,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    ProfileImagePicker(
                                        filePath: filePath,
                                        imageUrl: profileImage,
                                        onPressed: () async {
                                          final file = await imagePicker();
                                          setState(() {
                                            filePath = file;
                                          });
                                        }),
                                    const SizedBox(height: 14),
                                    Text('ID - $userId',
                                        style:
                                            CustomTypography.bodyLarge.copyWith(
                                          color: CustomColors.bgLight,
                                          fontSize: 20,
                                        )),
                                    const SizedBox(height: 14),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: CustomColors.bgLight
                                            .withOpacity(0.2),
                                      ),
                                      padding: const EdgeInsets.all(24),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Is there any family member of yours who is usually invited with you already registered with Aayojan',
                                            style: CustomTypography.bodyLarge
                                                .copyWith(
                                              color: CustomColors.bgLight,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: 'yes',
                                                groupValue: selectedValue,
                                                activeColor:
                                                    CustomColors.bgLight,
                                                focusColor:
                                                    CustomColors.bgLight,
                                                onChanged: (value) {
                                                  setState(() {
                                                    yes = 1;
                                                    selectedValue = value!;
                                                  });
                                                },
                                              ),
                                              Text(
                                                "Yes",
                                                style: CustomTypography
                                                    .bodyLarge
                                                    .copyWith(
                                                  color: CustomColors.bgLight,
                                                ),
                                              ),
                                              Radio<String>(
                                                value: 'no',
                                                groupValue: selectedValue,
                                                activeColor:
                                                    CustomColors.bgLight,
                                                onChanged: (value) {
                                                  if (familyIdController
                                                      .text.isNotEmpty) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    yes = 0;
                                                    selectedValue = value!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "No",
                                                style: CustomTypography
                                                    .bodyLarge
                                                    .copyWith(
                                                        color: CustomColors
                                                            .bgLight),
                                              )
                                            ],
                                          ),
                                          if (yes == 1)
                                            CustomTextField(
                                              isObscure: false,
                                              headerText: "",
                                              hintText: "Enter Your Family Id",
                                              controller: familyIdController,
                                              keyboardType:
                                                  TextInputType.number,
                                              fillColor: familyIdController
                                                      .text.isNotEmpty
                                                  ? CustomColors.contentPrimary
                                                      .withOpacity(0.5)
                                                  : CustomColors.primary,
                                              isDisabled: familyIdController
                                                  .text.isNotEmpty,
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      isObscure: false,
                                      headerText: "",
                                      maxLength: 30,
                                      hintText: "First Name *",
                                      inputFormatter: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z ]'))
                                      ],
                                      controller: firstnameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter your first name";
                                        }
                                        if (value.length < 3) {
                                          return "First name should be at least 3 characters";
                                        }

                                        return null;
                                      },
                                    ),
                                    CustomTextField(
                                      isObscure: false,
                                      headerText: "",
                                      maxLength: 30,
                                      hintText: "Last Name *",
                                      inputFormatter: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z ]'))
                                      ],
                                      controller: surnameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter your last name";
                                        }
                                        if (value.length < 3) {
                                          return "Last name should be at least 3 characters";
                                        }
                                        return null;
                                      },
                                    ),
                                    CustomTextField(
                                      isObscure: false,
                                      keyboardType: TextInputType.number,
                                      headerText: "",
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      maxLength: 3,
                                      hintText: "Age *",
                                      controller: ageController,
                                      validator: (value) {
                                        if (value!.toString().isEmpty) {
                                          return "Age is required";
                                        }
                                        if (int.parse(value) < 18) {
                                          return "Age should be greater than 18";
                                        }
                                        if (int.parse(value) > 150) {
                                          return "Age should be less than 150";
                                        }
                                        return null;
                                      },
                                    ),
                                    CustomDropdownButton(
                                      items: genderlist,
                                      initVal: gender,
                                      title: "Gender *",
                                      onChanged: ((value) {
                                        setState(() {
                                          gender = value!;
                                        });
                                      }),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Select your gender.";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    CustomDropdownButton(
                                      items: states,
                                      title: "States *",
                                      initVal: selectedState,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedState =
                                              value; // Update selected state\
                                          cityDistrict = [
                                            const DropdownMenuItem(
                                              value: -1,
                                              child: CustomText(
                                                "City/District *",
                                                color: CustomColors.info,
                                              ),
                                            )
                                          ];
                                          selectedCity = -1;
                                          context
                                              .read<ProfileCubit>()
                                              .getCities(
                                                  selectedState.toString());
                                        });
                                      },
                                      validator: (value) {
                                        if (value == -1 || value == null) {
                                          return 'Select your state';
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    CustomDropdownButton(
                                      items: cityDistrict,
                                      title: "City/District *",
                                      initVal: selectedCity,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCity = value!;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null ||
                                            value.toString().isEmpty) {
                                          return "Select your city or district.";
                                        }
                                        if (value == -1) {
                                          return "Select your city or district.";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 8),

                                    CustomTextField(
                                      isObscure: false,
                                      headerText: "",
                                      hintText: "Village/Town",
                                      maxLength: 30,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z ]'))
                                      ],
                                      controller: townController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return null;
                                        }
                                        if (value.length < 3) {
                                          return "Village/Town should be at least 3 characters.";
                                        }
                                        return null;
                                      },
                                    ),

                                    // create address field but not email

                                    CustomTextField(
                                      isObscure: false,
                                      headerText: "",
                                      maxLength: 30,
                                      hintText: "Address *",
                                      // regex for address to contain some number and text
                                      inputFormatter: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9 ]'))
                                      ],
                                      controller: addressController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {},
                                    ),

                                    // CustomTextField(
                                    //   isObscure: false,
                                    //   headerText: "",
                                    //   hintText: "Contact Number *",
                                    //   maxLength: 10,
                                    //   controller: phoneController,
                                    //   inputFormatter: [
                                    //     FilteringTextInputFormatter.digitsOnly
                                    //   ],
                                    //   keyboardType: TextInputType.number,
                                    //   validator: (value) {
                                    //     if (value!.toString().isEmpty) {
                                    //       return "please enter your phone number";
                                    //     }
                                    //     return null;
                                    //   },
                                    // ),
                                    if (!expand)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            expand = true;
                                          });
                                        },
                                        child: Text(
                                          "Add More details +",
                                          style: CustomTypography.bodyLarge
                                              .copyWith(
                                                  color: CustomColors.bgLight),
                                        ),
                                      ),
                                    if (expand)
                                      Column(
                                        children: [
                                          CustomTextField(
                                            isObscure: false,
                                            headerText: "",
                                            hintText: "Alternate Number",
                                            maxLength: 10,
                                            inputFormatter: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller: altPhoneController,
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value == null) {
                                                return null;
                                              }
                                              if (value.isNotEmpty &&
                                                  value ==
                                                      phoneController.text) {
                                                return "Alternate phone number cannot be same as phone number";
                                              }
                                              return null;
                                            },
                                          ),
                                          CustomDropdownButton(
                                            items: religion,
                                            initVal: selectedReligion,
                                            title: "Religion *",
                                            onChanged: (value) {
                                              setState(() {
                                                selectedReligion = value;
                                                selectedCommunity = -1;
                                                community = [
                                                  const DropdownMenuItem(
                                                    value: -1,
                                                    child: CustomText(
                                                      "Community *",
                                                      color: CustomColors.info,
                                                    ),
                                                  )
                                                ];
                                                context
                                                    .read<ProfileCubit>()
                                                    .getCommunites(
                                                        selectedReligion
                                                            .toString());
                                              });
                                            },
                                            validator: (value) {
                                              if (value == -1 ||
                                                  value == null) {
                                                return "Select your religion";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          CustomDropdownButton(
                                            items: community,
                                            title: "Community *",
                                            initVal: selectedCommunity,
                                            onChanged: (value) {
                                              selectedCommunity = value!;
                                            },
                                            validator: (value) {
                                              if (value == -1) {
                                                return "Select your community";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          // CustomDropdownButton(
                                          //   items: samaj,
                                          //   title: "Samaj",
                                          //   onChanged: (value) {
                                          //     selectedSamaj = value!;
                                          //   },
                                          // ),
                                          CustomTextField(
                                            isObscure: false,
                                            headerText: "",
                                            hintText: "Samaj",
                                            inputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[a-zA-Z ]'))
                                            ],
                                            controller: samajController,
                                          ),

                                          // const SizedBox(height: 8),
                                          // CustomDropdownButton(
                                          //   items: familymembers,
                                          //   title: "Family memebers (optional)",
                                          //   onChanged: (value) {
                                          //     selectedFamilyMembers = value!;
                                          //   },
                                          // ),
                                          // const SizedBox(height: 8),
                                          // make it custom text field
                                          CustomTextField(
                                            isObscure: false,
                                            headerText: "",
                                            hintText:
                                                "Family members (optional)",
                                            controller: familyMembersController,
                                            inputFormatter: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                          // CustomDropdownButton(
                                          //   items: kids,
                                          //   title: "Kids below 10 (optional)",
                                          //   onChanged: (value) {
                                          //     selectedKids = value!;
                                          //   },
                                          // ),
                                          CustomTextField(
                                            isObscure: false,
                                            headerText: "",
                                            hintText:
                                                "Kids below 10 (optional)",
                                            maxLength: 2,
                                            inputFormatter: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller: kidsController,
                                            keyboardType: TextInputType.number,
                                          ),
                                          CustomTextField(
                                            isObscure: false,
                                            headerText: "",
                                            hintText:
                                                "Family Nickname (optional)",
                                            maxLength: 30,
                                            controller:
                                                familyNicknameController,
                                            inputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[a-zA-Z ]'))
                                            ],
                                          ),

                                          // text button for hiding the extra fields
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                expand = false;
                                              });
                                            },
                                            child: Text(
                                              "Hide details -",
                                              style: CustomTypography.bodyLarge
                                                  .copyWith(
                                                      color:
                                                          CustomColors.bgLight),
                                            ),
                                          ),
                                        ],
                                      ),

                                    if (state is ProfileUpdateFailure)
                                      ErrorText(
                                        errorText: state.message,
                                      ),

                                    CustomButton(
                                      onPressed: () async {
                                        if (selectedReligion == null ||
                                            selectedReligion == -1 ||
                                            selectedCommunity == null ||
                                            selectedCommunity == -1) {
                                          setState(() {
                                            expand = true;
                                          });
                                          Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                              formKey.currentState!.validate();
                                            },
                                          );
                                          return;
                                        }
                                        if (formKey.currentState!.validate()) {
                                          log(yes.toString());
                                          log(familyIdController.text);
                                          context
                                              .read<ProfileCubit>()
                                              .updateProfile(
                                            {
                                              'profile': filePath,
                                              'family_id':
                                                  familyIdController.text,
                                              'name': firstnameController.text,
                                              'surname': surnameController.text,
                                              'age': ageController.text,
                                              'gender': gender,
                                              if (selectedCity != -1)
                                                'city': selectedCity,
                                              'town': townController.text,
                                              // 'village': villageController.text,
                                              if (selectedState != -1)
                                                'state': selectedState,
                                              'phone': phoneController.text,
                                              'alt_phone':
                                                  altPhoneController.text,
                                              'email': addressController.text,
                                              'is_exist_family_member':
                                                  yes.toString(),
                                              'address': addressController.text,
                                              // if religion id is not equal to -1
                                              if (selectedReligion != -1)
                                                'religion_id': selectedReligion,
                                              'relation': '',
                                              if (selectedCommunity != -1)
                                                'community': selectedCommunity,
                                              'samaj': samajController.text,
                                              'kids': kidsController.text,
                                              'familyCount':
                                                  familyMembersController.text,
                                              'family_nickname':
                                                  familyNicknameController.text,
                                            },
                                          );

                                          // Save the updated profile data to cache
                                          // _saveProfileData();
                                        }
                                      },
                                      text: "Save",
                                      isLoading: state is ProfileUpdateLoading,
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
