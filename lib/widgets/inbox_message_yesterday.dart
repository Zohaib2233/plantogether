
import 'package:flutter/material.dart';
import 'package:plan_together/widgets/text_widget.dart';

import '../utils/global_colors.dart';

class InboxMessageYesterday extends StatelessWidget {
  const InboxMessageYesterday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      child: ListTile(
          leading: Container(
            height: 81,
            width: 51,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("assets/images/inbox.png"),
                    fit: BoxFit.cover)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                  text: "John Harry",
                  size: 16,
                  color: homeBlackColor,
                  fontWeight: FontWeight.w700),
              TextWidget(
                  text: "Yesterday",
                  size: 12,
                  color: greyColor,
                  fontWeight: FontWeight.w400),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                  text: "Good morning, anything we ca...",
                  size: 14,
                  color: const Color(0xff50555C),
                  fontWeight: FontWeight.w400),
            ],
          )),
    );
  }
}
