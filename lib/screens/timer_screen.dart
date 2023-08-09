import 'package:flutter/material.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showStartTimerDialog(context);
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(360)
        ),
        child: Icon(Icons.add,color: Colors.white,),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('32 : 41 : 80',style: TextStyle(fontFamily: 'Digital',fontWeight: FontWeight.w500,fontSize: 60),),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/play.png',height: 30,),
                  Image.asset('assets/images/pause.png',height: 30,),
                  Image.asset('assets/images/stop.png',height: 30,),
                ],
              ),
            ),
            SizedBox(height: 50,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Text('1 Hour',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                    )
                  ),
                ),
                Expanded(
                  child: Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(
                        child: Text('1 Hour',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                      )
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(
                        child: Text('1 Hour',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                      )
                  ),
                ),
                Expanded(
                  child: Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(
                        child: Text('1 Hour',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                      )
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
