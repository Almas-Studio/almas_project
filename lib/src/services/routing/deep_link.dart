import 'package:flutter/material.dart';

String deepLink(){
  return WidgetsBinding.instance.platformDispatcher.defaultRouteName;
}

bool wasLaunchedFromDeepLink() {
  final initialLink = deepLink();
  return initialLink != '/';
}