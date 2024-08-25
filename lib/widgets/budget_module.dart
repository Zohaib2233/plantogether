import 'package:flutter/material.dart';
import 'package:plan_together/models/trip_model.dart';
import 'package:plan_together/utils/global_colors.dart';
import 'package:plan_together/views/group_budget.dart';
import 'package:plan_together/widgets/text_widget.dart';

import '../views/personal_budget.dart';

class BudgetModule extends StatefulWidget {
  final String tripId;
  final TripModel tripModel;
  const BudgetModule({Key? key, required this.tripId, required this.tripModel}) : super(key: key);

  @override
  State<BudgetModule> createState() => _BudgetModuleState();
}

class _BudgetModuleState extends State<BudgetModule> {



  int _currentIndex = 0;

  void _getCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<String> _tabs = [
    'Personal Budget',
    'Group Budget',
  ];

  @override
  Widget build(BuildContext context) {


    final List<Widget> tabBarView = [
      PersonalBudget(tripId: widget.tripId,),
      GroupBudget(tripModel: widget.tripModel),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xffEDEEEF),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Row(
              children: List.generate(
                _tabs.length,
                (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _getCurrentIndex(index),
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _currentIndex == index
                              ? primaryColor
                              : const Color(0xffEDEEEF),
                        ),
                        child: Center(
                          child: TextWidget(
                            text: _tabs[index],
                            size: 14,
                            fontWeight: FontWeight.w500,
                            color: _currentIndex == index
                                ? Colors.white
                                : Colors.black,
                            textAlign: TextAlign.center
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: tabBarView,
            ),
          ),
        ],
      ),
    );
  }
}
