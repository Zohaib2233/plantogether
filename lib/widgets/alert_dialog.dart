// alert_dialog.dart
import 'package:flutter/material.dart';

import '../utils/global_colors.dart';
import '../utils/images.dart';
import 'get_textfield.dart';
import 'mainButton.dart';

class CustomAlertDialog extends StatefulWidget {
  final String newItem;
  final String? title;
  final Function(String) addItem;

  const CustomAlertDialog({super.key, 
    required this.newItem,
    required this.addItem, this.title="Add New Item",
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  TextEditingController textFieldController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFieldController.text = widget.newItem;
  }


  @override
  Widget build(BuildContext context) {



    return AlertDialog(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title!,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff1B1F31),
                  fontWeight: FontWeight.w700,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child:
                Image.asset(cancel),
              ),
            ],
          ),
          const Divider(
            thickness: 0.6,
          ),
        ],
      ),
      content: SizedBox(
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Item Name",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff2F2F2F),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            getTextField(
                height: 39,
                borderRadius: 0,

                controller: textFieldController,
                contentPadding: 20)
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: MainButton(
              height: 50,
              color: primaryColor,
              text: "Add",
              textColor: Colors.white,
              textSize: 15,
              onPressed: () {
                String newItem = textFieldController.text;
                widget.addItem(newItem);
                Navigator.of(context).pop();
                print(newItem);
              },
              textFont: FontWeight.w700),
        ),
      ],
    );
  }
}
