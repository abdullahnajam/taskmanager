import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/screens/utils/constants.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';

class TimeBlockScreen extends StatefulWidget {
  const TimeBlockScreen({Key? key}) : super(key: key);

  @override
  State<TimeBlockScreen> createState() => _TimeBlockScreenState();
}

class _TimeBlockScreenState extends State<TimeBlockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAddTimeBlockDialog(context);
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
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey.shade200
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Things to do',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                              Icon(Icons.edit_outlined,size: 15,)
                            ],
                          ),
                          Text('Invest 1 Hour/ 5 Hours'),
                          SizedBox(height: 20,),
                          DashedCircularProgressBar.aspectRatio(
                            aspectRatio: 2.5, // width ÷ height
                            progress: 50,
                            maxProgress: 100,
                            startAngle: 180,
                            sweepAngle: 360,
                            foregroundColor: primaryColor,
                            backgroundColor: Colors.white,
                            foregroundStrokeWidth: 10,
                            backgroundStrokeWidth: 10,
                            animation: true,
                            child: Center(
                              child: Text('50/100',style: TextStyle(fontSize: 10),),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey.shade200
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Things to do',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                              Icon(Icons.edit_outlined,size: 15,)
                            ],
                          ),
                          Text('Invest 1 Hour/ 5 Hours'),
                          SizedBox(height: 20,),
                          DashedCircularProgressBar.aspectRatio(
                            aspectRatio: 2.5, // width ÷ height
                            progress: 50,
                            maxProgress: 100,
                            startAngle: 180,
                            sweepAngle: 360,
                            foregroundColor: primaryColor,
                            backgroundColor: Colors.white,
                            foregroundStrokeWidth: 10,
                            backgroundStrokeWidth: 10,
                            animation: true,
                            child: Center(
                              child: Text('50/100',style: TextStyle(fontSize: 10),),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey.shade200
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Things to do',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                              Icon(Icons.edit_outlined,size: 15,)
                            ],
                          ),
                          Text('Invest 1 Hour/ 5 Hours'),
                          SizedBox(height: 20,),
                          DashedCircularProgressBar.aspectRatio(
                            aspectRatio: 2.5, // width ÷ height
                            progress: 50,
                            maxProgress: 100,
                            startAngle: 180,
                            sweepAngle: 360,
                            foregroundColor: primaryColor,
                            backgroundColor: Colors.white,
                            foregroundStrokeWidth: 10,
                            backgroundStrokeWidth: 10,
                            animation: true,
                            child: Center(
                              child: Text('50/100',style: TextStyle(fontSize: 10),),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey.shade200
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Things to do',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                              Icon(Icons.edit_outlined,size: 15,)
                            ],
                          ),
                          Text('Invest 1 Hour/ 5 Hours'),
                          SizedBox(height: 20,),
                          DashedCircularProgressBar.aspectRatio(
                            aspectRatio: 2.5, // width ÷ height
                            progress: 50,
                            maxProgress: 100,
                            startAngle: 180,
                            sweepAngle: 360,
                            foregroundColor: primaryColor,
                            backgroundColor: Colors.white,
                            foregroundStrokeWidth: 10,
                            backgroundStrokeWidth: 10,
                            animation: true,
                            child: Center(
                              child: Text('50/100',style: TextStyle(fontSize: 10),),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
