import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/screens/calendar_screen.dart';
import 'package:taskmanager/screens/homepage.dart';
import 'package:taskmanager/screens/time_block_screen.dart';
import 'package:taskmanager/screens/timer_screen.dart';

import '../../api/background_handler.dart';
import '../../api/firebase_api.dart';
import '../../provider/timer_provider.dart';
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




  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      _currentIndex = _tabController!.index;
      _launchedFromWidget;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    print('uri $uri');
    if(mounted){
      if (uri != null) {
        _setTimerProvider(uri);
        _tabController!.animateTo(2);

      }
    }
  }

  void _setTimerProvider(Uri uri) {
    int counter = 0;

    Uri.parse(uri.toString()).queryParameters.forEach((key, value) {
      if(key.contains('message')) {
        counter=int.parse(value);
      }
    });
    Uri.parse(uri.toString()).queryParameters.forEach((key, value) {
      if(key.contains('message')) {
        counter=int.parse(value);
      }
    });
    if(uri.host=='homeone' || counter==1){
      final provider = Provider.of<TimerProvider>(context, listen: false);
      provider.setSelectedHours(1);
      provider.setHours(1);
      provider.setStartPlaying(true);
    }
    else if(uri.host=='hometwo' || counter==2){
      final provider = Provider.of<TimerProvider>(context, listen: false);
      provider.setSelectedHours(2);
      provider.setHours(2);
      provider.setStartPlaying(true);
    }
    else if(uri.host=='homethree' || counter ==3){
      final provider = Provider.of<TimerProvider>(context, listen: false);
      provider.setSelectedHours(3);
      provider.setHours(3);
      provider.setStartPlaying(true);
    }

    else if(uri.host=='homefour'|| counter==4){
      final provider = Provider.of<TimerProvider>(context, listen: false);
      provider.setSelectedHours(4);
      provider.setHours(4);
      provider.setStartPlaying(true);
    }
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
                  const Text('Time Block',maxLines: 1,style: TextStyle(fontSize: 12),)
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

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack();
        }
        break;
    }
  }
}
