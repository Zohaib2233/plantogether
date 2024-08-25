import 'package:flutter/cupertino.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/utils/app_strings.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class OneToOneAudioCall extends StatelessWidget {
  final String callingId,targetUserID,targetUserName;
  const OneToOneAudioCall({super.key, required this.callingId, required this.targetUserID, required this.targetUserName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
      ZegoUIKitPrebuiltCall(
          appID: AppStrings.AppId,
          appSign: AppStrings.Appsign,

          callID: callingId,
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()

            // ..audioVideoView = ZegoCallAudioVideoViewConfig(
            //   showCameraStateOnView: true
            // ),
      ,userID: targetUserID, userName: targetUserID??'zebi',),
    );
  }
}
