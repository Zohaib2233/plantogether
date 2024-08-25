import 'package:flutter/material.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/mainButton.dart';
import 'package:plan_together/widgets/text_widget.dart';

class FollowWidget extends StatefulWidget {
  String? image, name, userName;

  FollowWidget({
    Key? key,
    required this.name,
    required this.image,
    required this.userName,
  }) : super(key: key);

  @override
  State<FollowWidget> createState() => _FollowWidgetState();
}

class _FollowWidgetState extends State<FollowWidget> {
  bool isFollowing = false;

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 36.5,
        width: 36.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(widget.image ?? ""),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: TextWidget(
        text: widget.name ?? "",
        size: 16,
        color: followerNameColor,
        fontWeight: FontWeight.w700,
      ),
      subtitle: TextWidget(
        text: widget.userName ?? "",
        size: 16,
        color: followerUserNameColor,
        fontWeight: FontWeight.w400,
      ),
      trailing: MainButton(
        height: 36,
        width: 96,
        textFont:FontWeight.w700 ,
        textSize: 12,
        text: isFollowing ? 'Unfollow' : 'Follow',
        onPressed: toggleFollow,
        border: Border.all(color: primaryColor),
        color: isFollowing ? Colors.white :  primaryColor,
        textColor: isFollowing ?primaryColor :Colors.white  ,
      ),
    );
  }
}
