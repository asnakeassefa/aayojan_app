import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/utility/router.dart';
import 'package:aayojan/core/widgets/custom_button.dart';
import 'package:aayojan/features/auth/presentation/pages/login_page.dart';
import 'package:aayojan/features/dashboard/presentation/page/dashboard_page.dart';
import 'package:aayojan/features/invitation/presentation/bloc/invitation_cubit.dart';
import 'package:aayojan/features/invitation/presentation/pages/invitation_page.dart';
import 'package:aayojan/features/manage_family/presentation/pages/familiy_member_page.dart';
import 'package:aayojan/features/menu/menu_page.dart';
import 'package:aayojan/features/my_event/presentation/pages/my_event_page.dart';
import 'package:aayojan/features/plan_sub_event/presentation/pages/plan_sub_event_page.dart';
import 'package:aayojan/features/static_pages/faq_page.dart';
import 'package:aayojan/features/static_pages/how_it_work.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../core/di/injection.dart';
import '../core/theme/custom_colors.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key, this.title, this.index});
  final int? index;
  final String? title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  PageController pageController = PageController();

  // var _bottomNavIndex = 1; //default index of a first screen
  // List menuIconList = [
  //   Ionicons.home_outline,
  //   Ionicons.ice_cream,
  // ];
  // List menuIconActiveList = [
  //   Ionicons.home,
  //   Ionicons.logo_soundcloud,
  // ];
  // List<String> menuTitleList = <String>["Home", 'Host An Event'];
  // List<Widget> _pages = <Widget>[
  //   DashboardPage(),
  //   const PlanSubEventPage(),
  // ];

  final List<Widget> bottomBarPages = [
    BlocProvider(
      create: (context) => getIt<InvitationCubit>()..getInvitations(""),
      child: const InvitationPage(),
    ),
    const DashboardPage(),
    const FamiliyMemberPage(),
    const MyEventPage(),
    const FAQPage(),
    const HowItWork()
  ];

  int selected = 0;
  var heart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      pageController = PageController(initialPage: widget.index ?? 0);
      // check if the index is greater than 2 then set the index to 1
      if (widget.index != null && widget.index! > 2) {
        selected = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
              bottomBarPages.length, (index) => bottomBarPages[index]),
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 54,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomNavButton(
                iconPath: 'assets/icons/home.svg',
                isSelected: selected == 0,
                name: 'Home',
                onTap: () {
                  pageController.jumpToPage(0);
                  setState(() {
                    selected = 0;
                  });
                },
                width: MediaQuery.sizeOf(context).width / 4.5,
              ),
              const VerticalDivider(
                thickness: 2,
                width: 2,
                color: CustomColors.info,
              ),
              BottomNavButton(
                iconPath: 'assets/icons/speeker.svg',
                isSelected: selected == 1,
                name: 'Host Event',
                onTap: () {
                  pageController.jumpToPage(1);
                  setState(() {
                    selected = 1;
                  });
                },
                width: MediaQuery.sizeOf(context).width / 4.5,
              ),
              const VerticalDivider(
                thickness: 2,
                width: 2,
                color: CustomColors.info,
              ),
              BottomNavButton(
                iconPath: 'assets/icons/family.svg',
                isSelected: selected == 2,
                name: 'My Family',
                onTap: () {
                  pageController.jumpToPage(2);
                  setState(() {
                    selected = 2;
                  });
                },
                width: MediaQuery.sizeOf(context).width / 4.5,
              ),
              const VerticalDivider(
                thickness: 2,
                color: CustomColors.info,
                width: 2,
              ),
              BottomNavButton(
                iconPath: 'assets/icons/logout.svg',
                isSelected: selected == 3,
                name: 'Logout',
                onTap: () async {
                  // show dialog box for warning

                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  await const FlutterSecureStorage()
                                      .deleteAll();
                                  if (await const FlutterSecureStorage()
                                          .containsKey(key: 'accessToken') ==
                                      false) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        LoginPage.routeName, (route) => false);
                                  }
                                },
                                child: const Text('Yes')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'))
                          ],
                        );
                      });

                  // await const FlutterSecureStorage().delete(key: 'accessToken');
                  // if (await const FlutterSecureStorage()
                  //         .containsKey(key: 'accessToken') ==
                  //     false) {
                  //   Navigator.pushNamedAndRemoveUntil(
                  //       context, LoginPage.routeName, (route) => false);
                  // }
                },
                width: MediaQuery.sizeOf(context).width / 4.5,
              ),
            ],
          ),
        ),
      ),
      // extendBody: true,
      // bottomNavigationBar: StylishBottomBar(
      //   backgroundColor: CustomColors.primary,
      //   option: AnimatedBarOptions(
      //       // iconSize: 32,
      //       barAnimation: BarAnimation.fade,
      //       iconStyle: IconStyle.simple,
      //       opacity: 0.8),
      //   items: [
      //     BottomBarItem(
      //         backgroundColor: Colors.black,
      //         borderColor: CustomColors.info,
      //         icon: const BottomIcon(
      //           imageName: 'assets/icons/home.svg',
      //           color: CustomColors.info,
      //           text: 'Home',
      //         ),
      //         selectedIcon: const BottomIcon(
      //           color: CustomColors.bgLight,
      //           imageName: 'assets/icons/home.svg',
      //           text: 'Home',
      //         ),
      //         // backgroundColor: Colors.,

      //         selectedColor: Colors.white,
      //         unSelectedColor: const Color(0xffd4d4d8),
      //         title: const Text('Home')),
      //     BottomBarItem(
      //       borderColor: CustomColors.info,
      //       icon: const BottomIcon(
      //         imageName: 'assets/icons/speeker.svg',
      //         color: CustomColors.info,
      //         text: 'Host An Event',
      //       ),
      //       selectedIcon: const BottomIcon(
      //         color: CustomColors.bgLight,
      //         imageName: 'assets/icons/speeker.svg',
      //         text: 'Host An Event',
      //       ),
      //       selectedColor: Colors.white,
      //       unSelectedColor: const Color(0xffd4d4d8),
      //       // backgroundColor: Colors.orange,
      //       title: const Text('Host An Event'),
      //     ),
      //     BottomBarItem(
      //         borderColor: CustomColors.info,
      //         icon: const BottomIcon(
      //           imageName: 'assets/icons/family.svg',
      //           color: CustomColors.info,
      //           text: 'My Family',
      //         ),
      //         selectedIcon: const BottomIcon(
      //           color: CustomColors.bgLight,
      //           imageName: 'assets/icons/family.svg',
      //           text: 'My Family',
      //         ),
      //         // backgroundColor: Colors.,
      //         selectedColor: Colors.white,
      //         unSelectedColor: const Color(0xffd4d4d8),
      //         title: const Text('Rejected')),
      //     BottomBarItem(
      //       borderColor: CustomColors.info,
      //       icon: const BottomIcon(
      //         imageName: 'assets/icons/logout.svg',
      //         color: CustomColors.info,
      //         text: 'Logout',
      //       ),
      //       selectedIcon: const BottomIcon(
      //         color: CustomColors.bgLight,
      //         imageName: 'assets/icons/logout.svg',
      //         text: 'Logout',
      //       ),
      //       selectedColor: Colors.white,
      //       unSelectedColor: const Color(0xffd4d4d8),
      //       // backgroundColor: Color(0xffd4d4d8),
      //       title: const Text(
      //         'Logout',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //       // badge: const Text('9+'),
      //       // showBadge: true,
      //     ),
      //   ],
      //   hasNotch: true,
      //   fabLocation: StylishBarFabLocation.center,
      //   currentIndex: selected ?? 0,
      //   onTap: (index) {
      //     pageController.jumpToPage(index);
      //     if (index == 3) {
      //       setState(() async {
      //         await const FlutterSecureStorage().delete(key: 'accessToken');
      //         if (await const FlutterSecureStorage()
      //                 .containsKey(key: 'accessToken') ==
      //             false) {
      //           Navigator.pushNamedAndRemoveUntil(
      //               context, LoginPage.routeName, (route) => false);
      //         }
      //       });
      //     } else {
      //       setState(() {
      //         selected = index;
      //       });
      //     }
      //   },
      // ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final String text;
  final String imageName;
  final Color color;
  const BottomIcon({
    super.key,
    required this.text,
    required this.imageName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(imageName,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
          Text(
            text,
            style: TextStyle(fontSize: 15, color: color),
          )
        ],
      ),
    );
  }
}

class BottomNavButton extends StatelessWidget {
  final Function onTap;
  final bool isSelected;
  final double width;
  final String iconPath;
  final String name;
  const BottomNavButton({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.width,
    required this.iconPath,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: SizedBox(
          height: 46,
          child: Column(
            // svg,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                color: isSelected ? CustomColors.bgLight : CustomColors.info,
              ),
              Text(
                name,
                style: CustomTypography.bodySmall.copyWith(
                  color: isSelected ? CustomColors.bgLight : CustomColors.info,
                ),
              )
            ],
            // name
          ),
        ),
      ),
    );
  }
}
