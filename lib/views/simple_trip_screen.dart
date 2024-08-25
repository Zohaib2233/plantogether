import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:plan_together/cards/hotel_card.dart';
import 'package:plan_together/cards/resort_card_new.dart';
import 'package:plan_together/cards/trip_with_friend_simple.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/services/firebase_services.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/widgets/add_new_trip_button.dart';
import 'package:plan_together/widgets/custom_snackbar.dart';

class SimpleTrip extends StatefulWidget {

  final String startDate;
  final TripModel tripModel;
  final String endDate;
  final String tripName;
  final String docId;
  final int totalLength;
  const SimpleTrip({super.key,required this.startDate, required this.endDate, this.docId='', required this.tripName,required this.totalLength, required this.tripModel});

  @override
  State<SimpleTrip> createState() => _SimpleTripState();
}

class _SimpleTripState extends State<SimpleTrip> {
List<String> text=[
  "All",
  "Hotel",
  "Restaurant",
  "Attraction",
  "Waterpark"
];
int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(left: 17.sp, right: 17.sp,top: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: blackColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Build your trip',
                          style: TextStyle(
                              fontSize: 21.8.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'ProximaNovaMedium',
                              color: primaryColor),
                        ),
                        SizedBox(
                          height: 5.3.sp,
                        ),
                        Text(
                          'Start explore, share ideas with friends and family. Build unique trip together',
                          style: TextStyle(
                              fontSize: 10.7.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'ProximaNovaRegular',
                              color: grey),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Image.asset(
                          shopbg,
                          height: 39.sp,
                          width: 39.sp,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 13.3.sp,
                        ),
                        CircleAvatar(
                          backgroundColor: grey,
                          maxRadius: 19.5.sp,
                          backgroundImage: const AssetImage(profile2),
                        )
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 20.sp,
              ),
              TripsWithFriendsSimple(
                imagesList: widget.tripModel.profileUrls??[],
                totalLength: widget.totalLength,
                tripName: widget.tripName,
                location: widget.tripModel.destination?.join(',')??'',
                dateFrom: widget.startDate,
                timeFrom: ' ${DateFormat('h:mm a').format(widget.tripModel.tripStartDate!)}',
                dateTo: widget.endDate,
                timeTo: ' ${DateFormat('h:mm a').format(widget.tripModel.tripEndDate!)}',
                // buttonText: "Simple",
                // buttonColor: primaryColor,
              ),
              SizedBox(
                height: 20.sp,
              ),
              Text(
                '1 day to Kickstarting your Trips',
                style: TextStyle(
                    fontSize: 19.8.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProximaNovaSemiBold',
                    color: Colors.black),
              ),
              SizedBox(
                height: 20.sp,
              ),
              SizedBox(
                height: 30.sp,
                child: ListView.builder(
                  itemCount: text.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                              // width: 127.sp,
                              height: 24.sp,
                              decoration: BoxDecoration(
                                  color: selectedIndex == index ? primaryColor : white,
                                  border: Border.all(color: primaryColor),
                                  borderRadius: BorderRadius.circular(43.sp)),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 25.sp, right: 25.sp),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      text[index],
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'MontserratMedium',
                                        color: selectedIndex == index ? Colors.white : primaryColor,),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20.sp,
              ),
              Text(
                'First Hotel Stay',
                style: TextStyle(
                    fontSize: 17.8.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProximaNovaSemiBold',
                    color: primaryColor),
              ),
              SizedBox(
                height: 1.sp,
              ),
              SizedBox(
                  width: 120.sp,
                  child: const Divider(
                      color: primaryColor, thickness: 1.5)),
              SizedBox(
                height: 13.sp,
              ),
              HotelCard(
                date: '23/09/2023',
                image: hotel,
                title: 'Hotel Flower',
              ),
              SizedBox(
                height: 16.sp,
              ),
              Text(
                'Day 1',
                style: TextStyle(
                    fontSize: 19.8.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProximaNovaSemiBold',
                    color: Colors.black),
              ),
              SizedBox(
                height: 10.sp,
              ),
              ResortCardNew(
                image: dubai1,
                title: 'Legoland Dubai Resort',
                date: '23/09/2023',
                distance: '46km',
                icon: Icons.remove,
                iconButtonColor: Colors.red,
                description:
                    'Quantum computing is a type of computing where information is processed using quantum-mechanical phenomena, such as superposition and entanglement. In traditional computing, information is processed using bits, which can have a value of ',
              ),
              SizedBox(
                height: 20.sp,
              ),
              Text(
                'Second Hotel Stay',
                style: TextStyle(
                    fontSize: 17.8.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProximaNovaSemiBold',
                    color: primaryColor),
              ),
              SizedBox(
                height: 1.sp,
              ),
              SizedBox(
                  width: 147.sp,
                  child: const Divider(
                      color: primaryColor, thickness: 1.5)),
              SizedBox(
                height: 23.sp,
              ),
              HotelCard(
                date: '23/09/2023',
                image: hotel,
                title: 'Hotel Flower',
              ),
              SizedBox(
                height: 16.sp,
              ),
              Text(
                'Day 2',
                style: TextStyle(
                    fontSize: 19.8.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProximaNovaSemiBold',
                    color: Colors.black),
              ),
              SizedBox(
                height: 10.sp,
              ),
              ResortCardNew(
                image: dubai2,
                title: 'Legoland Dubai Resort',
                date: '23/09/2023',
                distance: '46km',
                icon: Icons.remove,
                iconButtonColor: Colors.red,
                description:
                    'Quantum computing is a type of computing where information is processed using quantum-mechanical phenomena, such as superposition and entanglement. In traditional computing, information is processed using bits, which can have a value of ',
              ),
              SizedBox(
                height: 20.sp,
              ),
              Text(
                'Day 3',
                style: TextStyle(
                    fontSize: 19.8.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProximaNovaSemiBold',
                    color: Colors.black),
              ),
              SizedBox(
                height: 10.sp,
              ),
              ResortCardNew(
                image: dubai2,
                title: 'Legoland Dubai Resort',
                date: '23/09/2023',
                distance: '46km',
                icon: Icons.remove,
                iconButtonColor: Colors.red,
                description:
                    'Quantum computing is a type of computing where information is processed using quantum-mechanical phenomena, such as superposition and entanglement. In traditional computing, information is processed using bits, which can have a value of ',
              ),
              SizedBox(
                height: 5.sp,
              ),
              Center(
                  child: AddNewTripButton(
                text: "Add Another Day",
                width: 132,
                    onPressed: () async{
                  await FirebaseServices.addDay(widget.docId,2).then((value) => customSnackBar(
                    message: "Day added",color: green
                  ));
                    },
              )),
              const SizedBox(
                height: 64,
              )
              // WeatherMain(
              //   date: 'Monday, December 20, 2021',
              //   time: '3.30PM',
              //   image: cloud1,
              //   temp: '18',
              //   description: 'Cloudy Rain',
              //   lastUpdated: '3.00 PM',
              // ),
              // SizedBox(
              //   height: 24.sp,
              // ),
              // Text(
              //   'Hourly Weather',
              //   style: TextStyle(
              //       fontSize: 20.sp,
              //       fontWeight: FontWeight.w500,
              //       fontFamily: 'SFProMedium',
              //       color: Colors.black),
              // ),
              // SizedBox(
              //   height: 16.sp,
              // ),
              // SizedBox(
              //   height: 110.sp,
              //   child: ListView.builder(
              //     itemCount: 6,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       return HourlyWeather(
              //           image: cloud3, temp: '20', time: '4.00PM');
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      )),
      // bottomNavigationBar: Padding(
      //   padding:EdgeInsets.only(top: 10,left: 30,bottom: 15,right: 30),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       bottomContainer(image: checklist, color: green),
      //       bottomContainer(image: share2, color: green),
      //       bottomContainer(image: delete, color: Color(0xffFF3333)),
      //       MainButton(
      //           width: 158,
      //           height: 56,
      //           color: primaryColor,
      //           text: "Save",
      //           textColor: Colors.white,
      //           textSize: 16,
      //           textFont: FontWeight.w700),
      //     ],
      //   ),
      // ),
    );
  }
}

Widget bottomContainer({
  required String image,
  required Color color,
}) {
  return Container(
    height: 36,
    width: 36,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    child: Center(
      child: Image.asset(image),
    ),
  );
}
