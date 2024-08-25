import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:plan_together/constant/firebase_consts.dart';
import 'package:plan_together/controllers/tripController/trip_summary_controller.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/widgets/budget_module.dart';
import 'package:plan_together/widgets/curerncy_widget.dart';
import 'package:plan_together/widgets/custom_app_bar.dart';
import 'package:plan_together/widgets/mainButton.dart';
import 'package:plan_together/widgets/trip_summary_qibla_finder.dart';
import 'package:plan_together/widgets/trip_summary_safety.dart';

import '../cards/trips_with_friends.dart';
import '../controllers/tripController/budget_controller.dart';
import '../utils/images.dart';
import '../utils/utils.dart';
import '../widgets/add_more_item.dart';
import '../widgets/weather.dart';

class TripSummery extends StatefulWidget {
  final String docId;
  final String tripName;
  final String startDate;
  final String endDate;
  final int length;
  final TripModel tripModel;

  const TripSummery(
      {Key? key,
      required this.tripName,
      required this.startDate,
      required this.endDate,
      required this.docId, required this.length, required this.tripModel})
      : super(key: key);

  @override
  State<TripSummery> createState() => _TripSummeryState();
}

class _TripSummeryState extends State<TripSummery> {
  @override
  void initState() {
    // TODO: implement initState/**/
    super.initState();
    if (Get.isRegistered<TripSummaryController>()) {
      Get.delete<TripSummaryController>();
      Get.delete<BudgetController>();
    }
  }

  @override
  Widget build(BuildContext context) {


    var controller = Get.put(TripSummaryController(docId: widget.docId));
    print(widget.docId);
    // Get.create(()=>BudgetController(docId));
    print("Trip Summary Build Called");
    return Scaffold(
      appBar: CustomAppBar(
          title: "Trip Summary",
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          onMoreButtonPressed: () {}),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 24, top: 14),
            child: TripsWithFriends(
              profileImages: widget.tripModel.profileUrls??[],
              totalLength: widget.length,
              tripName: widget.tripName,
              location: widget.tripModel.destination?.join(',')??'',
              dateFrom: formatDate(widget.startDate),
              timeFrom: ' ${DateFormat('h:mm a').format(widget.tripModel.tripStartDate!)}',
              dateTo: formatDate(widget.endDate),
              share: info,
              imageHeight: 25,
              imageWidth: 25,
              timeTo: ' ${DateFormat('h:mm a').format(widget.tripModel.tripEndDate!)}',
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          MainButton(
              onPressed: (){
                Get.bottomSheet(
                    Container(
                    height: Get.height*0.9,
                    width: Get.width,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                  child: GoogleMap(

                    initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(controller.createdPlaces[0].latitude as String),double.parse(controller.createdPlaces[0].longitude as String)),
                      zoom: 8
                    ),
                    markers: Set<Marker>.from(controller.createdPlaces.map((place) {
                      return Marker(markerId: MarkerId(place.placeId!),
                      position: LatLng(double.parse(place.latitude as String),double.parse(place.longitude as String)),
                      infoWindow: InfoWindow(title: place.placeName));
                    })),
                    zoomGesturesEnabled: true,
                    compassEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
                persistent: true,
                ignoreSafeArea: false,
                enableDrag: false,
                isScrollControlled: true);
              },
                width: 127,
                height: 26,
                color: primaryColor,
                text: "Show on map",
                textColor: Colors.white,
                textSize: 12.42,
                textFont: FontWeight.w600,
          ),
          const SizedBox(
            height: 14,
          ),
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            indicatorWeight: 2,
            controller: controller.tabController,
            labelColor: const Color(0xff1E232C),
            unselectedLabelColor: const Color(0xff7B7B7B),
            labelStyle: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
            tabs: [
              // Tab(
              //   text: 'Flight Information'),
              const Tab(text: 'Checklist'),
              const Tab(text: 'Weather'),
              const Tab(text: 'Currency'),
              const Tab(text: 'Budget Module'),
              const Tab(text: 'Safety'),
              const Tab(text: 'Qibla'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                Container(
                  height: Get.height * 0.7,
                  child: FutureBuilder(
                      future: FirebaseServices.getTravellersList(widget.docId),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          // var data = snapshot.data;
                          List list = snapshot.data['addTravelers']?.reversed.toList();
                          List userIds = snapshot.data['usersId'].reversed.toList();
                          var namesList = snapshot.data['names']?.reversed.toList();
                          List profileUrlList = snapshot.data['profileUrls']?.reversed.toList();
                          // print(profileUrlList);
                          print(snapshot.data);
                          print(snapshot.data['tripId']);
                          print(FirebaseConsts.auth.currentUser?.email);
                          int userAt = userIds.indexOf(FirebaseConsts.auth.currentUser?.uid);
                          if(snapshot.data['tripId']==FirebaseConsts.auth.currentUser?.uid){
                            print("Found = snapshot.data['tripId']==FirebaseConsts.user?.uid");
                            return ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),
                                    child: AddmoreItems(
                                      profileImages: profileUrlList.map((e) => e.toString()).toList(),
                                      docId: widget.docId,
                                      total: list.length.toString(),
                                      img: profileUrlList[index],
                                      name: namesList[index]??'',
                                      email: list[index],
                                      role: userIds[index] ==
                                          snapshot.data['tripId']
                                          ? "Admin"
                                          : '',),
                                  );
                                }
                            );
                          }
                          else{
                            return ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index) {

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),
                                    child: AddmoreItems(
                                      profileImages: profileUrlList.map((e) => e.toString()).toList(),
                                      docId: widget.docId,
                                      total: list.length.toString(),
                                      img: profileUrlList[userAt],
                                      name: namesList[userAt]??'',
                                      email: list[userAt],
                                      role: userIds[userAt] ==
                                          snapshot.data['tripId']
                                          ? "Admin"
                                          : '',),
                                  );
                                }
                            );
                          }



                        }
                      })),
                ),
                const SingleChildScrollView(
                    physics: BouncingScrollPhysics(), child: WeatherWidget()),
                const CurrencyWidget(),
                BudgetModule(tripModel: widget.tripModel, tripId: widget.docId,),
              TripSummarySafety(tripModel: widget.tripModel),
                const QiblaFinder(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
