import 'dart:io';

import 'package:twiza/db.dart';
import 'package:twiza/nav.dart';
// import 'package:twiza/phoneAuth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twiza/netState.dart';
import 'package:twiza/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'dart:async';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:twiza/menu.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => new _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  var _formkey = GlobalKey<FormState>();
  DB db = DB();
  late String _email, _pwd;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  late ProgressDialog pr;
  bool permission = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // permissions();
    pr = new ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal);
  }

  bool isEmail(String email) {
    return email.split('').contains("@") && email.split('').contains(".");
  }

  // permissions() async {
  //   if (await Permission.sms.isGranted &&
  //       await Permission.phone.isGranted &&
  //       await Permission.contacts.isGranted) {
  //     setState(() {
  //       permission = true;
  //     });
  //   } else if (await Permission.sms.request().isGranted &&
  //       await Permission.phone.request().isGranted &&
  //       await Permission.contacts.request().isGranted) {
  //     setState(() {
  //       permission = true;
  //     });
  //   } else {
  //     setState(() {
  //       permission = false;
  //       permissions();
  //     });
  //   }
  // }

  _singIn() async {
    final formState = _formkey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        ////print("55555");
        NetState().isConnected().then((state) async {
          if (state) {
            try {
              pr.style(
                  message: ' ...تسجيل الدخول',
                  progressWidget: Image.asset('images/ring.gif'),
                  textAlign: TextAlign.center);
              pr.show();
              db.login(_email, _pwd).then((user) {
                if (user != "error") {
                  pr.hide();
                  Nav().nav(
                      Menu(
                        add: false,
                      ),
                      context);
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context)=> new Menu(user:user)
                  // ));

                } else {
                  pr.hide();
                  Alert(
                          context: context,
                          title: "خطأ",
                          message: ":( البريد الإلكتروني أو كلمة المرور خاطئة",
                          info: true)
                      .show();
                }
              });
            } catch (_) {
              pr.hide().then((_) => Alert(
                      context: context,
                      title: "خطأ",
                      message: ":( البريد الإلكتروني أو كلمة المرور خاطئة",
                      info: true)
                  .show());
            }
          } else {
            Alert(
                    context: context,
                    title: "خطأ",
                    message: ":(  تحقق من شبكتك ",
                    info: true)
                .show();
            sleep();
          }
        });
      } on SocketException catch (_) {
        Alert(
                context: context,
                title: "خطأ",
                message: ":(  تحقق من شبكتك ",
                info: true)
            .show();
        sleep();
      }
    }
  }

  Future sleep() {
    return new Future.delayed(const Duration(seconds: 3), () => Alert().hide());
  }

  _onBackExit() {
    // flutter defined function
    Alert(
        context: context,
        title: "ناس الخير",
        message: "هل أنت متأكد أنك تريد الخروج",
        info: false,
        yesFunction: () => SystemChannels.platform
            .invokeMethod<void>('SystemNavigator.pop')).show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackExit(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.blueGrey,
                    ),
                    Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        "images/logo.png",
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.35,
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.55,
                      right: MediaQuery.of(context).size.width * 0.1,
                      left: MediaQuery.of(context).size.width * 0.1,
                      child: Container(
                        width: 300.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              style: BorderStyle.solid,
                              width: 0.2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.blue[
                                50]), //ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                        padding: EdgeInsets.all(4.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return "فارغ";
                            }
                            if (!isEmail(input)) {
                              return "ليس  بريد إلكتروني";
                            }
                          },
                          onSaved: (input) => _email = input!.trim(),
                          //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                          //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              labelText: 'البريد الإلكتروني',
                              labelStyle: TextStyle(fontFamily: 'Hacen')),
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.65,
                      right: MediaQuery.of(context).size.width * 0.1,
                      left: MediaQuery.of(context).size.width * 0.1,
                      child: Container(
                        width: 300.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              style: BorderStyle.solid,
                              width: 0.2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.blue[
                                50]), //ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                        padding: EdgeInsets.all(4.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          textDirection: TextDirection.ltr,
                          obscureText: true,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return "فارغ";
                            } else if (input.length < 6) {
                              return "يجب أن تكون كلمة المرور مكونة من 6 أرقام أو أكثر";
                            }
                          },
                          onSaved: (input) => _pwd = input!.trim(),
                          // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                          //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              labelText: 'كلمة المرور',
                              labelStyle: TextStyle(fontFamily: 'Hacen')),
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.75,
                      right: MediaQuery.of(context).size.width * 0.1,
                      left: MediaQuery.of(context).size.width * 0.1,
                      child: RaisedButton(
                        onPressed: _singIn,
                        padding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(55.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          margin: EdgeInsets.all(0),
                          height: 50.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                style: BorderStyle.solid,
                                width: 0.5,
                              ),
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Text('دخول',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Hacen",
                                    fontSize: 20)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
