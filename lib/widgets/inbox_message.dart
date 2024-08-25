import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/text_widget.dart';

class InboxMessage extends StatelessWidget {
  final String chatName, messageCount, lastMessage,imageUrl,timeAgo;

  const InboxMessage(
      {Key? key,
      required this.chatName,
      required this.messageCount,
      required this.lastMessage, required this.imageUrl, required this.timeAgo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              height: 81,
              width: 51,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage("$imageUrl"),
                      fit: BoxFit.cover)),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),

          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                  text: "${chatName}",
                  size: 16,
                  color: homeBlackColor,
                  fontWeight: FontWeight.w700),
              TextWidget(
                  text: timeAgo,
                  size: 12,
                  color: greyColor,
                  fontWeight: FontWeight.w400),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextWidget(
                    text: "$lastMessage",
                    size: 14,
                    color: const Color(0xff50555C),
                    fontWeight: FontWeight.w400),
              ),
              messageCount == '0'
                  ? Container()
                  : Container(
                      height: 18,
                      width: 18,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: primaryColor),
                      child: Center(
                          child: TextWidget(
                              text: messageCount,
                              size: 12,
                              color: whiteColor,
                              fontWeight: FontWeight.w700)),
                    )
            ],
          )),
    );
  }
}
