import 'package:naskhir/splashUI.dart';
import 'package:flutter/material.dart';
import 'menu.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       primarySwatch: Colors.deepPurple,
        fontFamily: 'Hacen',
        textTheme: TextTheme(body1: TextStyle(fontSize: 20)),
      iconTheme: IconThemeData(
            color: Colors.white,             
          ),
      ),
    // routes: <String, WidgetBuilder> {
  //   '/log': (BuildContext context) => new Login(),
  //   '/reg' : (BuildContext context) => new Regst(), 
  //   '/log' : (BuildContext context) => new Login(), 
    // '/menu' : (BuildContext context) => new Menu(add:false),
  //   '/terms' : (BuildContext context) => new Conditions(),
  // },
     home: SplashUI(),// MyHomePage(),
    );
  }
}
