import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/lists.dart';
import 'get_textfield.dart';

class CustomCurrencyPicker extends StatefulWidget {
  const CustomCurrencyPicker({super.key, required this.onCurrencySelected,});
  final Function(String) onCurrencySelected;

  // final Function(String name)? onSelect;


  @override
  State<CustomCurrencyPicker> createState() => _CustomCurrencyPickerState();
}

class _CustomCurrencyPickerState extends State<CustomCurrencyPicker> {

  TextEditingController searchController = TextEditingController();
  Map<String,String> filteredCurrencies = {};

  @override
  void initState() {
    super.initState();
    filteredCurrencies = currenciesList;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(

      height: Get.height*0.9,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          )),
      child: Column(
        children: [
          getTextField(
            controller: searchController,
            image: Icons.search,

            hint: "Search Currency",
            onChanged: _onSearchTextChanged,

          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCurrencies.length,
              itemBuilder: (context, index) {

                final currency = filteredCurrencies.keys.elementAt(index);
                final currencySymbol = filteredCurrencies[currency];
                return GestureDetector(
                  onTap: (){
                    final currency = filteredCurrencies.keys.elementAt(index);

                    widget.onCurrencySelected(currency);




                    Get.back();

                  },
                  child: ListTile(
                    title: Text("$currency - $currencySymbol"
                    ),
                  ),
                );},),
          )
        ],
      ),
    );

  }

  void _onSearchTextChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCurrencies = currenciesList;
      } else {
        filteredCurrencies={};
        currenciesList.forEach((currency, symbol) {
          if (currency.toLowerCase().contains(query.toLowerCase())) {
            filteredCurrencies[currency] = symbol;
            print(filteredCurrencies);
          }
        });
      }
    });
  }


}
