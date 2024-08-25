import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/core/extensions.dart';
import 'package:plan_together/models/user_model.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';

class SignupController extends GetxController {
  RxBool loading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  // RxString selectCountry = 'Please Select Country'.obs;
  // RxString selectCurrency = 'Please Select Currency'.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordAgainController.clear();
    userNameController.clear();
    currencyController.clear();
    countryController.clear();
  }



  // RxString country = ''.obs;
  RxString countryFlag = ''.obs;
  RxString currencyCode = 'USD'.obs;

  RxBool isObscure = true.obs;
  RxBool isAgainPasswordObscure = true.obs;

  Future<UserCredential?> signupMethod() async {
    UserCredential? userCredential;
    loading(true);
    try{
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
          .instance
          .collection(FirebaseConsts.userCollection)
          .where('username', isEqualTo: userNameController.text)
          .get();
      if (querySnapshot.docs.isEmpty) {
        try {
          print("${emailController.text} ${passwordController.text}");
          userCredential = await FirebaseConsts.auth
              .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
        } on FirebaseAuthException catch (e) {
          loading(false);

          // Fluttertoast.showToast(msg: e.message.toString());
          customSnackBar(color: red, message: e.message.toString());
        }
      } else {
        loading(false);
        customSnackBar(color: red, message: "Username already Exists");
      }
      return userCredential;
    }
    catch(e){
      throw Exception(e);
    }




  }

  Future storeUserData() async {

    // customSnackBar(color: red, message: "Username already exists");
    try{
      DocumentReference store = FirebaseConsts.firestore
          .collection(FirebaseConsts.userCollection)
          .doc(FirebaseConsts.auth.currentUser?.uid);
      UserModel userModel = UserModel(
          id: store.id,
          name: nameController.text,
          username: userNameController.text,
          email: emailController.text,
          password: passwordController.text,
          // localCurrency: selectCurrency.value,
          localCurrency: currencyController.text,
          // country: selectCountry.value,
          country: countryController.text,
          bgImgUrl: '',
          currencyCode: currencyController.text,
          profileImgUrl: 'https://www.cornwallbusinessawards.co.uk/wp-content/uploads/2017/11/dummy450x450.jpg',
          countryCode: countryFlag.value ?? '');

      await store.set(userModel.toJson());
      loading(false);
    }
    catch(e){
      throw Exception(e);
    }

  }

  onSelectCountry(Country country) {
    // selectCountry.value = country.name;
    countryController.text = country.name;
    countryFlag.value = country.flagEmoji;
    update();
    // country.value = getCountry;
  }

  onSelectCurrency(String localCurrency) {
    // selectCurrency.value = localCurrency;
    currencyController.text = localCurrency;

    update();
    // currency.value = localCurrency;
    // print("selectCurrency ${currency.value}");
  }

  //password validator
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (password.isUpperCase() == false) {
      return 'Password must contain at least one uppercase letter';
    }

    if (password.isLowerCase() == false) {
      return 'Password must contain at least one lowercase letter';
    }

    if (password.isContainDigit() == false) {
      return 'Password must contain at least one digit';
    }

    if (password.isContainSpecialCharacter() == false) {
      return 'Password must contain at least one special character';
    }

    return null; // Return null if the password is valid
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    userNameController.dispose();
    countryController.dispose();
    currencyController.dispose();
    emailController.dispose();
  }
}
