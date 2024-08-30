import 'dart:developer';

import 'package:flutter/cupertino.dart';

class NavigationService {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void pushTo(String route, {dynamic arguments}) {
    log("Changing to path $route", name: "Route", time: DateTime.timestamp());
    navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }
  void pushAndReplaceTo(String route, {dynamic arguments}) {
    log("Replacing the path to $route", name: "Route", time: DateTime.timestamp());
    navigatorKey.currentState?.pushNamedAndRemoveUntil(route, (route) => false, arguments: arguments);
  }

  dynamic goBack() {
    return navigatorKey.currentState?.pop();
  }
}