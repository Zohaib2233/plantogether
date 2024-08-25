import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/constant/constant.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/widgets/text_widget.dart';

// ignore: must_be_immutable
class ResortCardNew extends StatelessWidget {
  ResortCardNew({
    Key? key,
    this.date,
    this.image,
    this.description,
    this.distance,
    this.title,
    this.onPressed,
    this.icon,
    this.iconButtonColor,
    this.onPressedAdd,
    this.onPressedRemoved,
  }) : super(key: key);

  String? image, date, distance, description, title;
  IconData? icon;
  Color? iconButtonColor;
  VoidCallback? onPressed, onPressedAdd, onPressedRemoved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const [defaultShadow],
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.5.sp),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  '$image',
                  height: 99.sp,
                  width: double.infinity,
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
                                'Distance from Hotel: 6 Km',
                                style: TextStyle(
                                    fontSize: 11.1.sp,
                                    fontWeight: FontWeight.w700,
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
                    SizedBox(
                      height: 8.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 11.sp, bottom: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$description',
                            style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'ProximaNovaRegular',
                                color: greyText),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextWidget(
                              text: "Quick Links",
                              size: 10.66,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          SizedBox(
                            height: 14.sp,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                SizedBox(width: 15,),
                                  InkWell(
                                      onTap: onPressedRemoved,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            pin,
                                            height: 18.96.sp,
                                            width: 18.sp,
                                            fit: BoxFit.contain,
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: redColor2,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Icon(
                                      Icons.share,
                                      color: Color(0xff5F5F5F),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
