import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const primaryColor=Colors.black;
const greyColor=Colors.white;
//const greyColor=Color(0xffC3C1C1);

const loremIpsum='Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum.';

List<String> productLists =  ['299pelvictronmonthly','2999pelvictronyearly','599pelvictronmonthly'];

final dtf = new DateFormat('hh:mm:ss');
final f = new DateFormat('hh : mm');
final clockFormat = new DateFormat('HH : mm : ss');

