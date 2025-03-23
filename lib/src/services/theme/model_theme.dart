import 'package:flutter/material.dart';

abstract class AppThemeData {
  String get id;

  String? get fancyFont => null;
  String getName(BuildContext context);
  ThemeData getTheme(BuildContext context);
  Widget boxIcon();
  Widget antiBoxIcon();
  Widget storeIcon();
  Widget appIcon();
  Widget gemIcon();
  ScrollPhysics getScrollPhysics() => const BouncingScrollPhysics();
}
