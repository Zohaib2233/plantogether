
import 'package:flutter/material.dart';
import 'package:plan_together/widgets/text_widget.dart';

import '../constant/constant.dart';
import '../utils/global_colors.dart';

class RecentTrips extends StatelessWidget {
  String img;
  String cityName;
  String location;
   RecentTrips({Key? key,required this.img,required this.cityName,required this.location}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: 163,
          height: 135,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            image:  DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.fill),

          ),
        ),
        Container(
          width: 163,
          decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow:  [
                defaultShadow
              ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: cityName, size: 14, color: blackColor, fontWeight: FontWeight.w700),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children:  [
                    const Icon(
                      Icons.location_on,
                      size: 15,
                      color:subHeading ,
                    ),
                    TextWidget(text: location, size: 10, color: subHeading, fontWeight: FontWeight.w400)
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
