import 'package:get/get.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/models/trip_item_model.dart';
import 'package:plan_together/services/firebase_services.dart';

import '../../models/user_model.dart';

class AddMoreItemController extends GetxController {
  var itemsList = <TripItemModel>[].obs;


  void getItems(String email, String docId) async {
    UserModel model = await FirebaseServices.getUserByEmail(email);
    itemsList.assignAll(await FirebaseServices.getTripItemById(model.id, docId));
  }

  void addItem(String newItem, String docId, String email) async {
    await FirebaseServices.addItem(docId: docId, itemName: newItem, email: email);
    getItems(email, docId);
  }

  void selectItem({required String docId, required String tripId, required bool value}) async {
    await FirebaseServices.selectItem(tripId: tripId, docId: docId, value: value);
    // Refresh items after updating selection
    getItems(FirebaseConsts.auth.currentUser?.email ?? '', tripId);
  }
}
