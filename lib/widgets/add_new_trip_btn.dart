import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/utils/global_colors.dart';

class AddNewTrip extends StatelessWidget {
  const AddNewTrip({Key? key,
  required this.onTap
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 31.sp,
        width: 114.sp,
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(23.1.sp)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add New Trip',
              style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'ProximaNovaRegular',
                  color: Colors.white),
            ),
            SizedBox(
              width: 3.sp,
            ),
            Icon(
              Icons.add,
              size: 12.sp,
              color: white,
            )
          ],
        ),
      ),
    );
  }
}
