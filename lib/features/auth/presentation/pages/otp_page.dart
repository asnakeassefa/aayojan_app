import 'dart:developer';

import 'package:aayojan/core/widgets/error_text.dart';
import 'package:aayojan/core/widgets/success_text.dart';
import 'package:aayojan/features/app.dart';
import 'package:aayojan/features/dashboard/presentation/page/dashboard_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/widgets/custom_button.dart';
// import '../../../app.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class OtpPage extends StatefulWidget {
  static const routeName = "/otp_page";

  final String phoneNumber;
  const OtpPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otp = "";
  bool filled = false;
  // lets do count down timer
  int currSecond = 60;
  bool isResendActive = true;
  TextEditingController otpController = TextEditingController();
  bool otpSent = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is OtpSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }

            if (state is AuthFailure) {
              // make the otp sent true for 10 seconds only
              setState(() {
                otpSent = false;
              });
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          SvgPicture.asset('assets/images/logo.svg'),
                          Center(
                            child: Text(
                              'Enter OTP',
                              style: CustomTypography.titleMedium
                                  .copyWith(color: CustomColors.bgLight),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Enter the OTP sent to your phone number',
                              style: CustomTypography.bodyLarge
                                  .copyWith(color: CustomColors.info),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Pinput(
                            length: 6,
                            controller: otpController,
                            focusedPinTheme: PinTheme(
                              textStyle: const TextStyle(
                                color: CustomColors.bgLight,
                              ),
                              decoration: BoxDecoration(
                                color: CustomColors.primaryLight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: CustomColors.bgLight,
                                  width: 2,
                                ),
                              ),
                              width: 60,
                              height: 60,
                            ),
                            defaultPinTheme: PinTheme(
                              textStyle: const TextStyle(
                                color: CustomColors.bgLight,
                              ),
                              decoration: BoxDecoration(
                                color: CustomColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              width: 60,
                              height: 60,
                            ),
                            onCompleted: (value) {
                              otp = value;
                              setState(() {
                                filled = true;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      if (state is AuthFailure)
                        ErrorText(errorText: state.message),
                      if (state is AuthSuccess)
                        // show success message
                        SuccessText(successText: state.success),

                      CustomButton(
                        onPressed: () {
                          context.read<AuthCubit>().verifyOTP(
                              widget.phoneNumber, otpController.text);
                        },
                        isDisabled: !filled,
                        text: "Verify",
                        isLoading: state is AuthLoading,
                        height: 54,
                        width: MediaQuery.sizeOf(context).width * 0.7,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          
                          TextButton(
                            onPressed: () {
                              if (isResendActive) {
                                log(widget.phoneNumber);
                                context.read<AuthCubit>().resendOTP(
                                      widget.phoneNumber,
                                    );
                                setState(() {
                                  isResendActive = false;
                                });
                                setState(() {
                                  currSecond = 60;
                                });
                                Future.delayed(const Duration(seconds: 1), () {
                                  if (mounted) {
                                    setState(() {
                                      currSecond--;
                                    });
                                  }
                                });
                                // Start countdown timer
                                Future.doWhile(() async {
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  if (mounted && currSecond > 0) {
                                    setState(() {
                                      currSecond--;
                                    });
                                    return true;
                                  }
                                  if (mounted) {
                                    setState(() {
                                      isResendActive = true;
                                    });
                                  }
                                  return false;
                                });
                              }
                            },
                            child: Text(
                              isResendActive
                                  ? "Resend OTP"
                                  : "Resend OTP ($currSecond)",
                              style: CustomTypography.bodyLarge.copyWith(
                                color: isResendActive
                                    ? CustomColors.secondary
                                    : CustomColors.info,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   width: MediaQuery.sizeOf(context).width * 0.8,
                      //   child: Center(
                      //     child: RichText(
                      //       text: TextSpan(
                      //         text: "Didn\’t receive code? ", // Static text
                      //         style: CustomTypography.subHeadLarge.copyWith(
                      //           color: isResendActive
                      //               ? CustomColors.bgLight
                      //               : CustomColors.info,
                      //           fontFamily: GoogleFonts.poppins().fontFamily,
                      //         ), // Default text style
                      //         children: [
                      //           TextSpan(
                      //             text: "Resend again", // Hyperlink 1
                      //             style: CustomTypography.bodyLarge.copyWith(
                      //               color: isResendActive
                      //                   ? CustomColors.secondary
                      //                   : CustomColors.info,
                      //               fontFamily:
                      //                   GoogleFonts.poppins().fontFamily,
                      //             ),
                      //             recognizer: TapGestureRecognizer()
                      //               ..onTap = () {
                      //                 if (isResendActive) {
                      //                   log(widget.phoneNumber);
                      //                   context.read<AuthCubit>().resendOTP(
                      //                         widget.phoneNumber,
                      //                       );
                      //                   setState(() {
                      //                     isResendActive = false;
                      //                   });
                      //                   Future.delayed(
                      //                       const Duration(seconds: 10), () {
                      //                     setState(() {
                      //                       isResendActive = true;
                      //                     });
                      //                   });
                      //                 }
                      //               },
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
