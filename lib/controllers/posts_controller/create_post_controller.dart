import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/models/postsModel/post_model.dart';
import 'package:plan_together/services/firebase_storage_service.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/snackbars.dart';

class CreatePostController extends GetxController {

  RxList<File> pickedImages = <File>[].obs;

  RxBool uploading = false.obs;

  RxInt rating = 5.obs;

  RxList<String> imagesUrls = <String>[].obs;

  TextEditingController postTextController = TextEditingController();


  onStarTap(int index) {
    rating.value = index;
  }

  //image picker
  Future pickFromCamera() async {
    try {
      final _img = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (_img == null) {
        return;
      } else {
        pickedImages.add(
          File(_img.path),
        );
        print("Picked images list: $pickedImages");
        Get.back();
      }
    } on PlatformException catch (e) {
      log("$e", name: "Image picker exception on camera pick");
    } catch (e) {
      log("$e", name: "Image picker exception on camera pick");
    }
  }

  //on gallery pick
  Future multiImagePicker() async {
    try {
      List<XFile> _images = await ImagePicker().pickMultiImage();
      for (int i = 0; i < _images.length; i++) {
        pickedImages.add(File(_images[i].path));
      }
      print("Picked images list: $pickedImages");
    } on PlatformException catch (e) {
      log("$e", name: "Image picker exception on gallery pick");
    } catch (e) {
      log("$e", name: "Image picker exception on gallery pick");
    }
  }

  void removePickedImage(int index) {
    pickedImages.removeWhere(
          (element) => element == pickedImages[index],
    );
  }

  Future onPostExperience({required String tripDocId}) async {
    if(pickedImages.isEmpty){
      CustomSnackBars.instance.showCustomSnack(color: red, message: "Please Select Images");
    }
    else{
      uploading(true);
      imagesUrls.value = await FirebaseStorageService.instance.addImagesToFirebase(pickedImages);
      try {
        DocumentReference reference = FirebaseConsts.firestore.collection(
            FirebaseConsts.postsCollection).doc();

        await reference.set(PostModel(postId: reference.id,
            tripId: tripDocId,
            createdBy: userModelGlobal.value.id??'',
            createrName: "${userModelGlobal.value.name}",
            createrProfile: "${userModelGlobal.value.profileImgUrl}",
            description: postTextController.text,
            imageUrls: imagesUrls,
            totalLikes: 0,
            totalComments: 0,
            likes: <String>[],
            rate: rating.value,
            dateTime: DateTime.now()).toMap());


        await FirebaseConsts.firestore.collection(FirebaseConsts.tripsCollection).doc(tripDocId).update({
          'postsBy':FieldValue.arrayUnion([userModelGlobal.value.id]),
        });

        print("------------------------------ Uploaded to Firebase Done -----------");

        uploading(false);
      } catch (e) {
        print("------------------ Exception----------------");
        uploading(false);
        throw Exception(e);
      }
    }



  }


}