import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tablet;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= tablet && width < desktop;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;

  static int gridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktop) return 4;
    if (width >= tablet) return 3;
    return 2;
  }

  static double contentMaxWidth(BuildContext context) {
    if (isDesktop(context)) return 960;
    if (isTablet(context)) return 720;
    return double.infinity;
  }
}
