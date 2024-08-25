import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/models/CurrencyExchangeModel.dart';
import 'package:plan_together/repo/currency_repo.dart';

class CurrencyController extends GetxController{

  RxBool isLoading = false.obs;

  RxString fromCurrency = 'USD'.obs;
  RxString toCurrency = 'SGD'.obs;
  RxString amount = '0'.obs;
  RxString convertedAmount ='0'.obs;
  RxString flag = 'US'.obs;
  RxString convertedFlag = 'SG'.obs;
  Rx<Country> country = Country().obs;
  TextEditingController fromAmountController = TextEditingController();
  TextEditingController toAmountController = TextEditingController();

  @override
  onInit()  {
    super.onInit();
    print("----------------------Currency Controller Called");
    print("-------${userModelGlobal.value.localCurrency}-----");
    Country country = CountryPickerUtils.getCountryByCurrencyCode(userModelGlobal.value.localCurrency!);
    flag.value = country.isoCode??'';
    print("-------${country.isoCode}-----");
    fromCurrency.value = userModelGlobal.value.localCurrency??'USD';


  }


  convertCurrency() async {
    if(fromAmountController.text.isNotEmpty){
      isLoading(true);
      try{
        CurrencyExchangeModel currencyExchangeModel = await CurrencyExchangeRepo.exchangeCurrency(from: fromCurrency.value, to: toCurrency.value, amount: fromAmountController.text);
        toAmountController.text = currencyExchangeModel.result.toString();
        isLoading(false);
      }
      catch(e){
        isLoading(false);
        throw Exception(e);
      }

    }


  }

}