import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:get/get.dart';
import 'package:plan_together/utils/app_strings.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/receiver_message.dart';
import 'package:plan_together/widgets/text_field.dart';
import 'package:plan_together/widgets/text_widget.dart';

import '../widgets/get_textfield.dart';
import '../widgets/mainButton.dart';
import '../widgets/send_message.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({Key? key}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  List pollOptions = [
    {
      'id': 1,
      'question':
          'Is Flutter the best framework for building cross-platform applications?',
      'end_date': DateTime(2023, 11, 21),
      'options': [
        {
          'id': 1,
          'title': 'Dubai',
          'votes': 40,
        },
        {
          'id': 2,
          'title': 'England',
          'votes': 20,
        },
        {
          'id': 3,
          'title': 'Australia',
          'votes': 10,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            color: blackColor,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Row(children: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("assets/images/profile2.png"),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                  text: "Ashley",
                  size: 16.19,
                  color: homeBlackColor,
                  fontWeight: FontWeight.w500),
              TextWidget(
                  text: "Online",
                  size: 12.7,
                  color: const Color(0XFF130F26),
                  fontWeight: FontWeight.w400),
            ],
          ),
        ]),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.phone_enabled_sharp,
                color: blackColor,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: blackColor,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  const ReceiverMessage(
                    text: "Hello, good morning :)",
                    time: "11:20 PM",
                    icon: Icons.done_all_outlined,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SenderMessage(
                    time: "11:25 AM",
                    imageUrl: AppStrings.dummyProfileUrl,
                    text:
                        "Good morning, I saw your profile and i like your Personality.",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const ReceiverMessage(text: "Thanks 😍"),
                  const ReceiverMessage(image: "assets/images/message.png"),
                  // const ReceiverMessage(
                  //   text: "We are Going for the trip in \nDubai you wanna join",
                  //   time: "11:20 PM",
                  //   icon: Icons.done_all_outlined,
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         height: 61,
                  //         width: 39,
                  //         decoration: const BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             image: DecorationImage(
                  //                 image: AssetImage("assets/images/inbox.png"),
                  //                 fit: BoxFit.cover)),
                  //       ),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       Padding(
                  //           padding: const EdgeInsets.only(top: 15),
                  //           child:
                  //           Image.asset("assets/images/message_type.png"))
                  //     ]),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, left: 40),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FlutterPolls(
                      pollId: '1',
                      onVoted:
                          (PollOption pollOption, int newTotalVotes) async {
                        await Future.delayed(const Duration(seconds: 1));

                        /// If HTTP status is success, return true else false
                        return true;
                      },
                      pollOptionsBorder: Border.all(color: Colors.transparent),
                      pollOptionsHeight: 42,
                      votedProgressColor: primaryColor,
                      pollTitle: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Where should we go next time?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      pollOptions: List<PollOption>.from(
                        pollOptions[0]['options'].map(
                          (option) {
                            var a = PollOption(
                              id: option['id'].toString(),
                              title: Text(
                                option['title'],
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              votes: option['votes'],
                            );
                            return a;
                          },
                        ),
                      ),
                      pollOptionsFillColor: primaryColor,
                      votedBackgroundColor: const Color(0xffF9F5ED),
                    ),
                  ),

                  const ReceiverMessage(
                    text: "Please answer to poll",
                    time: "11:20 PM",
                    icon: Icons.done_all_outlined,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(children: [
                  const Icon(
                    Icons.attachment,
                    color: Color(0xffADB3BC),
                    size: 25,
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return createPollDialog();
                            });
                      },
                      child: const Icon(
                        Icons.poll,
                        color: Color(0xffADB3BC),
                        size: 25,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: textField(
                        text: "Type a message",
                        sufixIcon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Color(0xffADB3BC),
                        )),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor),
                    child: Center(
                      child: Image.asset(
                        "assets/icons/send3.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                  )
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createPollDialog() {
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
                      text: 'Create Poll',
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
                  text: 'Question',
                  size: 14,
                  color: const Color(0xff2F2F2F),
                  fontWeight: FontWeight.w400),
              const SizedBox(
                height: 10,
              ),
              getTextField(
                borderRadius: 5,
                contentPadding: 10,
              ),
              TextWidget(
                  text: 'Options',
                  size: 14,
                  color: const Color(0xff2F2F2F),
                  fontWeight: FontWeight.w400),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: whiteColor,
                        size: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextWidget(
                      text: 'Add option',
                      size: 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w500)
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: MainButton(
                    height: 60,
                    color: primaryColor,
                    text: "Done",
                    textColor: Colors.white,
                    textSize: 15.55,
                    onPressed: () {
                      Get.back();
                    },
                    textFont: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
