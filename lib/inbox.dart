// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:twiza/loginUI2.dart';
// import 'package:twiza/random_string.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'alert.dart';
import 'alert.dart';
import 'db.dart';
// import 'loginUI.dart';
import 'nav.dart';
// import 'netState.dart';
// import 'package:http/http.dart' as http;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Inbox extends StatefulWidget {
  String name, phone;
  Inbox({required this.name, required this.phone});
  @override
  _InboxState createState() => new _InboxState();
}

class _InboxState extends State<Inbox> {
  String notif = "";
  DB db = new DB();
  final FirebaseMessaging dbMsg = FirebaseMessaging.instance;
  // final String serverToken = "AAAAj6Cyvng:APA91bENrwHlkauLFLnA91lACnHvq0UVaexYxKA8jXiqLIj7zv6DCkmW2bLqf90mOmk5G6Uez8Rzcxtsyfh9_g0ZNS7eO4ihiJu939XzrBJl7Ad8PRDEFxjpDeuROY3YZAwb-QHW4-IU";
  String nextPositeDate = "";
  String positeDate = "";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = new DateTime.now();
    int month = now.month;
    String mm = '';

    if (month < 10) {
      mm = "0" + month.toString();
    }

//  dbMsg.getToken().then((token){
//   //  db.updateData("thanks", "donaters", {"token":token});
//         print("*"*100);
//         print(token);
//         print("*"*100);

//  });
    db.getData(widget.name, "donaters").then((snap) {
      setState(() {
        nextPositeDate = snap.get("nextPositeDate");
        positeDate = snap.get("positeDate");
      });
      if (snap.get("nextPositeDate") == "${now.day}-$mm-${now.year}") {
        setState(() {
          notif = "تذكير الاشتراك بجمعية ناس الخير";
        });
      }
    });

    dbMsg.subscribeToTopic(widget.phone);
    // var i =0;
    initCloudMsg();
    showNotification();
    // dbMsg.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     playLocalAsset();
    //     setState(() {
    //       notif = message['notification']['body'];
    //     });
    //   },
    //   onBackgroundMessage: myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     playLocalAsset();
    //     setState(() {
    //       notif = message['notification']['body'];
    //     });
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     playLocalAsset();
    //     setState(() {
    //       notif = message['notification']['body'];
    //     });
    //   },
    // );
    // dbMsg.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  initCloudMsg() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('logo');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Inbox(name: widget.name, phone: widget.phone);
    }));
  }

  showNotification() async {
    Future.delayed(Duration(seconds: 1), () {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                  AndroidNotificationDetails('high_importance_channel',
                      "A3Channel.com/channel01", 'mic',
                      icon: 'logo', sound: 'notif'
                      // other properties...
                      ),
                  IOSNotificationDetails()));
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          Alert(
                  context: context,
                  title: 'مسؤول جمعية ناس الخير رقان',
                  message: notification.body.toString(),
                  info: true)
              .show();
        }
      });
    });
  }

  _onBackPressed() {
    Nav().nav(LoginUI2(), context);
    //  Navigator.of(context).push(new MaterialPageRoute(
    // builder: (BuildContext context)=> new LoginUI()));
  }

//      sendAndRetrieveMessage(token) async {
//   //  await dbMsg.requestNotificationPermissions(
//   //    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
//   //  );
//    try {
//    await http.post(
//      'https://fcm.googleapis.com/fcm/send',
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'key=AAAAj6Cyvng:APA91bENrwHlkauLFLnA91lACnHvq0UVaexYxKA8jXiqLIj7zv6DCkmW2bLqf90mOmk5G6Uez8Rzcxtsyfh9_g0ZNS7eO4ihiJu939XzrBJl7Ad8PRDEFxjpDeuROY3YZAwb-QHW4-IU',
//       },
//       body: jsonEncode(
//       <String, dynamic>{
//         'notification': <String, dynamic>{
//           'body': "تذكير الاشتراك بجمعية ناس الخير",
//           'title': 'ناس الخير'
//         },
//         'priority': 'high',
//         'data': <String, dynamic>{
//           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//           'id': randomNumeric(6).toString(),
//           'status': 'done',
//           "extradata": "تذكير الاشتراك بجمعية ناس الخير ",
//         },
//         // 'to': '/topics/AAA',
//        // 'to':  "fSJ9BoIpQ-eLRWlUI-kSy-:APA91bEOLNF-X078-P7aXiSix_GpcHvbnl49aJoMcUBIQzrUCe6Qt6V0iVXqj9IkKy93198E9vPb2ukB-ZWfVpfDDesuI_Tv2OWi0cZm4J4EIAmEdAuZ4NcaaXl1MW890UTWsnLL1Xr0",
//        'to': token,
//       },
//      ),
//    );

// //   final Completer<Map<String, dynamic>> completer =
// //      Completer<Map<String, dynamic>>();
// //
// //   dbMsg.configure(
// //     onMessage: (Map<String, dynamic> message) async {
// //       completer.complete(message);
// //     },
// //   );
// //
// //   return completer.future;

//    } catch (e) {
//   return   Alert(context: context, title:"خطأ", message:":(  تحقق من شبكتك ",info:true).show();
//    }

//  }

  // Future<AudioPlayer> playLocalAsset() async {
  //   AudioCache cache = new AudioCache();
  //   return await cache.play("notif.wav");
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            // fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.4), BlendMode.dstATop),
                      image: AssetImage("images/notif.jpg")),
                ),
              ),
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Image.asset(
                  "images/logo.png",
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: 20,
                  right: 20,
                  child: Card(
                      elevation: 10.0,
                      // shadowColor: Colors.black45,
                      child: Container(
                          color: Color.fromARGB(255, 20, 29, 38),
                          width: MediaQuery.of(context).size.width * 0.25,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(0),
                          child: Center(
                              child: Text(
                            "حساب جمعية ناس الخير رقان\n" +
                                'BaridiMob: 00799999002100841241 \n CCP: 21008412 /41',
                            style: TextStyle(color: Colors.orange),
                            textAlign: TextAlign.center,
                          ))))),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.55,
                right: MediaQuery.of(context).size.width * 0.02,
                left: MediaQuery.of(context).size.width * 0.02,
                child: Card(
                  color: Colors.white,
                  elevation: 3.0,
                  child: ListTile(
                    leading: Text("الإسم:",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Hacen",
                          color: Colors.indigo,
                        )),
                    title: Text(widget.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Hacen",
                          color: Colors.indigo,
                        )),
                    trailing: Icon(
                      Icons.account_box,
                      size: 30,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.65,
                right: MediaQuery.of(context).size.width * 0.02,
                left: MediaQuery.of(context).size.width * 0.02,
                child: Card(
                  color: notif == "" ? Colors.blue[200] : Colors.orange[200],
                  elevation: 3.0,
                  child: ListTile(
                    leading: Icon(
                      Icons.alarm_on,
                      size: 20,
                    ),
                    title: Text(notif == "" ? "لايوجد" : notif,
                        style: TextStyle(fontSize: 30, fontFamily: "Hacen")),
                    trailing: Icon(Icons.calendar_today),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.75,
                right: MediaQuery.of(context).size.width * 0.02,
                left: MediaQuery.of(context).size.width * 0.02,
                child: Card(
                  color: Colors.orange,
                  elevation: 3.0,
                  child: Container(
                    height: 70.0,
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("تاريخ الاشتراك:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Hacen",
                                      color: Colors.white)),
                              Text(positeDate,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Hacen",
                                      color: Colors.white)),
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("تاريخ  تجديد الاشتراك:",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Hacen",
                                    color: Colors.white)),
                            Text(nextPositeDate,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Hacen",
                                    color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.9,
                right: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.1,
                child: RaisedButton(
                  onPressed: () => _onBackPressed(),
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(55.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(0.0),
                    height: 50.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                          // color: Colors.blue[50],
                          style: BorderStyle.solid,
                          width: 0.5,
                        ),
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Text('خروج',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Hacen",
                              fontSize: 20)),
                    ),
                  ),
                ),
              ),
            ],
          ), //
        ), //
      ),
    );
  }
}

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//   Future<AudioPlayer> playLocalAsset() async {
//     AudioCache cache = new AudioCache();
//     return await cache.play("notif.wav");
//   }

//   if (message.containsKey('data')) {
//     // Handle data message
//     playLocalAsset();
//     final dynamic data = message['data'];
//   }

//   if (message.containsKey('notification')) {
//     playLocalAsset();
//     // Handle notification message
//     final dynamic notification = message['notification'];
//     //////////print("onLaunch: $message");
//     @override
//     Widget build(BuildContext context) {
//       return Alert(
//           context: context,
//           title: 'ناس الخير',
//           message: message['data']['extradata'],
//           info: false,
//           yesFunction: () {
//             Navigator.of(context).pop();
//           }).show();
//     }
//   }

// //  final assetsAudioPlayer = AssetsAudioPlayer();

// //     assetsAudioPlayer.open(
// //         Audio("assets/notif.wav"),
// //     );

//   // print("sound played");

//   // return null;

//   // Or do other work.
// }
