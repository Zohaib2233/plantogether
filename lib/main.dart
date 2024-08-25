import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plan_together/bindings/bindings.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/controllers/authControllers/login_controller.dart';
import 'package:plan_together/controllers/authControllers/signup_controller.dart';
import 'package:plan_together/models/user_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/services/local_notification_service.dart';
import 'package:plan_together/services/sharedpreference_service.dart';
import 'package:plan_together/services/zego_call_service.dart';
import 'package:plan_together/utils/shared_preference_keys.dart';
import 'package:plan_together/views/mainScreens/bottom_tabs.dart';
import 'package:plan_together/views/splash_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'common/functions.dart';
import 'constant/firebase_consts.dart';
import 'firebase_options.dart';

/// 1/5: define a navigator key
final navigatorKey = GlobalKey<NavigatorState>();

//for getting notifications when the app is in background and the user doesn't tap on the notification
@pragma('vm:entry-point')   //for getting background notifications in release mode also
Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  print('Notification is: ${message.notification.toString()}');
  print("Message is (App is in background): ${message.data}");
  log('Notification is: ${message.notification!.title.toString()}');
  LocalNotificationService.instance.display(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ZegoCallService.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LocalNotificationService.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
  await LocalNotificationService.instance.pushNotifications();

  /// 2/5: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  ZegoUIKit().initLog().then((value) async {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    await navigateToScreen();

  });


}

navigateToScreen() async {

  bool value = await SharedPreferenceService().getSharedPreferenceBool(
      SharedPrefKeys.loggedIn) ?? false;
  if (value) {

    await getUserDataStream(userId: FirebaseConsts.auth.currentUser!.uid);

    UserModel userModel = await FirebaseServices.getCurrentUserById(
        FirebaseConsts.auth.currentUser!.uid);



     ZegoCallService.instance.onUserLogin(
        currentUserId: userModel.id, currentUserName: userModel.name);

    getAllTripsDates(userId: FirebaseConsts.auth.currentUser!.uid);

    Get.delete<SignupController>();
    Get.delete<LoginController>();
    runApp(MyApp(widget: const BottomTabs(), navigatorKey: navigatorKey,));
  }
  else {
    runApp(MyApp(widget: SplashScreen(), navigatorKey: navigatorKey,));
  }

}
class MyApp extends StatefulWidget {

  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.widget, required this.navigatorKey,});

  final Widget widget;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("LocalNotificationService.instance.getDeviceToken() = ${LocalNotificationService.instance.getDeviceToken()}");
    return ScreenUtilInit(
      designSize: const Size(390, 847),
      builder:
          (BuildContext context, child) =>
          GetMaterialApp(
            // key: navigatorKey,
            navigatorKey: navigatorKey,
            initialBinding: IntialBinding(),
            debugShowCheckedModeBanner: false,

            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Stack(
              children: [
                widget.widget,
                /// support minimizing
                ZegoUIKitPrebuiltCallMiniOverlayPage(
                  contextQuery: () {
                    return widget.navigatorKey.currentState!.context;
                  },
                ),
              ],
            ),
          ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
