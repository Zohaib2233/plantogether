import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plan_together/bindings/bindings.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/controllers/authControllers/login_controller.dart';
import 'package:plan_together/controllers/authControllers/signup_controller.dart';
import 'package:plan_together/services/sharedpreference_service.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/utils/shared_preference_keys.dart';
import 'package:plan_together/views/authScreens/signup_screen.dart';
import 'package:plan_together/views/mainScreens/bottom_tabs.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';
import 'package:plan_together/widgets/get_textfield.dart';
import 'package:plan_together/widgets/mainButton.dart';

import '../../services/zego_call_service.dart';
import '../../utils/global_colors.dart';
import '../../widgets/checkbox_widget.dart';
import '../../widgets/my_text_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();
    final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: loginFormKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24.sp, right: 50.sp),
                        child: Text('Welcome Back!',
                            style: TextStyle(
                                fontSize: 30.sp,
                                height: 0.9.sp,
                                // fontFamily: 'ProximaNovaBold',
                                fontWeight: FontWeight.w700)),
                      ),
                      SizedBox(height: 15.sp),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.sp),
                        child: Text(
                          'Happy to see you again! Please enter your email and password to login to your account.',
                          style: TextStyle(
                              fontSize: 14.sp,
                              // fontFamily: 'ProximaNovaRegular',
                              fontWeight: FontWeight.w400,
                              color: grey),
                        ),
                      ),
                      SizedBox(height: 41.sp),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Column(
                          children: [
                            getTextField(
                              hint: 'Email Address',
                              label: 'Email Address',
                              controller: controller.emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email Address is required';
                                } else if (!GetUtils.isEmail(value)) {
                                  return 'Enter a valid Email Address';
                                }
                                return null;
                              },
                            ),
                            // SizedBox(height: 20.sp),
                            Obx(
                              () => getTextField(
                                onSuffixTap: () {
                                  controller.isObscure.value =
                                      !controller.isObscure.value;
                                },
                                suffixColor: Color(0xFF9A9CA3),
                                iconData: controller.isObscure.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                isObscure: controller.isObscure.value,
                                hint: 'Your Password',
                                label: 'Password',
                                controller: controller.passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 10.sp),
                            Row(
                              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Transform.scale(
                                    scale: 0.9,
                                    child: Obx(()=>CheckBoxWidget(
                                        isChecked: controller.isChecked.value,
                                        onChanged: (value) {
                                          print("Value");
                                          controller.changeCheckValue(value!);
                                        }),
                                    ),

                                  ),
                                ),
                                MyText(
                                  paddingLeft: 10,
                                  text: "Remember me",
                                  size: 10,
                                  weight: FontWeight.w600,
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    await controller.resetPassword();
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'DMSansRegular',
                                        color: lightBlue),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 31.sp),
                            GestureDetector(
                              onTap: () async {
                                if (loginFormKey.currentState!.validate()) {
                                  await controller.loginMethod().then((value) {
                                    if (value != null) {

                                      Get.showSnackbar(const GetSnackBar(
                                        backgroundColor: green,
                                        message: "Login Successful",
                                        duration: Duration(seconds: 2),
                                      ));
                                      Get.delete<LoginController>();
                                      Get.delete<SignupController>();


                                      Get.offAll(() => const BottomTabs(),
                                          binding: BottomNavBinding());
                                    }
                                  });
                                }
                              },
                              child: MainButton(
                                  textFont: FontWeight.w700,
                                  textSize: 16.sp,
                                  color: primaryColor,
                                  text: 'Login',
                                  // fontFamily: 'ProximaNovaRegular',
                                  textColor: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 16.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child:
                                          Divider(height: 1.sp, color: border)),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.sp),
                                    child: Text(
                                      'Or',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: grey,
                                          fontFamily: 'ProximaNovaRegular'),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                    height: 1.sp,
                                    color: border,
                                  )),
                                ],
                              ),
                            ),
                            MainButton(
                                onPressed: () async {
                                  await controller
                                      .signInWithGoogle()
                                      .then((value) {
                                    if (value != null) {
                                      Get.to(const BottomTabs(),
                                          binding: BottomNavBinding());
                                      customSnackBar(
                                          message: "Login Successful",
                                          color: green);
                                    }
                                  });
                                },
                                textFont: FontWeight.w700,
                                textSize: 16.sp,
                                icon: google,
                                border: Border.all(color: border),
                                color: white,
                                text: 'Login with Google',
                                // fontFamily: 'ProximaNovaRegular',
                                textColor: Colors.black),
                            // Spacer(),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
            Obx(() {
              return controller.loading.value
                  ? Container(
                      height: Get.height,
                      width: Get.width,
                      color: Colors.grey.withOpacity(0.8),
                      child: const Center(child: CircularProgressIndicator()))
                  : Container();
            })
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => controller.loading.value
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.only(bottom: 0.07.sh),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'DMSansRegular',
                        fontWeight: FontWeight.w400,
                        color: grey,
                      ),
                    ),
                    SizedBox(
                      width: 3.sp,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          )),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'DMSansBold',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
