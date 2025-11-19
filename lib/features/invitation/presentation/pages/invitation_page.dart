import 'dart:developer';

import 'package:aayojan/core/utility/date_formater.dart';
import 'package:aayojan/features/app.dart';
import 'package:aayojan/features/dashboard/presentation/page/dashboard_page.dart';
import 'package:aayojan/features/invitation/presentation/bloc/invitation_cubit.dart';
import 'package:aayojan/features/menu/menu_page.dart';
import 'package:aayojan/features/notification/presentation/pages/notification_page.dart';
import 'package:aayojan/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:aayojan/features/profile/presentation/bloc/profile_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../data/model/invitation_model.dart';
import '../bloc/invitation_state.dart';
import '../widgets/invitation_card.dart';
import 'event_detail_page.dart';

class InvitationPage extends StatefulWidget {
  static const routeName = '/invitation_page';
  final String? imagePath;
  const InvitationPage({super.key, this.imagePath});

  @override
  State<InvitationPage> createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage> {
  final PageController controller =
      PageController(viewportFraction: 0.8, initialPage: 1);

  TextEditingController searchController = TextEditingController();
  BuildContext? parContext;
  List<String> params = [];
  List<EventData> invitations = [];
  bool accepted = false;
  bool rejected = false;
  bool pending = false;
  String profilePicture = "";
  bool isEmpty = false;

  // add focus node
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getProfilePic();
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
    parContext = context;
    return Scaffold(
      backgroundColor: CustomColors.bgLight,
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.pushNamedAndRemoveUntil(
                //     context, HomePage.routeName, (route) => false);
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
              Navigator.pushNamed(context, UpdateProfile.routeName).then(
                (value) {
                  getProfilePic();
                },
              );
            },
            icon: CircleAvatar(
              backgroundColor: CustomColors.bgSecondary,
              backgroundImage: NetworkImage(profilePicture),
              radius: 18,
              child: profilePicture.isEmpty
                  ? SvgPicture.asset(
                      'assets/icons/person.svg',
                      colorFilter: const ColorFilter.mode(
                        CustomColors.bgTeritary,
                        BlendMode.srcIn,
                      ),
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
          focusNode.unfocus();
        },
        child: Column(
          children: [
            Container(
              color: CustomColors.bgLight,
              child: Container(
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
                    hintText: "Search invitation",
                    prefix: Container(
                      margin: const EdgeInsets.only(left: 16, right: 8),
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        height: 32,
                        width: 32,
                        color: CustomColors.bgLight,
                      ),
                    ),
                    focusNode: focusNode,
                    fillColor: Colors.black.withOpacity(0.4),
                    controller: searchController,
                    onChanged: (value) {
                      log(value);
                      context.read<InvitationCubit>().getInvitations(value);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text(
                          "Invitations",
                          style: CustomTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            // show popup 100 by 100 on the right of the screen with checkbox inside to select values

                            showDialog(
                              context: context,
                              builder: (context) =>
                                  StatefulBuilder(builder: (context, setState) {
                                return FluidDialog(
                                  // Set the first page of the dialog.
                                  rootPage: FluidDialogPage(
                                    alignment: const Alignment(1, -0.8),
                                    //Aligns the dialog to the bottom left.
                                    builder: (context) => SizedBox(
                                      height: 150,
                                      width: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                  value: accepted,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      accepted = value!;
                                                      if (accepted) {
                                                        pending = false;
                                                        rejected = false;
                                                        parContext!
                                                            .read<
                                                                InvitationCubit>()
                                                            .getInvitations(
                                                                "Accept with thanks");
                                                      } else {
                                                        parContext!
                                                            .read<
                                                                InvitationCubit>()
                                                            .getInvitations("");
                                                      }
                                                    });
                                                    // select all
                                                  }),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Accepted",
                                                style: CustomTypography
                                                    .bodyLarge
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                  value: rejected,
                                                  onChanged: (value) {
                                                    // select all
                                                    setState(() {
                                                      rejected = value!;
                                                      if (rejected) {
                                                        pending = false;
                                                        accepted = false;
                                                        parContext!
                                                            .read<
                                                                InvitationCubit>()
                                                            .getInvitations(
                                                                "Not able to attend");
                                                      } else {
                                                        parContext!
                                                            .read<
                                                                InvitationCubit>()
                                                            .getInvitations("");
                                                      }
                                                    });
                                                  }),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Rejected",
                                                style: CustomTypography
                                                    .bodyLarge
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                  value: pending,
                                                  onChanged: (value) {
                                                    // select all
                                                    setState(() {
                                                      pending = value!;
                                                      if (pending) {
                                                        rejected = false;
                                                        accepted = false;
                                                        parContext!
                                                            .read<
                                                                InvitationCubit>()
                                                            .getInvitations(
                                                                "Not sure to attend");
                                                      } else {
                                                        parContext!
                                                            .read<
                                                                InvitationCubit>()
                                                            .getInvitations("");
                                                      }
                                                    });
                                                  }),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Pending",
                                                style: CustomTypography
                                                    .bodyLarge
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ), // This can be any widget.
                                  ),
                                );
                              }),
                            );
                          },
                          icon: const Icon(Icons.more_vert),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocConsumer<InvitationCubit, InvitationState>(
                    listener: (context, state) {
                      if (state is InvitationLoaded) {
                        invitations = state.invitation.data?.data ?? [];

                        if (invitations.isEmpty) {
                          setState(() {
                            isEmpty = true;
                          });
                        } else {
                          setState(() {
                            isEmpty = false;
                          });
                        }
                      }
                      // if (state is InvitationFailure) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       backgroundColor: CustomColors.error,
                      //       content: Text(state.message),
                      //     ),
                      //   );
                      // }
                    },
                    builder: (context, state) {
                      if (state is InvitationLoading) {
                        return SizedBox(
                          height: MediaQuery.sizeOf(context).height * .6,
                          child: const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }

                      if (state is InvitationLoaded) {
                        // Group invitations by mainEventId
                        final Map<String, List<EventData>> groupedInvitations =
                            {};
                        for (var invitation in invitations) {
                          final key = invitation.mainEventId.toString();
                          if (!groupedInvitations.containsKey(key)) {
                            groupedInvitations[key] = [];
                          }
                          groupedInvitations[key]!.add(invitation);
                        }
                        return isEmpty
                            ? SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.5,
                                child: Center(
                                  child: Container(
                                    height: 170,
                                    width: 170,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          CustomColors.bgLight.withOpacity(0.1),
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        opacity: 0.3,
                                        image: AssetImage(
                                            'assets/images/logo.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        // children: invitations.map(
                                        //   (e) {
                                        //     return InvitationCard(
                                        //       status: e.status.toString(),
                                        //       title: (e.subEvent?.title ?? "")
                                        //               .isNotEmpty
                                        //           ? "${(e.subEvent?.title ?? "")[0].toUpperCase()}${(e.subEvent?.title ?? "").substring(1)}"
                                        //           : "",
                                        //       date: formatDate(
                                        //           e.subEvent?.startDate ?? ""),
                                        //       onPressed: () {
                                        //         Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //             builder: (context) {
                                        //               return EventDetailPage(
                                        //                 mainEventId: e
                                        //                     .mainEventId
                                        //                     .toString(),
                                        //                 isAccepted: e
                                        //                         .guestResponsePreferences ==
                                        //                     'Accept with thanks',
                                        //                 startDate: e.subEvent
                                        //                         ?.startDate ??
                                        //                     DateTime.now()
                                        //                         .toString(),
                                        //                 endDate: e.subEvent
                                        //                         ?.endDate ??
                                        //                     DateTime.now()
                                        //                         .toString(),
                                        //                 time: formatTime(
                                        //                     e.subEvent?.time ??
                                        //                         ""),
                                        //                 title:
                                        //                     e.subEvent?.title ??
                                        //                         "",
                                        //                 imagePath:
                                        //                     "${Endpoints.imageUrl}${e.subEvent?.document}",
                                        //                 id: "${e.id}",
                                        //               );
                                        //             },
                                        //           ),
                                        //         ).then((value) {
                                        //           if (value != null &&
                                        //               value is bool &&
                                        //               value) {
                                        //             context
                                        //                 .read<InvitationCubit>()
                                        //                 .getInvitations("");
                                        //           }
                                        //         });
                                        //         // Navigator.pushNamed(
                                        //         //     context, EventDetailPage.routeName);
                                        //       },
                                        //       imagePath:
                                        //           'assets/icons/ring.png',
                                        //     );
                                        //   },
                                        // ).toList(),
                                        children: groupedInvitations.entries
                                            .map((entry) {
                                          final mainEventId = entry.key;
                                          final mainEvent =
                                              entry.value.first.mainEvent;

                                          return InvitationCard(
                                            status:
                                                mainEvent!.status.toString(),
                                            title: (mainEvent.title ?? "")
                                                    .isNotEmpty
                                                ? "${(mainEvent.title ?? "")[0].toUpperCase()}${(mainEvent.title ?? "").substring(1)}"
                                                : "",
                                            date: formatDate(
                                                mainEvent.startDate ?? ""),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return EventDetailPage(
                                                      subEvents:
                                                          groupedInvitations[
                                                                  mainEventId] ??
                                                              [],
                                                      // mainEventId: mainEventId,
                                                      // isAccepted:
                                                      //     'Accept with thanks' ==
                                                      //         'Accept with thanks',
                                                      // startDate:
                                                      //     mainEvent.startDate ??
                                                      //         DateTime.now()
                                                      //             .toString(),
                                                      // endDate:
                                                      //     mainEvent.endDate ??
                                                      //         DateTime.now()
                                                      //             .toString(),
                                                      // time: formatTime(
                                                      //     mainEvent.time ?? ""),
                                                      title:
                                                          mainEvent.title ?? "",
                                                      // imagePath:
                                                      //     "${Endpoints.imageUrl}${mainEvent.document}",
                                                      id: "${mainEvent.id}",
                                                    );
                                                  },
                                                ),
                                              ).then((value) {
                                                if (value != null &&
                                                    value is bool &&
                                                    value) {
                                                  context
                                                      .read<InvitationCubit>()
                                                      .getInvitations("");
                                                }
                                              });
                                            },
                                            imagePath: 'assets/icons/ring.png',
                                          );
                                        }).toList(),
                                      ),
                                      // SizedBox(
                                      //   height: 120,
                                      //   child: PageView(
                                      //     controller: controller,
                                      //     scrollDirection: Axis.horizontal,
                                      //     children: [
                                      //       Container(
                                      //         height: 120,
                                      //         width: double.infinity,
                                      //         margin: const EdgeInsets.symmetric(
                                      //             horizontal: 8),
                                      //         decoration: BoxDecoration(
                                      //           color: Colors.black.withOpacity(0.7),
                                      //           borderRadius: BorderRadius.circular(8),
                                      //           image: const DecorationImage(
                                      //             fit: BoxFit.cover,
                                      //             opacity: 0.7,
                                      //             image: NetworkImage(
                                      //               "https://s3-alpha-sig.figma.com/img/3cd3/3605/3b78a40cb246db8cba7adf680ea7ab3c?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=haUu-8FpDJNjgJpQSJyg98E0vWIqKxHJ78fOYdlw2ZZyzogsWXjWVNdy1bXBCqsCvc3FqqEHl08rnxFaUBr5QyeoRX3Q0-EgaRtXM6yayfx8wapCDmb~1SFZRwxXxnAztbReDAinMSRifysDXAIiucZIHh28lGwDUvfpTDUfFm2kYQdf0fRaZCriIENCEZMIpfrP3U4rS3O8dL6cUrhyktoWz-QE4jiYThPxRnGrU3dC7sUtrHMuaFqRB25wjmsBZsbbu7a1KhTj6mSq0hJFIgdEFV6F-GOsVgTdxEYRJ4O7TNyMPmj8366IgJp9CoxJXr9vPSwn64TiYq9qUJDZZw__",
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         height: 120,
                                      //         width: double.infinity,
                                      //         margin: const EdgeInsets.symmetric(
                                      //             horizontal: 8),
                                      //         decoration: BoxDecoration(
                                      //           color: Colors.black.withOpacity(0.7),
                                      //           borderRadius: BorderRadius.circular(8),
                                      //           image: const DecorationImage(
                                      //             fit: BoxFit.cover,
                                      //             opacity: 0.7,
                                      //             image: NetworkImage(
                                      //               "https://s3-alpha-sig.figma.com/img/3cd3/3605/3b78a40cb246db8cba7adf680ea7ab3c?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=haUu-8FpDJNjgJpQSJyg98E0vWIqKxHJ78fOYdlw2ZZyzogsWXjWVNdy1bXBCqsCvc3FqqEHl08rnxFaUBr5QyeoRX3Q0-EgaRtXM6yayfx8wapCDmb~1SFZRwxXxnAztbReDAinMSRifysDXAIiucZIHh28lGwDUvfpTDUfFm2kYQdf0fRaZCriIENCEZMIpfrP3U4rS3O8dL6cUrhyktoWz-QE4jiYThPxRnGrU3dC7sUtrHMuaFqRB25wjmsBZsbbu7a1KhTj6mSq0hJFIgdEFV6F-GOsVgTdxEYRJ4O7TNyMPmj8366IgJp9CoxJXr9vPSwn64TiYq9qUJDZZw__",
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         child: const Center(
                                      //           child: Text('Page 2'),
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         height: 120,
                                      //         width: double.infinity,
                                      //         margin: const EdgeInsets.symmetric(
                                      //             horizontal: 8),
                                      //         decoration: BoxDecoration(
                                      //           color: Colors.black.withOpacity(0.7),
                                      //           borderRadius: BorderRadius.circular(8),
                                      //           image: const DecorationImage(
                                      //             fit: BoxFit.cover,
                                      //             opacity: 0.7,
                                      //             image: NetworkImage(
                                      //               "https://s3-alpha-sig.figma.com/img/3cd3/3605/3b78a40cb246db8cba7adf680ea7ab3c?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=haUu-8FpDJNjgJpQSJyg98E0vWIqKxHJ78fOYdlw2ZZyzogsWXjWVNdy1bXBCqsCvc3FqqEHl08rnxFaUBr5QyeoRX3Q0-EgaRtXM6yayfx8wapCDmb~1SFZRwxXxnAztbReDAinMSRifysDXAIiucZIHh28lGwDUvfpTDUfFm2kYQdf0fRaZCriIENCEZMIpfrP3U4rS3O8dL6cUrhyktoWz-QE4jiYThPxRnGrU3dC7sUtrHMuaFqRB25wjmsBZsbbu7a1KhTj6mSq0hJFIgdEFV6F-GOsVgTdxEYRJ4O7TNyMPmj8366IgJp9CoxJXr9vPSwn64TiYq9qUJDZZw__",
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         child: const Center(
                                      //           child: Text('Page 3'),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                      }

                      if (state is InvitationFailure) {
                        return Center(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * .5,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.message,
                                    style: CustomTypography.bodyLarge.copyWith(
                                      color: CustomColors.error,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomButton(
                                    onPressed: () {
                                      context
                                          .read<InvitationCubit>()
                                          .getInvitations("");
                                    },
                                    text: "Retry",
                                    isLoading: false,
                                    height: 40,
                                    width: 120,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
