import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../main.dart';
import '../../presentation/pages/notification_page.dart';
import 'local_notificaiton_service.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // init notifications
  Future<void> initNotifications() async {
    // request permissions
    await _firebaseMessaging.requestPermission();

    // fetch token
    String? token = await _firebaseMessaging.getToken();
    String? apnsToken = await _firebaseMessaging.getAPNSToken();
    log('Token: $token');
    log('Ios Token: $apnsToken');
    initPushNotifications();
  }
  // function to handle received messages

  // getToken
  Future<String?> getToken() async {
    // if token device is ios send it to apns
    // if(Platform.isIOS){
    //   return await _firebaseMessaging.getAPNSToken();
    // }
    return await _firebaseMessaging.getToken();
  }

  void handleMessages(RemoteMessage? message) {
    if (message == null) return;
    log('hello');
    navigatorKey.currentState?.pushNamed(
      NotificationPage.routeName,
      arguments: message,
    );
  }

  Future handleBackgroundMessage(RemoteMessage message) async {
    log('Handling a background message ${message.messageId}');
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessages);
    // on opened app

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        log('after');
        log(message.data.toString());
        log(message.notification?.title.toString() ?? "");
        log(message.notification?.body.toString() ?? "");

        LocalNotificationService().showNotification(
            1,
            message.notification?.title ?? '',
            message.notification?.body ?? '',
            "payload");
        // navigatorKey.currentState?.pushNamed(
        //   NotificationPage.routeName,
        //   arguments: message,
        // );
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}