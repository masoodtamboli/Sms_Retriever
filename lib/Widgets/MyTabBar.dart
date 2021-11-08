import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_retriever/Constants/Values.dart';
import 'package:sms_retriever/Controllers/CsvController.dart';
import 'package:sms_retriever/Controllers/MessageController.dart';
import 'package:sms_retriever/Screens/Home.dart';
import 'package:sms_retriever/Screens/VIew.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({Key? key}) : super(key: key);

  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar>
    with SingleTickerProviderStateMixin {
  MessageController _msgController = Get.put(MessageController());
  CsvController _csvController = Get.put(CsvController());
  late TabController _tabController;
  static const List<Tab> _tabs = <Tab>[
    Tab(text: "Home"),
    Tab(text: "View"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, initialIndex: 0, length: _tabs.length);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        backgroundColor: primaryColor,
        title: new Text(appBarName),
        elevation: 0.7,
        bottom: new TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: _tabs,
        ),
        actions: [
          _tabController.index == 0
              ? GestureDetector(
                  child: Icon(Icons.refresh_rounded, size: 24),
                  onTap: () {
                    _msgController.fetchAllSms();
                  },
                )
              : GestureDetector(
                  child: Icon(Icons.share, size: 24),
                  onTap: () {
                    _csvController.generateCsv();
                  },
                ),
          SizedBox(width: 20),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Home(),
          View(),
        ],
      ),
    );
  }
}
