import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/models/user_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';

import '../../constant/instances_contant.dart';

class ProfileController extends GetxController {

  RxString profileImageUrl = ''.obs;
  RxString bgImageUrl = ''.obs;

  RxBool isLoading = false.obs;

  Rx<UserModel> userModel = UserModel().obs;


  fetchUserDetail({required userId}) async {
    userModel.value = await FirebaseServices.getCurrentUserById(userId);
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    // print(UserData().profileImageUrl);

    print("init called");

    print(userModelGlobal.toJson());


    bgImageUrl.value = userModelGlobal.value.bgImgUrl ?? '';
    profileImageUrl.value = userModelGlobal.value.profileImgUrl??'';

  }

  File? profileImage;
  File? backgroundImage;
  var profileImagePath = ''.obs;
  var bgImagePath = ''.obs;
  var profileImageLink = '';
  var bgImageLink = '';

  final picker = ImagePicker();

  changeImage(context, bool isProfileImage) async {
    print("Called changeImage");
    try {
      XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) return;
      if (isProfileImage) {
        isLoading(true);
        profileImagePath.value = img.path;
        await uploadImageToStorage(File(profileImagePath.value))
            .then((value) async {
          profileImageUrl.value = value;
          await updateImage(value, isProfileImage).then((value) =>
              customSnackBar(message: "Profile Image Updated", color: green));
        });
        isLoading(false);
      } else {
        isLoading(true);
        bgImagePath.value = img.path;
        await uploadImageToStorage(File(bgImagePath.value)).then((value) async {
          bgImageUrl.value = value;
          await updateImage(value, isProfileImage).then((value) =>
              customSnackBar(
                  message: "Background Image Updated", color: green));
        });
        isLoading(false);
      }
    } on PlatformException catch (e) {
      isLoading(false);
      print(e);
    }
  }

  Future<String> uploadImageToStorage(File image) async {

    try{
      String img = image.path.split('/').last;
      final storageReference = FirebaseStorage.instance.ref().child(
          'user_images/${DateTime.fromMillisecondsSinceEpoch(DateTime.february)}$img');
      final uploadTask = storageReference.putFile(image);
      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final downloadUrl = await snapshot.ref.getDownloadURL();

        return downloadUrl;
      }
      else {
        isLoading(false);
        throw ('Failed to upload image');
      }
    }
    catch(e){
      isLoading(false);
      throw Exception(e);
    }


  }

  Future updateImage(String imgUrl, bool profileImage) async {
    try {
      DocumentReference ref = FirebaseConsts.firestore
          .collection(FirebaseConsts.userCollection)
          .doc(FirebaseConsts.auth.currentUser?.uid);

      // final userModel = UserModel.fromJson(userDataSnapshot.data()!);
      if (profileImage) {
        print("profileImage");
        // userModel.copyWith(
        //     profileImgUrl: imgUrl
        // );
        ref.update({'profileImgUrl': imgUrl});
      } else {
        // userModel.copyWith(
        //     bgImgUrl: imgUrl
        // );
        ref.update({'bgImgUrl': imgUrl});
      }
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseConsts
          .firestore
          .collection(FirebaseConsts.userCollection)
          .doc(FirebaseConsts.auth.currentUser?.uid)
          .get();
      userModelGlobal.value = UserModel.fromJson(snapshot.data());
      //
      // print(userModel.profileImgUrl);
      //
      // final updatedUserModel = userModel.toJson();
      // print(updatedUserModel);
      // await ref.update(updatedUserModel);
      //
      // return await FirebaseConsts.firestore.collection(FirebaseConsts.userCollection)
      //     .doc(FirebaseConsts.auth.currentUser?.uid)
      //     .update(
      //   {
      //     'bgImgUrl':imgUrl
      //   }
      // );
    } catch (e) {
      return throw Exception(e.toString());
    }
  }
}
