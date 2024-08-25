import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_together/controllers/tripController/trip_summary_controller.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/utils/utils.dart';
import 'package:plan_together/widgets/get_textfield.dart';
import 'package:plan_together/widgets/text_widget.dart';

import '../utils/global_colors.dart';
import 'mainButton.dart';

class TripSummarySafety extends StatefulWidget {
  final TripModel tripModel;

  const TripSummarySafety({Key? key, required this.tripModel,})
      : super(key: key);

  @override
  State<TripSummarySafety> createState() => _TripSummarySafetyState();

}

class _TripSummarySafetyState extends State<TripSummarySafety> {
  int _currentIndex = 0;

  void _getCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<String> _tabs = [
    'Phone Numbers',
    'Pictures/documents',
  ];

  @override
  Widget build(BuildContext context) {
    print("*************${widget.tripModel.docId}***********8");
    var controller = Get.find<TripSummaryController>();
    final List<Widget> tabBarView = [
      phoneNumbers(controller),
      photosAndDocuments(controller),
    ];
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xffEDEEEF),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                child: Row(
                  children: List.generate(
                    _tabs.length,
                        (index) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _getCurrentIndex(index),
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 180,
                            ),
                            height: MediaQuery
                                .of(context)
                                .size
                                .height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: _currentIndex == index
                                  ? primaryColor
                                  : const Color(0xffEDEEEF),
                            ),
                            child: Center(
                              child: TextWidget(
                                text: _tabs[index],
                                size: 16,
                                fontWeight: FontWeight.w500,
                                color: _currentIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: tabBarView,
                ),
              ),
            ],
          ),
        ),
        Obx(() =>
        controller.isNumberAdding.value ? Container(
          height: Get.height, width: Get.width,
          color: Colors.grey.withOpacity(0.8),
          child: Center(child: CircularProgressIndicator(),),) : Container())
      ],
    );
  }

  Widget phoneNumbers(TripSummaryController controller) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        const SizedBox(
          height: 20,
        ),
        MainButton(
            onPressed: () {
              // Get.dialog(addPhoneNumberDialog());
              showDialog(
                  context: context,
                  builder: (context) {
                    return addPhoneDialog(controller);
                  });
            },
            height: 60,
            color: primaryColor,
            text: "Add New Item",
            textColor: Colors.white,
            textSize: 14.55,
            textFont: FontWeight.w700),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10),
          child: TextWidget(
              text: 'Added Phone Numbers',
              size: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        Obx(() =>
            ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: controller.phoneNumbers.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 13,
                  );
                },
                itemBuilder: (context, index) {
                  return phoneNumberTile(
                      phoneNumber: controller.phoneNumbers[index].phoneNumber ??
                          '',
                      phoneName: controller.phoneNumbers[index].name ?? ''
                  );
                }),
        ),
      ],
    );
  }

  Widget photosAndDocuments(TripSummaryController controller) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        const SizedBox(
          height: 20,
        ),
        MainButton(
            height: 60,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return addDocumentDialog(controller);
                  });
            },
            color: primaryColor,
            text: "Add More Items",
            textColor: Colors.white,
            textSize: 14.55,
            textFont: FontWeight.w700),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10),
          child: TextWidget(
              text: 'Added Pictures/Documents',
              size: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        StreamBuilder(stream: FirebaseServices.getSafetyDocuments(
            tripId: widget.tripModel.docId!),
            builder: (context, snapshot)
    {
      if(!snapshot.hasData){
        return Text("No Documents Added");
      }
      else{
        return  ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 13,
              );
            },
            itemBuilder: (context, index) {
              return picturesTile(
                image: getImageForFileType(snapshot.data![index].documentUrl),
                  date: Utils.formatDate(
                      snapshot.data![index].time),
                  title: snapshot.data![index].title
              );
            });
      }

    }

        )

      ],
    );
  }

  Widget phoneNumberTile({
    required String phoneName,
    required String phoneNumber,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: blackColor.withOpacity(0.036),
                blurRadius: 20,
                offset: const Offset(0, 3)),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget(
                  text: phoneName,
                  size: 14,
                  color: blackColor,
                  fontWeight: FontWeight.w400),
              const SizedBox(
                height: 10,
              ),
              TextWidget(
                  text: phoneNumber,
                  size: 18,
                  color: blackColor,
                  fontWeight: FontWeight.w600),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/bookmark.png',
                height: 24,
                width: 24,
              ),
              popupButton()
            ],
          ),
        ],
      ),
    );
  }

  Widget picturesTile({required String title, required String date,required String image}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: blackColor.withOpacity(0.036),
                blurRadius: 20,
                offset: const Offset(0, 3)),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                image,
                height: 70,
                width: 70,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                      text: title,
                      size: 14,
                      color: blackColor,
                      fontWeight: FontWeight.w600),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                      text: '$date',
                      size: 12,
                      color: const Color(0xff676767),
                      fontWeight: FontWeight.w600),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/bookmark.png',
                height: 24,
                width: 24,
              ),
              popupButton(),
              // Image.asset(
              //   'assets/images/more_vert.png',
              //   height: 24,
              //   width: 24,
              //   color: const Color(0xff565656),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget popupButton() {
    return PopupMenuButton(
      elevation: 4,
      color: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      position: PopupMenuPosition.over,
      offset: const Offset(-20, 00),
      constraints: BoxConstraints(
        minWidth: MediaQuery
            .of(context)
            .size
            .width * .4,
        maxWidth: MediaQuery
            .of(context)
            .size
            .width * .4,
      ),
      enableFeedback: false,
      itemBuilder: (BuildContext context) {
        return [
          // PopupMenuItem(
          //     value: 1,
          //     padding: const EdgeInsets.all(0),
          //     child: InkWell(
          //       onTap: () {},
          //       child: Column(
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(
          //                 bottom: 8.0, left: 15, right: 10, top: 4),
          //             child: Row(
          //               children: [
          //                 Image.asset(
          //                   'assets/images/edit_green.png',
          //                   height: 15,
          //                 ),
          //                 const SizedBox(
          //                   width: 10,
          //                 ),
          //                 TextWidget(
          //                     text: 'Edit',
          //                     size: 11,
          //                     color: const Color(0xff148326),
          //                     fontWeight: FontWeight.w400)
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     )),
          PopupMenuItem(
              value: 2,
              padding: const EdgeInsets.all(0),
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 15, right: 10, top: 4),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/delete_red.png',
                            height: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                              text: 'Delete',
                              size: 11,
                              color: const Color(0xffA52048),
                              fontWeight: FontWeight.w400)
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/more_vert.png',
          height: 24,
          width: 24,
          color: const Color(0xff565656),
        ),
      ),
    );
  }

  Widget addDocumentDialog(TripSummaryController controller) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xffFCFCFF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
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
                    text: 'Add Pictures/Documents',
                    size: 17,
                    color: const Color(0xff1B1F31),
                    fontWeight: FontWeight.w700),
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
              thickness: 1,
            ),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
                text: 'Title',
                size: 17,
                color: const Color(0xff2F2F2F),
                fontWeight: FontWeight.w400),
            const SizedBox(
              height: 10,
            ),
            getTextField(
                controller: controller.fileTitleController,
                borderRadius: 5, contentPadding: 10),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
                text: 'Attach picture/document',
                size: 17,
                color: const Color(0xff2F2F2F),
                fontWeight: FontWeight.w400),
            const SizedBox(
              height: 30,
            ),
            Obx(() =>
            controller.filePath.isEmpty ?
            Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      await controller.selectFile();
                    },
                    child: Image.asset(
                      'assets/images/blue_dcoument.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(
                    child: TextWidget(
                        text: 'Upload files',
                        size: 17,
                        color: primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: TextWidget(
                      text: 'pdf, png, jpg, word',
                      size: 13,
                      color: const Color(0xff979797),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ) :
            SizedBox(
                height: 100,
                width: 100,
                child: Image.file(File(controller.filePath.value))),
            ),

            const SizedBox(
              height: 30,
            ),
            TextWidget(
                text: 'Privacy options',
                size: 17,
                color: const Color(0xff2F2F2F),
                fontWeight: FontWeight.w400),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.changePublicValue();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xffE0E0E0), shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(() =>
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.isPublic.value
                                  ? primaryColor
                                  : Colors.transparent,
                            ),
                          ),
                      ),
                    ),
                  ),
                ),
                TextWidget(
                    text: 'Public',
                    size: 15,
                    color: const Color(0xff424242),
                    fontWeight: FontWeight.w600),
                GestureDetector(
                  onTap: () {
                    controller.changePublicValue();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, left: 50),
                    decoration: const BoxDecoration(
                        color: Color(0xffE0E0E0), shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(() =>
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.isPrivate.value
                                    ? primaryColor
                                    : Colors.transparent),
                          ),
                      ),
                    ),
                  ),
                ),
                TextWidget(
                    text: 'Private',
                    size: 15,
                    color: const Color(0xff424242),
                    fontWeight: FontWeight.w600)
              ],
            ),
            const Spacer(),
            MainButton(
                onPressed: () async {
                  Get.back();
                  await controller.addDocument();
                },
                height: 60,
                color: primaryColor,
                text: "Add",
                textColor: Colors.white,
                textSize: 14.55,
                textFont: FontWeight.w700),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Widget addPhoneDialog(TripSummaryController controller) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xffFCFCFF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
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
                    text: 'Add Phone numbers',
                    size: 17,
                    color: const Color(0xff1B1F31),
                    fontWeight: FontWeight.w700),
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
              thickness: 1,
            ),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
                text: 'Name',
                size: 17,
                color: const Color(0xff2F2F2F),
                fontWeight: FontWeight.w400),
            const SizedBox(
              height: 10,
            ),
            getTextField(
                controller: controller.phoneNameController,
                borderRadius: 5, contentPadding: 5),
            TextWidget(
                text: 'Phone No',
                size: 17,
                color: const Color(0xff2F2F2F),
                fontWeight: FontWeight.w400),
            const SizedBox(
              height: 10,
            ),
            getTextField(
                InputType: TextInputType.number,
                controller: controller.phoneNumberController,
                borderRadius: 5, contentPadding: 5),
            const SizedBox(
              height: 20,
            ),


            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.changePublicValue();

                    print("public ${controller.isPublic
                        .value} private ${controller.isPrivate.value}");
                  },
                  child: Obx(() =>
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                            color: Color(0xffE0E0E0), shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.isPublic.value
                                  ? primaryColor
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                  ),
                ),
                TextWidget(
                    text: 'Public',
                    size: 15,
                    color: const Color(0xff424242),
                    fontWeight: FontWeight.w600),
                GestureDetector(
                  onTap: () {
                    controller.changePublicValue();

                    print("public ${controller.isPublic
                        .value} private ${controller.isPrivate.value}");
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, left: 50),
                    decoration: const BoxDecoration(
                        color: Color(0xffE0E0E0), shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(() =>
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.isPrivate.value
                                    ? primaryColor
                                    : Colors.transparent),
                          ),
                      ),
                    ),
                  ),
                ),
                TextWidget(
                    text: 'Private',
                    size: 15,
                    color: const Color(0xff424242),
                    fontWeight: FontWeight.w600)
              ],
            ),
            const Spacer(),
            MainButton(
                onPressed: () async {
                  Get.back();
                  await controller.addPhoneNumber();
                },
                height: 60,
                color: primaryColor,
                text: "Add",
                textColor: Colors.white,
                textSize: 14.55,
                textFont: FontWeight.w700),
            const SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }

String getImageForFileType(String fileName) {
    // Determine the file extension
    String extension = fileName.split('/').last.split('?').first.split('.').last.toLowerCase();
    // print(extension);
    // Assign an image based on the file extension
    switch (extension) {
      case 'pdf':
        return 'assets/icons/pdf.png';
      case 'png':
      case 'jpg':
      case 'jpeg':
        return 'assets/icons/picture.png';
      case 'doc':
        return 'assets/doc_icon.png';
      default:
        return 'assets/icons/picture.png';
    }
  }
}
