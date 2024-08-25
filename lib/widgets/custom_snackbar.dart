import 'package:get/get.dart';




SnackbarController customSnackBar({required message,required color}){
  return  Get.showSnackbar(GetSnackBar(
    backgroundColor: color,
    message: message,
    duration: const Duration(seconds: 2),
  ));
}