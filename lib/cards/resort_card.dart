import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/utils/global_colors.dart';

// ignore: must_be_immutable
class ResortCard extends StatelessWidget {
  ResortCard(
      {Key? key,
      this.date,
      this.image,
      this.description,
      this.distance,
      this.title,
      this.onPressed,
      this.onPressedAdd,
      this.onPressedRemoved,
      })
      : super(key: key);

  String? image, date, distance, description, title;
  VoidCallback? onPressed, onPressedAdd, onPressedRemoved;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 244.sp,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 6.sp,),
                InkWell(
                  onTap: onPressedAdd,
                  child: Container(
                    height: 31.sp,
                    width: 31.sp,
                    decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 18.sp,),
                  ),
                ),
                SizedBox(height: 6.sp,),
                InkWell(
                  onTap: onPressedRemoved,
                  child: Container(
                    height: 31.sp,
                    width: 31.sp,
                    decoration: BoxDecoration(
                      color: pink,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(Icons.remove, color: Colors.white, size: 18.sp,),
                  ),
                ),
              ],
            ),
            SizedBox(width: 7.sp,),
            InkWell(
                onTap: onPressed,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.5.sp),
                  ),
                  child: Container(
                    height: 224.sp,
                    width: 300.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.5.sp),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          '$image',
                          height: 99.sp,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 12.5.sp,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 11.sp, right: 9.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$title',
                                        style: TextStyle(
                                            fontSize: 14.6.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'ProximaNovaSemiBold',
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 4.sp,
                                      ),
                                      Text(
                                        'Distance from Hotel: $distance',
                                        style: TextStyle(
                                            fontSize: 9.1.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'ProximaNovaMedium',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Date: $date',
                                        style: TextStyle(
                                            fontSize: 10.3.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'ProximaNovaMedium',
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'change Date',
                                        style: TextStyle(
                                            fontSize: 8.3.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'ProximaNovaRegular',
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.sp,),
                            Padding(
                              padding: EdgeInsets.only(left: 11.sp),
                              child: Text(
                                '$description',
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'ProximaNovaRegular',
                                    color: greyText),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
