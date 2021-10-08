import 'package:flutter/material.dart';
import 'package:twiza/constants.dart';

class PolyBox {
  late BuildContext headContext;
  late Widget content;
  late String title;
  late String btn1Text;
  late String btn2Text;
  late Function funcBtn1;
  late Function funcBtn2;
  PolyBox(
      {required this.headContext,
      required this.content,
      required this.title,
      required this.btn1Text,
      required this.btn2Text,
      required this.funcBtn1,
      required this.funcBtn2});
  show() {
    showDialog(
        context: headContext,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0),
              backgroundColor: bgColor,
              shape: Border.all(color: secondaryColor, width: 2),
              // elevation: 10.0,
              // titleTextStyle: TextStyle(color:Colors.white,fontSize: 30.0,fontFamily: 'Hacen'),
              // contentTextStyle: TextStyle(color:Colors.white,fontSize: 20.0,fontFamily: 'Hacen'),
              title: new Center(
                  child: Text(
                this.title,
                style: TextStyle(fontSize: 25.0),
              )),
              content: content,
              actions: <Widget>[
                RaisedButton(
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: primaryColor,
                  child: Center(
                    child: Text(
                      btn1Text,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Hacen',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  onPressed: () => funcBtn1(),
                ),
                RaisedButton(
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: primaryColor,
                  child: Center(
                    child: new Text(
                      btn2Text,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Hacen',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  onPressed: () => funcBtn2(context),
                ),
              ],
            ),
          );
        });
  }
}
