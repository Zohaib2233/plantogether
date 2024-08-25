import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/utils/images.dart';

class WeatherMain extends StatelessWidget {
  const WeatherMain({
    Key? key,
    this.time,
    this.date,
    this.imageIcon,
    this.temp,
    this.description,
    this.lastUpdated,
    this.onPressed,
  }) : super(key: key);

  final String? imageIcon;
  final String? date;
  final String? time;
  final String? temp;
  final String? description;
  final String? lastUpdated;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xff3B69DE).withOpacity(0.16),
                offset: const Offset(0, 3),
                blurRadius: 33,
              )
            ],
            borderRadius: BorderRadius.circular(12.sp),
            gradient: const LinearGradient(
              colors: [Color(0xFF4F7FFA), Color(0xFF335FD1)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$date',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SFProRegular',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: 'https://openweathermap.org/img/wn/$imageIcon@2x.png',
                      placeholder: (context, url) => Image.asset(
                        cloud1,
                        height: 90.sp,
                        width: 50.sp,
                        fit: BoxFit.cover,
                      ),
                      height: 90.sp,
                      width: 50.sp,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.sp),
                          Text(
                            '$temp',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SFProRegular',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.sp),
                          Text(
                            '$description',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SFProMedium',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ' $lastUpdated',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SFProRegular',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 19.6.sp),
                    Icon(Icons.refresh_sharp, size: 15.sp, color: Colors.white),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
