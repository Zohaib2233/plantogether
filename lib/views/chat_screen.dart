import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/controllers/chatsController/chat_controller.dart';
import 'package:plan_together/models/chat_models/chat_thread_model.dart';
import 'package:plan_together/services/chatting_service.dart';
import 'package:plan_together/services/zego_call_service.dart';
import 'package:plan_together/utils/app_strings.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/utils.dart';
import 'package:plan_together/views/audioCall/oneToOne_audioCall.dart';
import 'package:plan_together/widgets/receiver_message.dart';
import 'package:plan_together/widgets/text_field.dart';
import 'package:plan_together/widgets/text_widget.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../models/chat_models/message_model.dart';
import '../widgets/send_message.dart';

class ChatScreen extends StatefulWidget {
  final ChatThreadModel chatThreadModel;

  const ChatScreen({Key? key, required this.chatThreadModel}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var controller = Get.find<ChatController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.initializedMethod(widget.chatThreadModel);
  }

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
            CachedNetworkImage(
              imageUrl:
              widget.chatThreadModel.senderID == userModelGlobal.value.id
                  ? widget.chatThreadModel.receiverProfileImage ?? ''
                  : widget.chatThreadModel.senderProfileImage ?? '',
              imageBuilder: (context, imageProvider) =>
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                    text: widget.chatThreadModel.senderID ==
                        userModelGlobal.value.id
                        ? widget.chatThreadModel.receiverName ?? ''
                        : widget.chatThreadModel.senderName ?? '',
                    size: 16.19,
                    color: homeBlackColor,
                    fontWeight: FontWeight.w500),
                Obx(
                      () =>
                      TextWidget(
                          text: controller.userStatus.value,
                          size: 12.7,
                          color: controller.userStatus.value ==
                              AppStrings.online
                              ? green
                              : Color(0XFF130F26),
                          fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ]),
          actions: [


            ZegoCallService.instance.sendCallInvitationButton(
              onCallFinished: ZegoCallService.instance.onSendCallInvitationFinished,
              targetUserID: widget.chatThreadModel.senderID ==
                  userModelGlobal.value.id
                  ? widget.chatThreadModel.receiverId ?? ''
                  : widget.chatThreadModel.senderID ?? '',
              targetUserName:  widget.chatThreadModel.senderID ==
                  userModelGlobal.value.id
                  ? widget.chatThreadModel.receiverName ?? ''
                  : widget.chatThreadModel.senderName ?? '',
              // onCallFinished: ZegoCallService.instance.onSendCallInvitationFinished
            ),

            // ZegoStartInvitationButton(invitationType: , invitees: invitees, data: data)
            // IconButton(
            //     onPressed: () {
            //       Get.to(() =>
            //           OneToOneAudioCall(
            //               callingId: widget.chatThreadModel.senderID ==
            //                   userModelGlobal.value.id
            //                   ? widget.chatThreadModel.receiverId ?? ''
            //                   : widget.chatThreadModel.senderID ?? ''));
            //     },
            //     icon: const Icon(
            //       Icons.phone_enabled_sharp,
            //       color: blackColor,
            //     )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: blackColor,
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: ChattingService.instance
                      .fetchMessages(chatThreadModel: widget.chatThreadModel),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<MessageModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: Text("No Messages"),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            MessageModel messageModel = snapshot.data![index];
                            return messageModel.sentBy ==
                                userModelGlobal.value.id
                                ? ReceiverMessage(
                              icon: messageModel.seenBySender ?? false
                                  ? Icons.done_all_outlined
                                  : Icons.check_outlined,
                              // icon: Icons.done_all_outlined,

                              text: "${messageModel.message}",
                              time: Utils.formatDateTimetoTime(
                                  messageModel.sentAt!),
                            )
                                : SenderMessage(
                              imageUrl: widget.chatThreadModel.senderID ==
                                  userModelGlobal.value.id
                                  ? widget.chatThreadModel
                                  .receiverProfileImage ??
                                  ''
                                  : widget.chatThreadModel
                                  .senderProfileImage ??
                                  '',
                              text: "${messageModel.message}",
                              time: Utils.formatDateTimetoTime(
                                  messageModel.sentAt!),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(children: [
                      Expanded(
                        child: textField(
                            controller: controller.messageController,
                            text: "Type a message",
                            prefixIcon: Icons.attachment_outlined,
                            prefixColor: const Color(0xffADB3BC),
                            sufixIcon: const Icon(
                              Icons.emoji_emotions_outlined,
                              color: Color(0xffADB3BC),
                            )),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.sendMessage(
                              chatThreadModel: widget.chatThreadModel);
                        },
                        child: Container(
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
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ],
          ),
        )

    );
  }
}

ZegoSendCallInvitationButton callButton(isAudio, id, name) {
  return ZegoSendCallInvitationButton(
    buttonSize: const Size(50, 50),
    // icon: ButtonIcon(
    //
    //   icon: const Icon(
    //     Icons.phone_enabled_sharp,
    //     color: blackColor,
    //   )
    // ),
    iconSize: const Size(40, 40),
    invitees: [ZegoUIKitUser(id: id, name: name)],
    isVideoCall: isAudio,
    resourceID: "zego_call",

  );
}
