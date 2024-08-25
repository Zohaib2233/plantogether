import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/utils/global_colors.dart';

Widget getTextField({String? hint,

  String? label,
  bool readOnly = false,
  Function()? onSuffixTap,
  IconData? image,
  IconData? iconData,
  bool isObscure = false,
  double height = 75,
  int maxline = 1,
  double? contentPadding,
  double? borderRadius,
  TextEditingController? controller,
  Function(String)? onChanged,
  TextInputType? InputType,
  bool? isEnabled,
  Color? suffixColor,
  bool canRequestFocus=true,
  FocusNode? focusNode,
  FormFieldValidator? validator}) {
  return SizedBox(
    height: height,
    child: TextFormField(
      // autofocus: true,
      onFieldSubmitted: (value){
        print(value);

      },
        canRequestFocus: canRequestFocus,


      obscureText: isObscure,

      focusNode: focusNode,
        readOnly: readOnly,
        maxLines: maxline,
        validator: validator,
        controller: controller,
        onChanged: onChanged,
        keyboardType: InputType,
        enabled: isEnabled ?? true,
        style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            // fontFamily: 'ProximaNovaRegular',
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: hint ?? "",
          contentPadding: contentPadding == null
              ? EdgeInsets.symmetric(vertical: 15.sp, horizontal: 26.sp)
              : EdgeInsets.symmetric(
            horizontal: contentPadding.sp,
          ),
          filled: true,
          isDense: false,
          labelText: label ?? "",
          labelStyle: const TextStyle(color: grey),
          fillColor: Colors.white,
          prefixIcon: image == null
              ? null
              : SizedBox(
              height: 15.sp,
              width: 15.sp,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(

                    image,

                    // height: 23.sp,
                    // width: 21.sp,
                    // fit: BoxFit.contain,
                  ),
                ],
              )),
          suffixIcon: iconData == null
              ? null
              : GestureDetector(
            onTap: onSuffixTap,
                child: Icon(
                            iconData,
                            color: suffixColor ?? Colors.black,
                            size: 20,
                          ),
              ),
          hintStyle: TextStyle(
              color: const Color(0xFF828F9C),
              fontSize: 15.sp,
              fontFamily: 'ProximaNovaRegular',
              fontWeight: FontWeight.w400),
          enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius == null
                  ? BorderRadius.circular(48.sp)
                  : BorderRadius.circular(borderRadius),
              borderSide:
              BorderSide(color: border.withOpacity(0.7), width: 1.6.sp)),
          focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius == null
                  ? BorderRadius.circular(48.sp)
                  : BorderRadius.circular(borderRadius),
              borderSide:
              BorderSide(color: border.withOpacity(0.7), width: 1.6.sp)),
          border: OutlineInputBorder(
              borderRadius: borderRadius == null
                  ? BorderRadius.circular(48.sp)
                  : BorderRadius.circular(borderRadius),
              borderSide:
              BorderSide(color: border.withOpacity(0.7), width: 1.6.sp)),
          errorBorder: OutlineInputBorder(
              borderRadius: borderRadius == null
                  ? BorderRadius.circular(48.sp)
                  : BorderRadius.circular(borderRadius),
              borderSide:
              BorderSide(color: border.withOpacity(0.7), width: 1.6.sp)),
          disabledBorder: OutlineInputBorder(
              borderRadius: borderRadius == null
                  ? BorderRadius.circular(48.sp)
                  : BorderRadius.circular(borderRadius),
              borderSide:
              BorderSide(color: border.withOpacity(0.7), width: 1.6.sp)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRadius == null
                  ? BorderRadius.circular(48.sp)
                  : BorderRadius.circular(borderRadius),
              borderSide:
              BorderSide(color: border.withOpacity(0.7), width: 1.5.sp)),
        )),
  );
}

Widget getPasswordTextField({required String hint,
  String? label,
  String? image,
  TextEditingController? controller,
  Function(String)? onChanged,
  TextInputType? InputType,
  bool? isEnabled,
  bool? isObsecured,
  FormFieldValidator? validator}) {
  return TextFormField(
    validator: validator,
    controller: controller,
    onChanged: onChanged,
    keyboardType: InputType,
    enabled: isEnabled ?? true,
    style: const TextStyle(color: Color(0xFF9A9CA3)),
    decoration: InputDecoration(
        labelText: label ?? "",
        suffixIcon: isObsecured == true
            ? const Icon(
          Icons.visibility,
          color: Color(0xFF9A9CA3),
        )
            : const Icon(
          Icons.visibility_off,
          color: Color(0xFF9A9CA3),
        ),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: image == null
            ? null
            : SizedBox(
            height: 15.sp,
            width: 15.sp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  height: 23.sp,
                  width: 21.sp,
                  fit: BoxFit.contain,
                ),
              ],
            )),
        hintStyle: TextStyle(color: const Color(0xFF9A9CA3), fontSize: 12.sp),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white))),
  );
}

Widget getTextFieldMulti({required String hint,
  TextEditingController? controller,
  Function(String)? onChanged,
  bool? isEnabled,
  FormFieldValidator? validator}) {
  return TextFormField(
    validator: validator,
    controller: controller,
    onChanged: onChanged,
    enabled: isEnabled ?? true,
    style: const TextStyle(color: Color(0xFF9A9CA3)),
    maxLines: null,
    minLines: 4,
    keyboardType: TextInputType.multiline,
    decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: const Color(0xFF9A9CA3), fontSize: 12.sp),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white))),
  );
}


Widget getCustomSelectField({required String fieldName, required Function() onSuffixTap }){

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    height: 60,
    decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(45),
        border: Border.all(color: border.withOpacity(0.7),width: 1.6.sp)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(fieldName,),
        GestureDetector(
            onTap: onSuffixTap,
            child: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey,))
      ],
    ),
  );
}
