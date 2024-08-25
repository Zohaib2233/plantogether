import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/utils/app_strings.dart';
import 'package:plan_together/utils/lists.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';
import 'package:plan_together/widgets/loading_widget.dart';
import 'package:plan_together/widgets/mainButton.dart';

import '../../../utils/global_colors.dart';
import '../../../widgets/get_textfield.dart';
import '../../../widgets/text_widget.dart';
import '../../bindings/bindings.dart';
import '../../controllers/tripController/createtrip2_controller.dart';
import '../../models/user_model.dart';
import '../mainScreens/bottom_tabs.dart';

class CreateTrip2 extends StatelessWidget {
  const CreateTrip2({Key? key}) : super(key: key);

  // int id = 1;
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> tripKey = GlobalKey<FormState>();
    var controller = Get.put(CreateTrip2Controller());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
                text: "Create Trip",
                size: 21,
                color: homeBlackColor,
                fontWeight: FontWeight.w700),
          ],
        ),
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.more_vert_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(29),
                child: Form(
                  key: tripKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                          text: "Trip Name",
                          size: 15,
                          color: const Color(0xff424242),
                          fontWeight: FontWeight.w600),
                      const SizedBox(
                        height: 15,
                      ),
                      getTextField(
                        height: 56,
                        controller: controller.tripNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Trip Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              text: "Start Date",
                              size: 15,
                              color: const Color(0xff424242),
                              fontWeight: FontWeight.w600),
                          SizedBox(
                            width: Get.width * 0.3,
                          ),
                          TextWidget(
                              text: "End Date",
                              size: 15,
                              color: const Color(0xff424242),
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(child: GetBuilder<CreateTrip2Controller>(
                            builder: (controller) {
                              return GestureDetector(
                                onTap: () async {
                                  DateTime pickedDate = await controller
                                      .createDatePicker(context);
                                  controller.tripStartDate.value = pickedDate;
                                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  controller.changeDate(formattedDate);
                                },
                                child: getTextField(
                                    isEnabled: false,
                                    controller: controller.startDateController,
                                    height: 65,
                                    iconData: Icons.calendar_month,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Select Start Date';
                                      }
                                      return null;
                                    }),
                              );
                            },
                          )),
                          Container(
                            width: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: const Divider(
                              thickness: 2,
                            ),
                          ),
                          Expanded(
                            child: GetBuilder<CreateTrip2Controller>(
                              builder: (controller) {
                                return GestureDetector(
                                  onTap: () async {
                                    DateTime pickedDate = await controller
                                        .createDatePicker(context,intialDate: controller.tripStartDate.value);
                                    controller.tripEndDate.value = pickedDate;
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    controller.changeEndDate(formattedDate);
                                  },
                                  child: getTextField(
                                      controller: controller.endDateController,
                                      isEnabled: false,
                                      height: 65,
                                      iconData: Icons.calendar_month,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select Last Date';
                                        }
                                        return null;
                                      }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      TextWidget(
                          text: "Add Travelers",
                          size: 15,
                          color: const Color(0xff424242),
                          fontWeight: FontWeight.w600),
                      const SizedBox(
                        height: 15,
                      ),
                      GetBuilder<CreateTrip2Controller>(
                        builder: (controller) {
                          return TypeAheadField<UserModel>(
                              builder: (context, textController, focusNode) {
                                print(textController.text);
                                return getTextField(
                                  hint: "Search by Username",
                                    controller: textController, focusNode: focusNode);
                              }, itemBuilder: (context, UserModel model) {
                            return ListTile(
                              title: Text(model.name as String),
                              subtitle: Text(model.username as String),
                            );
                          }, onSelected: (UserModel model) {
                            controller.addSelectedUser(model);
                            controller.deviceTokensList.add(model.deviceToken??'');

                          }
                          , suggestionsCallback: (pattern) async {
                                controller.update();
                            return controller.searchUsers(pattern,FirebaseConsts.auth.currentUser?.uid);
                          });
                        },

                      ),

                      Obx(() {
                        return controller.selectedUsers.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selected Members:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Wrap(
                                    spacing: 8,
                                    children:
                                        controller.selectedUsers.map((user) {
                                      return Chip(
                                        label: Text(GetStringUtils("${user.name}").capitalize as String),
                                        onDeleted: () {
                                            controller.removeSelectedUser(user);
                                        controller.deviceTokensList.remove(user.deviceToken);
                                        }
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            : Container();
                      }),

                      const SizedBox(
                        height: 15,
                      ),
                      TextWidget(
                          text: "Destinations",
                          size: 15,
                          color: const Color(0xff424242),
                          fontWeight: FontWeight.w600),

                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                          onTap: (){
                            print("Tapped");
                            Get.bottomSheet(Container(
                                height: Get.height * 0.9,
                                width: Get.width,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                  ),
                                  color: Colors.white,
                                ),
                                //Todo: Place Pick
                                // child: PlacePicker(
                                //   apiKey: AppStrings.apiKey,
                                //   useCurrentLocation:true ,
                                //   initialPosition:  LatLng(-33.8567844, 151.213108),
                                //
                                //   onPlacePicked: (place){
                                //     controller.addSelectedPlace(place);
                                //     Get.back();
                                //   },
                                // )
                            ),  ignoreSafeArea: false,
                              isScrollControlled: true,
                              persistent: true,);
                          },
                          child: getTextField(
                            isEnabled: false,

                              height: 56)),
                      Obx(() {
                        return controller.selectedPlaces.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selected Places:',
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 8,
                              children:
                              controller.selectedPlaces.map((place) {
                                return Chip(
                                  label: Text(GetStringUtils("${place.placeName}").capitalize as String),
                                  onDeleted: () =>
                                      controller.removeSelectedPlace(place),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                            : Container();
                      }),
                      // Expanded(child: Container()),
                      const SizedBox(
                        height: 15,
                      ),
                      TextWidget(
                          text: "How you are Travelling",
                          size: 15,
                          color: const Color(0xff424242),
                          fontWeight: FontWeight.w600),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                            travelModeList.length,
                            (index1) => Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.selectIndex(index1);
                                    },
                                    child: Row(children: [
                                      Container(
                                        height: 18,
                                        width: 18,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffE0E0E0)),
                                        child: Center(
                                          child: Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: controller.index.value ==
                                                      index1
                                                  ? const Color(0xff1976D2)
                                                  : const Color(0xffE0E0E0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      TextWidget(
                                          text: travelModeList[index1],
                                          size: 15,
                                          color: const Color(0xff424242),
                                          fontWeight: FontWeight.w600)
                                    ]),
                                  ),
                                )),
                      ),
                      SizedBox(height: 100,),

                    Padding(
                          padding: const EdgeInsets.only(right: 23, left: 23, bottom: 16),
                          child: InkWell(
                            onTap: () async {
                              if (tripKey.currentState!.validate()) {
                                await controller.createTripe().then((value) async{
                                  await controller.incrementTrips().then((value) {

                                    customSnackBar(
                                        message: "Trip Created Successfully!",
                                        color: green);
                                    Get.offAll(()=>BottomTabs(
                                      currentIndex: 2,
                                    ), binding: BottomNavBinding());
                                  });

                                });
                              }


                            },
                            child: MainButton(
                                color: primaryColor,
                                text: "Create",
                                textColor: whiteColor,
                                textSize: 16,
                                textFont: FontWeight.w700),
                          ),
                        ),


                    ],
                  ),
                ),
              ),
            ),
            Obx(() => loadingWidget(controller.isLoading.value))
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

