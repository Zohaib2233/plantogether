import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:plan_together/core/app_strings.dart';
import 'package:plan_together/utils/images.dart';
import 'package:plan_together/widgets/add_new_trip_button.dart';
import 'package:plan_together/widgets/chat_bot.dart';
import 'package:plan_together/widgets/recent_trips.dart';
import 'package:plan_together/widgets/text_widget.dart';

import '../utils/global_colors.dart';
import 'homeScreen/create_trip2.dart';

class AiBot extends StatefulWidget {
  const AiBot({Key? key}) : super(key: key);

  @override
  State<AiBot> createState() => _AiBotState();
}

class _AiBotState extends State<AiBot> {
  final GlobalKey widgetKey = GlobalKey();
  late final GenerativeModel _model;
  late final GenerativeModel _visionModel;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  bool _loading = false;
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: AppStrings.geminiApiKey,


    );
    _visionModel = GenerativeModel(
      model: 'gemini-pro-vision',
      apiKey: AppStrings.geminiApiKey,
    );
    _chat = _model.startChat();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 26,
              ),
              TextWidget(
                  text: "Chat With AI Bot",
                  size: 19,
                  color: homeBlackColor,
                  fontWeight: FontWeight.w600),
              const SizedBox(
                height: 26,
              ),
              Expanded(
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     // Row(
                //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     //   children: [
                //     //     TextWidget(
                //     //         text: "Recent Trips",
                //     //         size: 19.88,
                //     //         color: homeBlackColor,
                //     //         fontWeight: FontWeight.w600),
                //     //     Padding(
                //     //         padding: const EdgeInsets.only(right: 17),
                //     //         child: AddNewTripButton(
                //     //           text: "Add New Trip",
                //     //           onPressed: () {
                //     //             Get.to(() => const CreateTrip2());
                //     //           },
                //     //         ))
                //     //   ],
                //     // ),
                //     // SizedBox(
                //     //   height: 220.sp,
                //     //   child: ListView.builder(
                //     //     itemCount: 5,
                //     //     shrinkWrap: true,
                //     //     scrollDirection: Axis.horizontal,
                //     //     itemBuilder: (context, index) {
                //     //       return Padding(
                //     //         padding: EdgeInsets.only(right: 10.sp),
                //     //         child: RecentTrips(
                //     //             img: dubai1,
                //     //             cityName: "Milano Park",
                //     //             location: "Sant Paulo, Milan, Italy"),
                //     //       );
                //     //     },
                //     //   ),
                //     // ),
                //     ///
                //
                //     // SingleChildScrollView(
                //     //   scrollDirection: Axis.horizontal,
                //     //   child: Row(
                //     //     children:[
                //     //       RecentTrips(img: dubai1, cityName: "Milano Park", location: "Sant Paulo, Milan, Italy"),
                //     //       SizedBox(width: 10,),
                //     //       RecentTrips(img: dubai1, cityName: "Dubai Gulfark", location: "Dubai Gulf, Gulf, Dubai"),
                //     //       SizedBox(width: 10,),
                //     //       RecentTrips(img: dubai1, cityName: "Milano Park", location: "Sant Paulo, Milan, Italy"),
                //     //  ] ),
                //     // ),
                //     const SizedBox(
                //       height: 26,
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(right: 30),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           TextWidget(
                //               text: "Chat With AI Bot",
                //               size: 19,
                //               color: homeBlackColor,
                //               fontWeight: FontWeight.w600),
                //           const SizedBox(
                //             height: 26,
                //           ),
                //
                //           ///
                //
                //           // const ChatBot(
                //           //   color: Color(0xff9547D2),
                //           //   text:
                //           //       "Explain quantum computing in simple terms",
                //           //   image: Y,
                //           // ),
                //           // // const SizedBox(
                //           // //   height: 30,
                //           // // ),
                //           // GestureDetector(
                //           //   key: widgetKey,
                //           //   onLongPress: () {
                //           //     showPopupMenu(context, widgetKey);
                //           //   },
                //           //   child: const ChatBot(
                //           //       // isSelectableText: true,
                //           //       color: Color(0xff10A37F),
                //           //       text:
                //           //           "Quantum computing is a type of computing where information is processed using quantum-mechanical phenomena, such as superposition and entanglement. In traditional computing, information is processed using bits, which can have a value of",
                //           //       image: "assets/images/chatgpt.png"),
                //           // ),
                //           // const SizedBox(
                //           //   height: 90,
                //           // ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, idx) {
                      final content = _generatedContent[idx];
                      return ChatBot(
                        text: content.text ?? '',
                        isFromUser: content.fromUser,
                      );
                    },
                    itemCount: _generatedContent.length,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 15,
                ),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.13),
                      offset: Offset(0, 3),
                      blurRadius: 18,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Write prompt',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9B9B9B),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'ProximaNovaMedium',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xFFD1D5DB), width: 1.sp),
                      // borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xFFD1D5DB), width: 1.sp),
                      // borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _sendChatMessage(_textController.text);
                      },
                      child: !_loading
                          ? Image.asset(
                              'assets/icons/send.png',
                              height: 17,
                              width: 17,
                              color: const Color(0xffACACBE),
                            )
                          : SizedBox(
                              height: 17,
                              width: 17,
                              child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  void showPopupMenu(BuildContext context, GlobalKey widgetKey) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox box =
        widgetKey.currentContext?.findRenderObject() as RenderBox;
    final Offset targetPosition =
        box.localToGlobal(Offset.zero, ancestor: overlay);

    final popupItems = [
      'Add to trip destination',
      'Copy Text',
      'Select All',
      'Cancel'
    ];

    final selectedValue = await showMenu(
      context: context,
      position:
          RelativeRect.fromLTRB(targetPosition.dx, targetPosition.dy, 0, 0),
      items: popupItems.map((item) {
        return PopupMenuItem<String>(
          value: item,
          onTap: () {},
          child: Text(item),
        );
      }).toList(),
    );

    // Handle the selected value (if needed)
    if (selectedValue != null) {
      if (selectedValue == 'Add to trip destination') {
        Get.to(() => const CreateTrip2());
      }
      print('Selected item: $selectedValue');
    }
  }
}
