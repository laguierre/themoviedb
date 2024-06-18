import 'dart:math';
import 'package:flutter/widgets.dart';

class SizeScreen {
  late double height, width, dg;

  static double diagonal(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;
    return sqrt(width * width + height * height);
  }

  static bool isTablet(BuildContext context) {
    return diagonal(context) > 750 ? true : false;
  }

  static double getWidth(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return size.width;
  }

  static double getHeight(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return size.height;
  }
}
