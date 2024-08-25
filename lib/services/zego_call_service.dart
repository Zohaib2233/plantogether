import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/utils/app_strings.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/views/audioCall/oneToOne_audioCall.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../utils/global_colors.dart';

///

/// Read Documentation => https://zegocloud.spreading.io/doc/callkit/Call%20Kit/main/Quick%20start%20(with%20call%20invitation)/eb1d3c42

// final GlobalKey<NavigatorState>  navigatorKeyZego = GlobalKey();


class ZegoCallService {


  //private constructor
  ZegoCallService._privateConstructor();

  //singleton instance variable
  static ZegoCallService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to FirebaseStorageService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static ZegoCallService get instance {
    _instance ??= ZegoCallService._privateConstructor();
    return _instance!;
  }

  ///

  // initialize(){
  //
  //   ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKeyZego);
  //
  //   // call the useSystemCallingUI
  //    ZegoUIKit().initLog().then((value) {
  //     ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
  //       [ZegoUIKitSignalingPlugin()],
  //     );
  //
  // });
  // }


  /// on App's user login
  /// on user login
  void onUserLogin({currentUserId, currentUserName}) {
    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: AppStrings.AppId /*input your AppID*/,
      appSign: AppStrings.Appsign,
      userID: currentUserId,
      userName: currentUserName,
      plugins: [
        ZegoUIKitSignalingPlugin(),
      ],
      // notificationConfig: ZegoCallInvitationNotificationConfig(
      //   androidNotificationConfig: ZegoCallAndroidNotificationConfig(
      //     showFullScreen: true,
      //     fullScreenBackground: 'assets/image/call.png',
      //     channelID: "ZegoUIKit",
      //     channelName: "Call Notifications",
      //     sound: "call",
      //     icon: "call",
      //   ),
      //   iOSNotificationConfig: ZegoCallIOSNotificationConfig(
      //     systemCallingIconName: 'CallKitIcon',
      //   ),
      // ),

      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoCallAndroidNotificationConfig(
          showFullScreen: true,
        ),
      ),

      requireConfig: (ZegoCallInvitationData data) {
        final config = (data.invitees.length > 1)
            ? ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        config
          ..turnOnMicrophoneWhenJoining = true
          ..turnOnCameraWhenJoining = false
          ..useSpeakerWhenJoining = true;

        config.avatarBuilder = customAvatarBuilder;

        /// support minimizing, show minimizing button
        config.topMenuBar.isVisible = true;
        config.topMenuBar.buttons
            .insert(0, ZegoCallMenuBarButtonName.minimizingButton);
        config.topMenuBar.buttons
            .insert(1, ZegoCallMenuBarButtonName.soundEffectButton);

        return config;
      },
    );
  }

  /// on App's user logout
  void onUserLogout() {
    /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged out
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }


  Widget sendCallInvitationButton({targetUserID, targetUserName,
    void Function(String code, String message, List<
        String>)? onCallFinished,}) {
    return ZegoSendCallInvitationButton(
      // onWillPressed: () async {
      //       //   Get.to(() =>
      //       //       OneToOneAudioCall(callingId: targetUserID,
      //       //           targetUserID: targetUserID,
      //       //           targetUserName: targetUserName));
      //       //   return false;
      //       // },

      callID: targetUserID,

      isVideoCall: false,

      /// You need to use the resourceID that you created in the subsequent steps. WAtch This https://www.youtube.com/watch?v=K3kRWyafRIY&t=4s
      resourceID: "zego_call",
      //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
      invitees: [
        ZegoUIKitUser(
          id: targetUserID,
          name: targetUserName,
        ),
      ],
      iconSize: const Size(35, 35),
      buttonSize: const Size(40, 40),
      icon: ButtonIcon(
          icon: const Icon(
            Icons.phone_enabled_sharp,
            color: blackColor,
          )
      ),
      onPressed: onCallFinished,
    );
  }


  Widget sendCallButton({
    required bool isVideoCall,
    required TextEditingController inviteeUsersIDTextCtrl,
    void Function(String code, String message, List<String>)? onCallFinished,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: inviteeUsersIDTextCtrl,
      builder: (context, inviteeUserID, _) {
        var invitees = getInvitesFromTextCtrl(
            inviteeUsersIDTextCtrl.text.trim());

        return ZegoSendCallInvitationButton(
          isVideoCall: isVideoCall,
          invitees: invitees,
          resourceID: "zego_data",
          iconSize: const Size(15, 15),
          buttonSize: const Size(35, 35),
          onPressed: onCallFinished,
        );
      },
    );
  }

  /// onSendCallInvitationFinished


  void onSendCallInvitationFinished(String code,
      String message,
      List<String> errorInvitees,) {
    print(
        " -------------- onSendCallInvitationFinished $code  $message  $errorInvitees");
    if (errorInvitees.isNotEmpty) {
      print("************************************8   ${errorInvitees
          .isNotEmpty}");
      String userIDs = "";
      for (int index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        var userID = errorInvitees.elementAt(index);
        userIDs += userID + ' ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = 'User doesn\'t exist or is offline: $userIDs';
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }

      print(
          "****************************** ${message} ********************************");
      // showToast(
      //   message,
      //   position: StyledToastPosition.top,
      //   context: ,
      // );
    } else if (code.isNotEmpty) {
      print("88888888888888888888888 else ${message}");
      // showToast(
      //   'code: $code, message:$message',
      //   position: StyledToastPosition.top,
      //   context: context,
      // );
    }
  }


  /// Get Inviteees from Text Field


  List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
    List<ZegoUIKitUser> invitees = [];

    var inviteeIDs = textCtrlText.trim().replaceAll('，', '');
    inviteeIDs.split(",").forEach((inviteeUserID) {
      if (inviteeUserID.isEmpty) {
        return;
      }

      invitees.add(ZegoUIKitUser(
        id: inviteeUserID,
        name: 'user_$inviteeUserID',
      ));
    });

    return invitees;
  }


}

Widget customAvatarBuilder(BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,) {
  return CachedNetworkImage(
    imageUrl: userModelGlobal.value.profileImgUrl ?? profileUrlDummy,
    imageBuilder: (context, imageProvider) =>
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) {
      ZegoLoggerService.logInfo(
        '$user avatar url is invalid',
        tag: 'live audio',
        subTag: 'live page',
      );
      return ZegoAvatar(user: user, avatarSize: size);
    },
  );
}