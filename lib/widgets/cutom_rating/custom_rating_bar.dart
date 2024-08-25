import 'package:flutter/material.dart';

class CustomRatingStar extends StatelessWidget {
  final int? rating;
  final Color? starColor;
  final double size;
  final MainAxisAlignment mainAxisAlignment;
  final Function(int value) onTap;

  CustomRatingStar({
    Key? key,
    this.rating,
    this.starColor,
    this.size = 30.0,
    this.mainAxisAlignment = MainAxisAlignment.start,required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (index) => GestureDetector(
          onTap: (){
            onTap(index+1);
          },
          child: Icon(
            index < rating! ? Icons.star : Icons.star_border,
            color: starColor ?? Theme.of(context).primaryColor,
            size: size,
          ),
        ),
      ),
    );
  }
}