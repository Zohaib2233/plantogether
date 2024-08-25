//local notification service class
import 'dart:convert';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:plan_together/views/trips_screen.dart';

import '../utils/snackbars.dart';



class LocalNotificationService {

  LocalNotificationService._privateConstructor();

  //singleton instance variable
  static LocalNotificationService? _instance;


  //getter to access the singleton instance
  static LocalNotificationService get instance {
    _instance ??= LocalNotificationService._privateConstructor();
    return _instance!;
  }


  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

   final firebaseMessaging = FirebaseMessaging.instance;

  //method to initialize the initialization settings
   Future<void> initialize() async {
    await requestNotificationPermission();
    //initializing settings for android
    InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    //we are getting details variable from the payload parameter of the notificationsPlugin.show() method
    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Key of the map is: ${details.payload}");
      },
    );

    getDeviceToken();
  }

  requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      AppSettings.openAppSettings();
    }
  }

  //getting device token for FCM
 Future<String?> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device token := $token");
    return token;
  }

  //method to display push notification on top of screen
   void display(RemoteMessage message) async {
    try {
      //getting a unique id
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      //creating notification details channel
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("planTogether", "general",
              importance: Importance.max, priority: Priority.max));

      //displaying heads up notification
      await notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data['type']);
    } on Exception catch (e) {
      print(
          "This exception occured while getting notification: $e Push Notification Exception");
    }
  }

  // A function to send the notification to the user upon messaging the other user
   Future<void> sendFCMNotification({
    required List<String> deviceTokens,
    required String title,
    required String body,
    required String type,
    required String sentBy,
    required String sentTo,
    required bool savedToFirestore
  }) async {
    //in header we put the server key of the firebase console that is used for this project
     ///Todo: change Authorization Key
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAEqH4crI:APA91bEP5dSqxanH9mtnk7x7tjMLcxL5VzFrrfv7cZPDnxd-h3N0SZYY6l1ajk8FuAenYzTiR6nNomqWryS_NO--Xz56usT_UTXkgeRKeEPc49iL6xKVxRAcnUjTAzUMQmJHxAWqynDU'
      };
      var request = http.Request(
          'POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
      request.body = json.encode({
        "registration_ids": deviceTokens,
        "notification": {"title": title, "body": body},
        "data": {"type": type, "sentBy": sentBy, "sentTo": sentTo}
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("************ Notification has been send**********");
        // if(savedToFirestore){
        //   await FirebaseCRUDServices.instance.saveNotificationToFirestore(
        //       title: title,
        //       body: body,
        //       sentBy: sentBy,
        //       sentTo: sentTo,
        //       type: type);
        // }

        //showSuccessSnackbar(title: 'Success', msg: '${response.statusCode}');
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Error sending FCM notification',
             message: '${response.statusCode}');
      }
    } catch (e) {
      print("Exception ****** $e *******");
      // Utils.showFailureSnackbar(
      //     title: 'Error sending FCM notification', msg: '$e');
    }
  }


 //Handle Message
 void handleMessage({required BuildContext context ,required RemoteMessage message}){
     if(message.data['type']=='general'){
       Get.to(()=>TripsScreen());
     }



 }

  //method to listen to firebase push notifications
//adding push notifications
  Future<void> pushNotifications() async {
    //for onMessage to work properly
    //to get the notification message when the app is in terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Notification got from the terminated state: ${message.data}");
        // Get.to(() => HostProfile());
      }
    });

    //works only if the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //displaying push notification via local notification package
      print("Message is (App is in foreground): ${message.data}");
      //adding new notification data to notification models list
      // Get.find<NotificationController>().addNewNotification(message: message);
      log('Notification is: ${message.notification!.title.toString()}');
      LocalNotificationService.instance.display(message);
    });

    //works only when the app is in background but opened and the user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message is (App is in background and user tapped): ${message.data}");
      //adding new notification data to notification models list
      // Get.find<NotificationController>().addNewNotification(message: message);
      // Get.to(() => HostProfile());
    });
  }
}
