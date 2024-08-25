
import 'package:get/get.dart';
import 'package:plan_together/models/user_model.dart';

Rx<UserModel> userModelGlobal = UserModel(
  country: '',
  countryCode: '',
  email: '',
  name: '',
  id: '',
  bgImgUrl: '',
  profileImgUrl: '',
  currencyCode: '',
  localCurrency: '',
  password: '',
  tripCount: 0,
  username: ''
).obs;