import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{

Future saveSharedPreferenceString({required String key,required value}) async{

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  return sharedPreferences.setString(key, value);

}

Future getSharedPreferenceString(String key) async{

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  return sharedPreferences.getString(key);

}

Future getSharedPreferenceBool(String key) async{

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  return sharedPreferences.getBool(key);

}
Future removeSharedPreferenceBool(String key) async{

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  return sharedPreferences.remove(key);

}

Future saveSharedPreferenceBool({required String key,required value}) async{

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  return sharedPreferences.setBool(key, value);

}


}