import 'package:almas_project/src/services/theme/model_theme.dart';
import 'package:flutter/material.dart';

class AppTheme extends InheritedWidget {
  final AppThemeData _theme;

  const AppTheme({
    super.key,
    required AppThemeData theme,
    required super.child,
  })  : _theme = theme;

  static AppThemeData of(BuildContext context) {
    var parent = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    return parent!._theme;
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    return oldWidget._theme != _theme;
  }
}
