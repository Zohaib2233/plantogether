import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/models/SafetyDocumentModel.dart';
import 'package:plan_together/models/SafetyPhoneNumberModel.dart';
import 'package:plan_together/models/group_budget_model.dart';
import 'package:plan_together/models/postsModel/comment_model.dart';
import 'package:plan_together/models/postsModel/post_model.dart';
import 'package:plan_together/models/trip_item_model.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/models/user_model.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';

import '../models/SelectedPlaceModel.dart';

class FirebaseServices {
  static Future<void> incrementTripCount(String id, int tripCount) async {
    try {
      print("incrementTripCount");
      await FirebaseConsts.firestore
          .collection(FirebaseConsts.userCollection)
          .doc(id)
          .update({'tripCount': (tripCount + 1)});
      // _tripCount++;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /* ------------------- Create Module  ------------------  */
  static Future createTripe(
      {tripName,
      startDate,
      required DateTime tripStartDate,
      required DateTime tripEndDate,
      docId,
      endDate,
      List<String>? addTravellers,
      List<String>? names,
      usersId,
      profileUrls,
      List<String>? destination,
      required List<SelectedPlaceModel> places,
      travelling}) async {
    DocumentReference reference = FirebaseConsts.firestore
        .collection(FirebaseConsts.tripsCollection)
        .doc();
    Map tripData = TripModel(
            tripId: FirebaseConsts.auth.currentUser?.uid,
            docId: reference.id ?? '',
            tripName: tripName,
            startDate: startDate,
            endDate: endDate,
            addTravelers: addTravellers ?? [],
            names: names ?? [],
            profileUrls: profileUrls ?? [],
            usersId: usersId ?? [],
            destination: destination ?? [],
            travlling: travelling,
            tripEndDate: tripEndDate,
            tripStartDate: tripStartDate)
        .toJson();
    await reference.set(tripData);
    await savePlacesToFirebase(tripId: reference.id, selectedPlaces: places);
    // await reference.set();
  }

  static savePlacesToFirebase(
      {required String tripId,
      required List<SelectedPlaceModel> selectedPlaces}) async {
    try {
      for (SelectedPlaceModel place in selectedPlaces) {
        DocumentReference reference = FirebaseConsts.firestore
            .collection(FirebaseConsts.placesCollection)
            .doc();
        await reference.set(SelectedPlaceModel(
                tripId: tripId,
                latitude: place.latitude,
                longitude: place.longitude,
                photoUrl: place.photoUrl,
                placeId: reference.id,
                placeName: place.placeName)
            .toJson());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Stream<List<TripModel>> getTrips(var currentUserEmail) {
    return FirebaseConsts.firestore
        .collection(FirebaseConsts.tripsCollection)
        .where('addTravelers', arrayContains: currentUserEmail)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TripModel.fromJson(doc.data()))
            .toList());
  }

  static Future<List<TripModel>> getTripsByDate(
      {required DateTime date, required String currentUser}) async {
    Timestamp timestamp = Timestamp.fromDate(date);
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseConsts
          .firestore
          .collection(FirebaseConsts.tripsCollection)
          .where('usersId', arrayContains: currentUser)
          .where('tripStartDate', isEqualTo: timestamp)
          .get();

      print(snapshot.docs);

      return snapshot.docs
          .map((doc) => TripModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<TripModel> getTripDetail(docId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseConsts
        .firestore
        .collection(FirebaseConsts.tripsCollection)
        .doc(docId)
        .get();
    Map<String, dynamic>? tripDetails = snapshot.data();
    // print("snapshot.data() = ${tripDetails?['profileUrls']}");
    return TripModel.fromJson(tripDetails);
  }

  static Stream<QuerySnapshot> getCurrentUserTrips(var currentUserId) {
    return FirebaseConsts.firestore
        .collection(FirebaseConsts.tripsCollection)
        .where('tripId', isEqualTo: currentUserId)
        .snapshots();
  }

  static Future<UserModel> getCurrentUserById(var currentUserId) async {
    var name = await FirebaseConsts.firestore
        .collection(FirebaseConsts.userCollection)
        .where('id', isEqualTo: currentUserId)
        .get();
    print(name.docs[0].data());
    return UserModel.fromJson(name.docs[0].data());
  }

  static Future<UserModel> getUserByEmail(var email) async {
    var name = await FirebaseConsts.firestore
        .collection(FirebaseConsts.userCollection)
        .where('email', isEqualTo: email)
        .get();
    // print(name.docs[0].data());
    return UserModel.fromJson(name.docs[0].data());
  }

  /* ------------------- Checklist Module  ------------------  */

  static Future getTravellersList(String id) async {
    try {
      print("getTravellersList");
      return await FirebaseConsts.firestore
          .collection(FirebaseConsts.tripsCollection)
          .doc(id)
          .get();
      // return trips['addTravelers'];
      // _tripCount++;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future addItem(
      {docId, String? itemName, required String email}) async {
    UserModel userModel = await getUserByEmail(email);
    DocumentReference reference = FirebaseConsts.firestore
        .collection(FirebaseConsts.tripsCollection)
        .doc(docId)
        .collection(FirebaseConsts.itemsCollection)
        .doc();

    await reference.set(TripItemModel(
            email: email,
            item: itemName,
            addedBy: userModel.id,
            selected: false,
            docId: reference.id)
        .toJson());
  }

  static Future<List<TripItemModel>> getTripItemById(var itemId, docId) async {
    var items = await FirebaseConsts.firestore
        .collection(FirebaseConsts.tripsCollection)
        .doc(docId)
        .collection(FirebaseConsts.itemsCollection)
        .where('addedBy', isEqualTo: itemId)
        .get();

    return items.docs
        .map((item) => TripItemModel.fromJson(item.data()))
        .toList();
  }

  static Stream<List<TripItemModel>> getTripItemByEmail(String email, String docId) {
    return FirebaseConsts.firestore
        .collection(FirebaseConsts.tripsCollection)
        .doc(docId)
        .collection(FirebaseConsts.itemsCollection)
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TripItemModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  // static Future<List<TripItemModel>> getTripItemByEmail(
  //     var email, docId) async {
  //   var items = await FirebaseConsts.firestore
  //       .collection(FirebaseConsts.tripsCollection)
  //       .doc(docId)
  //       .collection(FirebaseConsts.itemsCollection)
  //       .where('email', isEqualTo: email)
  //       .get();
  //
  //   // print(items);
  //
  //   return items.docs
  //       .map((item) => TripItemModel.fromJson(item.data()))
  //       .toList();
  // }

  static Future selectItem({tripId, docId, value}) async {
    await FirebaseConsts.firestore
        .collection(FirebaseConsts.tripsCollection)
        .doc(tripId)
        .collection(FirebaseConsts.itemsCollection)
        .doc(docId)
        .update({'selected': value});
  }

  static Future editItem({tripId, docId, itemName}) async {
    await FirebaseConsts.firestore
        .collection(FirebaseConsts.tripsCollection)
        .doc(tripId)
        .collection(FirebaseConsts.itemsCollection)
        .doc(docId)
        .update({'item': itemName});
  }
  static Future deleteItem({tripId, docId}) async {
    await FirebaseConsts.firestore
        .collection(FirebaseConsts.tripsCollection)
        .doc(tripId)
        .collection(FirebaseConsts.itemsCollection)
        .doc(docId).delete();
  }

  /* ------------------- Budget Module  ------------------  */

  static Future addPersonalBudget({
    tripId,
    amount,
  }) async {
    try {
      DocumentReference reference = FirebaseConsts.firestore
          .collection(FirebaseConsts.personalBudgetCollection)
          .doc();
      await reference.set({
        'pbId': reference.id,
        'createdBy': FirebaseConsts.auth.currentUser?.uid ?? '',
        'tripId': tripId ?? '',
        'amount': amount ?? '',
        'amountAdded': true,
      });
      return reference.id;
    } catch (e) {
      customSnackBar(message: "${e.printError}", color: red);
    }
  }

  static Future addGroupBudget({
    List<String>? travellers,
    String? tripId,
    double? amount,
    List<String>? images,
  }) async {
    try {
      print("Add Group Budget Called");
      DocumentReference reference = FirebaseConsts.firestore
          .collection(FirebaseConsts.groupBudgetCollection)
          .doc();
      GroupBudgetModel groupBudgetModel = GroupBudgetModel(
          travellers: travellers,
          images: images,
          amount: amount,
          tripId: tripId,
          time: DateTime.now(),
          addedBy: FirebaseConsts.auth.currentUser?.uid,
          expenseAdded: true,
          gbId: reference.id);
      await reference.set(groupBudgetModel.toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future<List<String>> addListOfImagesToFirebase(
      List<File> images) async {
    List<String> downloadUrls = [];
    final storage = FirebaseStorage.instance;
    for (var image in images) {
      String fileName = image.path.split('/').last;
      Reference reference = storage.ref().child('receipts/$fileName');
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }

  static Future getPersonalBudget(tripId) async {
    QuerySnapshot snapshot = await FirebaseConsts.firestore
        .collection(FirebaseConsts.personalBudgetCollection)
        .where(Filter.and(
            Filter('createdBy',
                isEqualTo: FirebaseConsts.auth.currentUser?.uid),
            Filter('tripId', isEqualTo: tripId)))
        .get();

    // print(snapshot.docs.first.data());
    print(snapshot.docs);
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    } else {
      return null;
    }
  }

  static Future<List<GroupBudgetModel>> getGroupBudget(tripId) async {
    QuerySnapshot snapshot = await FirebaseConsts.firestore
        .collection(FirebaseConsts.groupBudgetCollection)
        .where('tripId', isEqualTo: tripId)
        .where(Filter.or(
            Filter('addedBy', isEqualTo: FirebaseConsts.auth.currentUser?.uid),
            Filter('travellers',
                arrayContains: FirebaseConsts.auth.currentUser?.uid)))
        .get();

    // print(snapshot.docs.first.data());
    print(snapshot.docs);
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs
          .map((e) =>
              GroupBudgetModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

  static Stream<List<GroupBudgetModel>> groupBudgetStream(String tripId) {
    return FirebaseFirestore.instance
        .collection('group_budget')
        .where('tripId', isEqualTo: tripId)
        .where(Filter.or(
            Filter('addedBy', isEqualTo: FirebaseConsts.auth.currentUser?.uid),
            Filter('travellers',
                arrayContains: FirebaseConsts.auth.currentUser?.uid)))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupBudgetModel.fromJson(doc.data()))
            .toList());
  }

  static Future addPersonalExpenses(
      {tripId, itemPrice, pbId, item, date, time}) async {
    try {
      DocumentReference reference = FirebaseConsts.firestore
          .collection(FirebaseConsts.personalBudgetCollection)
          .doc(pbId)
          .collection(FirebaseConsts.totalExpensesCollection)
          .doc();
      await reference.set({
        'createdBy': FirebaseConsts.auth.currentUser?.uid ?? '',
        'docId': reference.id ?? '',
        'tripId': tripId ?? '',
        'itemPrice': itemPrice ?? '',
        'item': item ?? '',
        'date': date ?? '',
        'time': time ?? ''
      });
    } catch (e) {
      customSnackBar(message: "${e.printError}", color: red);
    }
  }

  static Future updateAmount(String pbId, amount) async {
    try {
      print("updateAmount Call");
      await FirebaseConsts.firestore
          .collection(FirebaseConsts.personalBudgetCollection)
          .doc(pbId)
          .update({'amount': amount});
      print("After updateAmount");
      // _tripCount++;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<Map<String, dynamic>>?> getTripExpensesById(
      {pbId, tripId}) async {
    print("getTripExpensesById $pbId $tripId");
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseConsts
        .firestore
        .collection(FirebaseConsts.personalBudgetCollection)
        .doc(pbId)
        .collection(FirebaseConsts.totalExpensesCollection)
        .get();

    // print(snapshot.docs.first.data());
    print(snapshot.docs);
    if (snapshot.docs.isNotEmpty) {
      print("Servise");

      return snapshot.docs.map((e) => e.data()).toList();
    } else {
      return null;
    }
  }

  // static Future<Map<String, List<Map<String, dynamic>>>>
  //     getExpensesByPbIdGroupedByDate(String pbId) async {
  //   try {
  //     final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseConsts
  //         .firestore
  //         .collection(FirebaseConsts.personalBudgetCollection)
  //         .doc(pbId)
  //         .collection(FirebaseConsts.totalExpensesCollection)
  //         .get();
  //
  //     // Group expenses by date
  //     Map<String, List<Map<String, dynamic>>> groupedExpenses = {};
  //
  //     snapshot.docs.forEach((expenseDoc) {
  //       Map<String, dynamic> expenseData = expenseDoc.data();
  //       String date = expenseData['date'];
  //
  //       // Check if a list for this date exists, if not create it
  //       if (!groupedExpenses.containsKey(date)) {
  //         groupedExpenses[date] = [];
  //       }
  //
  //       groupedExpenses[date]!.add(expenseData);
  //     });
  //     // print(groupedExpenses);
  //     return groupedExpenses;
  //   } catch (e) {
  //     print('Error fetching expenses: $e');
  //     return {};
  //   }
  // }

  static Stream<Map<String, List<Map<String, dynamic>>>>
      getExpensesByPbIdGroupedByDateStream(String pbId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream =
          FirebaseConsts.firestore
              .collection(FirebaseConsts.personalBudgetCollection)
              .doc(pbId)
              .collection(FirebaseConsts.totalExpensesCollection)
              .snapshots();

      return snapshotStream.map((snapshot) {
        // Group expenses by date
        Map<String, List<Map<String, dynamic>>> groupedExpenses = {};

        snapshot.docs.forEach((expenseDoc) {
          Map<String, dynamic> expenseData = expenseDoc.data();
          String date = expenseData['date'];

          // Check if a list for this date exists, if not create it
          if (!groupedExpenses.containsKey(date)) {
            groupedExpenses[date] = [];
          }

          groupedExpenses[date]!.add(expenseData);
        });

        return groupedExpenses;
      });
    } catch (e) {
      print('Error fetching expenses: $e');
      // Return an empty stream in case of error
      return Stream.empty();
    }
  }

  /* -------- Get Places ----------*/

  static Future<List<SelectedPlaceModel>> getPlacesByTripId(tripId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseConsts
        .firestore
        .collection(FirebaseConsts.placesCollection)
        .where('tripId', isEqualTo: tripId)
        .get();

    return snapshot.docs
        .map((doc) => SelectedPlaceModel.fromJson(doc.data()))
        .toList();
  }

  /* ------------- Trip Safety ---------------- */

  static addSafetyPhoneNumber(
      {required String name,
      required String phoneNumber,
      required bool isPublic,
      required String tripId,
      required String addedBy}) async {
    try {
      DocumentReference reference = FirebaseConsts.firestore
          .collection(FirebaseConsts.phoneNumbersCollection)
          .doc();

      await reference.set(SafetyPhoneNumberModel(
              tripId: tripId,
              addedBy: addedBy,
              docId: reference.id,
              name: name,
              isPublic: isPublic,
              phoneNumber: phoneNumber)
          .toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  static addDocument(
      {required String tripId,
      required String title,
      required String addedBy,
      required String documentUrl,
      required bool isPublic}) async {
    try {
      DocumentReference reference = FirebaseConsts.firestore
          .collection(FirebaseConsts.addDocumentCollection)
          .doc();

      await reference.set(SafetyDocumentModel(
              addedBy: addedBy,
              isPublic: isPublic,
              docId: reference.id,
              tripId: tripId,
              title: title,
              time: DateTime.now(),
              documentUrl: documentUrl)
          .toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  static Stream<List<SafetyPhoneNumberModel>> getPhoneNumbers(
      {required String tripId}) {
    return FirebaseConsts.firestore
        .collection(FirebaseConsts.phoneNumbersCollection)
        .where('tripId', isEqualTo: tripId)
        .where(Filter.or(Filter('isPublic', isEqualTo: true),
            Filter('addedBy', isEqualTo: FirebaseConsts.auth.currentUser?.uid)))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SafetyPhoneNumberModel.fromJson(doc.data()))
            .toList());
  }

  static Stream<List<SafetyDocumentModel>> getSafetyDocuments(
      {required String tripId}) {
    print("----------------getSafetyDocuments------------- $tripId");
    try {
      return FirebaseConsts.firestore
          .collection(FirebaseConsts.addDocumentCollection)
          .where('tripId', isEqualTo: tripId)
          .where(Filter.or(
              Filter('isPublic', isEqualTo: true),
              Filter('addedBy',
                  isEqualTo: FirebaseConsts.auth.currentUser?.uid)))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => SafetyDocumentModel.fromSnapshot(doc))
              .toList());
    } catch (e) {
      throw Exception();
    }
  }

  /* ------------- Post Module ------------ */

  static Stream<List<PostModel>> streamAllPosts() {
    print("StreamAllPost Called");
    return FirebaseConsts.firestore
        .collection(FirebaseConsts.postsCollection)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((event) {
      print(event.docs.first.data());
      return event.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
    });
  }

  static Stream<List<PostModel>> streamUserPosts({required userId}) {
    return FirebaseConsts.firestore
        .collection(FirebaseConsts.postsCollection)
        .where('createdBy', isEqualTo: userId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => PostModel.fromMap(doc.data())).toList());
  }

  static Future likePost({required List likes, required String docId}) async {
    print("Like Post called");

    if (likes.contains(userModelGlobal.value.id)) {
      try {
        await FirebaseConsts.firestore
            .collection(FirebaseConsts.postsCollection)
            .doc(docId)
            .update({
          'likes': FieldValue.arrayRemove([userModelGlobal.value.id]),
          'totalLikes': FieldValue.increment(-1)
        });
      } catch (e) {
        throw Exception(e);
      }
    } else {
      try {
        print("called Liked increment");
        await FirebaseConsts.firestore
            .collection(FirebaseConsts.postsCollection)
            .doc(docId)
            .update({
          'likes': FieldValue.arrayUnion([userModelGlobal.value.id]),
          'totalLikes': FieldValue.increment(1)
        });
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  static Future addComment(
      {required String postId, required String commentMsg}) async {
    try {
      DocumentReference reference = FirebaseConsts.firestore
          .collection(FirebaseConsts.commentsCollection)
          .doc();

      await reference.set(CommentModel(
              postId: postId,
              commentId: reference.id,
              date: DateTime.now(),
              commentMsg: commentMsg,
              commentorName: userModelGlobal.value.name ?? '',
              commentorProfile: userModelGlobal.value.profileImgUrl ?? '',
              commentorUid: userModelGlobal.value.id ?? '')
          .toJson());

      await FirebaseConsts.firestore
          .collection(FirebaseConsts.postsCollection)
          .doc(postId)
          .update({'totalComments': FieldValue.increment(1)});
    } catch (e) {
      throw Exception(e);
    }
  }

  static Stream<List<CommentModel>> streamComments({postId}) {
    return FirebaseConsts.firestore
        .collection(FirebaseConsts.commentsCollection)
        .where('postId', isEqualTo: postId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CommentModel.fromJson(doc.data()))
            .toList());
  }

  static Future addPostToBookmark(
      {required List bookmarkPosts, required postId}) async {
    try {
      if (bookmarkPosts.contains(postId)) {
        await FirebaseConsts.firestore
            .collection(FirebaseConsts.userCollection)
            .doc(userModelGlobal.value.id)
            .update({
          'bookmarkPosts': FieldValue.arrayRemove([postId])
        });
      } else {
        await FirebaseConsts.firestore
            .collection(FirebaseConsts.userCollection)
            .doc(userModelGlobal.value.id)
            .update({
          'bookmarkPosts': FieldValue.arrayUnion([postId])
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future connectToFriend(
      {required List following, required String userId}) async {
    try {
      if (following.contains(userId)) {
        await FirebaseConsts.firestore
            .collection(FirebaseConsts.userCollection)
            .doc(userModelGlobal.value.id)
            .update({
          'following': FieldValue.arrayRemove([userId]),
          'totalFollowing':FieldValue.increment(-1)
        });

        await FirebaseConsts.firestore
            .collection(FirebaseConsts.userCollection)
            .doc(userId)
            .update({
          'followers': FieldValue.arrayRemove([userModelGlobal.value.id]),
          'totalFollowers':FieldValue.increment(-1)
        });
      } else {
        await FirebaseConsts.firestore
            .collection(FirebaseConsts.userCollection)
            .doc(userModelGlobal.value.id)
            .update({
          'following': FieldValue.arrayUnion([userId]),
          'totalFollowing':FieldValue.increment(1)
        });

        await FirebaseConsts.firestore
            .collection(FirebaseConsts.userCollection)
            .doc(userId)
            .update({
          'followers': FieldValue.arrayUnion([userModelGlobal.value.id]),
          'totalFollowers':FieldValue.increment(1)
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /* Trip Add Day   */

  static Future addDay(tripId, day) async {
    DocumentReference reference = FirebaseConsts.firestore
        .collection(FirebaseConsts.daysCollection)
        .doc();

    await reference.set({
      'id': reference.id,
      'tripId': tripId,
      'day': day,
      'date': '',
      'hotel': '',
      'tourLocations': '',
      'img_url': ''
    });
  }
}
