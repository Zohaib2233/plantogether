import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:country_icons/country_icons.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_together/controllers/tripController/currency_controller.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/text_widget.dart';

class CurrencyWidget extends StatelessWidget {
  const CurrencyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CurrencyController());

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: double.maxFinite,
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 4),
                  ]),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                          text: 'Amount',
                          size: 16,
                          color: const Color(0xff989898),
                          fontWeight: FontWeight.w400),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              showCurrencyPicker(
                                context: context,
                                showFlag: true,
                                showCurrencyName: true,
                                showCurrencyCode: true,
                                onSelect: (Currency currency) {

                                  controller.fromCurrency.value = currency.code;
                                  print(currency.code);

                                  Country country = CountryPickerUtils.getCountryByCurrencyCode(currency.code);
                                  controller.flag.value = country.isoCode??'';
                                  print(controller.flag.value);


                                },
                              );
                            },
                            child: Row(
                              children: [
                                Obx(()=>Container(
                                    height: 50,
                                    width: 50,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        ),
                                    child: CountryIcons.getSvgFlag(controller.flag.value),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Obx(
                                    () => TextWidget(
                                      text: controller.fromCurrency.value,
                                      size: 22,
                                      color: const Color(0xff26278D),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Color(0xff3c3c3c),
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller.fromAmountController,
                              decoration: const InputDecoration(
                                  fillColor: Color(0xffEFEFEF),
                                  filled: true,
                                  border: InputBorder.none),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(
                            color: Color(0xffe7e7ee),
                            thickness: 1,
                          )),
                          GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              await controller.convertCurrency();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                  color: primaryColor, shape: BoxShape.circle),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/converter.png',
                                  height: 22,
                                  width: 17,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                              child: Divider(
                            color: Color(0xffe7e7ee),
                            thickness: 1,
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                          text: 'Converted Amount',
                          size: 16,
                          color: const Color(0xff989898),
                          fontWeight: FontWeight.w400),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCurrencyPicker(
                                context: context,
                                showFlag: true,
                                showCurrencyName: true,
                                showCurrencyCode: true,
                                onSelect: (Currency currency) {
                                  // controller.country.value = CountryPickerUtils.getCountryByCurrencyCode(currency.code);

                                  controller.toCurrency.value = currency.code;
                                  Country country = CountryPickerUtils.getCountryByCurrencyCode(currency.code);
                                  controller.convertedFlag.value = country.isoCode??'';
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Obx(()=>Container(
                            height: 50,
                            width: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CountryIcons.getSvgFlag(controller.convertedFlag.value),
                          )),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Obx(
                                    () => TextWidget(
                                      text: controller.toCurrency.value,
                                      size: 22,
                                      color: const Color(0xff26278D),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Color(0xff3c3c3c),
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: TextFormField(
                              readOnly: true,
                              controller: controller.toAmountController,
                              decoration: const InputDecoration(
                                  fillColor: Color(0xffEFEFEF),
                                  filled: true,
                                  border: InputBorder.none),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                  Obx(() => controller.isLoading.value
                      ? Container(
                          height: 350,
                          width: Get.width * 0.92,
                          color: Colors.grey.withOpacity(0.8),
                          child: Center(child: CircularProgressIndicator()))
                      : Container()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
