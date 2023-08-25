import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmanager/api/shared_pref_api.dart';
import 'package:taskmanager/models/time_block_model.dart';
import 'package:taskmanager/provider/user_data_provider.dart';

import '../provider/timer_provider.dart';

class SqliteHelper{



  static const _databaseName = "myDatabase.db";
  static const _databaseVersion = 1;


  static const _timer = 'Timer';

  static Future<Database> getDatabase()async{
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/$_databaseName';
    Database database = await openDatabase(path);
    return database;
  }

  Future initDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/$_databaseName';
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }
  //3182


  Future<void> _onCreate(Database db, int version) async {
    print('creating table');
    await db.execute('''
      CREATE TABLE $_timer (
        id INTEGER PRIMARY KEY,
        userId TEXT NOT NULL,
        todoId TEXT NOT NULL,
        todo TEXT NOT NULL,
        state INTEGER NOT NULL,
        maxHour INTEGER NOT NULL,
        maxMin INTEGER NOT NULL,
        doneHour INTEGER NOT NULL,
        doneMin INTEGER NOT NULL,
        timerHour INTEGER NOT NULL,
        timerMin INTEGER NOT NULL,
        timerSec INTEGER NOT NULL,
        timerRemainingHour INTEGER NOT NULL,
        timerRemainingMin INTEGER NOT NULL,
        timerRemainingSec INTEGER NOT NULL,
        customHour INTEGER NOT NULL,
        customSecondsInMinute INTEGER NOT NULL,
      )
    ''');


  }

  Future<int> insert(BuildContext context,TimeBlockModel timeBlockModel) async {

    Database db = await getDatabase();
    final user = Provider.of<UserDataProvider>(context, listen: false);
    final timer = Provider.of<TimerProvider>(context, listen: false);
    int hours=await SharedPrefHelper.getSeconds();
    int secondsInMinutes=((hours/24)*60).toInt();
    Map<String,dynamic> row={
      'id':0,
      'userId':user.userId,
      'todoId':timeBlockModel.id,
      'todo':timeBlockModel.todo,
      'state':timer.state,
      'maxHour':timeBlockModel.maxHour,
      'maxMin':timeBlockModel.maxMin,
      'doneHour':timeBlockModel.doneHour,
      'doneMin':timeBlockModel.doneMin,
      'timerHour':timer.selectedHours,
      'timerMin':timer.selectedMinutes,
      'timerSec':timer.selectedSeconds,
      'timerRemainingHour':timer.remainingHours,
      'timerRemainingMin':timer.remainingMinutes,
      'timerRemainingSec':timer.remainingSeconds,
      'customHour':hours,
      'customSecondsInMinute':secondsInMinutes,
    };
    return await db.insert(_timer, row);
  }


  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await getDatabase();
    return await db.query(_timer);
  }

  Future<List<Map<String, dynamic>>> queryStepsByDate() async {
    Database db = await getDatabase();
    return await db.rawQuery('SELECT date, time, SUM(steps) AS steps FROM Steps GROUP BY date ORDER BY id DESC');

  }



}