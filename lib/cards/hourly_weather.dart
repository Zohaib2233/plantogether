import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/utils/images.dart';

// ignore: must_be_immutable
class HourlyWeather extends StatelessWidget {
  HourlyWeather({
    Key? key,
    this.image,
    this.time,
    this.temp,
    this.onPressed,
  }) : super(key: key);

  final String? image;
  final String? time;
  final String? temp;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 3,
        shadowColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.sp),
        ),
        child: Container(
          height: 107.sp,
          width: 78.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.sp),
            color: Colors.lightBlue,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: image ?? '',
                  placeholder: (context, url) => Image.asset(
                    cloud2, // Your placeholder asset image
                    height: 40.sp,
                    width: 40.sp,
                    fit: BoxFit.contain,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 40.sp,
                  width: 40.sp,
                  fit: BoxFit.contain,
                ),
                Text(
                  '$temp°',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'SFProMedium',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$time',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'SFProRegular',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
