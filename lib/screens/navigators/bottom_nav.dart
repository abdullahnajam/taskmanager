import 'package:flutter/material.dart';
import 'package:taskmanager/screens/calendar_screen.dart';
import 'package:taskmanager/screens/homepage.dart';
import 'package:taskmanager/screens/time_block_screen.dart';
import 'package:taskmanager/screens/timer_screen.dart';

class BottomNavBar extends StatefulWidget {

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavBar>{

  int _currentIndex = 0;

  List<Widget> _children=[];

  @override
  void initState() {
    super.initState();
    _children = [
      const Homepage(),
      const TimeBlockScreen(),
      const TimerScreen(),
      const CalendarScreen(),


    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 5),
        height: AppBar().preferredSize.height+20,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: (){
                onTabTapped(0);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if(_currentIndex==0)
                    Image.asset("assets/images/home_fill.png",height: 25)
                  else
                    Image.asset("assets/images/home.png",height: 25),
                  const Text('Home')

                ],
              ),
            ),
            InkWell(
              onTap: (){
                onTabTapped(1);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if(_currentIndex==1)
                    Image.asset("assets/images/block_fill.png",height: 25)
                  else
                    Image.asset("assets/images/block.png",height: 25),
                  const Text('Time Block')
                ],
              ),
            ),
            InkWell(
              onTap: (){
                onTabTapped(2);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if(_currentIndex==2)
                    Image.asset("assets/images/timer_fill.png",height: 25)
                  else
                    Image.asset("assets/images/time.png",height: 25),
                  const Text('Timer')
                ],
              ),
            ),
            InkWell(
              onTap: (){
                onTabTapped(3);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if(_currentIndex==3)
                    Image.asset("assets/images/calendar_fill.png",height: 25)
                  else
                    Image.asset("assets/images/calendar.png",height: 25),
                  const Text('Schedule')
                ],
              ),
            ),


          ],
        ),
      ),
      body: _children[_currentIndex],
    );
  }
}
