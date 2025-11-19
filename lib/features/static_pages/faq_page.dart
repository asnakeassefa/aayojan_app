import 'dart:developer';

import 'package:aayojan/core/widgets/content_text.dart';
import 'package:aayojan/core/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/theme/custom_colors.dart';
import '../../core/theme/custom_typo.dart';
import '../../core/utility/faq_content.dart';
import '../../core/widgets/custom_text_field.dart';
import '../app.dart';
import '../notification/presentation/pages/notification_page.dart';
import '../profile/presentation/bloc/profile_cubit.dart';
import '../profile/presentation/bloc/profile_state.dart';
import '../profile/presentation/pages/profile_page.dart';

class FAQPage extends StatefulWidget {
  static const String routeName = '/faq';
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  String profilePicture = "";
  List isExpanded = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    getProfilePic();
    super.initState();
  }

  void getProfilePic() async {
    final image =
        await const FlutterSecureStorage().read(key: 'profilePic') ?? "";

    setState(() {
      profilePicture = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    // getProfilePic();
    return Scaffold(
        backgroundColor: CustomColors.bgLight,
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomePage.routeName, (route) => false);
                },
                child: SvgPicture.asset(
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
                Navigator.pushNamed(context, UpdateProfile.routeName);
              },
              icon: CircleAvatar(
                backgroundColor: CustomColors.bgSecondary,
                backgroundImage: NetworkImage(profilePicture),
                radius: 18,
                child: profilePicture.isEmpty
                    ? SvgPicture.asset(
                        'assets/icons/person.svg',
                        colorFilter: const ColorFilter.mode(
                            CustomColors.bgTeritary, BlendMode.srcIn),
                        height: 16,
                        width: 16,
                      )
                    : const SizedBox(),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  hintText: "Search FAQs",
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
                  onChanged: (value) {
                    // check for Faq
                  },
                  controller: searchController,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleText(
                    text: 'FAQ',
                  ),
                  const SizedBox(height: 10),
                  Column(
                    // Title with + icon in the right and when it tapped it will expand and show the content
                    children: faqContent
                        .map((e) => Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: CustomColors.bgLight,
                                    border: Border(
                                      // on top only
                                      bottom: BorderSide(
                                        color: CustomColors.primary,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isExpanded.contains(e.title)) {
                                              isExpanded.remove(e.title);
                                            } else {
                                              isExpanded.add(e.title);
                                            }
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width -
                                                        100,
                                                child:
                                                    TitleText(text: e.title)),
                                            SvgPicture.asset(
                                              'assets/icons/plus.svg',
                                              height: 24,
                                              width: 24,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (isExpanded.contains(e.title))
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          child: ContentText(text: e.content),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          ],
        )));
  }
}
