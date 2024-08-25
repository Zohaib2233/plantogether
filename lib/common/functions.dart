//listening user's data
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plan_together/common/variables.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/services/local_notification_service.dart';

import '../constant/instances_contant.dart';
import '../models/user_model.dart';
import '../services/zego_call_service.dart';


Future<void> getUserDataStream({required String userId}) async {
  //getting user's data stream
  String deviceToken = await LocalNotificationService.instance.getDeviceToken()??'';
  await  FirebaseConsts.firestore
      .collection(FirebaseConsts.userCollection)
      .doc(FirebaseAuth.instance.currentUser!.uid).update({
    'deviceToken':deviceToken
  });
  print("Get Stream Data $deviceToken");
  FirebaseConsts.firestore
      .collection(FirebaseConsts.userCollection)
      .doc(userId)
      .snapshots()
      .listen((event) {
    print(event);

    //binding that user's data stream into an observable UserModel object

    userModelGlobal.value = UserModel.fromJson(event);


    // log("User first name from model is: ${userModel.value.firstName}");
  });
}

getAllTripsDates({required String userId}) {
  print("tttttt getAllTripsDates({required String userId})");


  return FirebaseConsts.firestore
      .collection(FirebaseConsts.tripsCollection)
      .where('usersId', arrayContains: userId)
      .snapshots()
      .listen((event) {
    print("----------- getAllTripsDates---------  ${event.docs}");
    List<DateTime> tempList = [];
    for (var doc in event.docs) {


      TripModel tripModel = TripModel.fromJson(doc);
      print(" TripModel tripModel = TripModel.fromJson(doc); = ${tripModel.toJson()}");
      tempList.add(DateTime(tripModel.tripStartDate!.year,
          tripModel.tripStartDate!.month, tripModel.tripStartDate!.day));
    }
    allTripsDateList.value = tempList;
    print("Get All Trips $event  ${allTripsDateList}");
  });
}
