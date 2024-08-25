import 'package:currency_picker/currency_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/controllers/tripController/budget_controller.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/services/local_notification_service.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/snackbars.dart';
import 'package:plan_together/widgets/text_widget.dart';

import '../models/user_model.dart';
import '../utils/images.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/get_textfield.dart';
import '../widgets/mainButton.dart';

class GroupBudget extends StatefulWidget {
  final TripModel tripModel;

  const GroupBudget({Key? key, required this.tripModel}) : super(key: key);

  @override
  State<GroupBudget> createState() => _GroupBudgetState();
}

class _GroupBudgetState extends State<GroupBudget> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<BudgetController>();

    return Obx(() => controller.groupBudgetModels.isNotEmpty
        ? showBudget(controller)
        : noBudget(controller));
  }

  Widget noBudget(BudgetController controller) {
    return Container(
      height: 350,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                    text: 'All Friends',
                    size: 14,
                    color: blackColor,
                    fontWeight: FontWeight.w600),
                // TextWidget(
                //     text: 'See all',
                //     size: 11,
                //     color: lightGrey,
                //     fontWeight: FontWeight.w600),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Obx(
                () => controller.profileUrlsList.isNotEmpty
                    ? FlutterImageStack(
                        imageSource: ImageSource.network,
                        imageList: controller.profileUrlsList
                            .map((element) => element.toString())
                            .toList(),
                        totalCount: controller.profileUrlsList.length,
                        itemRadius: 30,

                        itemCount: controller.profileUrlsList.length,
                        itemBorderWidth: 0.05, // Border width around the images
                      )
                    : FlutterImageStack(
                        imageSource: ImageSource.network,
                        imageList: List.generate(3, (index) => profileUrlDummy),
                        totalCount: 3,
                        itemRadius: 30,

                        itemCount: 3,
                        itemBorderWidth: 0.05, // Border width around the images
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextWidget(
              text: 'Create expense you paid on behalf of trip member',
              size: 11,
              color: lightGrey,
              fontWeight: FontWeight.w600),
          const SizedBox(
            height: 40,
          ),
          MainButton(
              color: primaryColor,
              width: 120,
              text: "Add People",
              textColor: Colors.white,
              textSize: 15.55,
              onPressed: () {
                controller.pickedImages.clear();
                showDialog(
                    context: context,
                    builder: (context) {
                      return addPeopleDialog(controller);
                    });
              },
              textFont: FontWeight.w700),
        ],
      ),
    );
  }

  Widget showBudget(BudgetController controller) {
    List<String> images = [p1, p2, p3, p4, p1, p2, p3, p4, p1];
    return Stack(
      children: [
        Container(
          height: Get.height * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // shrinkWrap: true,

            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                        text: 'All Friends',
                        size: 14,
                        color: blackColor,
                        fontWeight: FontWeight.w600),
                    // TextWidget(
                    //     text: 'See all',
                    //     size: 11,
                    //     color: lightGrey,
                    //     fontWeight: FontWeight.w600),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlutterImageStack(
                      imageSource: ImageSource.network,
                      imageList: widget.tripModel.profileUrls ?? [],
                      totalCount: widget.tripModel.profileUrls!.length,
                      itemRadius: 20,
                      itemCount: widget.tripModel.profileUrls!.length,
                      itemBorderWidth: 0.05, // Border width around the images
                    ),
                    MainButton(
                        height: 50,
                        color: primaryColor,
                        width: 130,
                        text: "+ Add Expense",
                        textColor: Colors.white,
                        textSize: 14,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return addPeopleDialog(controller);
                              });
                        },
                        borderRadius: 10,
                        textFont: FontWeight.w700),
                  ],
                ),
              ),
              const Divider(
                color: Color(0xffE0E0E0),
                thickness: 1,
              ),
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    itemCount: controller.groupBudgetModels.length,
                    itemBuilder: (BuildContext context, int index) {
                      // print("controller.groupBudgetModels[index].travellers = ${controller.groupBudgetModels[index].travellers}");
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                                text:
                                    '\$ ${controller.groupBudgetModels[index].amount}',
                                size: 32,
                                color: greenColor,
                                fontWeight: FontWeight.w600),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    List<String> deviceTokens = [];
                                    for (UserModel userModel
                                        in controller.userModels.value) {
                                      deviceTokens
                                          .add(userModel.deviceToken ?? '');
                                    }
                                    CustomSnackBars.instance.showCustomSnack(
                                        color: green,
                                        message: "Reminder has been sent");
                                    LocalNotificationService.instance
                                        .sendFCMNotification(
                                            deviceTokens: deviceTokens,
                                            title: "Plan Together",
                                            body:
                                                "Reminder You have to pay ${controller.groupBudgetModels[index].amount} to ${userModelGlobal.value.name}",
                                            type: 'general',
                                            sentBy:
                                                userModelGlobal.value.id ?? '',
                                            sentTo: '',
                                            savedToFirestore: false);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 70,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: primaryColor),
                                    child: Center(
                                      child: TextWidget(
                                          text: 'Reminder',
                                          size: 10,
                                          color: white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     showCurrencyPicker(
                                //       context: context,
                                //       showFlag: true,
                                //       showCurrencyName: true,
                                //       showCurrencyCode: true,
                                //       onSelect: (Currency currency) {},
                                //     );
                                //   },
                                //   child: Row(
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: [
                                //       TextWidget(
                                //           text: 'Change currency',
                                //           size: 8,
                                //           color: const Color(0xff37474f),
                                //           fontWeight: FontWeight.w500),
                                //       const SizedBox(
                                //         width: 10,
                                //       ),
                                //       Container(
                                //         height: 28,
                                //         width: 58,
                                //         decoration: BoxDecoration(
                                //             color: white,
                                //             borderRadius: BorderRadius.circular(6),
                                //             border:
                                //             Border.all(color: const Color(0xff667085))),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.center,
                                //           children: [
                                //             TextWidget(
                                //                 text: 'USD',
                                //                 size: 11,
                                //                 color: blackColor,
                                //                 fontWeight: FontWeight.w500),
                                //             const Icon(
                                //               Icons.keyboard_arrow_down_outlined,
                                //               color: Color(0xff667085),
                                //               size: 15,
                                //             )
                                //           ],
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ).marginSymmetric(vertical: 10),
                      );
                    },
                  ),
                ),
              ),
              // billItem(),
              // billItem(),
            ],
          ),
        ),
        Obx(
          () => controller.groupBudgetLoading.value
              ? Container(
                  color: Colors.grey.withOpacity(0.8),
                  height: Get.height,
                  width: Get.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        )
      ],
    );
  }

  Widget addPeopleDialog(BudgetController controller) {
    return AlertDialog(
      backgroundColor: const Color(0xfffcfcff),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: 'Add People',
                      size: 17,
                      color: const Color(0xff1B1F31),
                      fontWeight: FontWeight.w600),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xff09121F),
                      size: 22,
                    ),
                  )
                ],
              ),
              const Divider(
                color: Color(0xffE0E0E0),
                thickness: 0.5,
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                  text: 'Persons',
                  size: 14,
                  color: const Color(0xff2F2F2F),
                  fontWeight: FontWeight.w400),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 68,
                child: Obx(
                  () => IgnorePointer(
                    ignoring: controller.isSelectedAll.value,
                    child: DropDownTextField.multiSelection(
                      padding: EdgeInsets.zero,
                      displayCompleteItem: true,
                      initialValue: controller.selectedUserIds,
                      dropDownList: controller.userModels.map((user) {
                        return DropDownValueModel(
                          name: '@${user.name}',
                          // Assuming username is a field in UserModel
                          value: user
                              .id, // You can use any unique identifier as the value
                        );
                      }).toList(),
                      submitButtonColor: Colors.blue,
                      submitButtonText: 'Save',
                      submitButtonTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      dropDownIconProperty: IconProperty(
                          icon: Icons.keyboard_arrow_down_outlined,
                          color: const Color(0xff667085)),
                      textFieldDecoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: border.withOpacity(0.7),
                                  width: 1.6.sp)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: border.withOpacity(0.7),
                                  width: 1.6.sp)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: border.withOpacity(0.7),
                                  width: 1.6.sp)),
                          hintStyle: TextStyle(
                              color: const Color(0xFF828F9C),
                              fontSize: 15.sp,
                              fontFamily: 'ProximaNovaRegular',
                              fontWeight: FontWeight.w400),
                          fillColor: Colors.white,
                          filled: true),
                      onChanged: (val) {
                        List userIds =
                            val.map((item) => item.value as String).toList();
                        // Update the selectedUserIds list in your controller
                        controller.updateSelectedUserIds(userIds);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                    child: Obx(
                      () => Checkbox(
                          value: controller.isSelectedAll.value,
                          onChanged: (val) {
                            controller.paidForEveryone(val);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4))),
                    ),
                  ),
                  TextWidget(
                      text: 'Paid for everyone',
                      size: 11,
                      color: const Color(0xff242323),
                      fontWeight: FontWeight.w600)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                  text: 'Expense',
                  size: 14,
                  color: const Color(0xff2F2F2F),
                  fontWeight: FontWeight.w400),
              const SizedBox(
                height: 10,
              ),
              getTextField(
                  controller: controller.groupExpenseController,
                  borderRadius: 5,
                  contentPadding: 10,
                  InputType: TextInputType.number),
              GestureDetector(
                onTap: () async {
                  print("Clicked");
                  await controller.multiImagePicker();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 35.0, bottom: 20),
                  child: DottedBorder(
                      color: primaryColor,
                      dashPattern: const [4, 6],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(70),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 20),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(70)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: whiteColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget(
                                        text: 'Add Receipt Photos',
                                        size: 13,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500),
                                    TextWidget(
                                        text: 'You can add multiple photos',
                                        size: 8,
                                        color: lightGrey,
                                        fontWeight: FontWeight.w400),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: TextWidget(
                                    text: 'Optional',
                                    size: 8,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              Obx(() => controller.pickedImages.isNotEmpty
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 13,
                      runSpacing: 12,
                      children: List.generate(controller.pickedImages.length,
                          (index) {
                        return Container(
                          height: 50,
                          width: 50,
                          clipBehavior: Clip.none,
                          child: Image.file(controller.pickedImages[index]),
                        );
                      }),
                    )
                  : Container()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: MainButton(
                    height: 60,
                    color: primaryColor,
                    text: "Save",
                    textColor: Colors.white,
                    textSize: 15.55,
                    onPressed: () async {
                      Get.back();
                      print("Add People Called");
                      controller.showFriendsBudget.value = true;
                      await controller.addGroupExpense();
                    },
                    textFont: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget billItem() {
    return GestureDetector(
      onTap: () => Get.to(() => const GroupBillDetails()),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            const Divider(
              color: Color(0xffE0E0E0),
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 15),
              child: TextWidget(
                  text: '10/Nov/2023',
                  size: 12,
                  color: lightGrey,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: 'Lunch Bill',
                      size: 12,
                      color: lightGrey,
                      fontWeight: FontWeight.w500),
                  TextWidget(
                      text: '\$20',
                      size: 14,
                      color: redColor3,
                      fontWeight: FontWeight.w600),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupBillDetails extends StatefulWidget {
  const GroupBillDetails({Key? key}) : super(key: key);

  @override
  State<GroupBillDetails> createState() => _GroupBillDetailsState();
}

class _GroupBillDetailsState extends State<GroupBillDetails> {
  bool isPaid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Details",
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          onMoreButtonPressed: () {}),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: const Color(0xffdcdcdc)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                          text: 'John Doe',
                          size: 18,
                          color: blackColor,
                          fontWeight: FontWeight.w600),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                        child: TextWidget(
                            text: 'Wed, May 08, 2023 •5:30 PM',
                            size: 8,
                            color: darkBlue,
                            fontWeight: FontWeight.w400),
                      ),
                      TextWidget(
                          text: '\$ 512.00',
                          size: 18,
                          color: greenColor,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                TextWidget(
                    text: isPaid ? 'Paid' : 'Unpaid',
                    size: 18,
                    color: isPaid ? greenColor : redColor2,
                    fontWeight: FontWeight.w700)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: MainButton(
                color: primaryColor,
                text: "Mark as paid",
                textColor: Colors.white,
                textSize: 15.55,
                onPressed: () {
                  setState(() {
                    isPaid = true;
                  });
                },
                textFont: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
