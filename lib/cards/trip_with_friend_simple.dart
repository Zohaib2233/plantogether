import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';

// ignore: must_be_immutable
class TripsWithFriendsSimple extends StatelessWidget {
  TripsWithFriendsSimple(
      {Key? key,
        this.location,
        required this.totalLength,
        this.timeFrom,
        this.dateFrom,
        this.timeTo,
        this.dateTo,
        this.image,
        this.buttonColor,
        this.buttonText,
        this.tripName,
        this.onPressed, required this.imagesList})
      : super(key: key);

  String? location, image, dateFrom, timeFrom, timeTo, dateTo,buttonText,tripName;
  Color? buttonColor;
  int totalLength;
  VoidCallback? onPressed;
  final List<String> imagesList;
  final List<String> _images = [p1, p2, p3, p4, p1, p2, p3, p4, p1];
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1,color: const Color(0xffDCDCDC)),

              borderRadius: BorderRadius.circular(23.sp)
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 28.sp, top: 27.sp, right: 12.6.sp, bottom: 28.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(
                    tripName??'Trips with friends',
                    style: TextStyle(
                        fontSize: 18.5.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'ProximaNovaSemiBold',
                        color: Colors.black),
                  ),

                  Container(
                    height: 18,
                    width: 60.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: buttonColor
                    ),child: Center(child: Text(
                    buttonText.toString(),style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                  ),),
                  ),
                ],),

                SizedBox(
                  height: 7.5.sp,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 15.sp,
                      color: lightGrey,
                    ),
                    SizedBox(height: 7.4.sp),
                    Text(
                      '$location',
                      style: TextStyle(
                          fontSize: 13.2.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'ProximaNovaMedium',
                          color: Colors.grey),
                    ),

                  ],
                ),
                SizedBox(
                  height: 8.5.sp,
                ),
                FlutterImageStack(
                  imageSource: ImageSource.network,
                  imageList: imagesList,
                  // showTotalCount: true,
                  totalCount: totalLength,
                  itemRadius: 26.sp, // Radius of each images
                  itemCount: totalLength, // Maximum number of images to be shown in stack
                  itemBorderWidth: 0.05, // Border width around the images
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Row(
                  children: [
                    Text(
                      '$dateFrom',
                      style: TextStyle(
                          fontSize: 9.7.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'ProximaNovaMedium',
                          color: darkBlue),
                    ),
                    SizedBox(
                      width: 1.sp,
                    ),
                    Text(
                      '$timeFrom',
                      style: TextStyle(
                          fontSize: 9.7.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'ProximaNovaMedium',
                          color: darkBlue),
                    ),
                    SizedBox(
                      width: 3.sp,
                    ),
                    Image.asset(
                      line,
                      height: 4.5.sp,
                      width: 19.sp,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: 7.sp,
                    ),
                    Text(
                      '$dateTo',
                      style: TextStyle(
                          fontSize: 9.7.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'ProximaNovaMedium',
                          color: darkBlue),
                    ),
                    SizedBox(
                      width: 1.sp,
                    ),
                    Text(
                      '$timeTo',
                      style: TextStyle(
                          fontSize: 9.7.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'ProximaNovaMedium',
                          color: darkBlue),
                    ),
                    SizedBox(
                      width: 3.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
