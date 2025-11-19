import 'package:aayojan/core/utility/image_picker.dart';
import 'package:aayojan/core/utility/router.dart';
import 'package:aayojan/core/widgets/custom_dropdown_button.dart';
import 'package:aayojan/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:aayojan/features/auth/presentation/bloc/auth_state.dart';
import 'package:aayojan/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/utility/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_image_picker.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/error_text.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/sign-up';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool termsAndConditions = false;
  bool submitCheck = false;
  String gender = "";
  List<DropdownMenuItem> states = [];
  List<DropdownMenuItem> cityDistrict = [
    const DropdownMenuItem(
      value: -1,
      child: CustomText("City/District", color: CustomColors.info),
    )
  ];
  int? selectedState = -1;
  int? selectedCity = -1;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String filePath = "";

  // define text editing controller
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  final TextEditingController villageController = TextEditingController();

  final _scrollController = ScrollController();
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>()..getStates(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }

          if (state is StateLoaded) {
            final newStates = state.states.data?.map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: CustomText(e.name ?? ""),
                  );
                }).toList() ??
                [];

            states = [
              const DropdownMenuItem(
                value: -1,
                child: CustomText("State", color: CustomColors.info),
              ),
              ...newStates
            ];
          }

          if (state is CityLoaded) {
            setState(() {
              final newCities = state.cities.data?.map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: CustomText(e.name ?? ""),
                    );
                  }).toList() ??
                  [];
              selectedCity = newCities.isNotEmpty ? newCities[0].value : -1;
              cityDistrict = [
                const DropdownMenuItem(
                  value: -1,
                  child: CustomText("City/District", color: CustomColors.info),
                ),
                ...newCities
              ];
            });
          }

          if (state is AuthSignupSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: CustomColors.primary,
                  content: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, LoginPage.routeName);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: CustomColors.bgLight,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage("assets/images/rounded_logo.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            "Welcome to Aayojan! Let’s Plan the events together.",
                            textAlign: TextAlign.center,
                            style: CustomTypography.bodyLarge.copyWith(
                              color: CustomColors.bgLight,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).then((value) {
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            });
          }

          // if (state is AuthFailure) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       backgroundColor: CustomColors.error,
          //       content: Text(
          //         state.message,
          //         style: const TextStyle(
          //           color: CustomColors.bgLight,
          //         ),
          //       ),
          //     ),
          //   );
          // }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        SizedBox(
                          child: Text("Register",
                              style: CustomTypography.titleMedium.copyWith(
                                  color: CustomColors.bgLight,
                                  fontFamily:
                                      GoogleFonts.poppins().fontFamily)),
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              ProfileImagePicker(
                                filePath: filePath,
                                imageUrl: "",
                                onPressed: () async {
                                  final file = await imagePicker();
                                  setState(() {
                                    filePath = file;
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                isObscure: false,
                                headerText: "",
                                hintText: "Name *",
                                maxLength: 30,
                                controller: firstnameController,
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your name.";
                                  }
                                  if (value.length < 3) {
                                    return "Name should be at least 3 characters.";
                                  }
                                  return null;
                                },
                              ),
                              CustomTextField(
                                isObscure: false,
                                headerText: "",
                                hintText: "Surname *",
                                maxLength: 30,
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'),
                                  ),
                                ],
                                controller: lastnameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your surname.";
                                  }
                                  if (value.length < 3) {
                                    return "Surname should be at least 3 characters.";
                                  }
                                  return null;
                                },
                              ),
                              CustomTextField(
                                isObscure: false,
                                headerText: "",
                                hintText: "Age *",
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                maxLength: 3,
                                keyboardType: TextInputType.number,
                                controller: ageController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Age is required.";
                                  }
                                  if (int.parse(value) < 18) {
                                    return "Age has to be greater than 18";
                                  }
                                  if (int.parse(value) > 150) {
                                    return "Age has to be less than 150";
                                  }
                                  return null;
                                },
                              ),
                              CustomDropdownButton(
                                items: genderlist,
                                title: "Gender *",
                                onChanged: (value) {
                                  gender = value!;
                                },
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
                                initVal: selectedState,
                                title: "State *",
                                onChanged: (value) {
                                  setState(() {
                                    selectedState = value!;
                                    cityDistrict = [
                                      const DropdownMenuItem(
                                        value: -1,
                                        child: CustomText("City/District",
                                            color: CustomColors.info),
                                      )
                                    ];
                                    selectedCity = -1;
                                    context
                                        .read<AuthCubit>()
                                        .getCities(selectedState!.toString());
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
                                title: "City/District *",
                                initVal: selectedCity,
                                onChanged: (value) {
                                  selectedCity = value!;
                                },
                                validator: (value) {
                                  if (value == null || value == -1) {
                                    return "Select your city or district.";
                                  }
                                  return null;
                                },
                              ),
                              // CustomTextField(
                              //   isObscure: false,
                              //   headerText: "",
                              //   hintText: "City",
                              //   controller: cityController,
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return "City cannot be empty";
                              //     }
                              //     return null;
                              //   },
                              // ),
                              // CustomTextField(
                              //   isObscure: false,
                              //   headerText: "",
                              //   hintText: "Town",
                              //   controller: townController,
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return "town cannot be empty";
                              //     }
                              //     return null;
                              //   },
                              // ),
                              // CustomTextField(
                              //   isObscure: false,
                              //   headerText: "",
                              //   hintText: "Village",
                              //   controller: villageController,
                              //   validator: (value) {
                              //     if (value!.isEmpty) {
                              //       return "village cannot be empty";
                              //     }
                              //     return null;
                              //   },
                              // ),
                              const SizedBox(height: 8),
                              // CustomDropdownButton(
                              //   items: village_town,
                              //   title: "Village/Town",
                              //   onChanged: (value) {
                              //     villageTown = value!;
                              //   },
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return "Village/Town is required";
                              //     }
                              //     return null;
                              //   },
                              // ),
                              CustomTextField(
                                isObscure: false,
                                headerText: "",
                                hintText: "Village/Town",
                                maxLength: 30,
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  if (value.length < 3) {
                                    return "Village/Town should be at least 3 characters.";
                                  }
                                  return null;
                                },
                                controller: villageController,
                              ),

                              // const SizedBox(height: 8),
                              CustomTextField(
                                isObscure: false,
                                headerText: "",
                                hintText: "Phone Number *",
                                maxLength: 15,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Phone cannot be empty";
                                  }
                                  if (!RegExp(r'^[6-9]\d{9}$')
                                      .hasMatch(value)) {
                                    return "Enter a valid phone number.";
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
                                hintText: "Alternate Phone Number",
                                controller: altPhoneController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value == phoneController.text) {
                                    return "Alternate phone number cannot be same as phone number";
                                  }
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      !RegExp(r'^[6-9]\d{9}$')
                                          .hasMatch(value)) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                              ),

                              if (state is AuthFailure)
                                ErrorText(errorText: state.message),
                              CustomButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return const OtpPage(
                                  //         phoneNumber: "",
                                  //         route: LoginPage.routeName,
                                  //       );
                                  //     },
                                  //   ),
                                  // );

                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().signUp(
                                      {
                                        "name": firstnameController.text,
                                        "surname": lastnameController.text,
                                        "age": ageController.text,
                                        "gender": gender,
                                        "city": selectedCity,
                                        "town": villageController.text,
                                        "state": selectedState,
                                        "phone": phoneController.text,
                                        "altPhone": altPhoneController.text,
                                        "profile": filePath
                                      },
                                    );
                                  }
                                },
                                text: "Register Now!",
                                isBold: true,
                                isLoading: state is AuthLoading,
                                height: 54,
                                width: MediaQuery.sizeOf(context).width,
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  text:
                                      "Already have an account?", // Static text
                                  style: CustomTypography.bodyLarge.copyWith(
                                    color: CustomColors.bgLight,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ), // Default text style
                                  children: [
                                    TextSpan(
                                      text: " Sign in", // Hyperlink 2
                                      style:
                                          CustomTypography.bodyLarge.copyWith(
                                        color: CustomColors.secondary,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            LoginPage.routeName,
                                            (routes) => false,
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24)
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
