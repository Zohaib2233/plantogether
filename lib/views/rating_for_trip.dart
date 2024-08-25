import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_together/controllers/posts_controller/create_post_controller.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/views/mainScreens/bottom_tabs.dart';
import 'package:plan_together/widgets/add_new_trip_button.dart';
import 'package:plan_together/widgets/customScreenLoading.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';
import 'package:plan_together/widgets/get_textfield.dart';
import 'package:plan_together/widgets/mainButton.dart';
import 'package:plan_together/widgets/text_widget.dart';
import 'package:plan_together/widgets/upload_trip_picture.dart';

import '../bindings/bindings.dart';
import '../widgets/cutom_rating/custom_rating_bar.dart';

class TripRatingScreen extends StatelessWidget {
  final TripModel? tripModel;
  const TripRatingScreen({Key? key, this.tripModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CreatePostController>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                      text: "Tell us About your trip",
                      size: 29,
                      color: homeBlackColor,
                      fontWeight: FontWeight.w700),
                  const SizedBox(
                    height: 11,
                  ),
                  TextWidget(
                      text:
                          "Lorem ipsum dolor sit amet consectetur. Laoreet integer maecenas velit non ultricies risus vel..",
                      size: 14,
                      color: const Color(0xff828F9C),
                      fontWeight: FontWeight.w400),
                  const SizedBox(
                    height: 28,
                  ),
                  TextWidget(
                      text: "Upload Trip pictures",
                      size: 17,
                      color: const Color(0xff1B1F31),
                      fontWeight: FontWeight.w700),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      height: 116,
                      width: Get.width,
                      child: Obx(()=>Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            controller.pickedImages.isNotEmpty
                                ? Expanded(
                                    flex: 3,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.pickedImages.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.only(right: 15),
                                            child: UploadTripPicture(
                                              image: controller.pickedImages[index],
                                            ),
                                          );
                                        }),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      controller.multiImagePicker();
                                    },
                                    child: Container(
                                      height: 116,
                                      width: 116,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF0F0F0),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(uploadMoreImages),
                                          TextWidget(
                                              text: "Upload image",
                                              size: 12,
                                              color: const Color(0xff9E9E9E),
                                              fontWeight: FontWeight.w600),
                                        ],
                                      ),
                                    ),
                                  ),
                            Obx(()=>
                                controller.pickedImages.isNotEmpty?
                                Expanded(
                                flex: 1,
                                child: AddNewTripButton(
                                  text: "Add More",
                                  onPressed: () {
                                    controller.multiImagePicker();
                                  },
                                  buttonColor: Colors.white,
                                  textColor: primaryColor,
                                ),
                              ):Container(),
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  TextWidget(
                      text: "Some information about your Trip",
                      size: 17,
                      color: const Color(0xff1B1F31),
                      fontWeight: FontWeight.w700),
                  const SizedBox(
                    height: 7,
                  ),
                  TextWidget(
                      text: "Tell us the overview of your Whole Trip",
                      size: 14,
                      color: const Color(0xff828F9C),
                      fontWeight: FontWeight.w400),
                  const SizedBox(
                    height: 17,
                  ),
                  getTextField(
                      controller: controller.postTextController,
                      maxline: 10, height: 202, borderRadius: 36),
                  const SizedBox(
                    height: 30,
                  ),
                  TextWidget(
                      text: "Rating of Trip",
                      size: 17,
                      color: const Color(0xff1B1F31),
                      fontWeight: FontWeight.w700),
                  const SizedBox(
                    height: 12,
                  ),
                  TextWidget(
                      text: "Rate your Trip from 1-5 Stars",
                      size: 14,
                      color: const Color(0xff828F9C),
                      fontWeight: FontWeight.w400),
                  const SizedBox(
                    height: 15,
                  ),

                  Obx(()=>CustomRatingStar(
                      onTap:(index)=> controller.onStarTap(index),

                      rating: controller.rating.value,
                      starColor: Color(0xffFFCD00),
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              onPressed: () async{
                await controller.onPostExperience(
                  tripDocId: tripModel?.docId??''

                ).then((value){
                  customSnackBar(message: "Post uploaded Successfully!", color: green);
                  // CustomSnackBars.instance.showCustomSnack(color: green, message: "Post uploaded Successfully!");
                  // Get.back();
                });
                Get.offAll(()=>BottomTabs(currentIndex: 3,),binding: BottomNavBinding());


              },
                color: primaryColor,
                text: "Post Experience",
                textColor: Colors.white,
                textSize: 16,
                textFont: FontWeight.w700),
          ),
        ),
        Obx(() => CustomScreenLoading(controller.uploading.value))
      ],
    );
  }
}




