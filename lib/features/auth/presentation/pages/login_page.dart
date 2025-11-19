import 'dart:developer';

import 'package:aayojan/core/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/error_text.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'otp_page.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.success),
                backgroundColor: CustomColors.primary,
              ),
            );
            log('here in auth success');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return OtpPage(phoneNumber: phoneController.text);
                },
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      SvgPicture.asset('assets/images/logo.svg'),
                      SizedBox(
                        child: Text(
                          "Sign In",
                          textAlign: TextAlign.center,
                          style: CustomTypography.titleMedium.copyWith(
                            color: CustomColors.bgLight,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              isObscure: false,
                              headerText: "",
                              hintText: "Phone number *",
                              maxLength: 10,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your phone number.";
                                }
                                // check if the follows RegExp(r'^[6-9]\d{9}$')
                                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                                  return "Please enter a valid phone number.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            if (state is AuthFailure)
                              if (state.message.contains(
                                  'Validation failed The selected phone is invalid.'))
                                const ErrorText(
                                  errorText: 'Please register to get started',
                                ),
                            if (state is AuthFailure &&
                                state.message !=
                                    'Validation failed The selected phone is invalid.')
                              ErrorText(
                                errorText: state.message,
                              ),
                            CustomButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context
                                      .read<AuthCubit>()
                                      .signIn(phoneController.text);
                                }
                              },
                              isDisabled: state is AuthLoading,
                              text: "Login",
                              isLoading: state is AuthLoading,
                              height: 54,
                              width: MediaQuery.sizeOf(context).width,
                            ),
                            const SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                text: "Don\’t have an account?", // Static text
                                style: CustomTypography.bodyLarge.copyWith(
                                  color: CustomColors.bgLight,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ), // Default text style
                                children: [
                                  TextSpan(
                                    text: " Sign up", // Hyperlink 2
                                    style: CustomTypography.bodyLarge.copyWith(
                                      color: CustomColors.secondary,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, SignUpPage.routeName);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )));
        },
      ),
    );
  }
}
