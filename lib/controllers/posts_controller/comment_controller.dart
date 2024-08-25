import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:plan_together/services/firebase_services.dart';

class CommentController extends GetxController{

  TextEditingController textController = TextEditingController();


  onSendComment({required postId}) async{
    if(textController.text.isNotEmpty){
      await FirebaseServices.addComment(postId: postId, commentMsg: textController.text);
      textController.clear();
    }

  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    textController.dispose();
  }


}