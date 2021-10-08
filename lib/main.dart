import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'src/resources/data_store.dart';
import 'src/app.dart';
import 'src/bloc/settings_provider.dart';
import 'src/utilities/Helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    String token = await FirebaseMessaging.instance.getToken();
    DataStore().saveFcmToken(token);
  } catch (e) {
    print('EXCEPTION try token');
    print(e);
  }

  try {
    print('try channel');
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    print('DONE try channel');
  } catch (e) {
    print('EXCEPTION try channel');
    print(e);
  }

  try {
    FirebaseMessaging msg = FirebaseMessaging.instance;
    msg.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        Helper.NOTIFICATION_INFO = message.data;
      }
    });
  } catch (e) {
    print(e);
  }

  try {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Future.delayed(Duration(seconds: 1), () {
        Helper.NOTIFICATION_INFO = message.data;
        Helper.HANDLE_NOTIFICATION();
      });
    });
  } catch (e) {
    print(e);
  }

  try {
    await FirebaseMessaging.instance.requestPermission();
  } catch (e) {
    print(e);
  }

  try {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  } catch (e) {
    print('EXCEPTION try notif reg ios');
    print(e);
  }

  runApp(SettingsProvider(child: App()));
}
