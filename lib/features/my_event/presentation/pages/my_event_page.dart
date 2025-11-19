import 'dart:developer';

import 'package:aayojan/core/widgets/custom_button.dart';
import 'package:aayojan/features/app.dart';
import 'package:aayojan/features/my_event/presentation/bloc/my_event_cubit.dart';
import 'package:aayojan/features/my_event/presentation/bloc/my_event_state.dart';
import 'package:aayojan/features/my_event/presentation/pages/my_event_detail_page.dart';
import 'package:aayojan/features/plan_event/presentation/bloc/plan_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/theme/custom_typo.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../notification/presentation/pages/notification_page.dart';
import '../../../plan_event/presentation/pages/plan_event_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../widget/event_card.dart';

class MyEventPage extends StatefulWidget {
  static const String routeName = '/my_event';
  final String? imagePath;

  const MyEventPage({super.key, this.imagePath});

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {
  TextEditingController searchController = TextEditingController();
  String profilePicture = "";

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<MyEventCubit>()..getEvents(),
        ),
      ],
      child: Scaffold(
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
            ),
          ],
        ),
        body: BlocConsumer<MyEventCubit, MyEventState>(
          listener: (context, state) {
            getProfilePic();

            // if (state is MyEventFailure) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(state.message),
            //       backgroundColor: Colors.red,
            //     ),
            //   );
            //   context.read<MyEventCubit>().getEvents();
            // }

            if (state is MyEventDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Event Deleted"),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<MyEventCubit>().getEvents();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
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
                        hintText: "Search event",
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
                          log(value);
                          context.read<MyEventCubit>().searchEvent(value);
                        },
                        controller: searchController,
                      ),
                    ),
                  ),
                  if (state is MyeventLoading)
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * .7,
                      child: const Center(
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  if (state is MyEventFailure)
                    Center(
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * .7,
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
                                  context.read<MyEventCubit>().getEvents();
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
                    ),
                  if (state is MyEventLoaded)
                    state.response.data!.data!.isEmpty
                        ? SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.7,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          CustomColors.bgLight.withOpacity(0.3),
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        opacity: 0.3,
                                        image: AssetImage(
                                            'assets/images/logo.png'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    "No Events",
                                    style: CustomTypography.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "My Events",
                                    style: CustomTypography.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height * .7,
                                    child: ListView.separated(
                                      itemCount:
                                          state.response.data?.data?.length ??
                                              0,
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 10);
                                      },
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (state.response.data
                                                    ?.data?[index] ==
                                                null) {
                                              return;
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return MyEventDetailPage(
                                                      event: state.response
                                                          .data!.data![index]);
                                                },
                                              ),
                                            ).then(
                                              (value) {
                                                if (value == true) {
                                                  context
                                                      .read<MyEventCubit>()
                                                      .getEvents();
                                                }
                                              },
                                            );
                                          },
                                          child: EventCard(
                                            title: state.response.data
                                                    ?.data?[index].title ??
                                                '',
                                            imagePath:
                                                "${Endpoints.imageUrl}${state.response.data?.data?[index].document}",
                                            date: state.response.data
                                                    ?.data?[index].startDate ??
                                                "",
                                            time: "",
                                            onDelete: () {
                                              // context
                                              //     .read<MyEventCubit>()
                                              //     .deleteEvent(state.response
                                              //             .data?.data?[index].id
                                              //             .toString() ??
                                              //         "");

                                              // show the dialog
                                              showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return BlocProvider.value(
                                                    value: context
                                                        .read<MyEventCubit>(),
                                                    child: AlertDialog(
                                                      title: const Text(
                                                          "Delete Event"),
                                                      content: const Text(
                                                          "Are you sure you want to delete this event?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                dialogContext);
                                                          },
                                                          child:
                                                              const Text("No"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            log('here');
                                                            context
                                                                .read<
                                                                    MyEventCubit>()
                                                                .deleteEvent(state
                                                                        .response
                                                                        .data
                                                                        ?.data?[
                                                                            index]
                                                                        .id
                                                                        .toString() ??
                                                                    "");
                                                            Navigator.pop(
                                                                dialogContext);
                                                          },
                                                          child:
                                                              const Text("Yes"),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            onTap: () {
                                              log(
                                                state.response.data
                                                        ?.data?[index].id
                                                        .toString() ??
                                                    "",
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return BlocProvider(
                                                      create: (context) =>
                                                          getIt<
                                                              PlanEventCubit>()
                                                            ..getEventDetails(
                                                              state
                                                                      .response
                                                                      .data
                                                                      ?.data?[
                                                                          index]
                                                                      .id
                                                                      .toString() ??
                                                                  "",
                                                            ),
                                                      child: PlanEventPage(
                                                        id: state.response.data
                                                            ?.data?[index].id,
                                                        isUpdate: true,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
