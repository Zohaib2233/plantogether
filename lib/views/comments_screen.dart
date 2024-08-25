import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_together/controllers/posts_controller/comment_controller.dart';
import 'package:plan_together/models/postsModel/post_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/widgets/text_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/postsModel/comment_model.dart';
import '../utils/global_colors.dart';
import '../widgets/comments.dart';
import '../widgets/text_field.dart';

class CommentsScreen extends StatelessWidget {
  final PostModel postModel;

  const CommentsScreen({Key? key, required this.postModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CommentController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: whiteColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: blackColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: TextWidget(
          text: "Comments",
          size: 21.88,
          color: homeBlackColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream:
          FirebaseServices.streamComments(postId: postModel.postId),
          builder: (BuildContext context,
              AsyncSnapshot<List<CommentModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            else if (!snapshot.hasData) {
              return Center(child: Text("No Comments Yet!"),);
            }
            else {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    CommentModel commentModel = snapshot.data![index];
                    return Comments(img: commentModel.commentorProfile,
                        timeAgo: timeago.format(commentModel.date,locale: 'en_short'),
                        name: commentModel.commentorName,
                        text: commentModel.commentMsg).paddingSymmetric(horizontal: 20);
                  });
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
        const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 20),
        child: Row(
          children: [
            Expanded(
              child: textField(
                controller: controller.textController,
                text: "Write a Comment",
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                controller.onSendComment(postId: postModel.postId);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Center(
                  child: Image.asset(
                    "assets/icons/send.png",
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset:
      true, // Allow body to resize when keyboard appears
    );
  }
}
