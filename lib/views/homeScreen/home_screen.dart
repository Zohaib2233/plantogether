import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_together/bindings/bindings.dart';
import 'package:plan_together/cards/home_screen_card.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/views/authScreens/Profile_screen.dart';
import 'package:plan_together/views/comments_screen.dart';
import 'package:plan_together/views/homeScreen/create_trip2.dart';
import 'package:plan_together/widgets/mainButton.dart';
import 'package:plan_together/widgets/text_widget.dart';

import '../../../widgets/welcome_widget.dart';
import '../../models/postsModel/post_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List circleIcons = const [];

  List starIcons = const [
    Icon(
      Icons.star,
      color: Color(0xffFFCD00),
    ),
    Icon(
      Icons.star,
      color: Color(0xffFFCD00),
    ),
    Icon(
      Icons.star,
      color: Color(0xffFFCD00),
    ),
    Icon(
      Icons.star,
      color: Color(0xffFFFFFF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 17, right: 17, top: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                welcomeWidget(
                    headingText: "Plan Together",
                    subheading: "Build your own Vacation or Trip."),
                MainButton(
                    color: primaryColor,
                    text: "Start Building my Trip",
                    textFont: FontWeight.w700,
                    textSize: 16,
                    onPressed: () {
                      Get.to(() => const CreateTrip2());
                    },
                    textColor: Colors.white),
                const SizedBox(
                  height: 30,
                ),
                TextWidget(
                    text: "Community Timeline",
                    size: 19.88,
                    color: homeBlackColor,
                    fontWeight: FontWeight.w600),
                const SizedBox(
                  height: 19,
                ),
                StreamBuilder(
                  stream: FirebaseServices.streamAllPosts(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PostModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print(
                          "snapshot.connectionState == ConnectionState.waiting");

                      return Container(
                          height: Get.height,
                          width: Get.width,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ));
                    } else if (!snapshot.hasData) {
                      print("!snapshot.hasData");

                      return Center(
                        child: Text("No posts Created Yet!"),
                      );
                    } else {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          print(index);

                          if (snapshot.data!.isEmpty) {
                            print("snapshot.data!.isEmpty");
                            return Center(
                              child: Text("No posts Created Yet!"),
                            );
                          } else {
                            print("snapshot.data!.isEmpty Not");
                            PostModel postModel = snapshot.data![index];
                            return HomeScreenCard(
                                postByMe: userModelGlobal.value.id ==
                                    postModel.createdBy,
                                onConnectClicked: () async {
                                  await FirebaseServices.connectToFriend(
                                      following:
                                          userModelGlobal.value.following,
                                      userId: postModel.createdBy);
                                },
                                isConnected: userModelGlobal.value.following
                                    .contains(postModel.createdBy),
                                isBookmark: userModelGlobal.value.bookmarkPosts
                                    .contains(snapshot.data![index].postId),
                                onBookmarkPressed: () {
                                  FirebaseServices.addPostToBookmark(
                                      bookmarkPosts:
                                          userModelGlobal.value.bookmarkPosts,
                                      postId: snapshot.data![index].postId);
                                },
                                isFavourite: snapshot.data![index].likes
                                    .contains(userModelGlobal.value.id),
                                onLikeClick: () async {
                                  await FirebaseServices.likePost(
                                      likes: snapshot.data![index].likes,
                                      docId: snapshot.data![index].postId);
                                },
                                images: snapshot.data![index].imageUrls,
                                comments:
                                    '${snapshot.data![index].totalComments}',
                                hearts: '${snapshot.data![index].totalLikes}',
                                rating: snapshot.data![index].rate,
                                onCommentPressed: () {
                                  Get.to(
                                      () =>
                                          CommentsScreen(postModel: postModel),
                                      binding: CommentBinding());
                                },
                                image: home,
                                userProfile:
                                    snapshot.data![index].createrProfile,
                                description: snapshot.data![index].description,
                                username: snapshot.data![index].createrName,
                                onProfilePressed: () {
                                  Get.to(() => ProfileScreen(
                                        userId: snapshot.data![index].createdBy,
                                        isMe: postModel.createdBy ==
                                            userModelGlobal.value.id,
                                      ));
                                });
                          }
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
