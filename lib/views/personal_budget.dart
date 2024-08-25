import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_together/controllers/tripController/budget_controller.dart';

import '../utils/global_colors.dart';
import '../widgets/get_textfield.dart';
import '../widgets/mainButton.dart';
import '../widgets/text_widget.dart';

class PersonalBudget extends StatelessWidget {
  final String tripId;

  const PersonalBudget({Key? key, required this.tripId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<BudgetController>();
    return Obx(() => controller.isLoading.isFalse
        ? (controller.showAvailableBalance.value
            ? availableBalance(context, tripId)
            : noBudget(context, tripId))
        : Container(
            height: Get.height,
            width: Get.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ));
  }

  Widget noBudget(context, tripId) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return addOverallBudgetDialog(context, tripId);
                    });
                // Get.dialog(ad);
              },
              child: Container(
                height: 64,
                width: 51,
                margin: const EdgeInsets.only(top: 30, bottom: 15),
                decoration: BoxDecoration(
                    color: addBgColor.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(30)),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: primaryColor,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: TextWidget(
              text: 'Add trip budget',
              size: 13.11,
              color: blackColor,
              fontWeight: FontWeight.w400),
        ),
        Container(
          height: 213,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 30),
          child: DottedBorder(
              radius: const Radius.circular(8),
              color: primaryColor.withOpacity(0.16),
              dashPattern: const [6, 6],
              strokeWidth: 2,
              child: Center(
                  child: TextWidget(
                      text: 'No budget to show',
                      size: 12,
                      color: lightGrey,
                      fontWeight: FontWeight.w500))),
        ),
      ],
    );
  }

  Widget availableBalance(context, tripId) {
    var controller = Get.find<BudgetController>();
    print(controller.amountController.text);
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(
          height: 20,
        ),
        const Divider(
          color: Color(0xffE0E0E0),
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 10),
          child: TextWidget(
              text: 'Available Balance',
              size: 12,
              color: blackColor,
              fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => TextWidget(
                    text: '\$ ${controller.amount}',
                    size: 32,
                    color: controller.personalExpenses.isNotEmpty?red:greenColor,
                    fontWeight: FontWeight.w600),
              ),
              MainButton(
                  height: 50,
                  color: primaryColor,
                  width: 130,
                  text: "+ Add Expense",
                  textColor: Colors.white,
                  textSize: 14,
                  onPressed: () {
                    // await FirebaseServices.getPersonalBudget(tripId);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return addExpenseDialog(context, controller);
                        });
                  },
                  borderRadius: 10,
                  textFont: FontWeight.w700),
            ],
          ),
        ),
        const Divider(
          color: Color(0xffE0E0E0),
          thickness: 1,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20.0, bottom: 15, right: 20, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                  text: 'Summary',
                  size: 14,
                  color: blackColor,
                  fontWeight: FontWeight.w600),
              // TextWidget(
              //     text: 'See all',
              //     size: 12,
              //     color: lightGrey,
              //     fontWeight: FontWeight.w500),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Divider(
            color: Color(0xffE0E0E0),
            thickness: 1,
          ),
        ),
        // ...List.generate(2, (index) => billItem(date: 'Today'))
        Container(
          height: 350,
          child: StreamBuilder<Map<String, List<Map<String, dynamic>>>>(
            stream: controller.getExpensesByGroupDate(),

            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }


              Map<String, List<Map<String, dynamic>>> groupedExpenses =
                  snapshot.data ?? {};

              // Now you can use the groupedExpenses data to build your UI
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupedExpenses.length,
                itemBuilder: (context, index) {
                  String date = groupedExpenses.keys.toList()[index];
                  List<Map<String, dynamic>> expenses =
                      groupedExpenses[date] ?? [];
                  if(groupedExpenses.isEmpty){
                    return billItem(date: '', expenses: [{'':'No Expenses Added'}]);
                  }
                  else{
                    return billItem(date: date, expenses: expenses);
                  }

                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget addOverallBudgetDialog(context, tripId) {
    var controller = Get.find<BudgetController>();
    return AlertDialog(
      backgroundColor: const Color(0xfffcfcff),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                    text: 'Add overall budget',
                    size: 17,
                    color: const Color(0xff1B1F31),
                    fontWeight: FontWeight.w600),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xff09121F),
                    size: 22,
                  ),
                )
              ],
            ),
            const Divider(
              color: Color(0xffE0E0E0),
              thickness: 0.5,
            ),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
                text: 'Amount',
                size: 14,
                color: const Color(0xff2F2F2F),
                fontWeight: FontWeight.w400),
            const SizedBox(
              height: 10,
            ),
            getTextField(
                controller: controller.amountController,
                borderRadius: 5,
                contentPadding: 5,
                InputType: TextInputType.number),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: MainButton(
                  height: 60,
                  color: primaryColor,
                  text: "Add",
                  textColor: Colors.white,
                  textSize: 15.55,
                  onPressed: () async {
                    Get.back();
                    await controller
                        .addTotalAmount();

                    // controller.showAvailableBalance.value = true;
                    Navigator.pop(context);
                  },
                  textFont: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget addExpenseDialog(context, BudgetController controller) {
    return AlertDialog(
      backgroundColor: const Color(0xfffcfcff),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: 'Add Expense',
                      size: 17,
                      color: const Color(0xff1B1F31),
                      fontWeight: FontWeight.w600),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xff09121F),
                      size: 22,
                    ),
                  )
                ],
              ),
              const Divider(
                color: Color(0xffE0E0E0),
                thickness: 0.5,
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                  text: 'Item name',
                  size: 14,
                  color: const Color(0xff2F2F2F),
                  fontWeight: FontWeight.w400),
              const SizedBox(
                height: 10,
              ),
              getTextField(
                controller: controller.itemNameController,
                borderRadius: 5,
                contentPadding: 10,
              ),
              TextWidget(
                  text: 'Amount',
                  size: 14,
                  color: const Color(0xff2F2F2F),
                  fontWeight: FontWeight.w400),
              const SizedBox(
                height: 10,
              ),
              getTextField(
                  controller: controller.itemPriceController,
                  borderRadius: 5,
                  contentPadding: 10,
                  InputType: TextInputType.number),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                            text: 'Add date',
                            size: 14,
                            color: const Color(0xff2F2F2F),
                            fontWeight: FontWeight.w400),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await controller.createDatePicker(context);
                          },
                          child: getTextField(
                              controller: controller.dateController,
                              borderRadius: 5,
                              isEnabled: false,
                              contentPadding: 10,
                              InputType: TextInputType.number),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                            text: 'Add time',
                            size: 14,
                            color: const Color(0xff2F2F2F),
                            fontWeight: FontWeight.w400),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await controller.createTimePiker(context);
                          },
                          child: getTextField(
                              controller: controller.timeController,
                              borderRadius: 5,
                              isEnabled: false,
                              contentPadding: 10,
                              InputType: TextInputType.number),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: MainButton(
                    height: 60,
                    color: primaryColor,
                    text: "Done",
                    textColor: Colors.white,
                    textSize: 15.55,
                    onPressed: () async {
                      Get.back();
                      await controller.addExpenses().then(
                          (value) async{

                              print("After Add Expenses Call");
                              await controller.updatePbAmount();


                          }
                      );

                    },
                    textFont: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget billSummaryItem({required String item, required String quantity}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextWidget(
              text: item,
              size: 12,
              color: lightGrey,
              fontWeight: FontWeight.w500),
          TextWidget(
              text: quantity,
              size: 12,
              color: lightGrey,
              fontWeight: FontWeight.w500),
        ],
      ),
    );
  }

  // Widget billItem({required String date}) {
  //   return Column(
  //     children: [
  //       Center(
  //           child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 10.0),
  //         child: TextWidget(
  //             text: date,
  //             size: 12,
  //             color: lightGrey,
  //             fontWeight: FontWeight.w500),
  //       )),
  //       billSummaryItem(item: 'Item', quantity: 'Price paid'),
  //       billSummaryItem(item: '1. Breakfast bill', quantity: '\$ 20'),
  //       billSummaryItem(item: '2. Lunch bill', quantity: '\$ 20'),
  //       const Padding(
  //         padding: EdgeInsets.symmetric(
  //           horizontal: 40.0,
  //         ),
  //         child: Divider(
  //           color: Color(0xffE0E0E0),
  //           thickness: 1,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget billItem(
      {required String date, required List<Map<String, dynamic>> expenses}) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextWidget(
              text: date,
              size: 12,
              color: lightGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Now display each expense for this date
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> expense = expenses[index];
            return billSummaryItem(
                item: expense['item'], quantity: expense['itemPrice']);
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Divider(
            color: Color(0xffE0E0E0),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
