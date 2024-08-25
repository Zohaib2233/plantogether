import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/custom_app_bar.dart';
import 'package:plan_together/widgets/mainButton.dart';

import 'homeScreen/create_trip2.dart';


class CreateTrip extends StatelessWidget {
  const CreateTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Create Trip', onBackButtonPressed: () {Navigator.pop(context); }, onMoreButtonPressed: () {  },),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 19.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Get.to(

                     const CreateTrip2());
                },
                child: MainButton(
                    textFont: FontWeight.w700,
                    textSize: 16.sp,
                    color: primaryColor,
                    text: 'Simple Trip',
                    smallText:
                        "Fx: Short Trips, Camping, Fishing, Visit Parent in Law",
                    // fontFamily: 'ProximaNovaRegular',
                    textColor: Colors.white),
              ),
              SizedBox(
                height: 17.sp,
              ),
              InkWell(
                onTap: () {
                  Get.to(const CreateTrip2());
                },
                child: MainButton(
                    textFont: FontWeight.w700,
                    textSize: 16.sp,
                    color: primaryColor,
                    text: 'Unique Trip',
                    smallText:
                        "Fx: Require more planning, Vacation to Dubai, Maldives, London e.t.c ",
                    // fontFamily: 'ProximaNovaRegular',
                    textColor: Colors.white),
              ),
            ],
          ),
        ));
  }
}
