import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =  GlobalKey<NavigatorState>();
  static final NavigationService _instance = NavigationService._internal();
  int _userRoleId = -1;

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal();

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) async {
    return await navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> changeTo(String routeName, {Object? arguments}) async {
    return await navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  Future backToPage(String path) async{
    navigatorKey.currentState?.popUntil((route) {
      if (route.settings.name == path) {
        return true;
      }
      return false;
    });
  }

  int getUserRole() {
    return _userRoleId;
  }

  setUserRole(int roleId) {
    _userRoleId = roleId;
  }


  Future navigationPop() async {
    navigatorKey.currentState?.pop();
  }

  Future navigateIfDifferentRoute(String newRouteName, {Object? arguments}) async {
    navigatorKey.currentState?.popUntil((route) {
      if (route.settings.name != newRouteName) {
        navigateTo(newRouteName, arguments: arguments);
      }
      return true;
    });
  }

  Future navigateOrChangeIfDifferentRoute(String newRouteName, {Object? arguments}) async {
    navigatorKey.currentState?.popUntil((route) {
      if (route.settings.name != newRouteName) {
        navigateTo(newRouteName, arguments: arguments);
      } else {
        changeTo(newRouteName, arguments: arguments);
      }
      return true;
    });
  }

  bool goBack({Object? arguments}) {
    if(navigatorKey.currentState != null) {
      navigatorKey.currentState?.pop(arguments);
      return true;
    }
    return false;
  }
}
