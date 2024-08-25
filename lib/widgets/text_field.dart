import 'package:flutter/material.dart';
import 'package:plan_together/utils/global_colors.dart';

Widget textField({
  required text,
  TextEditingController? controller,
  final sufixIcon,
  final prefixIcon,
  Color? prefixColor,
  Function(String)? onChange,
}) {
  return TextField(
    onChanged: onChange,
    controller: controller,
      decoration:  InputDecoration(
    filled: true, //<-- SEE HERE

    fillColor: const Color(0xffF0F3F6),
    hintText: text,
    suffixIcon: sufixIcon,
    labelStyle: const TextStyle(
        fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xffADB3BC)),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(25.0),
    ),
    prefixIcon: Icon(
      prefixIcon,
      size: 30,
      color: prefixColor??primaryColor,
    ),
  ));
}
