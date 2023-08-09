import 'package:flutter/material.dart';
import 'package:taskmanager/screens/utils/constants.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.settings,color: Colors.transparent,),
                  Text('Home'),
                  InkWell(
                    onTap: (){
                      showSettingDialog(context);
                    },
                    child: Icon(Icons.settings,color: Colors.black,),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('32 : 41 : 80',style: TextStyle(fontFamily: 'Digital',fontWeight: FontWeight.w500,fontSize: 60),)

                ],
              ),
            ),
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How to use this app?',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  Text(loremIpsum),
                  SizedBox(height: 5,),
                  Text(loremIpsum),
                  SizedBox(height: 5,),
                  Text(loremIpsum),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
