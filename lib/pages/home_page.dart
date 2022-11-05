import 'dart:ui';

import 'package:ashtothram/datas/ashtothrams.dart';
import 'package:ashtothram/datas/parayanams.dart';
import 'package:flutter/material.dart';
import 'package:ashtothram/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final double barHeight = 50.0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // initialise it here
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          body(),
          appBar(statusbarHeight, context),
        ],
      ),
    );
  }

  TabBarView body() {
    return TabBarView(
      controller: _tabController,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              vSpace(100),
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF0575E6), Color(0xFF021B79)]),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
              vSpace(20),
              listCollection(list: vishnu),
              vSpace(20),
              listCollection(list: vishnuparivar),
              vSpace(20),
              listCollection(list: bramma),
              vSpace(20),
              listCollection(list: siva),
              vSpace(20),
              listCollection(list: navagraham),
              vSpace(20),
              listCollection(list: otherAshtothrams),
              vSpace(20),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              vSpace(100),
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF0575E6), Color(0xFF021B79)]),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
              vSpace(20),
              listCollection(list: panchasuktam, isParayanam: true),
              vSpace(20),
              listCollection(list: othersuktams, isParayanam: true),
              vSpace(20),
            ],
          ),
        ),
      ],
    );
  }

  Positioned appBar(double statusbarHeight, BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            // background: linear-gradient(90deg, #FC466B 0%, #3F5EFB 100%);
            // color: Color.fromARGB(60, 25, 2, 70),

            padding: EdgeInsets.only(top: statusbarHeight),
            height: statusbarHeight + barHeight,
            width: MediaQuery.of(context).size.width,
            color: Color(0xFF021B79).withOpacity(0.8),
            child: TabBar(
              indicatorColor: Colors.blue[100],
              indicatorPadding: EdgeInsets.all(4),
              indicatorWeight: 4,
              controller: _tabController,
              labelColor: Colors.white,
              labelStyle:
                  const TextStyle(fontSize: 18, fontFamily: 'Baskerville'),
              tabs: const [
                Tab(text: 'Ashtothram'),
                Tab(
                  text: 'Parayanam',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
