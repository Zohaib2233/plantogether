import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:plan_together/cards/weather_main.dart';
import 'package:plan_together/controllers/tripController/trip_summary_controller.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/utils.dart';
import 'package:plan_together/widgets/text_widget.dart';

import '../cards/hourly_weather.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {

  List dats = [
    '21/03/2021',
    '22/03/2021',
    '23/03/2021',
    '24/03/2021',
  ];

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TripSummaryController>();
    return Obx(()=>controller.isWeatherLoading.value?Container(
      height: Get.height*0.8,
      width: Get.width,
      child: Center(child: CircularProgressIndicator(),),
    ):Container(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
              child: GetBuilder<TripSummaryController>(
                builder: (TripSummaryController controller) {

                  return  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.dates.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async{
                            await controller.changeDate(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: index == controller.activeDate.value
                                    ? Colors.black
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.only(bottom: 20, right: 10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 12),
                              child: Center(
                                child: TextWidget(
                                    text: controller.dates[index],
                                    size: 13,
                                    color: index == controller.activeDate.value
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        );
                      });
                },

              ),
            ),
            Row(
              children: [
                Obx(
                  () =>controller.weatherList.isNotEmpty?
                  WeatherMain(
                    imageIcon: controller.weatherList[controller.activeDate.value].weather?.first.icon??'02d',
                    time: "3.30PM",
                    date: Utils.formatDateWithMonth(controller.dates[controller.activeDate.value]??''),
                    temp: "${controller.weatherList[controller.activeDate.value].main?.temp??'0'}º C",
                    description: controller.weatherList[controller.activeDate.value].weather?.first.description??'',
                    lastUpdated: "Last updated 3.00 PM",
                    onPressed: () {},
                  ):Container(height: 200,width: 100,),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xffEE3E33),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/sunrise.png',
                              width: 22,
                              height: 17,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            TextWidget(
                                text: 'SUNRISE',
                                size: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Obx(()=>TextWidget(
                                    text: Utils.convertTime(controller.sunriseTime.value),
                                    size: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/sunrise_line.png',
                              height: 32,
                              width: double.infinity,
                            ),
                            const Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(()=> TextWidget(
                              text: 'Sunset: ${Utils.convertTime(controller.sunsetTime.value)}',
                              size: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            TextWidget(
                text: "Hourly Weather",
                size: 20,
                color: blackColor,
                fontWeight: FontWeight.w500),
            const SizedBox(
              height: 16,
            ),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List.generate(
                  controller.weatherList.length,
                  (index) {
                    String? time = controller.weatherList[index].dtTxt?.split(' ')[1];
                    String iconUrl ='https://openweathermap.org/img/wn/${controller.weatherList[index].weather?.first.icon}@2x.png';
                    return HourlyWeather(
                      time: Utils.convertTimeTo12HourFormat(time??''),
                      image: iconUrl,
                      temp: "${controller.weatherList[index].main?.temp}º",
                      onPressed: () {},
                    );
                  }
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
