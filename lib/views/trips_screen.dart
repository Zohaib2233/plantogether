import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plan_together/bindings/bindings.dart';
import 'package:plan_together/cards/trips_with_friends.dart';
import 'package:plan_together/constant/instances_contant.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/views/rating_for_trip.dart';
import 'package:plan_together/views/trip_summery.dart';
import 'package:plan_together/widgets/welcome_widget.dart';

import '../constant/firebase_consts.dart';
import '../models/trip_model.dart';
import '../services/firebase_services.dart';
import '../utils/utils.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});



  @override
  Widget build(BuildContext context) {
    print("TripsScreen Build Called");

    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(left: 17.sp, right: 17.sp, top: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.sp),
              welcomeWidget(
                  headingText: "Get inspired",
                  subheading:
                      "Add attractions to your trip, see how far they are to your hotel and more!"),
              Text(
                'Recent Saved Trips',
                style: TextStyle(
                    fontSize: 19.8.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProximaNovaSemiBold',
                    color: Colors.black),
              ),
              SizedBox(
                height: 10.sp,
              ),
              StreamBuilder(
                  stream: FirebaseServices.getTrips(
                      FirebaseConsts.auth.currentUser?.email),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TripModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text("No Trips Created Yet"));
                    } else {
                      if (snapshot.data!.isNotEmpty) {
                        return SizedBox(
                          height: 0.64.sh,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var tripModel = snapshot.data?[index];
                              var docId = snapshot.data?[index].docId;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.sp),
                                child: TripsWithFriends(
                                  profileImages: tripModel?.profileUrls??[],
                                  totalLength: tripModel!.names!.length,
                                  tripName: tripModel.tripName,
                                  location: tripModel.destination?.join(',')??'',
                                  dateFrom: formatDate(tripModel.startDate ?? ""),
                                  timeFrom: DateFormat('h:mm a').format(tripModel.tripStartDate!),
                                  dateTo: formatDate(tripModel.endDate ?? ""),
                                  timeTo: DateFormat('h:mm a').format(tripModel.tripEndDate!),
                                  share: info,
                                  imageWidth: 25,
                                  imageHeight: 25,
                                  onPressed: ()
                                    {
                                      print(tripModel.tripStartDate);
                                      print(tripModel.tripEndDate);
                                      bool? tripClosed = tripModel.tripEndDate?.isBefore(DateTime.now())??false;

                                      if(tripClosed && !tripModel.postsBy!.contains(userModelGlobal.value.id)){
                                        Get.to(()=>TripRatingScreen(
                                          tripModel: tripModel
                                        ),binding: CreatePostBinding());
                                      }
                                      else{
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TripSummery(
                                                tripModel: tripModel,
                                                docId: docId!,
                                                tripName: tripModel.tripName ?? '',
                                                startDate: tripModel.startDate ?? '',
                                                endDate: tripModel.endDate ?? '',
                                                length: tripModel.names!.length,
                                              ),
                                            ));
                                      }

                                    }

                                ),
                              );
                            },
                          ),
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
      )),
    );
  }
}
