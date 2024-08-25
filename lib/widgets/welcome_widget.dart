import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/views/authScreens/Profile_screen.dart';
import 'package:plan_together/views/calendar/calendar_screen.dart';

import '../utils/global_colors.dart';
import '../utils/images.dart';



Widget welcomeWidget({
  required headingText,
  required subheading,
}) {
  // var controller = Get.find<UserDetailService>();
  return Padding(
    padding: EdgeInsets.only(bottom: 31.sp),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headingText,
              style: TextStyle(
                  fontSize: 21.8.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'ProximaNovaMedium',
                  color: primaryColor),
            ),
            SizedBox(
              height: 5.3.sp,
            ),
            
            SizedBox(
              width: 225,
              child: Text(
                subheading,
                overflow: TextOverflow.visible, // Set overflow behavior to wrap text
                maxLines: 2,
                style: TextStyle(
                    fontSize: 12.7.sp,
                    fontWeight: FontWeight.w400,
                    // fontFamily: 'ProximaNovaRegular',
                    color: grey,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
          GestureDetector(
            onTap: (){
              Get.to(()=>CalendarScreen());
            },
            child: Container(
            width: 39.sp,  // Adjust the width as needed
            height: 39.sp,  // Adjust the height as needed
            decoration: BoxDecoration(
              color: lightBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 22.0,  // Adjust the size of the icon as needed
              ),
            ),
                    ),
          ),

            // Image.asset(
            //
            //   shopbg,
            //   height: 39.sp,
            //   width: 39.sp,
            //   fit: BoxFit.contain,
            // ),
            SizedBox(
              width: 13.3.sp,
            ),
            Obx(()=>GestureDetector(
                onTap: (){
                  Get.to(()=>ProfileScreen(userId: userModelGlobal.value.id??'',isMe: true,));
                },
                child: userModelGlobal.value.profileImgUrl == ''?CircleAvatar(
                  backgroundColor: grey,
                  maxRadius: 19.5.sp,
                  backgroundImage: const AssetImage(profile2),
                ):
                    CachedNetworkImage(imageUrl: userModelGlobal.value.profileImgUrl as String,
                    imageBuilder: (BuildContext context,provider){
                      return CircleAvatar(
                        backgroundColor: grey,
                        maxRadius: 19.5.sp,
                        backgroundImage: provider,
                      );
                    },)

                ),
            ),
          ],
        )
      ],
    ),
  );
}
