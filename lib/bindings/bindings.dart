import 'package:get/get.dart';
import 'package:plan_together/controllers/authControllers/login_controller.dart';
import 'package:plan_together/controllers/authControllers/signup_controller.dart';
import 'package:plan_together/controllers/chatsController/chat_controller.dart';
import 'package:plan_together/controllers/chatsController/inbox_controller.dart';
import 'package:plan_together/controllers/posts_controller/comment_controller.dart';
import 'package:plan_together/controllers/posts_controller/create_post_controller.dart';

class IntialBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SignupController());
    Get.put(LoginController());

  }

}

class TripSummaryBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    // Get.put(TripSummaryController(docId: docId));
  }

}

class AuthBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(SignupController());
    Get.put(LoginController());
    // TODO: implement dependencies
  }

}

class CreatePostBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(CreatePostController());
  }

}

class CommentBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.put(CommentController());
  }

}

class ChatScreenBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ChatController());
  }
}

class BottomNavBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    // Get.put(InboxController());
  }

}