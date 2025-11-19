import 'package:aayojan/core/utility/how_it_works_content.dart';
import 'package:aayojan/features/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/theme/custom_colors.dart';
import '../../core/theme/custom_typo.dart';
import '../../core/widgets/content_text.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/title_text.dart';
import '../notification/presentation/pages/notification_page.dart';
import '../profile/presentation/pages/profile_page.dart';

class HowItWork extends StatefulWidget {
  static const String routeName = '/how_it_work';
  const HowItWork({super.key});

  @override
  State<HowItWork> createState() => _HowItWorkState();
}

class _HowItWorkState extends State<HowItWork> {
  String profilePicture = "";
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
                  hintText: "Search",
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
            // List of How It Works title and content
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TitleText(
                text: "How It Works",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: howItWorksContent.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(
                            text: howItWorksContent[index].title,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 10),
                          ContentText(
                            text: howItWorksContent[index].content,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),
              ),
            ),
          ],
        )));
  }
}
