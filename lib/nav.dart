
import 'package:flutter/material.dart';

class Nav{
nav(route,context){
  Navigator.pushAndRemoveUntil(context,PageRouteBuilder(
        transitionDuration: Duration(seconds: 2),
            pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>route,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
                // alignment: Alignment.centerLeft,
                scale:   
                Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: child,
              ),
              ),(Route<dynamic> route) => false);
}
  
}