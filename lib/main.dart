import 'dart:developer';

import 'package:aayojan/features/auth/presentation/pages/login_page.dart';
import 'package:aayojan/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'core/di/injection.dart';
import 'core/theme/theme.dart';
import 'core/utility/router.dart';
import 'features/app.dart';
import 'features/notification/data/service/flutter_service.dart';
import 'features/notification/data/service/local_notificaiton_service.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    // Initialize dependencies
    await configureInjection(Environment.prod);
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseService().initNotifications();
    await LocalNotificationService().initialize();
    runApp(const MyApp());
  } catch (e) {
    log('Error in main: $e');
    runApp(const MyApp());
  }
}

// class BootstrapApp extends StatefulWidget {
//   static const String routeName = '/';
//   const BootstrapApp({super.key});

//   @override
//   State<BootstrapApp> createState() => _BootstrapAppState();
// }

// class _BootstrapAppState extends State<BootstrapApp> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     try {
//       WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//       FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//       await configureInjection(Environment.prod);
//       await Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform);
//       // await Future.delayed(const Duration(seconds: 2));
//       await FirebaseService().initNotifications();
//       await LocalNotificationService().initialize();
//       final initialRoute = await determineInitialRoute();
//       Navigator.pushReplacementNamed(
//         navigatorKey.currentContext!,
//         initialRoute,
//       );
//       FlutterNativeSplash.remove();
//     } catch (e) {
//       log('Error initializing app: $e');
//       Navigator.pushReplacementNamed(
//         navigatorKey.currentContext!,
//         LoginPage.routeName,
//       );
//     } finally {
//       setState(() {}); // rebuild to load actual app
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xff62396C),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Example logo
//             Image.asset('assets/images/splash_logo.png', height: 300),
//           ],
//         ),
//       ),
//     );
//   }
// }

Future<String> determineInitialRoute() async {
  const storage = FlutterSecureStorage();
  final authenticated = await storage.containsKey(key: 'accessToken');
  return authenticated ? HomePage.routeName : LoginPage.routeName;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    _determineInitialRoute();
  }

  Future<void> _determineInitialRoute() async {
    try {
      const storage = FlutterSecureStorage();
      final authenticated = await storage.containsKey(key: 'accessToken');
      setState(() {
        _initialRoute =
            authenticated ? HomePage.routeName : LoginPage.routeName;
      });
      FlutterNativeSplash.remove();
    } catch (e) {
      log('Error determining initial route: $e');
      setState(() {
        _initialRoute = LoginPage.routeName;
      });
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialRoute == null) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xff62396C),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset('assets/images/splash_logo.png', height: 300),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Aayojan',
      theme: lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: _initialRoute,
      routes: routes,
    );
  }
}
