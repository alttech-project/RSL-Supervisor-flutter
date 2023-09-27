import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../utils/helpers/alert_helpers.dart';
import '../utils/helpers/basic_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../utils/helpers/getx_storage.dart';
import '../video/controller/upload_video_controller.dart';

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
    createNotificationChannel();
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
        showNotification(notification.title ?? "", notification.body ?? "",
            message.from ?? "", message);
      }
    });
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

  handleMessage(RemoteMessage? payload) {
    if (payload != null) {
      showDialog(payload);
    }
  }

  showDialog(message) {
    try {
      navigateVideoUploadPage(message);
      /* showDefaultDialog(
          context: Get.context!,
          title: "Alert",
          message: "Are you sure want to record now?",
          isTwoButton: true,
          acceptBtnTitle: "Record Now",
          acceptAction: () {
            navigateVideoUploadPage(message);
          },
          cancelBtnTitle: "Not now",
          cancelAction: () {
            navigateBack();
          });*/
    } catch (e) {
      e.printError();
    }
  }

  navigateVideoUploadPage(message) {
    try {
      final UploadVideoController controller =
          Get.find<UploadVideoController>();
      controller.verificationId = message!.data["verificationId"] ?? "";
      controller.initializeCamera();
      Get.toNamed(AppRoutes.uploadVideoPage);
    } catch (e) {
      e.printError();
    }
  }

  navigateBack() {
    Get.back();
  }
}
