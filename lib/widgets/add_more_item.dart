import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/constant.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/controllers/tripController/add_more_item_controller.dart';
import 'package:plan_together/models/trip_item_model.dart';
import 'package:plan_together/models/user_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/widgets/add_new_trip_button.dart';
import 'package:plan_together/widgets/alert_dialog.dart';
import 'package:plan_together/widgets/popups/showChecklistPopup.dart';
import 'package:plan_together/widgets/text_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/global_colors.dart';
import '../utils/images.dart';

//
// class AddmoreItems extends StatefulWidget {
//   final String img, name, role, email, total, docId;
//   final List<String> profileImages;
//
//
//   // final List<String> profile ;
//
//   const AddmoreItems({
//     Key? key,
//     required this.img,
//     required this.name,
//     required this.role,
//     required this.email,
//     required this.total, required this.docId, required this.profileImages,
//   }) : super(key: key);
//
//   @override
//   State<AddmoreItems> createState() => _AddmoreItemsState();
// }
//
//
// class _AddmoreItemsState extends State<AddmoreItems> {
//
//   var controller = Get.put(AddMoreItemController());
//
//   List<TripItemModel> itemsList = [];
//
//   @override
//   initState() {
//     super.initState();
//     getItems();
//   }
//
//   getItems() async {
//     UserModel model = await FirebaseServices.getUserByEmail(widget.email);
//
//     itemsList = await FirebaseServices.getTripItemById(model.id,widget.docId);
//     setState(() {
//
//     });
//   }
//
//
//
//
//   // List to store the added items
//   void addItem(String newItem) async {
//     await FirebaseServices.addItem(
//
//         docId: widget.docId, itemName: newItem, email: widget.email);
//     getItems();
//     setState(() {
//       // itemsList.add(tripItemModel);
//       print("${itemsList} itemsList"); // Add the new item to the list
//     });
//   }
//
//
//   TextEditingController textFieldController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(9),
//             boxShadow: const [defaultShadow]),
//         child: Theme(
//           data: ThemeData().copyWith(dividerColor: Colors.transparent),
//           child: FutureBuilder(
//             future: FirebaseServices.getTripItemByEmail(widget.email,widget.docId),
//             builder: (BuildContext context,
//                 AsyncSnapshot<List<TripItemModel>> snapshot) {
//               if(snapshot.connectionState == ConnectionState.waiting){
//                 return
//                   Shimmer.fromColors( baseColor: Colors.grey.shade300,
//                     highlightColor: Colors.grey.shade100,
//                     enabled: true,
//                 child: Container(
//                     padding: const EdgeInsets.only(left: 12, right: 12),
//                     height: 150,
//                     decoration: BoxDecoration(
//
//                         borderRadius: BorderRadius.circular(5) ,
//                 ),child: ListTile(
//
//                   leading: Container(height: 53,width: 50,color: Colors.grey,),
//                   title: Container(height: 10,width: double.infinity,color: Colors.grey,),
//                   subtitle: Container(padding:const EdgeInsets.symmetric(vertical: 5),height: 10,width: double.infinity,color: Colors.grey,),
//                 ),),);
//
//               }
//               else if(snapshot.hasData) {
//                 List<TripItemModel> tripItems = snapshot.data ?? [];
//                 return ExpansionTile(
//                   onExpansionChanged: (value) {
//                     print(value);
//                   },
//                   title: Row(
//                     children: [
//                       Container(
//                         height: 38,
//                         width: 38,
//                         decoration: const BoxDecoration(shape: BoxShape.circle),
//                         child: ClipOval(
//                           child: widget.img != ''
//                               ? CachedNetworkImage(
//                             imageUrl: widget.img,
//                             placeholder: (context, url) =>
//                                 const CircularProgressIndicator(),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.error),
//                             fit: BoxFit.fill,
//                           )
//                               : Image.asset(profile3),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextWidget(
//                               text: widget.name,
//                               size: 18.53,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w600),
//                           TextWidget(
//                               text: widget.email,
//                               size: 12.85,
//                               color: addMoreItems,
//                               fontWeight: FontWeight.w400),
//                           TextWidget(
//                               text: widget.role,
//                               size: 12.85,
//                               color: addMoreItems,
//                               fontWeight: FontWeight.w400),
//                         ],
//                       )
//                     ],
//                   ),
//                   subtitle: Column(
//                     children: [
//                       Row(children: [
//                         Padding(
//                           padding:
//                           const EdgeInsets.symmetric(vertical: 15.0,
//                               horizontal: 0),
//                           child: FlutterImageStack(
//                             imageSource: ImageSource.network,
//                             imageList: widget.profileImages,
//                             // showTotalCount: true,
//                             totalCount: int.parse(widget.total),
//                             itemRadius: 26.sp,
//                             // Radius of each images
//                             itemCount: int.parse(widget.total),
//                             // Maximum number of images to be shown in stack
//                             itemBorderWidth: 0.05, // Border width around the images
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         TextWidget(
//                             text: "Checklist is shared",
//                             size: 12.85,
//                             color: primaryColor,
//                             fontWeight: FontWeight.w600)
//                       ]),
//                       AddNewTripButton(
//                         text: "Add checklist item(s)",
//                         width: 150,
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return CustomAlertDialog(
//                                 addItem: addItem,
//                                 newItem: textFieldController.text,
//                                 // Pass the addItem function
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   children:tripItems.map((item) {
//                     print(item.toJson());
//                     return Container(
//                       padding: const EdgeInsets.only(left: 12, right: 12),
//                       height: 53,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: item.selected == true
//                             ? const Color.fromRGBO(32, 185, 252, 0.07)
//                             : Colors.white,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextWidget(
//                             text: item.item ?? '', // Use item data here
//                             size: 15,
//                             color: primaryColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           Row(
//                             children: [
//                               Transform.scale(
//                                 scale: 1,
//                                 child: Checkbox(
//                                   activeColor: primaryColor,
//                                   value: item.selected,
//                                   shape: const RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(5.0),
//                                     ),
//                                   ),
//                                   side: MaterialStateBorderSide.resolveWith(
//                                         (Set<MaterialState> states) {
//                                       if (states.contains(MaterialState.selected)) {
//                                         return const BorderSide(
//                                             width: 2, color: Colors.transparent);
//                                       }
//                                       return const BorderSide(
//                                         width: 1,
//                                         color: Colors.black,
//                                       );
//                                     },
//                                   ),
//                                   onChanged: (bool? value) async{
//                                     print("On Changed Value $value ${item.docId}");
//                                     await FirebaseServices.selectItem(tripId: widget.docId,docId: item.docId,value: value);
//                                     setState(() {
//                                       print(item.docId);
//
//                                     });
//                                     print(item.selected);
//                                   },
//                                 ),
//                               ),
//                               const Icon(
//                                 Icons.more_vert_outlined,
//                                 color: Color(0xff666666),
//                                 size: 15,
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     );
//                   }).toList(),
//
//
//                 );
//               }
//               else{
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//
//           ),
//         ));
//   }
//
//
// }

class AddmoreItems extends StatefulWidget {
  final String img, name, role, email, total, docId;
  final List<String> profileImages;

  const AddmoreItems({
    Key? key,
    required this.img,
    required this.name,
    required this.role,
    required this.email,
    required this.total,
    required this.docId,
    required this.profileImages,
  }) : super(key: key);

  @override
  State<AddmoreItems> createState() => _AddmoreItemsState();
}

class _AddmoreItemsState extends State<AddmoreItems> {
  var controller = Get.put(AddMoreItemController());
  List<TripItemModel> itemsList = [];

  @override
  initState() {
    super.initState();
    getItems();
  }

  getItems() async {
    UserModel model = await FirebaseServices.getUserByEmail(widget.email);

    itemsList = await FirebaseServices.getTripItemById(model.id, widget.docId);
    setState(() {});
  }

  void addItem(String newItem) async {
    await FirebaseServices.addItem(
        docId: widget.docId, itemName: newItem, email: widget.email);
    getItems();
    setState(() {});
  }

  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [defaultShadow],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: StreamBuilder(
          stream:
              FirebaseServices.getTripItemByEmail(widget.email, widget.docId),
          builder: (BuildContext context,
              AsyncSnapshot<List<TripItemModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 53,
                      width: 50,
                      color: Colors.grey,
                    ),
                    title: Container(
                      height: 10,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                    subtitle: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      height: 10,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              List<TripItemModel> tripItems = snapshot.data ?? [];
              return ExpansionTile(
                onExpansionChanged: (value) {
                  print(value);
                },
                title: Row(
                  children: [
                    Container(
                      height: 38,
                      width: 38,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: widget.img != ''
                            ? CachedNetworkImage(
                                imageUrl: widget.img,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.fill,
                              )
                            : Image.asset(profile3),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: widget.name,
                          size: 18.53,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        TextWidget(
                          text: widget.email,
                          size: 12.85,
                          color: addMoreItems,
                          fontWeight: FontWeight.w400,
                        ),
                        TextWidget(
                          text: widget.role,
                          size: 12.85,
                          color: addMoreItems,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    )
                  ],
                ),
                subtitle: Column(
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 0),
                        child: FlutterImageStack(
                          imageSource: ImageSource.network,
                          imageList: widget.profileImages,
                          totalCount: int.parse(widget.total),
                          itemRadius: 26.sp,
                          itemCount: int.parse(widget.total),
                          itemBorderWidth: 0.05,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget(
                        text: "Checklist is shared",
                        size: 12.85,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      )
                    ]),
                    AddNewTripButton(
                      text: "Add checklist item(s)",
                      width: 150,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              addItem: addItem,
                              newItem: textFieldController.text,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                children: tripItems
                    .map((item) => ChecklistItemWidget(
                          item: item,
                          tripId: widget.docId,
                        ))
                    .toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class ChecklistItemWidget extends StatefulWidget {
  final TripItemModel item;
  final String tripId;

  const ChecklistItemWidget({
    Key? key,
    required this.item,
    required this.tripId,
  }) : super(key: key);

  @override
  _ChecklistItemWidgetState createState() => _ChecklistItemWidgetState();
}

class _ChecklistItemWidgetState extends State<ChecklistItemWidget> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.item.selected ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      height: 53,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.item.selected!
            ? const Color.fromRGBO(32, 185, 252, 0.07)
            : Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: widget.item.item ?? '',
            size: 15,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
          Row(
            children: [
              Transform.scale(
                scale: 1,
                child: Checkbox(
                  activeColor: primaryColor,
                  value: isChecked,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const BorderSide(
                            width: 2, color: Colors.transparent);
                      }
                      return const BorderSide(
                        width: 1,
                        color: Colors.black,
                      );
                    },
                  ),
                  onChanged: (bool? value) async {
                    setState(() {
                      isChecked = value ?? false; // Update the local state
                    });
                    await FirebaseServices.selectItem(
                        tripId: widget.tripId,
                        docId: widget.item.docId,
                        value: value);
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  showPopupChecklist(context,
                      onEditTap: () {
                    Get.back();
                    showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        newItem: widget.item.item ?? '',
                        addItem: (value) async{

                          await FirebaseServices.editItem(
                            tripId: widget.tripId,
                            docId: widget.item.docId,
                            itemName: value
                          );
                        },
                        title: "Edit Item",
                      ),
                    );
                  },
                  onDeleteTap: () async {
                    Get.back();
                    await FirebaseServices.deleteItem(
                        tripId: widget.tripId,
                        docId: widget.item.docId,
                    );


                  });
                },
                child: const Icon(
                  Icons.more_vert_outlined,
                  color: Color(0xff666666),
                  size: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
