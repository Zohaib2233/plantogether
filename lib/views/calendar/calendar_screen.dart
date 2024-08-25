import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/common/variables.dart';
import 'package:plan_together/constant/instances_contant.dart';

import '../../cards/trips_with_friends.dart';
import '../../models/trip_model.dart';
import '../../services/firebase_services.dart';
import '../../utils/global_colors.dart';
import '../../utils/images.dart';
import '../trip_summery.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    // allTripsDateList.first??
        DateTime.now(),
  ];

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Trips"),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor.withOpacity(0.1)),
                    child: _buildDefaultSingleDatePickerWithValue()),
                const SizedBox(
                  height: 20,
                ),

                const Divider(
                  color: kGreyColor,
                  height: 0,
                ),
                const SizedBox(
                  height: 20,
                ),

                FutureBuilder(
                    future: FirebaseServices.getTripsByDate(
                        date: _singleDatePickerValueWithDefaultValue.first
                            as DateTime,
                        currentUser: userModelGlobal.value.id ?? ''),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TripModel>> snapshot) {
                      // print(snapshot.hasData);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                            child: Text("No Completed Trips"));
                      } else {
                        if (snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              String? docId = snapshot.data![index].docId;

                              int totalLength =
                                  (snapshot.data![index].names!.length);
                              var trip = snapshot.data![index];
                              return Padding(
                                  padding: EdgeInsets.only(bottom: 12.sp),
                                  child: TripsWithFriends(
                                    profileImages: trip.profileUrls ?? [],
                                    totalLength: totalLength,
                                    tripName: trip.tripName,
                                    location: trip.destination?.join(',') ?? '',
                                    dateFrom: trip.startDate,
                                    timeFrom: ' 5:30 PM',
                                    dateTo: trip.endDate,
                                    timeTo: ' 5:30 PM',
                                    // buttonColor: primaryColor,
                                    // buttonText: "Simple",
                                    share: info,
                                    imageHeight: 25,
                                    imageWidth: 25,
                                    onPressed: () =>    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TripSummery(
                                            tripModel: trip,
                                            docId: docId!,
                                            tripName: trip.tripName ?? '',
                                            startDate: trip.startDate ?? '',
                                            endDate: trip.endDate ?? '',
                                            length: trip.names!.length,
                                          ),
                                        ))
                                  ));
                            },
                          );
                        } else {
                          return const Center(
                              child: Text("No Completed Trips"));
                        }
                      }
                    }),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultSingleDatePickerWithValue() {
    List<DateTime> highlightedDates = [
      DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).add(Duration(days: 1)),
      DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).add(Duration(days: 4)),
      DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).add(Duration(days: 5)),
      DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).add(Duration(days: 6)),

      // DateTime.now().add(Duration(days: 1)), // Example: Highlight tomorrow
      // DateTime.now().add(Duration(days: 3)), // Example: Highlight 3 days from now
      // DateTime.now().add(Duration(days: 5)), // Example: Highlight 3 days from now
    ];

    final config =
    CalendarDatePicker2Config(

      selectedDayHighlightColor: Colors.amber[900],

      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,



      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
        fontSize: 22
      ),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),

      selectableDayPredicate: (day){

        // print(highlightedDates[0]);

        DateTime formattedDay = DateTime(day.year, day.month, day.day);
        // print(formattedDay);
        return allTripsDateList.contains(formattedDay);
        // return true;

      }

      // selectableDayPredicate: (day) => !day
      //     .difference(DateTime.now().subtract(const Duration(days: 3)))
      //     .isNegative,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        CalendarDatePicker2(
            config: config,


            value: _singleDatePickerValueWithDefaultValue,
            onValueChanged: (dates) {
              print(dates.first);
              setState(() => _singleDatePickerValueWithDefaultValue = dates);
              print(_singleDatePickerValueWithDefaultValue);
            }),
        // const SizedBox(height: 10),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     const Text('Selection(s):  '),
        //     const SizedBox(width: 10),
        //     Text(
        //       _getValueText(
        //         config.calendarType,
        //         _singleDatePickerValueWithDefaultValue,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
