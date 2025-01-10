import 'package:flutter/material.dart';

class Sizes {
  static double width = 1, height = 1;
  static double widthPercent = 1, heightPercent = 1;
  static double bottomNavigationHeight = 1;

  static double paddingBig = 1, paddingRegular = 1, paddingSmall = 1;
  static double textSizeBig = 1, textSizeRegular = 1, textSizeSmall = 1;
  static double iconSize = 1;
  static double borderRadius = 1, borderRadiusBig = 1;

  void initialize(BuildContext context) {
    MediaQueryData m = MediaQuery.of(context);
    width = m.size.width;
    height = m.size.height;
    widthPercent = width / 100;
    heightPercent = height / 100;
    paddingSmall = width / 31.25;
    paddingRegular = paddingSmall * 2;
    paddingBig = paddingRegular * 2;
    textSizeSmall = width / 25;
    textSizeRegular = width / 18.75;
    textSizeBig = width / 15;
    borderRadius = widthPercent * 3;
    borderRadiusBig = borderRadius * 2;
    bottomNavigationHeight = widthPercent * 14;
    iconSize = widthPercent * 7.5;
  }
}
