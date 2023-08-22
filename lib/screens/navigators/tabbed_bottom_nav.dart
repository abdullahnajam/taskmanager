import 'package:flutter/material.dart';
import 'package:taskmanager/screens/calendar_screen.dart';
import 'package:taskmanager/screens/homepage.dart';
import 'package:taskmanager/screens/time_block_screen.dart';
import 'package:taskmanager/screens/timer_screen.dart';

import '../../api/firebase_api.dart';
import '../../test.dart';
import '../utils/constants.dart';

class TabbedBottomNavBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<TabbedBottomNavBar> with SingleTickerProviderStateMixin {

  int _currentIndex = 0;

  List<Widget> _children=[];
  TabController? _tabController;
  @override
  void initState() {
    super.initState();

    _children = [
      const Homepage(),
      const TimeBlockScreen(),
      const TimerScreen(),
      const CalendarScreen(),
    ];
    _tabController = new TabController(vsync: this, length: _children.length);
    _tabController!.addListener(_handleTabChange);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      // Do something with _tabController.index (current tab index)
      _currentIndex = _tabController!.index;
      print('Current Tab Index: $_currentIndex');
    });
  }

  @override
  Widget build(BuildContext context) {


    return DefaultTabController(

      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,

        bottomNavigationBar: TabBar(
          controller: _tabController,
          indicator: UnderlineTabIndicator(

              borderSide: BorderSide(width: 4,color: Colors.orange),
              insets: EdgeInsets.symmetric(horizontal:16.0)
          ),
          tabs: [
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if(_currentIndex==0)
                    Image.asset("assets/images/home_fill.png",height: 25)
                  else
                    Image.asset("assets/images/home.png",height: 25),
                  const Text('Home',style: TextStyle(fontSize: 12),)

                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if(_currentIndex==1)
                    Image.asset("assets/images/block_fill.png",height: 25)
                  else
                    Image.asset("assets/images/block.png",height: 25),
                  const Text('Time Block',style: TextStyle(fontSize: 12),)
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if(_currentIndex==2)
                    Image.asset("assets/images/timer_fill.png",height: 25)
                  else
                    Image.asset("assets/images/time.png",height: 25),
                  const Text('Timer',style: TextStyle(fontSize: 12),)
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if(_currentIndex==3)
                    Image.asset("assets/images/calendar_fill.png",height: 25)
                  else
                    Image.asset("assets/images/calendar.png",height: 25),
                  const Text('Schedule',style: TextStyle(fontSize: 12),)
                ],
              ),
            ),
          ],
        ),

        body:  _children[_currentIndex],
      ),
    );
  }
}
