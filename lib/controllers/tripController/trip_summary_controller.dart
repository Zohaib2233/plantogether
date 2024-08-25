import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/controllers/tripController/budget_controller.dart';
import 'package:plan_together/models/ForecastWeatherModel.dart';
import 'package:plan_together/models/SafetyDocumentModel.dart';
import 'package:plan_together/models/SafetyPhoneNumberModel.dart';
import 'package:plan_together/models/SelectedPlaceModel.dart';
import 'package:plan_together/models/SusetSunriseModel.dart';
import 'package:plan_together/repo/weather_repo.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/utils.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';

class TripSummaryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxList<Map<String, dynamic>> travelersList = <Map<String, dynamic>>[].obs;
  RxList<SelectedPlaceModel> createdPlaces = <SelectedPlaceModel>[].obs;
  RxList<SusetSunriseModel> sunsetSunriseModels = <SusetSunriseModel>[].obs;
  RxList<SafetyPhoneNumberModel> phoneNumbers = <SafetyPhoneNumberModel>[].obs;
  RxList<SafetyDocumentModel> safetyDocuments = <SafetyDocumentModel>[].obs;

  RxBool isPublic = true.obs;
  RxBool isPrivate = false.obs;
  RxBool isNumberAdding = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController phoneNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController fileTitleController = TextEditingController();

  final String docId;

  RxString sunriseTime = '6:20:00 AM'.obs;
  RxString sunsetTime = '6:30:00 PM'.obs;
  RxInt activeDate = 0.obs;
  RxBool isWeatherLoading = false.obs;

  List<String> dates = [];
  RxList<ListElement> weatherList = <ListElement>[].obs;
  Rx<ForecastWeatherModel> weatherData = ForecastWeatherModel().obs;

  RxString filePath = ''.obs;
  RxString fileUrl = ''.obs;

  //
  TripSummaryController({required this.docId});

  @override
  void onInit() async {
    super.onInit();

    tabController = TabController(vsync: this, length: 6);
    tabController.addListener(() {
      // SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusManager.instance.primaryFocus?.unfocus();
    });

    FirebaseServices.getPhoneNumbers(tripId: docId).listen((event) {
      phoneNumbers.assignAll(event);
    });
    FirebaseServices.getSafetyDocuments(tripId: docId).listen((event) {
      print("FirebaseServices.getSafetyDocuments(tripId: docId)----$event");
      safetyDocuments.value = event;
    });

    Get.put(BudgetController(docId));
    dates = Utils.getNextFiveDays();
    createdPlaces.value = await FirebaseServices.getPlacesByTripId(docId);
    await intializeWeatherData();
    intializeSunset();
  }

  intializeWeatherData() async {
    isWeatherLoading(true);
    weatherData.value = await WeatherRepo.getForecastWeather(
        lat: createdPlaces.first.latitude!,
        long: createdPlaces.first.latitude!);

    weatherList.value = weatherData.value.list!
        .where((element) => element.dtTxt!.contains(dates[0]))
        .toList();

    isWeatherLoading(false);
  }

  intializeSunset() async {
    for (String date in dates) {
      SusetSunriseModel sunriseModel = await WeatherRepo.getSunriseTime(
          lat: createdPlaces.first.latitude!,
          long: createdPlaces.first.latitude!,
          date: date);
      sunsetSunriseModels.add(sunriseModel);
    }

    sunriseTime.value = sunsetSunriseModels[0].results?.sunrise as String;
    sunsetTime.value = sunsetSunriseModels[0].results?.sunset as String;
  }

  changeDate(int index) async {
    activeDate.value = index;
    weatherList.value = weatherData.value.list!
        .where((element) => element.dtTxt!.contains(dates[index]))
        .toList();

    sunriseTime.value = sunsetSunriseModels[index].results?.sunrise as String;
    sunsetTime.value = sunsetSunriseModels[index].results?.sunset as String;
    update();
  }

  /* --------------- SafetyPhoneNumber Module --------- */

  changePublicValue() {
    isPublic.value = !isPublic.value;
    isPrivate.value = !isPrivate.value;
  }

  addPhoneNumber() async {
    if (phoneNumberController.text.isNotEmpty ||
        phoneNameController.text.isNotEmpty) {
      isNumberAdding(true);
      await FirebaseServices.addSafetyPhoneNumber(
          name: phoneNameController.text,
          phoneNumber: phoneNumberController.text,
          isPublic: isPublic.value,
          tripId: docId,
          addedBy: FirebaseConsts.auth.currentUser?.uid ?? '');
      isNumberAdding(false);
      customSnackBar(color: green, message: "Number Added Successfully");
    } else {
      isNumberAdding(false);
      customSnackBar(message: "Please Enter Name and Phone Number", color: red);
    }
  }



  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'png', 'jpg', 'doc']);

    if (result != null) {

      filePath.value =result.files.single.path!;


      print(" filepath.value = ${filePath.value}");
    }
  }

  uploadDocumentToFireStorage(File document) async {


    Uint8List fileData =await document.readAsBytes();
    var ref = FirebaseStorage.instance
        .ref()
        .child('files/${filePath.value.split('/').last}');
    // var uploadTask = ref.putFile(document);
    var uploadTask = ref.putData(fileData);
    final snapshot = await uploadTask;

    if (snapshot.state == TaskState.success) {
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print("________________________________________");
      return downloadUrl;
    } else {
      // User canceled the picker
    }
  }

  addDocument() async {

    if (fileTitleController.text.isNotEmpty || fileUrl.isNotEmpty) {
      isNumberAdding(true);
      File file = File(filePath.value);
      fileUrl.value = await uploadDocumentToFireStorage(file);
      print("${fileUrl.value} ------------------------- fileUrl.value");
      await FirebaseServices.addDocument(
        addedBy: FirebaseConsts.auth.currentUser?.uid??'',
          tripId: docId,
          title: fileTitleController.text,
          documentUrl: fileUrl.value,
          isPublic: isPublic.value);
      print("Documet Added -------------------");
      isNumberAdding(false);
      customSnackBar(message: "Document Added Successfully!", color: green);
    } else {
      customSnackBar(
          message: "Please Select Document and Enter Title", color: red);
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
