import 'dart:async';
import 'dart:ui';

import 'package:ashtothram/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullscreen/fullscreen.dart';

import '../datas/datas.dart';

class AshtothramPage extends StatefulWidget {
  String id;
  bool isParayanam;
  Ashtothram manthra;

  AshtothramPage(
      {Key? key,
      required this.id,
      required this.isParayanam,
      required this.manthra})
      : super(key: key);

  @override
  State<AshtothramPage> createState() => _AshtothramPageState();
}

class _AshtothramPageState extends State<AshtothramPage> {
  ScrollController _scrollController = ScrollController();
  bool scroll = false;
  double speedFactor = 50;

  _scroll() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;

    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: durationDouble.toInt()),
        curve: Curves.linear);
  }

  _toggleScrolling() {
    setState(() {
      scroll = !scroll;
    });

    if (scroll) {
      _scroll();
    } else {
      _scrollController.animateTo(_scrollController.offset,
          duration: const Duration(seconds: 1), curve: Curves.linear);
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.top]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    super.dispose();
  }

  bool isZoomed = false;
  TransformationController transformationController =
      TransformationController();
  double minScaleValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        bool portrait = orientation == Orientation.portrait;
        return Stack(
          children: [
            NotificationListener(
              onNotification: (notif) {
                if (notif is ScrollEndNotification && scroll) {
                  Timer(const Duration(seconds: 1), () {
                    _scroll();
                  });
                }
                return true;
              },
              child: InteractiveViewer(
                minScale: minScaleValue,
                // maxScale: 2.0,
                transformationController: transformationController,
                onInteractionEnd: (ScaleEndDetails endDetails) {
                  double correctScaleValue =
                      transformationController.value.getMaxScaleOnAxis();
                  if (correctScaleValue > minScaleValue) {
                    setState(() {
                      isZoomed = true;
                    });
                  } else {
                    setState(() {
                      isZoomed = false;
                    });
                  }
                },
                onInteractionUpdate: (x) {
                  double correctScaleValue =
                      transformationController.value.getMaxScaleOnAxis();
                  if (correctScaleValue > minScaleValue) ;
                  setState(() {
                    isZoomed = true;
                  });
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    physics: isZoomed
                        ? const NeverScrollableScrollPhysics()
                        : const ScrollPhysics(),
                    controller: _scrollController,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: portrait ? 22 : 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          vSpace(75),
                          GradientText(widget.manthra.title,
                              style: const TextStyle(
                                  color: Color(0xFF3F5EFB),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'TiroTamil'),
                              gradient: const LinearGradient(colors: [
                                Color(0xFFFC466B),
                                const Color(0xFF3F5EFB)
                              ])),
                          vSpace(30),
                          Text(
                            widget.manthra.ashtothram ?? '',
                            style: const TextStyle(
                                fontSize: 17,
                                fontFamily: 'NotoSansTamil',
                                height: 1.8),
                          ),
                          vSpace(100),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: scroll
                  ? portrait
                      ? 10
                      : 0
                  : portrait
                      ? -50
                      : 0,
              right: portrait
                  ? 0
                  : scroll
                      ? 20
                      : -50,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              child: Container(
                height: portrait ? 45 : MediaQuery.of(context).size.height - 40,
                width: portrait ? MediaQuery.of(context).size.width - 50 : 45,
                margin: EdgeInsets.only(
                    bottom: portrait ? 6 : 20,
                    left: portrait ? 25 : 0,
                    right: portrait ? 25 : 0,
                    top: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      colors: [Color(0xFFf6d365), Color(0xFFfda085)]),
                ),
                child: portrait
                    ? Row(
                        children: speedWidgets(portrait),
                      )
                    : Column(
                        children: speedWidgets(portrait),
                      ),
              ),
            ),
            AnimatedPositioned(
                bottom: scroll ? -70 : 0,
                left: 0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.ease,
                child: Container(
                  height: portrait ? 70 : 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8)
                      ],
                      gradient: LinearGradient(
                          colors: [Color(0xFFFC466B), Color(0xFF3F5EFB)])),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 20,
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: Colors.white,
                      ),
                      const Flexible(
                          child: Text(
                        'ஸ்ரீ சுதர்சன அஷ்டோத்தர சத நாமாவளி',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'TiroTamil'),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      )),
                      IconButton(
                        onPressed: () {
                          _toggleScrolling();
                        },
                        icon: Icon(
                            scroll ? Icons.pause : Icons.play_arrow_rounded),
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          iconSize: 20,
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          iconSize: 20,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              // isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              builder: (context) => SizedBox(
                                height: 130,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Size',
                                          style: TextStyle(color: Colors.grey)),
                                      Row(
                                        children: [
                                          const Icon(Icons.text_decrease,
                                              size: 16),
                                          Expanded(
                                              child: Slider(
                                            value: 0,
                                            onChanged: (value) {},
                                            min: 0,
                                            max: 10,
                                          )),
                                          const Icon(
                                            Icons.text_increase,
                                            size: 22,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.more_vert_rounded),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
              top: 15,
              left: 15,
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black26
                    // gradient: LinearGradient(
                    //     colors: [const Color(0xFFd53369), Color(0xFFdaae51)]),
                    ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 20,
                  splashRadius: 25,
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  List<Widget> speedWidgets(bool portrait) {
    return [
      Expanded(
        child: RotatedBox(
          quarterTurns: portrait ? 0 : 3,
          child: Slider(
            thumbColor: Colors.pinkAccent,
            inactiveColor: Colors.white54,
            onChanged: (double value) => setState(() {
              speedFactor = value;
              _scroll();
            }),
            value: speedFactor,
            max: 100,
            min: 10,
          ),
        ),
      ),
      IconButton(
        onPressed: () => setState(() {
          _toggleScrolling();
        }),
        icon: const Icon(Icons.stop),
        color: Colors.pinkAccent,
      )
    ];
  }
}
