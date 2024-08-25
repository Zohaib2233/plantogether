import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/widgets/text_widget.dart';


class ChatBot extends StatelessWidget {
  final bool isFromUser;
  final String text;
  // final Color color;
  final bool isSelectableText;

  const ChatBot(
      {Key? key,
      required this.isFromUser,
      required this.text,
      // required this.color,
      this.isSelectableText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,

            color: !isFromUser?Color(0xff10A37F):Color(0xff9547D2),
            child: Center(
              child: isFromUser?
                  Image.network(userModelGlobal.value.profileImgUrl??profileUrlDummy,
                    width: 25,
                    height: 25,):
              Image.asset(
                gptImage,
                width: 25,
                height: 25,
              ),
            ),
          ),
          const SizedBox(
            width: 21,
          ),
          Expanded(
            child: isSelectableText
                ? SelectableText(
                    text,

                    style: const TextStyle(
                        fontSize: 14,
                        height: 1.8,
                        color: Color(0xff343541),
                        fontWeight: FontWeight.w400),
                  )
                : isFromUser?TextWidget(
                    text: text,
                    size: 14,
                    lineHeight: 1.8,
                    color: const Color(0xff343541),
                    fontWeight: FontWeight.w400):MarkdownBody(data: text,),
          ),
          const SizedBox(
            width: 30,
          ),
          ///
          // const Icon(
          //   Icons.thumb_up_alt_outlined,
          //   color: Color(0xffACACBE),
          //   size: 17,
          // ),
          // const SizedBox(
          //   width: 13.2,
          // ),
          // const Icon(
          //   Icons.thumb_down_alt_outlined,
          //   color: Color(0xffACACBE),
          //   size: 17,
          // )
        ],
      ),
    );
  }
}
