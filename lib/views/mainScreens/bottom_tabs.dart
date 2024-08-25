import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/views/add_trips_screen.dart';
import 'package:plan_together/views/ai_bot.dart';
import 'package:plan_together/views/search_inbox.dart';
import 'package:plan_together/views/trips_screen.dart';

import '../homeScreen/home_screen.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key, this.currentIndex=0});
  
  final int currentIndex;

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  late int _currentIndex ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = widget.currentIndex;
    // getAllTripsDates();
  }

  final tabs = [
    const HomeScreen(),
    const AiBot(),
    const AddTripsScreen(),
    const TripsScreen(),
    const SearchInbox()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5.sp),
              child: Image.asset(
                _currentIndex == 0 ? bt1 : bt1,
                color: _currentIndex == 0
                    ? primaryColor
                    : grey,
                height: 24.sp,
                width: 24.sp,
                fit: BoxFit.contain,
              ),
            ),
            label: _currentIndex == 0 ? "." : '',

          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5.sp),
              child: Image.asset(
                _currentIndex == 1 ? bt2 : bt2,
                color: _currentIndex == 1
                    ? primaryColor
                    : grey,
                height: 26.sp,
                width: 28.sp,
                fit: BoxFit.contain,
              ),
            ),
            label: _currentIndex == 1 ? "." : '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5.sp),
              child: Image.asset(
                _currentIndex == 2 ? bt3 : bt3,
                color: _currentIndex == 2
                    ? primaryColor
                    : grey,
                height: 26.2.sp,
                width: 33.sp,
                fit: BoxFit.contain,
              ),
            ),
            label: _currentIndex == 2 ? "." : '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5.sp),
              child: Image.asset(
                _currentIndex == 3 ? bt4 : bt4,
                color: _currentIndex == 3
                    ? primaryColor
                    : grey,
                height: 24.sp,
                width: 23.sp,
                fit: BoxFit.contain,
              ),
            ),
            label: _currentIndex == 3 ? "." : '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5.sp),
              child: Image.asset(
                _currentIndex == 4 ? bt5 : bt5,
                color: _currentIndex == 4
                    ? primaryColor
                    : grey,
                height: 30.sp,
                width: 30.sp,
                fit: BoxFit.contain,
              ),
            ),
            label: _currentIndex == 4 ? "." : '',
          ),
        ],
        selectedLabelStyle: TextStyle(fontSize: 9.6.sp),
        unselectedLabelStyle: TextStyle(fontSize: 9.6.sp),
        selectedItemColor: primaryColor,
        unselectedItemColor: grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
