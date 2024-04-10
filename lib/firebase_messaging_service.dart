import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    // Hide State
    FirebaseMessaging.onMessage.listen((message) => doSomething(message));

    // Foreground state
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => doSomething(message));

    // Background State
    FirebaseMessaging.onBackgroundMessage((message) => doSomething(message));

    // call refresh token
    _listenToTokenRefresh();
  }

  static Future<String?> getFCMToken() async {
    return _firebaseMessaging.getToken();
  }

  static Future<void> _listenToTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      //TODO: sending token to server
    });
  }

  static doSomething(RemoteMessage message) {
    debugPrint('notification: data: ${message.data}');
    debugPrint("notification: message: ${message.notification?.title}");
    debugPrint("notification: body: ${message.notification?.body}");
    debugPrint("notification: token: $getFCMToken()");
  }
}
