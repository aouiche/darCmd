import 'package:flutter/material.dart';

class Nav {
  nav(route, context) {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(microseconds: 500),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              route,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            // alignment: Alignment.centerLeft,
            scale: Tween<double>(
              begin: 1.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.ease,
              ),
            ),
            child: child,
            filterQuality: FilterQuality.high,
          ),
        ),
        (Route<dynamic> route) => false);
  }
}
