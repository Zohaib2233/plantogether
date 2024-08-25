import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/views/authScreens/login_screen.dart';
import 'package:plan_together/views/authScreens/signup_screen.dart';
import 'package:plan_together/widgets/mainButton.dart';

import '../utils/global_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
          SizedBox(
            height: 5.sp,
          ),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34.sp),
              child: Container(
                  child: Image.asset(
                splahscreenImage,
                height: 0.5.sh,
                width: 376.sp,
                fit: BoxFit.cover,
              )),
            ),
          ),
          SizedBox(height: 20.sp),
          Padding(
            padding: EdgeInsets.only(left: 24.sp, right: 50.sp),
            child: Text('Build your unique trip with friends and family - get started!',
                style: TextStyle(
                    fontSize: 33.sp,
                    height: 1.sp,
                    fontFamily: 'ProximaNovaBold',
                    fontWeight: FontWeight.w700)),
          ),
          SizedBox(height: 12.sp),
          Padding(
            padding: EdgeInsets.only(left: 22.sp, right: 50.sp),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vitae sapien viverra laoreet fusce cras nibh. ',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'ProximaNovaRegular',
                  fontWeight: FontWeight.w400,
                  color: grey),
            ),
          ),
          SizedBox(height: 28.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  )),
              child: MainButton(

                            textFont: FontWeight.w700,
                            textSize: 16.sp,
                            color: primaryColor,
                            text: 'Login',
                            // fontFamily: 'ProximaNovaRegular',
                            textColor: Colors.white),
            ),
          ),
          SizedBox(height: 14.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  )),
              child: MainButton(

                            textFont: FontWeight.w700,
                            textSize: 16.sp,
                            border: Border.all(color: border),
                            color: Colors.white,
                            text: 'Sign up',
                            // fontFamily: 'ProximaNovaRegular',
                            textColor: Colors.black),
            ),
          ),
        ]),
      ),
    );
  }
}
