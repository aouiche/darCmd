// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:twiza/constants.dart';
import 'package:twiza/inbox.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:twiza/splashUI.dart';
import 'package:flutter/material.dart';
import 'menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: 'Hacen'),
          bodyText2: TextStyle(fontFamily: 'Hacen'),
          button: TextStyle(fontFamily: 'Hacen'),
          caption: TextStyle(fontFamily: 'Hacen'),
          headline1: TextStyle(fontFamily: 'Hacen'),
          headline2: TextStyle(fontFamily: 'Hacen'),
          headline3: TextStyle(fontFamily: 'Hacen'),
          headline4: TextStyle(fontFamily: 'Hacen'),
          headline5: TextStyle(fontFamily: 'Hacen'),
          headline6: TextStyle(fontFamily: 'Hacen'),
          overline: TextStyle(fontFamily: 'Hacen'),
          subtitle1: TextStyle(fontFamily: 'Hacen'),
          subtitle2: TextStyle(fontFamily: 'Hacen'),
        ),
        canvasColor: secondaryColor,
      ),

      // routes: <String, WidgetBuilder> {
      //   '/log': (BuildContext context) => new Login(),
      //   '/reg' : (BuildContext context) => new Regst(),
      //   '/log' : (BuildContext context) => new Login(),
      // '/menu' : (BuildContext context) => new Menu(add:false),
      //   '/terms' : (BuildContext context) => new Conditions(),
      // },, // MyHomePage(),
      home: SplashUI(), // MyHomePage(),
    );
  }
}
