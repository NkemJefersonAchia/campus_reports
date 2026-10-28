import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < tablet;
  static int gridColumns(BuildContext context) => isMobile(context) ? 2 : 3;
}
