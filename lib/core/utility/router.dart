import 'package:aayojan/features/app.dart';
import 'package:aayojan/features/guest/presentation/pages/add_guest_page.dart';
import 'package:aayojan/features/guest/presentation/pages/guest_page.dart';
import 'package:aayojan/features/invitation/presentation/pages/invitation_page.dart';
import 'package:aayojan/features/manage_family/presentation/pages/familiy_member_page.dart';
import 'package:aayojan/features/my_event/presentation/pages/my_event_page.dart';
import 'package:aayojan/features/plan_event/presentation/pages/plan_event_page.dart';
import 'package:aayojan/features/plan_sub_event/presentation/pages/plan_sub_event_page.dart';
import 'package:aayojan/features/profile/presentation/pages/profile_page.dart';
import 'package:aayojan/features/static_pages/faq_page.dart';
import 'package:aayojan/features/static_pages/how_it_work.dart';
import 'package:aayojan/main.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up.dart';
import '../../features/dashboard/presentation/page/dashboard_page.dart';
import '../../features/guest/presentation/pages/upload_file_page.dart';
import '../../features/menu/menu_page.dart';
import '../../features/notification/presentation/pages/notification_page.dart';

final Map<String, WidgetBuilder> routes = {
  SignUpPage.routeName: (context) => SignUpPage(),
  LoginPage.routeName: (context) => LoginPage(),
  Menu.routeName: (context) => Menu(),
  DashboardPage.routeName: (context) => DashboardPage(),
  UpdateProfile.routeName: (context) => UpdateProfile(),
  HomePage.routeName: (context) => HomePage(),
  InvitationPage.routeName: (context) => InvitationPage(),
  // EventDetailPage.routeName: (context) => EventDetailPage(),
  FamiliyMemberPage.routeName: (context) => FamiliyMemberPage(),
  // AcceptedEventPage.routeName: (context) => AcceptedEventPage(),
  GuestPage.routeName: (context) => GuestPage(),
  AddGuestPage.routeName: (context) => AddGuestPage(),
  UploadFilePage.routeName: (context) => UploadFilePage(),
  // FamilyListPage.routeName: (context) => FamilyListPage(),
  PlanEventPage.routeName: (context) => PlanEventPage(),
  PlanSubEventPage.routeName: (context) => PlanSubEventPage(),
  MyEventPage.routeName: (context) => MyEventPage(),
  // MyEventDetailPage.routeName: (context) => MyEventDetailPage(),
  FAQPage.routeName: (context) => FAQPage(),
  HowItWork.routeName: (context) => HowItWork(),
  NotificationPage.routeName: (context) => NotificationPage(),
  // bootstrapAppRoute: (context) => const BootstrapApp(),
  // BootstrapApp.routeName: (context) => const BootstrapApp(),
};
