import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:plan_together/bindings/bindings.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/models/user_model.dart';

import '../models/chat_models/chat_thread_model.dart';
import '../models/chat_models/message_model.dart';
import '../views/chat_screen.dart';

class ChattingService {
  ChattingService._privateConstructor();

  static ChattingService? _instance;

  static ChattingService get instance {
    _instance ??= ChattingService._privateConstructor();
    return _instance!;
  }

  createChatThread({required UserModel userModel
      // required EventModel eventModel,
      }) async {
    try {
      // Query for existing chat thread
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConsts.chatRoomsCollection)
          .where(Filter.or(Filter.and(
          Filter('senderID', isEqualTo: userModelGlobal.value.id),
          Filter('receiverId', isEqualTo: userModel.id)), Filter.and(
          Filter('senderID', isEqualTo: userModel.id),
          Filter('receiverId', isEqualTo: userModelGlobal.value.id))))

          .get();

      // If chat thread exists, navigate to chat screen
      if (snapshot.docs.isNotEmpty) {
        ChatThreadModel chatThreadModel =
            ChatThreadModel.fromMap(snapshot.docs.first);
        Get.to(() => ChatScreen(chatThreadModel: chatThreadModel),
            binding: ChatScreenBinding(), arguments: chatThreadModel);
      }
      // If chat thread doesn't exist, create a new one
      else {
        DocumentReference reference = FirebaseConsts.firestore
            .collection(FirebaseConsts.chatRoomsCollection)
            .doc();

        print("******* Chat Thread Created ******** ${reference.id}");

        ChatThreadModel chatThreadModel = ChatThreadModel(
          chatHeadId: reference.id,
          senderName: userModelGlobal.value.name,
          receiverName: userModel.name,
          receiverProfileImage: userModel.profileImgUrl,
          senderProfileImage: userModelGlobal.value.profileImgUrl,
          lastMessageTime: DateTime.now(),
          participants: [],
          receiverId: userModel.id,
          senderID: userModelGlobal.value.id,
          receiverUnreadCount: 0,
          senderUnreadCount: 0,
        );
        await reference.set(chatThreadModel.toMap());

        Get.to(() => ChatScreen(chatThreadModel: chatThreadModel),
            binding: ChatScreenBinding(), arguments: [chatThreadModel]);
      }
    } catch (e) {
      print('Error creating or accessing chat thread: $e');
      throw Exception(e);
      // Handle the error as needed
    }
  }

  Future sendMessage(
      {required ChatThreadModel chatThreadModel,
      required String message}) async {
    try {
      DocumentReference reference = FirebaseConsts.firestore
          .collection(FirebaseConsts.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .collection(FirebaseConsts.messagesCollection)
          .doc();

      MessageModel messageModel = MessageModel(
          message: message,
          messageId: reference.id,
          sentAt: DateTime.now(),
          sentBy: userModelGlobal.value.id);

      await reference.set(messageModel.toMap());
      print(
          "Message Send = ${chatThreadModel.senderID} ------------ ${userModelGlobal.value.id}");
      if (chatThreadModel.senderID == userModelGlobal.value.id) {
        await FirebaseConsts.firestore
            .collection(FirebaseConsts.chatRoomsCollection)
            .doc(chatThreadModel.chatHeadId)
            .update({
          'lastMessage': message,
          'lastMessageTime': DateTime.now(),
          'receiverUnreadCount': FieldValue.increment(1)
        });
      } else {
        await FirebaseConsts.firestore
            .collection(FirebaseConsts.chatRoomsCollection)
            .doc(chatThreadModel.chatHeadId)
            .update({
          'lastMessage': message,
          'lastMessageTime': DateTime.now(),
          'senderUnreadCount': FieldValue.increment(1)
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<ChatThreadModel>> streamChatHeads() {
    print("--------------------Stream Chat Heads Call-----------------------");
    // print(FirebaseConstants.auth.currentUser?.uid);
    try {
      return FirebaseConsts.firestore
          .collection(FirebaseConsts.chatRoomsCollection)
          .where(Filter.or(
              Filter('senderID', isEqualTo: userModelGlobal.value.id),
              Filter('receiverId', isEqualTo: userModelGlobal.value.id)))
          .orderBy('lastMessageTime', descending: false)
          .snapshots()
          .map((documents) {
        // print(documents.docs.asMap());
        return documents.docs
            .map((doc) => ChatThreadModel.fromMap(doc))
            .toList();
      });
    } catch (e) {
      print(e);
      print("Catch e Called");

      // return <ChatThreadModel>[];
      throw Exception(e);
    }
  }

  Stream<List<MessageModel>> fetchMessages(
      {required ChatThreadModel chatThreadModel}) {
    try {
      print("Called fetchMessages");
      return FirebaseConsts.firestore
          .collection(FirebaseConsts.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .collection('messages')
          .orderBy('sentAt', descending: false)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => MessageModel.fromJson1(e.data())).toList());
    } catch (e) {
      throw Exception(e);
    }
  }
}
