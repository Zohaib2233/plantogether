import 'package:flutter/material.dart';
import 'package:plan_together/utils/images.dart';

class ProfileWidget extends StatelessWidget {
  final Function()? profileBtn;
  final Function()? bgBtn;
  final ImageProvider bgImageProvider;
  final ImageProvider profileImageProvider;
  final bool currentUser;

  const ProfileWidget(
      {Key? key,
      this.profileBtn,
      this.bgBtn,
      required this.bgImageProvider,
      required this.profileImageProvider,
      required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 137,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: bgImageProvider, fit: BoxFit.cover)),
              ),
              currentUser?
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE1E1E1),
                  ),
                  child: GestureDetector(
                    onTap: bgBtn,
                    child: Center(
                        child: Image.asset(
                      choseNewImage,
                      width: 20,
                      height: 20,
                    )),
                  ),
                ),
              ):Container(),

              Positioned(
                top: 90,
                left: 14,
                child: Stack(clipBehavior: Clip.none, children: [
                  InkWell(
                    onTap: profileBtn,
                    child: Container(
                      height: 99,
                      width: 99,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill, image: profileImageProvider),
                        shape: BoxShape.circle,
                        color: const Color(0xffE1E1E1),
                      ),
                    ),
                  ),
                  currentUser?
                  Positioned(
                    right: -10,
                    bottom: 10,
                    child: GestureDetector(
                      onTap: () {
                        print("clicked");
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0XFFE1E1E1)),
                        child: Center(
                          child: Image.asset(choseNewImage),
                        ),
                      ),
                    ),
                  ):Container(),
                ]),
              )
            ],
          ),
        ]);
  }
}
