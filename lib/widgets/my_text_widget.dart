import 'package:flutter/material.dart';
import 'package:plan_together/utils/global_colors.dart';


// ignore: must_be_immutable
class MyText extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var text, color, weight, align, decoration, fontFamily;
  double? size, height;
  TextDirection? textDirection;
  double? paddingTop, paddingLeft, paddingRight, paddingBottom, letterSpacing;
  FontStyle? fontStyle;
  // ignore: prefer_typing_uninitialized_variables
  var maxLines, overFlow;
  VoidCallback? onTap;

  MyText({
    Key? key,
    @required this.text,
    this.size,
    this.textDirection,
    this.height,
    this.maxLines = 100,
    this.decoration = TextDecoration.none,
    this.color,
    this.letterSpacing,
    this.weight = FontWeight.w400,
    this.align,
    this.overFlow,
    this.fontFamily,
    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingLeft = 0,
    this.paddingBottom = 0,
    this.onTap,
    this.fontStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop!,
        left: paddingLeft!,
        right: paddingRight!,
        bottom: paddingBottom!,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          "$text",
          textDirection: textDirection,
          style: TextStyle(

            fontSize: size,
            color: color ?? blackColor,
            fontWeight: weight,
            decoration: decoration,
            decorationColor: color,
            decorationThickness: 3,
            decorationStyle: TextDecorationStyle.solid,

            height: height,
            fontStyle: fontStyle,
            letterSpacing: letterSpacing,
          ),
          textAlign: align,
          maxLines: maxLines,
          overflow: overFlow,
        ),
      ),
    );
  }
}
