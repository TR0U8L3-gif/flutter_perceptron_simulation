import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:perceptron_simulation/core/controllers/routes/route_controller.dart';

//Initialization
var routeController = RouteController.instance;

//Duration double
double smallDelay = 10;
double mediumDelay = 100;
double largeDelay = 500;

//Durations
const Duration duration15 = Duration(milliseconds: 15);
const Duration duration50 = Duration(milliseconds: 50);
const Duration duration200 = Duration(milliseconds: 200);
const Duration duration400 = Duration(milliseconds: 400);
const Duration duration600 = Duration(milliseconds: 600);
const Duration duration1200 = Duration(milliseconds: 1200);

//Disable scroll glow effect
class DisableScrollGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

//Turn number to shorter version
String formatNumber(int num) {
  if (num < 1000) {
    return num.toString();
  } else if (num < 1000000) {
    String numStr = num.toString();
    String suffix = "K";
    String firstNumberStr = numStr.substring(0, numStr.length - 3);
    String secondNumberStr = "";
    if(firstNumberStr.length == 1){
      secondNumberStr = ".${numStr[1]}";
    }
    return firstNumberStr + secondNumberStr + suffix;
  } else if (num < 1000000000) {
    String numStr = (num ~/ 1000).toString();
    String suffix = "M";
    String firstNumberStr = numStr.substring(0, numStr.length - 3);
    String secondNumberStr = "";
    if(firstNumberStr.length == 1){
      secondNumberStr = ".${numStr[1]}";
    }
    return firstNumberStr + secondNumberStr + suffix;
  } else if (num < 1000000000000) {
    String numStr = (num ~/ 1000000).toString();
    String suffix = "B";
    String firstNumberStr = numStr.substring(0, numStr.length - 3);
    String secondNumberStr = "";
    if(firstNumberStr.length == 1){
      secondNumberStr = ".${numStr[1]}";
    }
    return firstNumberStr + secondNumberStr + suffix;
  } else {
    String numStr = (num ~/ 1000000000).toString();
    String suffix = "T";
    String firstNumberStr = numStr.substring(0, numStr.length - 3);
    String secondNumberStr = "";
    if(firstNumberStr.length == 1){
      secondNumberStr = ".${numStr[1]}";
    }
    return firstNumberStr + secondNumberStr + suffix;
  }
}

//Turn DateTime to string
String timeAgoSinceDate(DateTime date) {
  final date2 = DateTime.now();
  final difference = date2.difference(date);

  if (difference.inDays > 7) {
    return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() == 1 ? '' : 's'} ago';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  }
}

//Get number in range
num inRange<T extends num>(T min, T max){
  if(T is int){
    return Random().nextInt(max as int) + min;
  } else {
    return Random().nextDouble() * (max - min) + min;
  }
}

num min<T extends num>(T a, T b){
  return a > b ? b : a;
}

num max<T extends num>(T a, T b){
  return a > b ? a : b;
}

double roundDouble(double value, int places){
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}