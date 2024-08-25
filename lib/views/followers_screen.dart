import 'package:flutter/material.dart';
import 'package:plan_together/widgets/follow_unfollow.dart';

import '../utils/images.dart';
import '../widgets/custom_app_bar.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({Key? key}) : super(key: key);

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Followers",
        elevation: 1,
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        onMoreButtonPressed: () {
          // Handle more button press
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                      child: FollowWidget(
                        name: "AzizDjan", image: p1, userName: "A_AzizDjan",),
                    );
                }),
          )
        ],
      ),
    );
  }
}
