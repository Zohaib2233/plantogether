// import 'package:flutter/material.dart';
// import 'package:plan_together/services/firebase_services.dart';
// import 'package:plan_together/utils/images.dart';
// import 'package:plan_together/widgets/add_more_item_controller.dart';
//
//
// class CheckList extends StatefulWidget {
//   const CheckList({Key? key}) : super(key: key);
//
//   @override
//   State<CheckList> createState() => _CheckListState();
// }
//
// class _CheckListState extends State<CheckList> {
//   final List<String> _images = [p1, p2, p3, p4, p1, p2, p3, p4, p1];
//
//   int selectedCheckboxIndex = -1;
//   bool valuefirst = false;
//   bool valuesecond = false;
//   bool valuethird = false;
//   TextEditingController textFieldController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         children: [
//
//           AddmoreItems(
//             img: p2,
//             email: '@gmail.com',
//             name: "Andrew Sams",
//             role: "Admin",
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           // AddmoreItems(
//           //   img: p2,
//           //   name: "Andrew Sams",
//           //   role: "Added: 3 Things",
//           // ),
//           // const SizedBox(
//           //   height: 10,
//           // ),
//           // AddmoreItems(
//           //   img: p3,
//           //   name: "Cameron ash",
//           //   role: "Added: 3 Things",
//           // ),
//           const SizedBox(
//             height: 10,
//           ),
//           const SizedBox(
//             height: 30,
//           )
//         ],
//       ),
//     );
//   }
// }
