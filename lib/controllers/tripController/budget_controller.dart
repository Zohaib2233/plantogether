
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plan_together/models/group_budget_model.dart';
import 'package:plan_together/models/user_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';

class BudgetController extends GetxController {
  final String tripId;

  BudgetController(this.tripId);

  // Observables
  final RxBool showAvailableBalance = false.obs;
  final RxBool showFriendsBudget = false.obs;
  final RxBool isSelectedAll = false.obs;
  final RxList<String> profileUrlsList = <String>[].obs;
  final RxList<String> receiptsUrlList = <String>[].obs;
  final RxList<UserModel> userModels = <UserModel>[].obs;
  final RxList<GroupBudgetModel> groupBudgetModels = <GroupBudgetModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool groupBudgetLoading = false.obs;
  final RxString amount = ''.obs;
  String personalBudgetId = '';
  RxList<dynamic> selectedUserIds = <dynamic>[].obs;
  RxList<File> pickedImages = <File>[].obs;

  RxMap<String, List<Map<String, dynamic>>> personalExpenses =<String, List<Map<String, dynamic>>>{}.obs;




  final TextEditingController amountController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController groupExpenseController = TextEditingController();





  @override
  void onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> _initialize() async {
    final details = await FirebaseServices.getPersonalBudget(tripId);
    final tripModel = await FirebaseServices.getTripDetail(tripId);

    listenToGroupBudgetChanges();

    // print("$groupBudgetModels groupBudgetModels" );

    tripModel.usersId?.forEach((userId) async {
      final userModel = await FirebaseServices.getCurrentUserById(userId);
      userModels.add(userModel);
    });

    if (details != null) {
      showAvailableBalance.value = details['amountAdded'];
      amount.value = details['amount'].toString();
      personalBudgetId = details['pbId'];

      print("personalBudgetId = $personalBudgetId");

      final expenseDetails = await FirebaseServices.getTripExpensesById(
          pbId: personalBudgetId, tripId: tripId);

      profileUrlsList.value = tripModel.profileUrls ?? [];

      // Print details
      // print("Details: $details");
      // print("Expense Details: $expenseDetails");
    }
  }
  void listenToGroupBudgetChanges() {
    FirebaseServices.getGroupBudget(tripId).then((list) {
      groupBudgetModels.assignAll(list);
      // print("listenToGroupBudgetChanges $groupBudgetModels");
    });

    // Subscribe to changes in the group budget collection
    FirebaseServices.groupBudgetStream(tripId).listen((list) {
      groupBudgetModels.assignAll(list);
    });
  }

  void updateSelectedUserIds(List newSelectedUserIds) {
    selectedUserIds.assignAll(newSelectedUserIds);

  }

  void paidForEveryone(bool? selectAll) {
    isSelectedAll(selectAll);
    if (selectAll==true) {
      selectedUserIds.assignAll(userModels.map((user) => user.id as String));
    } else {
      selectedUserIds.clear();
    }
    // print(selectedUserIds);
  }


  Future multiImagePicker() async {
    try {
      List<XFile> _images = await ImagePicker().pickMultiImage();
      for (int i = 0; i < _images.length; i++) {
        pickedImages.add(File(_images[i].path));
      }
      print("Picked images list: $pickedImages");

    } on PlatformException catch (e) {
      print(e);
      // log("$e", name: "Image picker exception on gallery pick");
    } catch (e) {
      print(e);
      // log("$e", name: "Image picker exception on gallery pick");
    }
  }


    Future<void> createDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final formattedDate =
      DateFormat('yyyy-MM-dd').format(pickedDate);
      dateController.text = formattedDate;
    }
  }

  Future<void> createTimePiker(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final now = DateTime.now();
      final times = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      final formatter = DateFormat.jm();
      timeController.text = formatter.format(times);
    }
  }

  Future<void> addTotalAmount() async {
    isLoading(true);
    personalBudgetId = await FirebaseServices.addPersonalBudget(
      amount: amountController.text,
      tripId: tripId,
    );
    amount.value = amountController.text;
    showAvailableBalance(true);
    isLoading(false);
    customSnackBar(message: "Total Amount Added", color: green);
  }

  Future<void> addExpenses() async {
    await FirebaseServices.addPersonalExpenses(
      itemPrice: itemPriceController.text,
      tripId: tripId,
      item: itemNameController.text,
      date: dateController.text,
      pbId: personalBudgetId,
      time: timeController.text,
    );
  }

  Future<void> updatePbAmount() async {
    final newAmount =
    (int.parse(amount.value) - int.parse(itemPriceController.text))
        .toString();
    amount.value = newAmount;
    await FirebaseServices.updateAmount(personalBudgetId, newAmount);
    customSnackBar(message: "Item Added!", color: green);
  }

  Stream<Map<String, List<Map<String, dynamic>>>>
  getExpensesByGroupDate()  {
    FirebaseServices.getExpensesByPbIdGroupedByDateStream(personalBudgetId).listen((event) {
      personalExpenses.value = event;
    });
    return FirebaseServices.getExpensesByPbIdGroupedByDateStream(personalBudgetId);
  }


  addGroupExpense() async{

    if(selectedUserIds.isEmpty || groupExpenseController.text.isEmpty){
      customSnackBar(message: "Please add Travellers and Expense",color: red);
    }
    else{
      groupBudgetLoading(true);

      if(pickedImages.isNotEmpty){
        receiptsUrlList.value = await FirebaseServices.addListOfImagesToFirebase(pickedImages);
        await FirebaseServices.addGroupBudget(
          tripId: tripId,
          amount: double.parse(groupExpenseController.text),
          images: receiptsUrlList,
          travellers: selectedUserIds.map((element) => element.toString()).toList(),

        );
        groupBudgetLoading(false);
        // print("pickedImages.isNotEmpty = $receiptsUrlList");
      }
      else{
        groupBudgetLoading(true);
        // print("pickedImages.isEmpty = $receiptsUrlList");
        await FirebaseServices.addGroupBudget(
          tripId: tripId,
          amount: double.parse(groupExpenseController.text),
          images: receiptsUrlList,
          travellers: selectedUserIds.map((element) => element.toString()).toList(),

        );
        groupBudgetLoading(false);
      }

    }


  }
}
