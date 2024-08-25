import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_together/cards/trips_with_friends.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/controllers/authControllers/profile_controller.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/services/chatting_service.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/services/sharedpreference_service.dart';
import 'package:plan_together/services/zego_call_service.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/utils/shared_preference_keys.dart';
import 'package:plan_together/views/followers_screen.dart';
import 'package:plan_together/views/simple_trip_screen.dart';
import 'package:plan_together/views/splash_screen.dart';
import 'package:plan_together/widgets/customScreenLoading.dart';
import 'package:plan_together/widgets/custom_app_bar.dart';
import 'package:plan_together/widgets/profile.dart';

import '../../bindings/bindings.dart';
import '../../cards/home_screen_card.dart';
import '../../models/postsModel/post_model.dart';
import '../../utils/global_colors.dart';
import '../../utils/utils.dart';
import '../../widgets/mainButton.dart';
import '../../widgets/text_widget.dart';
import '../comments_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final bool isMe;

  const ProfileScreen({Key? key, required this.userId, required this.isMe})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  var controller = Get.put(ProfileController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    if(widget.isMe){
      controller.userModel.value = userModelGlobal.value;
    }
    else{
      controller.fetchUserDetail(userId: widget.userId);
    }

    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sharedPref = SharedPreferenceService();
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        onMoreButtonPressed: () async {
          print(controller.userModel.value.bgImgUrl?.isEmpty);
          showPopupMenu(context, onLogoutTap: () async {
            ZegoCallService.instance.onUserLogout();
            await FirebaseConsts.auth.signOut();

            await sharedPref
                .removeSharedPreferenceBool(SharedPrefKeys.loggedIn);
            Get.offAll(() => const SplashScreen(),binding: AuthBindings());
          });
        },
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => ProfileWidget(
                          profileImageProvider: controller
                                  .profileImagePath.isNotEmpty
                              ? FileImage(
                                  File(controller.profileImagePath.value))
                              : controller.userModel.value.profileImgUrl == null
                                  ? const AssetImage(profile3) as ImageProvider
                                  // : NetworkImage(controller.profileImageUrl.value),
                                  : CachedNetworkImageProvider(controller
                                      .userModel.value.profileImgUrl!),
                          bgBtn: () async {
                            // print("Clicked");
                            await controller.changeImage(context, false);
                            // await controller.pickImage(ImageSource.gallery, false);
                          },
                          profileBtn: () async {
                            print("Profile Btn");
                            await controller.changeImage(context, true);
                          },
                          bgImageProvider:
                              controller.userModel.value.bgImgUrl!.isEmpty
                                  ? const AssetImage(profileBackground)
                                      as ImageProvider
                                  // : NetworkImage(controller.bgImageUrl.value)
                                  : CachedNetworkImageProvider(
                                      controller.userModel.value.bgImgUrl!,
                                    ),
                          currentUser: userModelGlobal.value.id ==
                              controller.userModel.value.id,
                        )),
                    const SizedBox(
                      height: 45,
                    )
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Obx(
                                  () => TextWidget(
                                    text: controller.userModel.value.name ?? '',
                                    size: 19.88,
                                    color: homeBlackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const GradientText(
                                  'Super Traveller',
                                  textAlign: TextAlign.left,
                                  // shaderRect: Rect.fromLTWH(50.0, 25.0, 50.0, 50.0),
                                  // gradient: Gradients.backToFuture,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                Image.asset('assets/images/medal.png',
                                    height: 15, width: 15)
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Obx(
                                  () => TextWidget(
                                    text: controller.userModel.value.country ??
                                        '',
                                    size: 12,
                                    color: homeBlackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Obx(() => Text(
                                    controller.userModel.value.countryCode ??
                                        '')),
                                const SizedBox(height: 19),
                              ],
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 75,
                        child: GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1 / 0.5,
                          ),
                          // children: List.generate(
                          //   3,
                          //   (index) => _gridTile('1200', 'Followers'),
                          children: [
                            Obx(
                              () => _gridTile(
                                  '${controller.userModel.value.totalFollowers}',
                                  'Followers'),
                            ),
                            Obx(
                              () => _gridTile(
                                  '${controller.userModel.value.totalFollowing}',
                                  'Following'),
                            ),
                            Obx(() => _gridTile(
                                '${controller.userModel.value.tripCount}',
                                'Trips')),
                          ],
                        ),
                      ),
                      widget.isMe
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MainButton(
                                      height: 45,
                                      color: primaryColor,
                                      text: "Follow",
                                      textColor: Colors.white,
                                      textSize: 16,
                                      textFont: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        await ChattingService.instance
                                            .createChatThread(
                                                userModel:
                                                    controller.userModel.value);
                                      },
                                      child: MainButton(
                                        height: 45,
                                        color: plusButton,
                                        text: "Message",
                                        textColor: Colors.white,
                                        textSize: 16,
                                        textFont: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                      TabBar(
                        isScrollable: true,
                        indicatorColor: primaryColor,
                        indicatorWeight: 2,
                        controller: _tabController,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 50.0),
                        labelColor: primaryColor,
                        unselectedLabelColor: const Color(0xff7B7B7B),
                        indicatorPadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        labelStyle: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'Posts'),
                          Tab(text: 'Trips'),
                        ],
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
              SliverFillRemaining(
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          StreamBuilder(
                            stream: FirebaseServices.streamUserPosts(
                                userId: widget.userId),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<PostModel>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!snapshot.hasData) {
                                return const Center(
                                  child: Text("No posts Created Yet!"),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 17, right: 17, top: 25),
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.length,
                                    itemBuilder: (context, index) {
                                      if (snapshot.data!.length == 0) {
                                        return const Center(
                                          child: Text("No posts Created Yet!"),
                                        );
                                      } else {
                                        PostModel postModel =
                                            snapshot.data![index];
                                        return HomeScreenCard(
                                            postByMe:
                                                userModelGlobal.value.id ==
                                                    postModel.createdBy,
                                            isConnected: userModelGlobal
                                                .value.following
                                                .contains(postModel.createdBy),
                                            isBookmark: userModelGlobal
                                                .value.bookmarkPosts
                                                .contains(snapshot
                                                    .data![index].postId),
                                            onBookmarkPressed: () {
                                              FirebaseServices
                                                  .addPostToBookmark(
                                                      bookmarkPosts:
                                                          userModelGlobal.value
                                                              .bookmarkPosts,
                                                      postId: snapshot
                                                          .data![index].postId);
                                            },
                                            isFavourite: snapshot
                                                .data![index].likes
                                                .contains(
                                                    userModelGlobal.value.id),
                                            onLikeClick: () async {
                                              await FirebaseServices.likePost(
                                                  likes: snapshot
                                                      .data![index].likes,
                                                  docId: snapshot
                                                      .data![index].postId);
                                            },
                                            images:
                                                snapshot.data![index].imageUrls,
                                            comments:
                                                '${snapshot.data![index].totalComments}',
                                            hearts: '${snapshot.data![index].totalLikes}',
                                            rating: snapshot.data![index].rate,
                                            onCommentPressed: () {
                                              Get.to(
                                                  () => CommentsScreen(
                                                      postModel: postModel),
                                                  binding: CommentBinding());
                                            },
                                            image: home,
                                            userProfile: snapshot.data![index].createrProfile,
                                            description: snapshot.data![index].description,
                                            username: snapshot.data![index].createrName,
                                            onProfilePressed: () {
                                              Get.to(() => ProfileScreen(
                                                    userId: snapshot
                                                        .data![index].createdBy,
                                                    isMe: postModel.createdBy ==
                                                        userModelGlobal
                                                            .value.id,
                                                  ));
                                            });
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          StreamBuilder(
                            stream: FirebaseServices.getCurrentUserTrips(
                                widget.userId),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot<Object?>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (!snapshot.hasData) {
                                return const Text("No Trips Created Yet");
                              } else {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    TripModel tripModel = TripModel.fromJson(
                                        snapshot.data!.docs[index]);
                                    int totalLength =
                                        (tripModel.names?.length) ?? 0;
                                    var data = snapshot.data?.docs;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10),
                                      child: TripsOnProfile(
                                        profileImages:
                                            tripModel.profileUrls ?? [],
                                        tripModel: tripModel,
                                        tripName: tripModel.tripName,
                                        location:
                                            tripModel.destination?.join(',') ??
                                                '',
                                        dateFrom: formatDate(
                                            tripModel.startDate ?? ''),
                                        timeFrom: '5:30 PM',
                                        dateTo:
                                            formatDate(tripModel.endDate ?? ''),
                                        timeTo: '5:30 PM',
                                        // buttonColor: primaryColor,
                                        // buttonText: "Simple",
                                        share: info,
                                        imageHeight: 25,
                                        imageWidth: 25,
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SimpleTrip(
                                              tripModel: tripModel,
                                              totalLength: totalLength,
                                              tripName: data?[index]
                                                  ['tripName'],
                                              startDate: formatDate(
                                                  data?[index]['startDate']),
                                              endDate: formatDate(
                                                  data?[index]['endDate']),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(() => CustomScreenLoading(controller.isLoading.value))
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _content;

  _SliverAppBarDelegate(this._content);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _content,
    );
  }

  @override
  double get maxExtent => 250.0;

  @override
  double get minExtent => 250.0;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

Widget _gridTile(String number, String type) {
  return GestureDetector(
    onTap: () {
      Get.to(const FollowersScreen());
    },
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffececec),
          width: 0.3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Color(0xff222B45),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            type,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff6B779A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

const hotLinear = LinearGradient(
    colors: [Color(0xff8000FF), Color(0xffFF1F00)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight);

class GradientText extends StatelessWidget {
  const GradientText(
    this.data, {
    this.key,
    required this.style,
    this.gradient = hotLinear,
    this.shaderRect,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  final Key? key;
  final String data;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final Gradient gradient;
  final Rect? shaderRect;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      // Regarding the blend mode: The source is the gradient to draw, and the
      // destination is the text. With srcIn the gradient is drawn with the
      // shape of the text.
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) => gradient.createShader(shaderRect ?? rect),
      child: Text(
        data,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}

void showPopupMenu(BuildContext context, {Function()? onLogoutTap}) {
  final RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      appBarRenderBox.localToGlobal(Offset.zero, ancestor: overlay),
      appBarRenderBox.localToGlobal(
          appBarRenderBox.size.bottomRight(Offset.zero),
          ancestor: overlay),
    ),
    const Offset(-20, 00) & overlay.size,
  );

  showMenu<String>(
    context: context,
    position: position,
    items: [
      PopupMenuItem(
        value: 'logout',
        child: InkWell(
          onTap: onLogoutTap,
          child: const Row(
            children: [
              Icon(Icons.logout),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ),
      const PopupMenuItem(
        value: 'edit',
        child: Row(
          children: [
            Icon(Icons.edit),
            SizedBox(width: 8),
            Text('Edit'),
          ],
        ),
      ),
    ],
  ).then((value) {
    if (value == 'logout') {
      // Handle logout action
      print('Logout clicked');
    } else if (value == 'edit') {
      // Handle edit action
      print('Edit clicked');
    }
  });
}
