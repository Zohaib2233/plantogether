import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plan_together/cards/trips_with_friends.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/controllers/tripController/add_trips_screen_controller.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/views/calendar/calendar_screen.dart';
import 'package:plan_together/views/simple_trip_screen.dart';
import 'package:plan_together/widgets/add_new_trip_button.dart';
import 'package:plan_together/widgets/welcome_widget.dart';

import '../common/functions.dart';
import 'homeScreen/create_trip2.dart';

class AddTripsScreen extends StatelessWidget {
  const AddTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AddTripScreenController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 17.sp, right: 17.sp, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.sp),
                welcomeWidget(
                    headingText: "Created Trips",
                    subheading:
                        "Add attractions to your trip, see how far they are to your hotel and more!"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddNewTripButton(
                        text: "View Trips",
                        onPressed: () {
                          getAllTripsDates(userId: FirebaseConsts.auth.currentUser!.uid);
                          Get.to(() => const CalendarScreen());
                        }),
                    AddNewTripButton(
                        text: "Add New Trip  +",
                        onPressed: () {
                          Get.to(() => const CreateTrip2());
                        })
                  ],
                ),
                SizedBox(
                  height: 20.sp,
                ),
                StreamBuilder(
                  stream: FirebaseServices.getTrips(
                      FirebaseConsts.auth.currentUser?.email),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TripModel>> snapshot) {
                    // print(snapshot.hasData);
                    if (!snapshot.hasData) {
                      return const Center(
                          child: Text("No Trips Created Yet"));
                    } else {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
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
                                  profileImages: trip.profileUrls??[],
                                  totalLength: totalLength,
                                  tripName: trip.tripName,
                                  location: trip.destination?.join(',')??'',
                                  dateFrom: controller
                                      .formatDate(trip.startDate as String),
                                  timeFrom: ' ${DateFormat('h:mm a').format(trip.tripStartDate!)}',
                                  dateTo:
                                  controller.formatDate(trip.endDate as String),
                                  timeTo: ' ${DateFormat('h:mm a').format(trip.tripEndDate!)}',
                                  // buttonColor: primaryColor,
                                  // buttonText: "Simple",
                                  share: info,
                                  imageHeight: 25,
                                  imageWidth: 25,
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SimpleTrip(
                                          tripModel: trip,
                                          totalLength: totalLength,
                                          tripName: trip.tripName??'',
                                          docId: docId??'',
                                          startDate:
                                          controller.formatDate(
                                              trip.startDate??''),
                                          endDate: controller.formatDate(
                                            trip.endDate??'',
                                          ),
                                        )),
                                  ),
                                ));
                          },
                        );
                      } else {
                        return const Center(
                            child: Text("No Trips Created Yet"));
                      }
                    }
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
