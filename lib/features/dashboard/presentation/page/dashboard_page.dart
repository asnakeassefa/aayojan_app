import 'dart:developer';

import 'package:aayojan/core/di/injection.dart';
import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/features/app.dart';
import 'package:aayojan/features/dashboard/presentation/widget/menu_button.dart';
import 'package:aayojan/features/guest/presentation/pages/guest_page.dart';
import 'package:aayojan/features/invitation/presentation/bloc/invitation_cubit.dart';
import 'package:aayojan/features/invitation/presentation/bloc/invitation_state.dart';
import 'package:aayojan/features/invitation/presentation/pages/invitation_page.dart';
import 'package:aayojan/features/menu/menu_page.dart';
import 'package:aayojan/features/my_event/presentation/bloc/my_event_cubit.dart';
import 'package:aayojan/features/my_event/presentation/bloc/my_event_state.dart';
import 'package:aayojan/features/my_event/presentation/pages/my_event_page.dart';
import 'package:aayojan/features/notification/presentation/pages/notification_page.dart';
import 'package:aayojan/features/plan_event/presentation/pages/plan_event_page.dart';
import 'package:aayojan/features/plan_sub_event/presentation/pages/plan_sub_event_page.dart';
import 'package:aayojan/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:aayojan/features/profile/presentation/bloc/profile_state.dart';
import 'package:aayojan/features/profile/presentation/pages/profile_page.dart';
import 'package:aayojan/features/static_pages/faq_page.dart';
import 'package:aayojan/features/static_pages/how_it_work.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/network/endpoints.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../manage_family/presentation/pages/familiy_member_page.dart';
import '../../../plan_event/presentation/bloc/plan_event_cubit.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = PageController();
  TextEditingController searchController = TextEditingController();

  // if (state is ProfileLoaded) {
  //   setState(() {
  //     profileImage =
  //         "https://vkapsprojects.com/aayojan-app/storage/${state.profile.data?.user?.profile}";
  //   });
  // }

  String profileImage = "";
  bool visibleDashboard = true;

  @override
  void initState() {
    getProfilePic();
    super.initState();
  }

  void getProfilePic() async {
    final image =
        await const FlutterSecureStorage().read(key: 'profilePic') ?? "";
    setState(() {
      profileImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    // getProfilePic();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<MyEventCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<InvitationCubit>(),
        ),
      ],
      child: Scaffold(
          backgroundColor: CustomColors.bgLight,
          appBar: AppBar(
            title: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      HomePage.routeName,
                      (route) => false,
                    );
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/title.svg',
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, NotificationPage.routeName);
                },
                icon: SvgPicture.asset(
                  'assets/icons/notification.svg',
                  height: 24,
                  width: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, UpdateProfile.routeName)
                      .then((value) {
                    getProfilePic();
                  });
                },
                icon: CircleAvatar(
                  backgroundColor: CustomColors.bgSecondary,
                  backgroundImage: NetworkImage(
                    profileImage,
                  ),
                  radius: 18,
                  child: profileImage.isEmpty
                      ? SvgPicture.asset(
                          'assets/icons/person.svg',
                          colorFilter: const ColorFilter.mode(
                              CustomColors.bgTeritary, BlendMode.srcIn),
                          height: 16,
                          width: 16,
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 80,
                  decoration: const BoxDecoration(
                    color: CustomColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: CustomTextField(
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
                      hintText: "Search event/invitation",
                      controller: searchController,
                      onChanged: (value) {
                        // if (value.isEmpty) {
                        //   setState(() {
                        //     visibleDashboard = true;
                        //   });
                        //   context.read<ProfileCubit>().getProfile();
                        // }
                        // if (value.isNotEmpty) {
                        //   setState(() {
                        //     visibleDashboard = false;
                        //   });
                        //   context.read<MyEventCubit>().searchEvent(value);
                        //   // context.read<InvitationCubit>().getInvitations();
                        // }
                      },
                    ),
                  ),
                ),
                BlocConsumer<InvitationCubit, InvitationState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is InvitationLoaded)
                      return const SizedBox(
                        child: Text('invitation data'),
                      );

                    return const SizedBox();
                  },
                ),
                BlocConsumer<MyEventCubit, MyEventState>(
                  listener: (context, state) {
                    log((state is MyEventLoaded).toString());
                  },
                  builder: (context, state) {
                    if (state is MyeventLoading) {
                      // show loading indicator
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.7,
                        child: const Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: CustomColors.primary,
                            ),
                          ),
                        ),
                      );
                    }

                    if (state is MyEventLoaded) {
                      // list builder

                      return SizedBox(
                        height: 200,
                        child: Text('my events'),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(),
                if (visibleDashboard)
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 16),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .2,
                          child: PageView(
                            controller: controller,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.sizeOf(context).height * .2,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/dashboard_image.png"),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.sizeOf(context).height * .2,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.sizeOf(context).height * .2,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/dashboard_image.png"),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.sizeOf(context).height * .2,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.sizeOf(context).height * .2,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/dashboard_image.png"),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.sizeOf(context).height * .2,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: 3,
                            effect: const WormEffect(
                              dotWidth: 10,
                              dotHeight: 10,
                              activeDotColor: CustomColors.primary,
                              dotColor: CustomColors.info,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            MenuButton(
                              height: 120,
                              width: MediaQuery.sizeOf(context).width * .45,
                              svgPath: 'assets/icons/plan_event.svg',
                              title: 'Plan An Event',
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BlocProvider(
                                    create: (context) =>
                                        getIt<PlanEventCubit>(),
                                    child: const PlanEventPage(),
                                  );
                                })).then((value) {
                                  getProfilePic();
                                });
                              },
                            ),
                            const SizedBox(width: 16),
                            MenuButton(
                              height: 120,
                              width: MediaQuery.sizeOf(context).width * .45,
                              svgPath: 'assets/icons/my_event.svg',
                              title: 'My Events',
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      // return MyEventPage(
                                      //   imagePath: profileImage,
                                      // );
                                      return const HomePage(
                                        index: 3,
                                      );
                                    },
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                            MenuButton(
                              height: 120,
                              width: MediaQuery.sizeOf(context).width * .45,
                              svgPath: 'assets/icons/manage_guest.svg',
                              title: 'Manage Guest List',
                              onTap: () {
                                Navigator.pushNamed(
                                        context, GuestPage.routeName)
                                    .then((value) {
                                  getProfilePic();
                                });
                              },
                            ),
                            const SizedBox(width: 16),
                            MenuButton(
                              height: 120,
                              width: MediaQuery.sizeOf(context).width * .45,
                              svgPath: 'assets/icons/faq.svg',
                              title: 'FAQ',
                              onTap: () {
                                // Navigator.pushNamed(context, FAQPage.routeName)
                                //     .then((value) {
                                //   getProfilePic();
                                // });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      // return MyEventPage(
                                      //   imagePath: profileImage,
                                      // );
                                      return const HomePage(
                                        index: 4,
                                      );
                                    },
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                            MenuButton(
                              height: 120,
                              width: MediaQuery.sizeOf(context).width * .95,
                              svgPath: 'assets/icons/how_it_works.svg',
                              title: 'How It Works',
                              onTap: () {
                                // Navigator.pushNamed(
                                //   context,
                                //   HowItWork.routeName,
                                // ).then((value) {
                                //   getProfilePic();
                                // });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      // return MyEventPage(
                                      //   imagePath: profileImage,
                                      // );
                                      return const HomePage(
                                        index: 5,
                                      );
                                    },
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ],
                    ),
                  )
              ],
            ),
          )),
    );
  }
}

class Card2 extends StatelessWidget {
  final String title;
  final String path;
  final Function onPressed;
  const Card2({
    required this.title,
    required this.path,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        width: MediaQuery.sizeOf(context).width * .18,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              child: SvgPicture.asset(
                path,
                color: CustomColors.bgLight.withOpacity(0.7),
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: CustomTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class Card2Png extends StatelessWidget {
  final String title;
  final String path;
  final Function onPressed;
  const Card2Png({
    required this.title,
    required this.path,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        width: MediaQuery.sizeOf(context).width * .18,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              child: Image.asset(
                path,
                color: CustomColors.bgLight.withOpacity(0.7),
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: CustomTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final String name;
  final String iconName;
  const Card({
    super.key,
    required this.name,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: MediaQuery.sizeOf(context).width * .21,
      height: 110,
      decoration: BoxDecoration(
        color: CustomColors.primaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 20,
            child: Image.asset(
              'assets/icons/$iconName.png',
              color: CustomColors.bgLight.withOpacity(0.5),
              width: 16,
              height: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: CustomTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
