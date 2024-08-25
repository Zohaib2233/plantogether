import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:plan_together/models/CurrentWeatherModel.dart';
import 'package:plan_together/models/ForecastWeatherModel.dart';
import 'package:plan_together/models/SusetSunriseModel.dart';
import 'package:plan_together/utils/app_strings.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';

class WeatherRepo {
  static getForecastWeather({required String lat, required String long}) async {
    print("Called getForecastWeather");
    try {

      http.Response response = await http.get(Uri.parse(
          "${AppStrings.weatherForecastBaseUrl}lat=$lat&lon=$long&appid=${AppStrings.weatherApiKey}&&units=metric"));
      print("___________________$response getForecastWeather ____________________");
      var decodedData = jsonDecode(response.body);
      if(response.statusCode==200){
      return ForecastWeatherModel.fromJson(decodedData);
    }
      else{
        customSnackBar(message: "Error ${response.statusCode}",color: red);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  static getCurrentWeather({required String lat, required String long}) async {
    print("Called getForecastWeather");
    try {

      http.Response response = await http.get(Uri.parse(
          "${AppStrings.weatherCurrentBaseUrl}lat=$lat&lon=$long&appid=${AppStrings.weatherApiKey}&&units=metric"));
      print("___________________$response Current Weather____________________");
      var decodedData = jsonDecode(response.body);
      if(response.statusCode==200){
        // print(decodedData);
      return CurrentWeatherModel.fromJson(decodedData);
    }
      else{
        customSnackBar(message: "Error ${response.statusCode}",color: red);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static getSunriseTime({required String lat, required String long,required String date}) async {
    try{
      http.Response response = await http.get(Uri.parse("${AppStrings.sunsetSunriseBaseUrl}lat=$lat&lng=$long&date=$date"));
      print("___________________$response Sunrise API ____________________");
      // print(response.body);
      var decodedData = jsonDecode(response.body);
      if(response.statusCode==200){
        return SusetSunriseModel.fromJson(decodedData);
      }
      else{
        customSnackBar(message: "Error ${response.statusCode}",color: red);
      }
    }catch(e){
      throw Exception(e);
    }
  }
}
