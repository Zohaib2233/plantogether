import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/models/chat_models/chat_thread_model.dart';
import 'package:plan_together/services/chatting_service.dart';
import 'package:plan_together/utils/app_strings.dart';

import '../../models/user_model.dart';

class InboxController extends FullLifeCycleController with FullLifeCycleMixin {
  RxList<ChatThreadModel> chatThreadModel = <ChatThreadModel>[].obs;
  TextEditingController searchController = TextEditingController();

  RxBool isSearch = false.obs;

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection(FirebaseConsts.userCollection);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    ChattingService.instance.streamChatHeads().listen((events) {
      List<ChatThreadModel> tempList = [];

      // for(ChatThreadModel event in events){
      //   print(event.toMap());
      //   tempList.add(event);
      // }

      events.sort(
        (a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime as DateTime),
      );
      chatThreadModel.value = events;

      // tempList.assignAll(event);
    });
    print(
        "On init method InboxController---------------- ${userModelGlobal.value.id}  ");

    setStatus(status: AppStrings.online);
  }

  Stream<List<UserModel>> searchUsersByName(String name) {
    if(searchController.text.isNotEmpty){
      isSearch(true);

    }else{
      isSearch(false);
    }

    return usersCollection
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: name + '\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }

  setStatus({required String status}) async {
    try{
      await FirebaseConsts.firestore
          .collection(FirebaseConsts.userCollection)
          .doc(FirebaseConsts.auth.currentUser?.uid)
          .update({
        'status':status
      });

    }
    catch(e){
      throw Exception(e);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setStatus(status: AppStrings.online);
      print("Resumed.........");
    } else {
      setStatus(status: AppStrings.offline);
      print("Offline-------------");
    }
  }
}
