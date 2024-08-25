import 'package:flutter/material.dart';

import '../utils/global_colors.dart';




class CheckBoxWidget extends StatelessWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;
  final Color kborderColor;
  final bool haveCheckBoxTrue = false;

  const CheckBoxWidget(
      {super.key,
      this.isChecked = false,
      required this.onChanged,
      this.kborderColor = kSecondaryColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5,
      width: 20,
      child: Checkbox(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: BorderSide(
            color: (isChecked == true) ? lightBlue : grey),
        checkColor: Colors.white,
        activeColor: lightBlue,
        focusColor: Colors.amber,
        fillColor: MaterialStatePropertyAll(
            (isChecked == true) ? lightBlue : Colors.transparent),
        value: isChecked,
        onChanged: onChanged,
      ),
    );
  }
}
