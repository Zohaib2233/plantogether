import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/models/chat_models/chat_thread_model.dart';
import 'package:plan_together/services/chatting_service.dart';

class ChatController extends GetxController {
  TextEditingController messageController = TextEditingController();

  RxString userStatus = 'Offline'.obs;

  sendMessage({required ChatThreadModel chatThreadModel}) async {
    print("Button Clicked");
    if (messageController.text.isNotEmpty) {
      await ChattingService.instance.sendMessage(
          chatThreadModel: chatThreadModel, message: messageController.text);
    }
    messageController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    //chatThreadModel = Get.arguments as ChatThreadModel;
    // ChattingService.instance.fetchMessages(chatThreadModel: Get.arguments[0]);

    print(Get.arguments);
    //print(chatThreadModel.toMap());
  }

  initializedMethod(ChatThreadModel chatThreadModel) async {
    if (chatThreadModel.senderID == userModelGlobal.value.id) {
      seenMessage(chatThreadModel: chatThreadModel, isSender: false);
      FirebaseConsts.firestore
          .collection(FirebaseConsts.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .update({'senderUnreadCount': 0});

      DocumentSnapshot<Map<String, dynamic>> document = await FirebaseConsts
          .firestore
          .collection(FirebaseConsts.userCollection)
          .doc(chatThreadModel.receiverId)
          .get();

      userStatus.value = document['status'];
    } else {
      seenMessage(chatThreadModel: chatThreadModel, isSender: true);
      FirebaseConsts.firestore
          .collection(FirebaseConsts.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .update({'receiverUnreadCount': 0});

      DocumentSnapshot<Map<String, dynamic>> document = await FirebaseConsts
          .firestore
          .collection(FirebaseConsts.userCollection)
          .doc(chatThreadModel.senderID)
          .get();

      userStatus.value = document['status'];
    }
  }

  seenMessage({required ChatThreadModel chatThreadModel,required bool isSender}) async{
    if(isSender){
      QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseConsts.firestore
          .collection(FirebaseConsts.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .collection(FirebaseConsts.messagesCollection).where('sentBy',isEqualTo: FirebaseConsts.auth.currentUser?.uid)
          .get();

      for(var snapshot in snapshots.docs){

        snapshot.reference.update({
          'seenBySender':true
        });

      }
    }
    else{
      QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseConsts.firestore
          .collection(FirebaseConsts.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .collection(FirebaseConsts.messagesCollection).where('sentBy',isNotEqualTo: FirebaseConsts.auth.currentUser?.uid)
          .get();

      for(var snapshot in snapshots.docs){

        snapshot.reference.update({
          'seenBySender':true
        });

      }
    }

  }

}
