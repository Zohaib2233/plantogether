
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget loadingWidget(bool value){
  return value
      ? Container(
      height: Get.height,
      width: Get.width,
      color: Colors.grey.withOpacity(0.8),
      child: const Center(child: CircularProgressIndicator()))
      : Container();
}