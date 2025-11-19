import 'package:aayojan/core/theme/custom_colors.dart';
import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/widgets/custom_button2.dart';
import 'package:aayojan/features/app.dart';
import 'package:aayojan/features/invitation/presentation/bloc/invitation_cubit.dart';
import 'package:aayojan/features/invitation/presentation/pages/invitation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/di/injection.dart';

class Menu extends StatefulWidget {
  static const routeName = '/menu';
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/logo.svg',
              ),
              const SizedBox(height: 24),
              CustomButtonOut(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomePage.routeName, (route) => false);
                },
                backgroundColor: CustomColors.primary,
                borderColor: CustomColors.bgLight,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/dashboard.svg',
                      color: CustomColors.tertiary,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'View Dashboard as Host',
                      style: CustomTypography.bodyLarge.copyWith(
                        color: CustomColors.bgLight,
                      ),
                    ),
                  ],
                ),
                isLoading: false,
                height: 54,
                width: double.infinity,
              ),
              const SizedBox(height: 24),
              CustomButtonOut(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return BlocProvider(
                      create: (context) =>
                          getIt<InvitationCubit>()..getInvitations(""),
                      child: const InvitationPage(),
                    );
                  }), (route) => false);
                },
                backgroundColor: CustomColors.primary,
                borderColor: CustomColors.bgLight,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/wedding_invitation.png',
                      color: CustomColors.tertiary,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'View Invitations',
                      style: CustomTypography.bodyLarge.copyWith(
                        color: CustomColors.bgLight,
                      ),
                    ),
                  ],
                ),
                isLoading: false,
                height: 54,
                width: double.infinity,
              )
            ],
          ),
        ),
      ),
    );
  }
}
