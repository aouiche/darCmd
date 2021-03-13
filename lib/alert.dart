// import 'package:bbdz/Setup/db.dart';
import 'package:flutter/material.dart';

class Alert {
  String title;
  String message;
  bool info;
  dynamic yesFunction;
  dynamic context;

  show() {
    // flutter defined function
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            contentPadding: EdgeInsets.all(0),
            // elevation: 10.0,
            // titleTextStyle: TextStyle(color:Colors.white,fontSize: 30.0,fontFamily: 'Hacen'),
            // contentTextStyle: TextStyle(color:Colors.white,fontSize: 20.0,fontFamily: 'Hacen'),
            // title: new Text(this.title != null ?this.title:""),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Stack(fit: StackFit.expand, children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.09,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Text(
                    this.title != null ? this.title : "",
                    style: TextStyle(
                        fontFamily: "Hacen", color: Colors.white, fontSize: 30),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.17,
                  left: MediaQuery.of(context).size.width * 0.02,
                  right: MediaQuery.of(context).size.width * 0.02,
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 0.5,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(55.0)),
                    child: Center(
                        child: Text(
                      this.message,
                      style: TextStyle(fontFamily: "Hacen"),
                    )),
                  ),
                ),
              ]),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              this.info
                  ? RaisedButton(
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55.0),
                      ),
                      color: Colors.purple,
                      child: Center(
                        child: new Text(
                          "إغلاق",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'Hacen',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : Container(),
              !this.info
                  ? RaisedButton(
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55.0),
                      ),
                      color: Colors.purple,
                      child: Center(
                        child: Text(
                          "نعم",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'Hacen',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onPressed: this.yesFunction,
                    )
                  : Container(),
              !this.info
                  ? RaisedButton(
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55.0),
                      ),
                      color: Colors.purple,
                      child: Center(
                        child: new Text(
                          "لا",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'Hacen',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  hide() {
    Navigator.of(context).pop();
  }

  Alert({
    this.context,
    this.title = '',
    this.message = '',
    this.info = false,
    this.yesFunction,
  });
}
