import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:aayojan/features/notification/presentation/pages/notification_detail_page.dart';
import 'package:aayojan/features/notification/presentation/widget/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/custom_colors.dart';
import '../bloc/notification_state.dart';

class NotificationPage extends StatefulWidget {
  static const String routeName = 'notification';
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..getNotifications(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Notification',
              style: CustomTypography.headLineLarge,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(color: CustomColors.primaryLight),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .5,
                        child: Text(
                          'All Notificaitons',
                          style: CustomTypography.bodyLarge
                              .copyWith(color: CustomColors.bgLight),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoading) {
                      return SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.7,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: CustomColors.bgLight,
                          ),
                        ),
                      );
                    } else if (state is NotificationLoaded) {
                      if (state.notifications.data?.data?.isEmpty ?? true) {
                        return SizedBox(
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
                                      image:
                                          AssetImage('assets/images/logo.png'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "No Notifications",
                                  style: CustomTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.bgLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // itemCount: state.notifications.data?.data?.length ?? 0,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return NotificationCard(
                            detail: state.notifications.data?.data?[index]
                                    .description ??
                                "",
                            imagePath: 'assets/icons/cake.png',
                            time: state.notifications.data?.data?[index]
                                    .createdAt ??
                                '',
                            title:
                                state.notifications.data?.data?[index].title ??
                                    "",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationDetailPage(
                                            title: state.notifications.data
                                                    ?.data?[index].title ??
                                                "",
                                            time: state.notifications.data
                                                    ?.data?[index].createdAt ??
                                                "",
                                            description: state
                                                    .notifications
                                                    .data
                                                    ?.data?[index]
                                                    .description ??
                                                "",
                                            document: 'assets/icons/cake.png',
                                          )));
                            },
                          );
                        },
                      );
                    } else if (state is NotificationFailure) {
                      return Center(
                        child: Text(
                          state.message,
                          style: CustomTypography.bodyLarge.copyWith(
                            color: CustomColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }
}
