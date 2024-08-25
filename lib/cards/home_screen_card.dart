import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/constant.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/widgets/text_widget.dart';

// ignore: must_be_immutable
class HomeScreenCard extends StatefulWidget {
  HomeScreenCard({
    Key? key,
    this.hearts,
    this.comments,
    this.rating = 5,
    this.image,
    this.description,
    this.onPressed,
    this.username,
    this.onProfilePressed,
    required this.onBookmarkPressed,
    this.onCommentPressed,
    this.userProfile,
    required this.isBookmark,
    this.images,
    this.onLikeClick,
    this.onConnectClicked,
    required this.isFavourite,
    required this.isConnected,
    required this.postByMe,
  }) : super(key: key);

  String? hearts, comments, image, description, username, userProfile;
  VoidCallback? onPressed;
  List<String>? images;

  VoidCallback? onProfilePressed,onCommentPressed,onBookmarkPressed;
  VoidCallback? onLikeClick,onConnectClicked;
  int rating;
  bool isFavourite, isBookmark, isConnected, postByMe;

  @override
  State<HomeScreenCard> createState() => _HomeScreenCardState();
}

class _HomeScreenCardState extends State<HomeScreenCard> {
  bool isCommentClicked = false;
  bool isSendClicked = false;
  // bool isBookmarkClicked = false;

  int imgIndex = 0;

  @override
  Widget build(BuildContext context) {
    // bool isFavoriteClicked = widget.isFavourite;
    // bool isConnectClicked = widget.isConnected;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [defaultShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              GestureDetector(
                    onTap: widget.onProfilePressed,

                child: Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.userProfile ?? profileUrlDummy,
                        width: 41.12,
                        height: 36.12,
                        fit: BoxFit.cover, // Ensures the image covers the circular area
                        placeholder: (context, url) => CircularProgressIndicator(), // Placeholder widget while the image is loading
                        errorWidget: (context, url, error) => Icon(Icons.error), // Widget to display in case of error loading image
                      ),
                    ),

                    SizedBox(width: 10,),

                    TextWidget(
                        text: "${widget.username}",
                        size: 14.15,
                        color: homeBlackColor,
                        fontWeight: FontWeight.w600),
                  ],
                ),
              ),

              const SizedBox(
                width: 10,
              ),
              widget.postByMe?Container():
              GestureDetector(
                onTap: (){
                  widget.onConnectClicked!();

                  setState(() {
                    widget.isConnected=!widget.isConnected;
                  });
                },
                child: TextWidget(
                    text: widget.isConnected?"Connected":"Connect",
                    size: 14,
                    color: primaryColor,
                    fontWeight: widget.isConnected? FontWeight.w700 : FontWeight.w400),
              ),
            ],
          ).paddingSymmetric(horizontal: 10),

          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                      text: "${widget.description}",
                      size: 11.4,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ]),
          ),
          const SizedBox(
            height: 10,
          ),
          Stack(alignment: Alignment.center, children: [
            SingleChildScrollView(
              physics: widget.images?.length == 1
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(
                widget.images?.length ?? 0,
                (index) {
                  imgIndex = index;
                  // print(imgIndex);
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : 5),
                    child: Image.network(
                      "${widget.images![index]}",
                      height: 368,
                      fit: BoxFit.cover,
                      width: Get.width,
                      //  width: double.maxFinite,
                    ),
                  );
                },
              )),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 8, top: 7),
                decoration: BoxDecoration(
                    color: const Color(0xff000000).withOpacity(0.5),
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(25))),
                height: 41,
                width: 113,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                        text: "Exp Rate",
                        size: 9,
                        color: whiteColor,
                        fontWeight: FontWeight.w400),
                    Row(
                        children: List.generate(widget.rating, (index) {
                      return const Icon(
                        Icons.grade,
                        color: Colors.yellow,
                        size: 14,
                      );
                    })),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 10,
              child: Row(children: [
                Icon(
                  Icons.circle,
                  color: primaryColor,
                  size: 12,
                ),
                SizedBox(
                  width: 7,
                ),
                Icon(
                  Icons.circle,
                  color: Color(0xff939393),
                  size: 12,
                ),
                SizedBox(
                  width: 7,
                ),
                Icon(
                  Icons.circle,
                  color: Color(0xff939393),
                  size: 12,
                ),
                SizedBox(
                  width: 7,
                ),
                Icon(
                  Icons.circle,
                  color: Color(0xff939393),
                  size: 12,
                ),
              ]),
            ),
          ]),
          const SizedBox(
            height: 9,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: "${widget.hearts} Hearts",
                      size: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onLikeClick!();
                      setState(() {
                        widget.isFavourite = !widget.isFavourite;
                      });
                    },
                    child: Icon(
                      Icons.favorite_outline,
                      color: widget.isFavourite ? Colors.red : iconColor,
                    ),
                  ),
                  InkWell(
                    onTap: widget.onCommentPressed,
                    //isCommentClicked==true?Colors.red:
                    child: Image.asset('assets/icons/comment.png',
                        height: 20.sp,
                        width: 20.sp,
                        fit: BoxFit.contain,
                        color: iconColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSendClicked = !isSendClicked;
                      });
                    },
                    child: Icon(
                      Icons.send,
                      color: isSendClicked ? Colors.red : iconColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.isBookmark = !widget.isBookmark;
                      });
                      widget.onBookmarkPressed!();
                    },
                    child: Icon(
                      Icons.bookmark_outline_outlined,
                      color: widget.isBookmark ? Colors.red : iconColor,
                    ),
                  ),
                ]),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 10),
            child: TextWidget(
                text: "${widget.comments} Comments",
                size: 12.41,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
