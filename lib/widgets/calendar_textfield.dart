import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/global_colors.dart';

class CalendarTextField extends StatefulWidget {
  String text;
   CalendarTextField({Key? key,required this.text}) : super(key: key);
  @override
  _CalendarTextFieldState createState() => _CalendarTextFieldState();
}

class _CalendarTextFieldState extends State<CalendarTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
      SizedBox(
        height: 43,
        child: TextFormField(
          maxLines: 2,
          textAlign: TextAlign.start,
          controller: _textEditingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 40),
          labelText: widget.text,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize:16,
            color: Color(0xff555555),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFE6E8E7),
            ),
          ), prefixIcon: const Icon(Icons.date_range_outlined,size: 20,color:blackColor,),
          border: OutlineInputBorder(
              borderSide:const BorderSide(color: Color(0XFFE6E8E7)) ,
              borderRadius: BorderRadius.circular(10)
          ),
        ),
          onTap: () {
            _showDatePicker(context);
          },
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _textEditingController.text =
            DateFormat('MM/dd/yyyy').format(_selectedDate!);
      });
    }
  }
}