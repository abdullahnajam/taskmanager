import 'dart:async';

import 'package:flutter/material.dart';



class CountdownScreen extends StatefulWidget {
  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int totalSeconds = 0;
  bool isRunning = false;

  void startCountdown() {
    totalSeconds = hours * 60 * 80 + minutes * 80 + seconds;

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (totalSeconds > 0) {
        setState(() {
          totalSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          isRunning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter initial time:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      hours = int.tryParse(value) ?? 0;
                    },
                    decoration: InputDecoration(labelText: 'Hours'),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      minutes = int.tryParse(value) ?? 0;
                    },
                    decoration: InputDecoration(labelText: 'Minutes'),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      seconds = int.tryParse(value) ?? 0;
                    },
                    decoration: InputDecoration(labelText: 'Seconds'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (!isRunning)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isRunning = true;
                  });
                  startCountdown();
                },
                child: Text('Start Countdown'),
              ),
            SizedBox(height: 20),
            Text(
              'Time Remaining: ${totalSeconds ~/ (60 * 80)} hours, '
                  '${(totalSeconds % (60 * 80)) ~/ 80} minutes, '
                  '${totalSeconds % 80} seconds',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
