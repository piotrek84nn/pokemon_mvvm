import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/ui/favourite/favourite_view.dart';
import 'package:pokemon/ui/home/home_view.dart';

class RoutePaths {
  static const String home = '/';
  static const String favourite = '/favourite';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return generateRouteFromName(settings.name!, settings.arguments);
  }

  static Route<dynamic> generateRouteFromName(String name, Object? arguments) {
    var settings = RouteSettings(name: name, arguments: arguments);
    switch (name) {
      case RoutePaths.home:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const HomeView());
      case RoutePaths.favourite:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const FavouriteView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                  Container(height: 70),
                  Text('Not implemented yet!\n route: $name',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25)),
                ])),
          ),
        );
    }
  }
}
