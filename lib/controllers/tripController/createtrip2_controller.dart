import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/models/SelectedPlaceModel.dart';
import 'package:plan_together/models/user_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/services/local_notification_service.dart';
import 'package:plan_together/utils/app_strings.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/lists.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';

class CreateTrip2Controller extends GetxController {
  TextEditingController tripNameController = TextEditingController();
  TextEditingController addTravelController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  Rx<DateTime> tripStartDate = DateTime.now().obs;
  Rx<DateTime> tripEndDate = DateTime.now().obs;

  RxBool isLoading = false.obs;
  RxInt index = 0.obs;

  List<String> deviceTokensList = <String>[];
  RxList<UserModel> searchedUsers = <UserModel>[].obs;

  RxList<UserModel> selectedUsers = <UserModel>[].obs;
  RxList<SelectedPlaceModel> selectedPlaces = <SelectedPlaceModel>[].obs;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(FirebaseConsts.userCollection);

  @override
  void onInit() {
    // fetchUsers();
    // TODO: implement onInit
    // incrementTrips();
    super.onInit();
    tripNameController.clear();
    destinationController.clear();
    startDateController.text = '';
    endDateController.clear();
  }

  addSelectedPlace(
      // PickResult result
      ) {
    // selectedPlaces.add(SelectedPlaceModel(
    //   placeName: result.name,
    //   latitude: result.geometry?.location.lat.toString(),
    //   longitude: result.geometry?.location.lng.toString(),
    //   photoUrl:
    //       "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${result.photos?.first.photoReference ?? ''}&key=${AppStrings.apiKey}",
    // ));
  }

  void removeSelectedPlace(SelectedPlaceModel locationModel) {
    selectedPlaces.remove(locationModel);
  }

  Future<List<UserModel>> searchUsers(String pattern, currentUserId) async {
    print("Search Users");
    // update();
    QuerySnapshot<Object?> snapshot = await usersCollection
        .where('username', isGreaterThanOrEqualTo: pattern)
        .where('username', isLessThan: '${pattern}z')
        .get();
    // print(snapshot.docs.map((e) => print(e.data())));

    List<UserModel> users = snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .where((user) => user.id != currentUserId)
        .where((user) => userModelGlobal.value.following.contains(user.id))
        .where((user) =>
            !selectedUsers.any((element) => element.email == user.email))
        .toList();

    // Update the searchedUsers list
    searchedUsers.assignAll(users);

    return users;
  }

  // Method to add a selected user to the list of selected users
  void addSelectedUser(UserModel user) {
    if (!selectedUsers.contains(user)) {
      selectedUsers.add(user);
    }
  }

  // Method to remove a selected user from the list of selected users
  void removeSelectedUser(UserModel user) {
    selectedUsers.remove(user);
  }

  selectIndex(travelIndex) {
    index.value = travelIndex;
  }

  changeDate(date) {
    startDateController.text = date;

    update();
  }

  changeEndDate(date) {
    DateTime startDate = DateTime.parse(startDateController.text);
    DateTime endDate = DateTime.parse(date);

    if (endDate.isBefore(startDate)) {
      customSnackBar(
          message: "End date must be after the start date", color: red);
      print("End date must be after the start date");
    } else {
      endDateController.text = date;
      print("Dates are valid");
    }

    update();
  }

  createDatePicker(BuildContext context, {DateTime? intialDate}) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: intialDate ?? DateTime.now(),
        //get today's date
        firstDate: intialDate ?? DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime.now().add(Duration(days: 365)));

    if (pickedDate != null) {
      print(
          pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000

      String formattedDate = DateFormat('dd/MM/yyyy').format(
          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      print(
          formattedDate); //formatted date output using intl package =>  2022-07-04
      //You can format date as per your need
      // return formattedDate;
      return pickedDate;
    } else {
      print("Date is not selected");
    }
  }

  Future incrementTrips() async {
    isLoading(true);
    String? userId = FirebaseConsts.auth.currentUser?.uid;
    DocumentSnapshot doc = await usersCollection.doc(userId).get();

    var userModel = UserModel.fromJson(doc.data());

    await FirebaseServices.incrementTripCount(userId!, userModel.tripCount);
    isLoading(false);
  }

  Future createTripe() async {
    // UserModel currentUserModel = UserModel.fromJson(await FirebaseServices.getCurrentUserName(FirebaseConsts.auth.currentUser?.uid));
    selectedUsers.add(await FirebaseServices.getCurrentUserById(
        FirebaseConsts.auth.currentUser?.uid));
    isLoading(true);

    await FirebaseServices.createTripe(
        tripEndDate: tripEndDate.value,
        tripStartDate: tripStartDate.value,
        places: selectedPlaces,
        tripName: tripNameController.text,
        usersId: selectedUsers.map((element) => element.id ?? '').toList(),
        startDate: startDateController.text,
        endDate: endDateController.text,
        addTravellers:
            selectedUsers.map((element) => element.email.toString()).toList(),
        names: selectedUsers.map((element) => element.name.toString()).toList(),
        profileUrls: selectedUsers
            .map((element) => element.profileImgUrl.toString() ?? '')
            .toList(),
        travelling: travelModeList[index.value],
        destination:
            selectedPlaces.map((place) => place.placeName.toString()).toList());

    await LocalNotificationService.instance.sendFCMNotification(
        deviceTokens: deviceTokensList,
        title: "Plan Together",
        body:
            "${userModelGlobal.value.name} added you in trip ${tripNameController.text}",
        type: 'general',
        sentBy: userModelGlobal.value.id!,
        sentTo: '',
        savedToFirestore: false);
    // await reference.set();
    isLoading(false);
  }

// Future<List<UserModel>> searchUser(String query) async {
//   final userCollection = FirebaseConsts.firestore.collection(
//       FirebaseConsts.userCollection);
//
//
//   final QuerySnapshot result = await userCollection.get();
//   return result.docs.map((model) {
//
//     return UserModel(
//         id: model.id,
//         name: model['name'],
//         email: model['email']
//     );
//   }).toList();
// }
}
