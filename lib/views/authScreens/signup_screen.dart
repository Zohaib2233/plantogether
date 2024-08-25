import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plan_together/controllers/authControllers/signup_controller.dart';
import 'package:plan_together/views/authScreens/login_screen.dart';
import 'package:plan_together/views/mainScreens/bottom_tabs.dart';
import 'package:plan_together/widgets/custom_currency_picker.dart';
import 'package:plan_together/widgets/get_textfield.dart';
import 'package:plan_together/widgets/mainButton.dart';

import '../../services/sharedpreference_service.dart';
import '../../utils/global_colors.dart';
import '../../utils/shared_preference_keys.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formKey1 = GlobalKey<FormState>();
    var controller = Get.find<SignupController>();
    // final currencyFocusNode = FocusNode();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: formKey1,
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.sp, right: 50.sp),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 30.sp,
                          height: 0.9.sp,
                          fontFamily: 'ProximaNovaSemiBold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.sp),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.sp),
                      child: Text(
                        'Welcome! Please enter your Name, email and password to create your account.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'ProximaNovaRegular',
                          fontWeight: FontWeight.w400,
                          color: grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.sp),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Column(
                        children: [
                          getTextField(
                            hint: 'Full Name',
                            label: 'Full Name',
                            controller: controller.nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Full Name is required';
                              }
                              return null;
                            },
                          ),
                          // SizedBox(height: 20.sp),
                          getTextField(

                            isEnabled: true,
                            hint: 'Username',
                            label: 'Username',
                            controller: controller.userNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username is required';
                              }
                              return null;
                            },
                          ),
                          // Obx(() => getCustomSelectField(
                          //     fieldName: controller.selectCountry.value,
                          //     onSuffixTap: () {
                          //       showCountryPicker(
                          //         context: context,
                          //         showPhoneCode: true,
                          //         onSelect: (Country country) {
                          //           controller.onSelectCountry(country);
                          //           print('Select country: ${country.name}');
                          //         },
                          //       );
                          //     })),
                          // SizedBox(height: 20.sp),


                             GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    onSelect: (Country country) {
                                      controller.onSelectCountry(country);
                                      print('Select country: ${country.name}');
                                    },
                                  );
                                },
                                child: getTextField(

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select Country';
                                    }
                                    return null;
                                  },

                                  controller: controller.countryController,
                                  // canRequestFocus: false,
                                  hint: 'Country e.g Pakistan',
                                  label: 'Country',
                                  isEnabled: false,
                                  iconData: Icons.keyboard_arrow_down_outlined,
                                  suffixColor: const Color(0xffB3B3B3),
                                ),
                              ),

                          // SizedBox(height: 20.sp),

                             GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                    CustomCurrencyPicker(
                                      onCurrencySelected: (currency){
                                        controller.currencyController.text = currency;
                                      },


                                    ),
                                    ignoreSafeArea: false,
                                    isScrollControlled: true,
                                    persistent: true,);

                                },
                                child: getTextField(

                                  // focusNode: currencyFocusNode,
                                    onChanged: (value){
                                    print(value);
                                    },

                                    controller: controller.currencyController,
                                    hint: 'Currency e.g USD',
                                    label: 'Your local currency',
                                    isEnabled: false,
                                    iconData:
                                        Icons.keyboard_arrow_down_outlined,
                                    suffixColor: const Color(0xffB3B3B3),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Currency is required';
                                      }
                                      return null;
                                    }),
                              ),

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
                              suffixColor: const Color(0xFF9A9CA3),
                              iconData: controller.isObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              isObscure: controller.isObscure.value,
                              hint: 'Your Password',
                              label: 'Password',
                              controller: controller.passwordController,
                              validator: (value) {
                                return controller.validatePassword(value);
                              },
                            ),
                          ),
                          // SizedBox(height: 20.sp),
                          Obx(
                            () => getTextField(
                              onSuffixTap: () {
                                controller.isAgainPasswordObscure.value =
                                    !controller.isAgainPasswordObscure.value;
                              },
                              suffixColor: const Color(0xFF9A9CA3),
                              iconData: controller.isAgainPasswordObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              isObscure:
                                  controller.isAgainPasswordObscure.value,
                              hint: 'Re-enter Password',
                              label: 'Re-enter Password',
                              controller: controller.passwordAgainController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Re-enter Password is required';
                                } else if (value !=
                                    controller.passwordController.text) {
                                  return 'Passwords should be the same';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 30.sp),
                          GestureDetector(
                            onTap: () async {
                              // Perform overall validation before signing up
                              if (formKey1.currentState!.validate()) {
                                // Validation successful, proceed with signup
                                await controller.signupMethod().then((value) {
                                  if (value != null) {
                                    controller.storeUserData().then((value) {
                                      Get.to(() => const BottomTabs());
                                      SharedPreferenceService()
                                          .saveSharedPreferenceBool(
                                          key: SharedPrefKeys.loggedIn,
                                          value: true);
                                      Get.showSnackbar(const GetSnackBar(
                                        backgroundColor: green,
                                        message: "Signup Successful",
                                        duration: Duration(seconds: 2),
                                      ));

                                    });
                                  }
                                });
                              }
                            },
                            child: MainButton(
                              textFont: FontWeight.w700,
                              textSize: 16.sp,
                              color: primaryColor,
                              text: 'Sign up',
                              textColor: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
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
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  ),
                                  child: Text(
                                    'Login',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => controller.loading.value
                ? Container(
                    height: Get.height,
                    width: Get.width,
                    color: Colors.grey.withOpacity(0.8),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
