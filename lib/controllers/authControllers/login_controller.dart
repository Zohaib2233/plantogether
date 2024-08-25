import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plan_together/common/functions.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';

import '../../constant/firebase_consts.dart';
import '../../models/user_model.dart';
import '../../services/sharedpreference_service.dart';
import '../../services/zego_call_service.dart';
import '../../utils/shared_preference_keys.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Form key

  RxBool loading = false.obs;
  RxBool isObscure = true.obs;
  RxBool isChecked = false.obs;

  changeCheckValue(bool value){
    isChecked.value = value;
  }

  Future<UserCredential?> loginMethod() async {
    UserCredential? userCredential;

    try {
      loading(true);

      userCredential = await FirebaseConsts.auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if(isChecked.isTrue){
        SharedPreferenceService()
            .saveSharedPreferenceBool(
            key: SharedPrefKeys.loggedIn,
            value: true);
      }

      await getUserDataStream(userId: FirebaseConsts.auth.currentUser!.uid);
      ZegoCallService.instance.onUserLogin(
          currentUserId:
          userCredential.user!.uid,
          currentUserName: userModelGlobal.value.name??'${userCredential.user!.uid} _user');
      loading(false);
    } on FirebaseAuthException catch (e) {
      loading(false);
      print("Error $e");
      Fluttertoast.showToast(msg: e.message.toString());
    }
    return userCredential;
  }

  Future signInWithGoogle() async {
    try {
      loading(true);
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);


      if (FirebaseAuth.instance.currentUser != null) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        bool isExist = await isAlreadyExist(uid: uid);
        if(isExist){
          getUserDataStream(userId: FirebaseConsts.auth.currentUser!.uid);
        }
        else{
          await storeUserData(userCredential);
          getUserDataStream(userId: FirebaseConsts.auth.currentUser!.uid);
        }
      }

    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
    return null;
  }

  Future storeUserData(UserCredential userCredential) async {
    try {
      DocumentReference store = FirebaseConsts.firestore
          .collection(FirebaseConsts.userCollection)
          .doc(FirebaseConsts.auth.currentUser?.uid);
      UserModel userModel = UserModel(
        id: store.id,
        name: userCredential.user?.displayName ?? '',
        username: '',
        email: userCredential.user?.email ?? '',
        password: '',
        localCurrency: '',
        country: '',
      );

      await store.set(userModel.toJson());
      loading(false);
    } catch (e) {
      loading(false);
      throw Exception(e);
    }
  }

  Future<bool> isAlreadyExist({required String uid}) async {
    var userData = await FirebaseConsts.firestore
        .collection(FirebaseConsts.userCollection)
        .doc(uid)
        .get();

    if (userData.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future resetPassword() async {
    loading(true);
    String email = emailController.text.trim();

    if (email.isNotEmpty) {
      try {
        await FirebaseConsts.auth.sendPasswordResetEmail(email: email);
        // await firebaseService.resetPassword(email);
        print('Password reset email sent to $email');
        customSnackBar(
            message: 'Password reset email sent to $email', color: green);
        loading(false);
      } on FirebaseAuthException catch (e) {
        loading(false);
        Fluttertoast.showToast(msg: e.toString());
      }

      // You can show a success message to the user
    } else {
      loading(false);
      customSnackBar(message: "Please Enter Email", color: red);
      print('Please enter a valid email address');
      // You can show an error message to the user
    }
  }
}
