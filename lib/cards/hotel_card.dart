
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/constant/constant.dart';

// ignore: must_be_immutable
class HotelCard extends StatelessWidget {
  HotelCard({
    Key? key,
    this.date,
    this.image,
    this.title,
    this.onPressed,
  }) : super(key: key);

  String? image, date, distance, description, title;
  VoidCallback? onPressed, onPressedAdd, onPressedRemoved;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 114.sp,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(21.sp),
      color: Colors.white,
      boxShadow: const [defaultShadow]),
      child: Row(
        children: [
          Image.asset(
            '$image',
            height: 114.sp,
            width: 148.sp,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 15.sp,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.6.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProximaNovaSemiBold'),
              ),
              SizedBox(
                height: 8.sp,
              ),
              Text(
                'Date: $date',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10.3.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ProximaNovaSemiBold'),
              )
            ],
          )
        ],
      ),
    );
  }
}
