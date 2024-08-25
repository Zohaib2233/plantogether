import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:plan_together/bindings/bindings.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/controllers/chatsController/inbox_controller.dart';
import 'package:plan_together/models/chat_models/chat_thread_model.dart';
import 'package:plan_together/services/chatting_service.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/views/authScreens/Profile_screen.dart';
import 'package:plan_together/views/chat_screen.dart';
import 'package:plan_together/views/group_chat_screen.dart';
import 'package:plan_together/widgets/common_image_view_widget.dart';
import 'package:plan_together/widgets/text_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/user_model.dart';
import '../widgets/inbox_message.dart';
import '../widgets/text_field.dart';
import '../widgets/welcome_widget.dart';

class SearchInbox extends StatefulWidget {
  const SearchInbox({Key? key}) : super(key: key);

  @override
  State<SearchInbox> createState() => _SearchInboxState();
}

class _SearchInboxState extends State<SearchInbox> {
  int _currentIndex = 0;

  void _getCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<String> _tabs = [
    'Private',
    'Groups',
  ];

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(InboxController());
    final List<Widget> tabBarView = [
      privateChats(controller),
      groupChats(),
    ];
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 17, right: 17, top: 25.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  welcomeWidget(
                      headingText: "Plan Together",
                      subheading: "Build your own Vacation or Trip."),
                  TextWidget(
                      text: "Inbox",
                      size: 19.88,
                      color: homeBlackColor,
                      fontWeight: FontWeight.w600),
                  const SizedBox(
                    height: 21,
                  ),
                  textField(
                    onChange: (value){

                      print(controller.isSearch.value);
                      controller.searchUsersByName(value);
                      // setState(() {
                      //
                      // });
                    },
                    controller: controller.searchController,
                    text: "Search People",
                    prefixIcon: Icons.search,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                ],
              ),
            ),

            Obx(()=>
                controller.isSearch.isTrue?
                Expanded(
                  child: StreamBuilder<List<UserModel>>(
                    stream: controller.searchUsersByName(controller.searchController.text),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No users found');
                      }
                      final users = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            UserModel user = users[index];
                            return GestureDetector(
                              onTap: (){
                                Get.to(()=>ProfileScreen(userId: user.id!, isMe: false));
                              },
                              child: ListTile(
                                leading: CommonImageView(
                                  fit: BoxFit.fill,
                                  width: 50,
                                  height: 50,
                                  url: user.profileImgUrl??profileUrlDummy,
                                ),
                                title: Text(user.name??''),
                                subtitle: Text(user.email??''),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )):
                Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: const Color(0xffF0F3F6),
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
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    color: _currentIndex == index
                                        ? primaryColor
                                        : Colors.transparent,
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
            ),

          ],
        ),
      ),
    );
  }

  Widget privateChats(InboxController controller) {
    return StreamBuilder(
      stream: ChattingService.instance.streamChatHeads(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ChatThreadModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text("No Chats Available"),
          );
        } else {
          print("Has Data****************");
          print(snapshot.data);
          return ListView.builder(
              itemCount: snapshot.data?.length,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                print(
                    "***********************  itemCount: controller.chatThreadModel.length ${controller.chatThreadModel.length}");
                ChatThreadModel chatThreadModel = snapshot.data![index];
                return InkWell(
                    onTap: () {
                      Get.to(() => ChatScreen(chatThreadModel: chatThreadModel),
                          binding: ChatScreenBinding());
                    },
                    child: InboxMessage(
                      timeAgo: timeago.format(chatThreadModel.lastMessageTime!,locale: 'en_short'),
                      imageUrl:
                          chatThreadModel.senderID == userModelGlobal.value.id
                              ? chatThreadModel.receiverProfileImage ?? ''
                              : chatThreadModel.senderProfileImage ?? '',
                      lastMessage: chatThreadModel.lastMessage ?? '',
                      messageCount:
                          '${chatThreadModel.senderID == userModelGlobal.value.id ? chatThreadModel.senderUnreadCount : chatThreadModel.receiverUnreadCount}',
                      chatName:
                          chatThreadModel.senderID == userModelGlobal.value.id
                              ? chatThreadModel.receiverName ?? ''
                              : chatThreadModel.senderName ?? '',
                    ));
              });
        }
      },
    );
  }

  Widget groupChats() {
    return ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Get.to(() => const GroupChatScreen());
              },
              child: InboxMessage(
                timeAgo: timeago.format(DateTime.now(),locale: 'en_short'),
                chatName: 'name',
                messageCount: '0',
                lastMessage: '',
                imageUrl: profileUrlDummy,
              ));
        });
  }
}
