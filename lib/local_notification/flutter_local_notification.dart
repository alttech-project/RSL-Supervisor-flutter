import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import '../routes/app_routes.dart';
import '../utils/helpers/alert_helpers.dart';
import '../utils/helpers/basic_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/helpers/getx_storage.dart';
import '../video/controller/upload_video_controller.dart';
import '../views/controller/splash_controller.dart';

class FlutterLocalNotify {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var remoteMessage;

  final _androidChannel = const AndroidNotificationChannel(
      'verification', 'Supervisor video verification',
      description: 'Supervisor video and location verification',
      importance: Importance.defaultImportance);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    printLogs("FIREBASE TOKEN : ${FCMToken}");
    GetStorageController().saveDeviceToken(value: FCMToken ?? "");
    initNotificationMethod();
    // createNotificationChannel();
  }

  Future initNotificationMethod() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((handleMessage));
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      // printLogs("hi ON MESSAGE :$message  ${notification}");
      if (notification != null) {
        remoteMessage = message;
        showDialog(message);
        /* showNotification(notification.title ?? "", notification.body ?? "",
            message.from ?? "", message);*/
      }
    });
  }

  handleMessage(RemoteMessage? payload) {
    if (payload != null) {
      showDialog(payload);
    }
  }

  showDialog(message) {
    try {
      final SplashController controller = Get.find<SplashController>();
      print("hi isSplashScreen ${controller.isSplashScreen.value}");
      if (controller.isSplashScreen.value == false) {
        showDefaultDialog(
            context: NavigationService.navigatorKey.currentContext!,
            title: "Alert",
            message: "Are you sure want to record video now?",
            isTwoButton: true,
            acceptBtnTitle: "Yes, now",
            acceptAction: () {
              Navigator.of(NavigationService.navigatorKey.currentContext!)
                  .pop(false);
              navigateVideoUploadPage(message);
            },
            cancelBtnTitle: "No",
            cancelAction: () {
              Navigator.of(NavigationService.navigatorKey.currentContext!)
                  .pop(false);
            });
      } else {
        Future.delayed(
          const Duration(seconds: 2),
          () async {
            showDialog(remoteMessage);
          },
        );
      }
    } catch (e) {
      e.printError();
    }
  }

  navigateVideoUploadPage(message) {
    try {
      final UploadVideoController controller =
          Get.find<UploadVideoController>();
      controller.verificationId = message.data["verificationId"] ?? "";
      controller.videoRecordingTime = message.data["verificationTime"] ?? 10;
      controller.initializeCamera();
      Get.toNamed(AppRoutes.uploadVideoPage);
    } catch (e) {
      e.printError();
    }
  }

  Future createNotificationChannel() async {
    const IOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings("@drawable/ic_launcher");
    const settings = InitializationSettings(android: android, iOS: IOS);
    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse? payload) {
        printLogs("hi Response From : ${payload.toString()}");
        showDialog(remoteMessage);
      },
    );
    final platform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  // Function to schedule and show a notification
  Future<void> showNotification(
      String? title, String? body, String? from, RemoteMessage? message) async {
    int expiryTime;
    try {
      var time = int.parse(message!.data["expiryTime"]);
      if (time < 60000) {
        expiryTime = 60000;
      } else {
        expiryTime = time;
      }
    } catch (e) {
      expiryTime = 60000;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'verification', // A unique ID for the notification channel
            'Supervisor video verification', // A name for the channel
            channelDescription: 'Supervisor video and location verification',
            // A description for the channel
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            timeoutAfter: 60000 /*expiryTime*/);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        '$title', // Title
        '$body', // Body
        platformChannelSpecifics,
        payload: from);
  }
}
