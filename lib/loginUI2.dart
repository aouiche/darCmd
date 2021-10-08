// // import 'dart:html';
// import 'dart:io';
// // import 'package:awesome_card/awesome_card.dart';
// // import 'package:twiza/ads.dart';
// import 'package:twiza/db.dart';
// import 'package:twiza/inbox.dart';
// import 'package:twiza/nav.dart';
// // import 'package:twiza/phoneAuth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:twiza/netState.dart';
// import 'package:twiza/alert.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'dart:async';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:twiza/menu.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:permission_handler/permission_handler.dart';

// class LoginUI2 extends StatefulWidget {
//   @override
//   _LoginUI2State createState() => new _LoginUI2State();
// }

// class _LoginUI2State extends State<LoginUI2> {
//   var _formkey = GlobalKey<FormState>();
//   // Ads ads = new Ads();
//   GlobalKey<ScaffoldState> scaffoldStatex = GlobalKey();
//   DB db = DB();
//   late String _email, _pwd;
//   // final GoogleSignIn _googleSignIn = GoogleSignIn();
//   late ProgressDialog pr;
//   bool permission = false;
//   String _statusText = "Waiting...";
//   final String _finished = "Finished creating channel";
//   final String _error = "Error while creating channel";

//   static const MethodChannel _channel =
//       MethodChannel('A3Channel.com/channel01');

//   Map<String, String> channelMap = {
//     "id": "CHAT_MESSAGES",
//     "name": "Chats",
//     "description": "Chat notifications",
//   };

//   void _createNewChannel() async {
//     try {
//       await _channel.invokeMethod('createNotificationChannel', channelMap);
//       setState(() {
//         _statusText = _finished;
//       });
//     } on PlatformException catch (e) {
//       _statusText = _error;
//       print(e);
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     pr = new ProgressDialog(context,
//         isDismissible: true, type: ProgressDialogType.Normal);
//     _createNewChannel();
//     // ads.scaffoldState = scaffoldStatex;
//     // ads.interstitialAd = ads.initState();
//     // ads.load();
//   }

//   bool isEmail(String email) {
//     return email.split('').contains("@") && email.split('').contains(".");
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     // ads.dispose();
//   }

//   _singIn() async {
//     final formState = _formkey.currentState;
//     if (formState!.validate()) {
//       formState.save();
//       _email = _email.trimLeft();
//       _email = _email.trimRight();
//       try {
//         ////print("55555");
//         // starAD();
//         NetState().isConnected().then((state) async {
//           if (state) {
//             try {
//               pr.style(
//                   message: ' ...تسجيل الدخول',
//                   progressWidget: Image.asset('images/ring.gif'),
//                   textAlign: TextAlign.center);
//               pr.show();
//               db.getData(_email, "donaters").then((user) {
//                 // print("*"*100);
//                 // print(user.documentID);
//                 // print(user.data);
//                 // print("*"*100);
//                 if (user.id == _email && user.get("phone") == _pwd) {
//                   pr.hide();
//                   Nav().nav(Inbox(name: _email, phone: _pwd), context);
//                   // Navigator.of(context).push(MaterialPageRoute(
//                   //     builder: (BuildContext context)=> new Menu(user:user)
//                   // ));

//                 } else {
//                   pr.hide();
//                   Alert(
//                           context: context,
//                           title: "خطأ",
//                           message: "حساب غير موجود",
//                           info: true)
//                       .show();
//                 }
//               }).catchError((e) {
//                 pr.hide();
//                 Alert(
//                         context: context,
//                         title: "خطأ",
//                         message: "حساب غير موجود",
//                         info: true)
//                     .show();
//               });
//               // db.login(_email, _pwd).then((user){
//               //   if (user != "error") {
//               //  pr.hide();
//               //  Nav().nav(Menu(), context);
//               // // Navigator.of(context).push(MaterialPageRoute(
//               // //     builder: (BuildContext context)=> new Menu(user:user)
//               // // ));

//               //   } else {
//               //       pr.hide();
//               //     Alert(context: context, title:"خطأ", message:":( البريد الإلكتروني أو كلمة المرور خاطئة",info:true).show();
//               //   }
//               // });
//             } catch (e) {
//               pr.hide().then((_) => Alert(
//                       context: context,
//                       title: "خطأ",
//                       message: "حساب غير موجود",
//                       info: true)
//                   .show());
//             }
//           } else {
//             Alert(
//                     context: context,
//                     title: "خطأ",
//                     message: ":(  تحقق من شبكتك ",
//                     info: true)
//                 .show();
//             sleep();
//           }
//         });
//       } on SocketException catch (_) {
//         Alert(
//                 context: context,
//                 title: "خطأ",
//                 message: ":(  تحقق من شبكتك ",
//                 info: true)
//             .show();
//         sleep();
//       }
//     }
//   }

//   Future sleep() {
//     return new Future.delayed(const Duration(seconds: 3), () => Alert().hide());
//   }

//   _onBackExit() {
//     // flutter defined function
//     Alert(
//         context: context,
//         title: "ناس الخير",
//         message: "هل أنت متأكد أنك تريد الخروج",
//         info: false,
//         yesFunction: () => SystemChannels.platform
//             .invokeMethod<void>('SystemNavigator.pop')).show();
//   }

//   // starAD() async {
//   //   if (await ads.isLoaded()) {
//   //     ads.show();
//   //   } else {
//   //     ads.showSnackBar('Interstitial ad is still loading...');
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _onBackExit(),
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           key: scaffoldStatex,
//           body: Form(
//             key: _formkey,
//             child: SingleChildScrollView(
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 color: Colors.white,
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xff7c94b6),
//                         image: new DecorationImage(
//                             fit: BoxFit.cover,
//                             colorFilter: ColorFilter.mode(
//                                 Colors.white.withOpacity(0.4),
//                                 BlendMode.dstATop),
//                             image: AssetImage("images/login.jpg")),
//                       ),
//                     ),
//                     Positioned(
//                       top: 60,
//                       left: 0,
//                       right: 0,
//                       child: Image.asset(
//                         "images/logo.png",
//                         width: MediaQuery.of(context).size.width * 0.25,
//                         height: MediaQuery.of(context).size.height * 0.25,
//                       ),
//                     ),
//                     Positioned(
//                         top: MediaQuery.of(context).size.height * 0.35,
//                         left: 20,
//                         right: 20,
//                         child: Card(
//                             elevation: 10.0,
//                             // shadowColor: Colors.black45,
//                             child: Container(
//                                 color: Color.fromARGB(255, 20, 29, 38),
//                                 width: MediaQuery.of(context).size.width * 0.25,
//                                 padding: EdgeInsets.all(10),
//                                 margin: EdgeInsets.all(0),
//                                 child: Center(
//                                     child: Text(
//                                   "حساب جمعية ناس الخير رقان\n" +
//                                       'BaridiMob: 00799999002100841241 \n CCP: 21008412 /41',
//                                   style: TextStyle(
//                                     color: Colors.orange,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ))))),
//                     Positioned(
//                       top: MediaQuery.of(context).size.height * 0.55,
//                       right: MediaQuery.of(context).size.width * 0.1,
//                       left: MediaQuery.of(context).size.width * 0.1,
//                       child: Container(
//                         width: 300.0,
//                         height: 60.0,
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                               style: BorderStyle.solid,
//                               width: 0.2,
//                             ),
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                             color: Colors.blue[
//                                 50]), //ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

//                         padding: EdgeInsets.all(4.0),
//                         child: TextFormField(
//                           keyboardType: TextInputType.emailAddress,
//                           textDirection: TextDirection.rtl,
//                           validator: (input) {
//                             if (input!.isEmpty) {
//                               return "فارغ";
//                             }
//                             //      if(!isEmail(input) ){
//                             //   return "ليس  بريد إلكتروني";
//                             // }
//                           },
//                           onSaved: (input) => _email = input!.trim(),
//                           //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
//                           //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(5))),
//                               labelText: ' الاسم الكامل',
//                               // labelText: 'البريد الإلكتروني',
//                               labelStyle: TextStyle(fontFamily: 'Hacen')),
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: MediaQuery.of(context).size.height * 0.67,
//                       right: MediaQuery.of(context).size.width * 0.1,
//                       left: MediaQuery.of(context).size.width * 0.1,
//                       child: Container(
//                         width: 300.0,
//                         height: 60.0,
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                               style: BorderStyle.solid,
//                               width: 0.2,
//                             ),
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                             color: Colors.blue[
//                                 50]), //ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

//                         padding: EdgeInsets.all(4.0),
//                         child: TextFormField(
//                           keyboardType: TextInputType.phone,
//                           textDirection: TextDirection.rtl,
//                           maxLength: 10,
//                           validator: (input) {
//                             if (input!.isEmpty) {
//                               return "فارغ";
//                             }
//                           },
//                           onSaved: (input) => _pwd = input!.trim(),
//                           //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
//                           //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(5))),
//                               labelText: 'رقم الهاتف',
//                               labelStyle: TextStyle(fontFamily: 'Hacen'),
//                               counterText: ""),
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                       ),
//                       //       Container(
//                       //           width: 300.0,
//                       //           height: 60.0,
//                       //           decoration: BoxDecoration(border:Border.all(style: BorderStyle.solid,width: 0.2,),
//                       //                           borderRadius: BorderRadius.all(Radius.circular(5)),color: Colors.blue[50]) ,//ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

//                       //           padding: EdgeInsets.all(4.0),
//                       //           child: TextFormField(
//                       //             keyboardType: TextInputType.text,
//                       //             textDirection: TextDirection.ltr,
//                       //             obscureText: true,
//                       //             validator: (input){
//                       //               if(input.isEmpty  ){
//                       //             return "فارغ";
//                       //           }else if(input.length<6){
//                       //             return "يجب أن تكون كلمة المرور مكونة من 6 أرقام أو أكثر";
//                       //           }
//                       //             },
//                       //             onSaved: (input)=> _pwd = input.trim(),
//                       //            // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
//                       //             //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
//                       //             decoration: InputDecoration(
//                       //                  border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(5)) ),
//                       //                 labelText: 'كلمة المرور',
//                       //               labelStyle: TextStyle(fontFamily: 'Hacen')
//                       //             ),
//                       //             style:TextStyle(fontSize: 20.0 ),
//                       //           ),
//                       // ),
//                     ),
//                     Positioned(
//                       top: MediaQuery.of(context).size.height * 0.8,
//                       right: MediaQuery.of(context).size.width * 0.1,
//                       left: MediaQuery.of(context).size.width * 0.1,
//                       child: RaisedButton(
//                         onPressed: _singIn,
//                         padding: const EdgeInsets.all(0.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(55.0),
//                         ),
//                         child: Container(
//                           padding: const EdgeInsets.all(0.0),
//                           margin: EdgeInsets.all(0),
//                           height: 50.0,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 style: BorderStyle.solid,
//                                 width: 0.5,
//                               ),
//                               color: Colors.green,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5))),
//                           child: Center(
//                             child: Text('دخول',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontFamily: "Hacen",
//                                     fontSize: 20)),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: MediaQuery.of(context).size.height * 0.9,
//                       right: MediaQuery.of(context).size.width * 0.1,
//                       left: MediaQuery.of(context).size.width * 0.1,
//                       child: RaisedButton(
//                         onPressed: () {
//                           // starAD();
//                           Nav().nav(Menu(add: true), context);
//                         },
//                         padding: const EdgeInsets.all(0.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(55.0),
//                         ),
//                         child: Container(
//                           padding: const EdgeInsets.all(0.0),
//                           margin: EdgeInsets.all(0),
//                           height: 50.0,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.green,
//                                 style: BorderStyle.solid,
//                                 width: 0.7,
//                               ),
//                               color: Colors.white,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5))),
//                           child: Center(
//                             child: Text('إشتراك جديد',
//                                 style: TextStyle(
//                                     color: Colors.green,
//                                     fontFamily: "Hacen",
//                                     fontSize: 20)),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:twiza/db.dart';

import 'alert.dart';
import 'inbox.dart';
import 'menu.dart';
import 'nav.dart';
import 'netState.dart';

class LoginUI2 extends StatefulWidget {
  @override
  _LoginUI2State createState() => new _LoginUI2State();
}

class _LoginUI2State extends State<LoginUI2> {
  Duration get loginTime => Duration(milliseconds: 2250);
  // var _formkey = GlobalKey<FormState>();
  // Ads ads = new Ads();
  GlobalKey<ScaffoldState> scaffoldStatex = GlobalKey();
  DB db = DB();
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  late ProgressDialog pr;
  bool permission = false;
  late Map<String, String> users = Map<String, String>();

  Future<String> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      // users = {data.name: data.password};
      // if (!users.containsKey(data.name)) {
      //   return 'المستخدم غير موجود';
      // }
//abideaiche07@gmail.com
      if (users[data.name] != data.password) {
        return 'فارغ';
      }
      // }
      return '';
    });
  }

  // Future sleep() {
  //   return new Future.delayed(const Duration(seconds: 3), () => Alert().hide());
  // }

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

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'المستخدم غير موجود';
      }
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: FlutterLogin(
          theme: LoginTheme(
            pageColorLight: Color(0xFF2A2D3E),
            pageColorDark: Color(0xFF2A2D3E),
          ),
          logo: 'assets/images/logo.png',
          onLogin: _authUser,
          onSignup: _authUser,
          messages: LoginMessages(
            userHint: "البريد الإلكتروني",
            passwordHint: 'كلمة المرور',
            confirmPasswordHint: 'تأكيد كلمة المرور',
            loginButton: 'دخول',
            signupButton: 'تسجيل',
            forgotPasswordButton: 'نسيت كلمة المرور',
            recoverPasswordButton: 'ساعدني',
            goBackButton: 'الرجوع',
            confirmPasswordError: 'لا يتطابق!',
            recoverPasswordDescription:
                'تم إرسال بريد إلكتروني إليك بكلمة مرور',
            recoverPasswordSuccess: 'تم إنقاذ كلمة المرور بنجاح',
          ),
          onRecoverPassword: _recoverPassword,
        ));
  }
}
