import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:naskhir/random_string.dart';
import 'package:naskhir/searchAll.dart';
import 'package:progress_dialog/progress_dialog.dart';
// import 'package:sms_maintained/sms.dart';
import 'alert.dart';
import 'db.dart';
import 'loginUI.dart';
import 'loginUI2.dart';
import 'nav.dart';
import 'netState.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;

// SmsSender sender = SmsSender();
// sendSms(address, msg) {
//   SmsMessage message = SmsMessage(
//     address,
//     msg,
//   );

// message.onStateChanged.listen((state) async{
//   if (state == SmsMessageState.Sent) {
//     print("SMS is sent!");
//   } else if (state == SmsMessageState.Delivered) {
//     print("SMS is delivered!");
//     // if(await smsRemover.removeSmsById(message.id, message.threadId)){
//     // print("SMS is X");

//     // }
//   }
// });
//   sender.sendSms(message);
// }

class Menu extends StatefulWidget {
  bool add;
  Menu({this.add = false});
  @override
  _MenuState createState() => new _MenuState();
}

class _MenuState extends State<Menu> {
  var _formkey = GlobalKey<FormState>();
  var _formkey2 = GlobalKey<FormState>();
  DB db = new DB();
  bool _sms = false;
  late String _fname, _phone, _positeDate, _nextPositeDate, _prix, _smsTxt;
  late ProgressDialog pr;
  TextEditingController _cfname = TextEditingController();
  TextEditingController _cphone = TextEditingController();
  TextEditingController _cpositeDate = TextEditingController();
  TextEditingController _cnextPositeDate = TextEditingController();
  TextEditingController _cPrix = TextEditingController();
  TextEditingController _csms = TextEditingController();
  var maskTextInputFormatter = MaskTextInputFormatter(
      mask: "##-##-####", filter: {"#": RegExp(r'[0-9]')});
  var maskTextInputFormatter2 = MaskTextInputFormatter(
      mask: "##-##-####", filter: {"#": RegExp(r'[0-9]')});
  final FirebaseMessaging dbMsg = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final String serverToken =
      "AAAAj6Cyvng:APA91bENrwHlkauLFLnA91lACnHvq0UVaexYxKA8jXiqLIj7zv6DCkmW2bLqf90mOmk5G6Uez8Rzcxtsyfh9_g0ZNS7eO4ihiJu939XzrBJl7Ad8PRDEFxjpDeuROY3YZAwb-QHW4-IU";
  List<Widget> DLA = [];
  List<String> DLAnumber = [];
  List<Widget> newDonatersList = [];
  List<String> donatersList = [];
  int notifNum = 0;
  int notifNewDonaters = 0;
  String donater = 'الإسم';
  late bool rm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = new ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal);

    setState(() {
      _fname = '';
      _positeDate = '';
      _nextPositeDate = '';
      _phone = '';
      _prix = '';
      rm = false;
    });

    init();
    //  if (!widget.add) {
    // dbMsg.subscribeToTopic("12345678");
    initCloudMsg();
    showNotification();
    //  }
//  dbMsg.getToken().then((token){
//   //  db.updateData("thanks", "donaters", {"token":token});
//         //print("*"*100);
//         //print(token);
//         //print("*"*100);

// //  });
//     dbMsg.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         if (message['notification']['title'] == "adminx") {
//           playLocalAsset();
//           for (var address
//               in message['notification']['body'].split("#").toList()) {
//             //  sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");
//           }
//         }
//       },
//       onBackgroundMessage: myBackgroundMessageHandler,
//       onLaunch: (Map<String, dynamic> message) async {
//         if (message['notification']['title'] == "adminx") {
//           playLocalAsset();
//           for (var address
//               in message['notification']['body'].split("#").toList()) {
//             //  sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");
//           }
//         }
//       },
//       onResume: (Map<String, dynamic> message) async {
//         if (message['notification']['title'] == "adminx") {
//           playLocalAsset();
//           for (var address
//               in message['notification']['body'].split("#").toList()) {
//             //  sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");
//           }
//         }
//       },
//     );
//     dbMsg.requestNotificationPermissions(
//         const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp();

  //   Alert(
  //           context: context,
  //           title: 'مسؤول جمعية ناس الخير رقان',
  //           message: message.data.values.toString(),
  //           info: true)
  //       .show();
  // }

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
      return Menu(
        add: false,
      );
    }));
  }

  showNotification() async {
    await Firebase.initializeApp();
    // var android = AndroidNotificationDetails(
    //     'high_importance_channel', 'A3Channel.com/channel01', 'mic',
    //     priority: Priority.High,
    //     importance: Importance.Max,
    //     playSound: true,
    //     sound: 'notif');
    // var iOS = IOSNotificationDetails();
    // var platform = new NotificationDetails(android, iOS);
    // await flutterLocalNotificationsPlugin.show(
    //     0, 'logo', 'Flutter Local Notification Demo', platform,
    //     payload: 'Welcome to the Local Notification demo');
    Future.delayed(Duration(seconds: 1), () {
      // FirebaseMessaging.onBackgroundMessage(
      //     _firebaseMessagingBackgroundHandler);
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

  init() async {
    var now = new DateTime.now();
    int month = now.month;
    String mm;
    if (month < 10) {
      mm = "0" + month.toString();
    } else {
      mm = month.toString();
    }
    setState(() {
      DLA.clear();
      DLAnumber.clear();
      newDonatersList.clear();
    });

    db.getDatagroup("donaters").then((snap) {
      if (snap != 'error') {
        for (var item in snap.docs) {
          donatersList.add(item.id.toString());
          db.getData(item.id.toString(), "donaters").then((snapx) {
            //  print("_"*100);
            //  print("${now.day}-$mm-${now.year}");
            //  print("_"*100);

            if (snapx.get("nextPositeDate") == "${now.day}-$mm-${now.year}") {
              //  sendSms(snapx.get("phone"), "تذكير دفع الاشتراك بجمعية ناس الخير");
              setState(() {
                notifNum++;
                DLAnumber.add(snapx.get("phone"));
                DLA.add(Card(
                    color: Colors.white,
                    elevation: 3.0,
                    child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.notifications_active,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        title: Column(children: [
                          Text(snapx.id,
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold)),
                          Text(
                            snapx.get("phone"),
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ]))));
              });
            }
          });
        }
      }
    });

    db.getDatagroup("newDonaters").then((snap) {
      if (snap != 'error') {
        for (var item in snap.docs) {
          db.getData(item.id.toString(), "newDonaters").then((snapx) {
            setState(() {
              notifNewDonaters++;
              newDonatersList.add(Card(
                  color: Colors.white,
                  elevation: 3.0,
                  child: ListTile(
                    title: Column(children: [
                      Text(snapx.id,
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.bold)),
                      Text(
                        snapx.get("phone"),
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ]),
                    leading: InkWell(
                      child: CircleAvatar(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onTap: () {
                        newDonatersList.removeAt(notifNewDonaters);
                        Map<String, dynamic> formData = {
                          'fullName': snapx.get("fullName"),
                          'phone': snapx.get("phone"),
                          'positeDate': "بداية الإشتراك",
                          'nextPositeDate': "بداية الإشتراك",
                        };
                        db.setData(
                            'بداية الإشتراك',
                            "donaters/${snapx.get("fullName")}/dates",
                            formData);
                        db.setData(
                            '${snapx.get("fullName")}', "donaters", formData);
                        db.deleteDataDoc(
                          "newDonaters",
                          '${snapx.get("fullName")}',
                        );
                        donatersList.add(snapx.get("fullName").toString());
                        sendAndRetrieveMessage(snapx.get("phone"), "");
                        //  sendSms(snapx.get("phone"),"تم قبول طلب الاشتراك في جمعية ناس الخير");
                        pr.hide();
                        pr.style(
                            message: 'تم التسجيل بنجاح',
                            progressWidget: Image.asset('images/done.gif'),
                            textAlign: TextAlign.center);
                        pr.show().then((stat) {
                          _cfname.text = snapx.get("fullName");
                          _cphone.text = snapx.get("phone");
                          init();
                          // _cpositeDate.text = "";
                          // _cnextPositeDate.text = "";
                          sleep();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  )));
            });
          });
        }
      }
    });
  }

  addAllNewDonaters() {
    pr.style(
        message: '...التسجيل ',
        progressWidget: Image.asset('images/done.gif'),
        textAlign: TextAlign.center);
    pr.show().then((stat) {
      db.getDatagroup("newDonaters").then((snap) {
        if (snap != 'error') {
          for (var item in snap.docs) {
            db.getData(item.id.toString(), "newDonaters").then((snapx) {
              setState(() {
                Map<String, dynamic> formData = {
                  'fullName': snapx.get("fullName"),
                  'phone': snapx.get("phone"),
                  'positeDate': "بداية الإشتراك",
                  'nextPositeDate': "بداية الإشتراك",
                };
                db.setData('بداية الإشتراك',
                    "donaters/${snapx.get("fullName")}/dates", formData);
                db.setData('${snapx.get("fullName")}', "donaters", formData);
                db.deleteDataDoc(
                  "newDonaters",
                  '${snapx.get("fullName")}',
                );
                donatersList.add(snapx.get("fullName").toString());
                sendAndRetrieveMessage(snapx.get("phone"), "");
                //  sendSms(snapx.get("phone"),"تم قبول طلب الاشتراك في جمعية ناس الخير");

                _cfname.text = snapx.get("fullName");
                _cphone.text = snapx.get("phone");
                init();
                // _cpositeDate.text = "";
                // _cnextPositeDate.text = "";
                sleep();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            });
          }
        }
      }).whenComplete(() {
        newDonatersList.clear();
        pr.hide();
        pr.style(
            message: 'تم التسجيل بنجاح',
            progressWidget: Image.asset('images/done.gif'),
            textAlign: TextAlign.center);
        pr.show().whenComplete(() => sleep());
      });
    });
  }

  // Future<AudioPlayer> playLocalAsset() async {
  //   AudioCache cache = new AudioCache();
  //   return await cache.play("notif.wav");
  // }

  _onBackPressed() {
    if (widget.add) {
      Nav().nav(LoginUI2(), context);
    } else {
      Nav().nav(LoginUI(), context);
    }
    //  Navigator.of(context).push(new MaterialPageRoute(
    // builder: (BuildContext context)=> new LoginUI()));
  }

  Future sleep() {
    return new Future.delayed(const Duration(seconds: 2), () {
      pr.hide();
      // Nav().nav(LoginUI(), context);
    });
  }

  sendAndRetrieveMessage(token, smsMsg) async {
    //  await dbMsg.requestNotificationPermissions(
    //    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    //  );
    try {
      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAj6Cyvng:APA91bENrwHlkauLFLnA91lACnHvq0UVaexYxKA8jXiqLIj7zv6DCkmW2bLqf90mOmk5G6Uez8Rzcxtsyfh9_g0ZNS7eO4ihiJu939XzrBJl7Ad8PRDEFxjpDeuROY3YZAwb-QHW4-IU',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': smsMsg == ""
                  ? "تم قبول طلب الاشتراك في جمعية ناس الخير"
                  : smsMsg,
              'title': 'ناس الخير',
              "sound": "notif.wav",
              "android_channel_id": "CHAT_MESSAGES",
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': 100,
              'status': 'done',
              "extradata": "تذكير الاشتراك بجمعية ناس الخير ",
            },
            'to': '/topics/$token',
            // 'to':  "fSJ9BoIpQ-eLRWlUI-kSy-:APA91bEOLNF-X078-P7aXiSix_GpcHvbnl49aJoMcUBIQzrUCe6Qt6V0iVXqj9IkKy93198E9vPb2ukB-ZWfVpfDDesuI_Tv2OWi0cZm4J4EIAmEdAuZ4NcaaXl1MW890UTWsnLL1Xr0",
            //  'to': token,
          },
        ),
      );

//   final Completer<Map<String, dynamic>> completer =
//      Completer<Map<String, dynamic>>();
//
//   dbMsg.configure(
//     onMessage: (Map<String, dynamic> message) async {
//       completer.complete(message);
//     },
//   );
//
//   return completer.future;

    } catch (e) {
      return Alert(
              context: context,
              title: "خطأ",
              message: ":(  تحقق من شبكتك ",
              info: true)
          .show();
    }
  }

  _next(bool remove) {
    final formState = _formkey.currentState;

    setState(() {
      if (formState!.validate()) {
        try {
          NetState().isConnected().then((state) async {
            if (state) {
              pr.style(
                  message: '...تسجيل ',
                  progressWidget: Image.asset(
                    'images/ring.gif',
                  ),
                  textAlign: TextAlign.center);
              pr.show().then((stat) {
                formState.save();

                if (remove) {
                  db.deleteDataDoc('donaters', '$_fname');
                  pr.hide();
                  pr.style(
                      message: 'تم الحذف بنجاح',
                      progressWidget: Image.asset('images/done.gif'),
                      textAlign: TextAlign.center);
                } else {
                  if (widget.add) {
                    bool existe = false;
                    int i = 1;
                    db.getDatagroup("donaters").then((snp) {
                      for (var itm in snp.docs) {
                        db.getData(itm.id, "donaters").then((snpx) {
                          if (_phone == snpx.get("phone")) {
                            setState(() {
                              existe = true;
                            });
                          }
                          setState(() {
                            i++;
                          });
                        }).whenComplete(() {
                          //    print("*"*100);
                          //     print(existe);
                          //     print(i );
                          //     print( snp.docs.length);
                          // print("*"*100);
                          if (existe && i == snp.docs.length) {
                            pr.hide();
                            pr.style(
                                message: 'هذا الرقم مسجل',
                                progressWidget: Image.asset('images/error.gif'),
                                textAlign: TextAlign.center);
                            pr.show().then((stat) {
                              setState(() {
                                _cfname.text = "";
                                _cphone.text = "";
                                _cpositeDate.text = "";
                                _cnextPositeDate.text = "";
                                rm = false;
                                sleep();
                              });
                            });
                          } else if (i == snp.docs.length) {
                            Map<String, dynamic> formData = {
                              'fullName': _fname,
                              'phone': _phone,
                            };
                            //         fname = fname.trim();
                            //   List<String> _e = fname.split("");
                            //  _e.removeWhere((element) => element==" ");
                            //  fname = _e.join("");

                            db.setData('$_fname', "newDonaters", formData);
                            dbMsg.subscribeToTopic(_phone);
                            pr.hide();
                            pr.style(
                                message: 'تم التسجيل بنجاح',
                                progressWidget: Image.asset('images/done.gif'),
                                textAlign: TextAlign.center);
                            pr.show().then((stat) {
                              setState(() {
                                _cfname.text = "";
                                _cphone.text = "";
                                _cpositeDate.text = "";
                                _cnextPositeDate.text = "";
                                rm = false;
                                sleep();
                              });
                            });
                          }
                        });
                      }
                    });
                  } else {
                    Map<String, dynamic> formData = {
                      'fullName': _fname,
                      'phone': _phone,
                      'positeDate': _positeDate,
                      'nextPositeDate': _nextPositeDate,
                      'montant': _prix,
                    };
                    db.setData(
                        '$_positeDate', "donaters/$_fname/dates", formData);
                    db.setData('$_fname', "donaters", formData);
                    pr.hide();
                    pr.style(
                        message: 'تم التسجيل بنجاح',
                        progressWidget: Image.asset('images/done.gif'),
                        textAlign: TextAlign.center);
                    pr.show().then((stat) {
                      setState(() {
                        _cfname.text = "";
                        _cphone.text = "";
                        _cpositeDate.text = "";
                        _cnextPositeDate.text = "";
                        _cPrix.text = "";
                        rm = false;
                        init();
                        sleep();
                      });
                    });
                  }
                }
              });
            }
          });
        } catch (_) {
          pr.hide().then((_) => Alert(
                context: context,
                title: "خطأ",
                message: "تعذر الإتصال بالسرفر",
                info: true,
              ).show());
        }
      }

      // Alert(context:context,title:"خطأ" , message:"نسيت أحد الحقول فارغا أو ام لم يحدد",info:true,).show();
    });
  }

  bool aff = false;

  List<Widget> dates = [];
  _search(context, bool history, bool sms, bool _checkbtn) {
    // flutter defined function
    setState(() {
      _sms = sms;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0),
              backgroundColor: Color.fromARGB(255, 36, 52, 71),
              shape: Border.all(color: Colors.orange, width: 2),
              // elevation: 10.0,
              // titleTextStyle: TextStyle(color:Colors.white,fontSize: 30.0,fontFamily: 'Hacen'),
              // contentTextStyle: TextStyle(color:Colors.white,fontSize: 20.0,fontFamily: 'Hacen'),
              // title: new Text(this.title != null ?this.title:""),
              content: !aff
                  ? Form(
                      key: _formkey2,
                      child: SingleChildScrollView(
                          child: Container(
                        height: sms ? 250 : 121,
                        child: Column(children: [
                          // Container(
                          //   margin: EdgeInsets.all(10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Container(
                          //         decoration: BoxDecoration(
                          //             border: Border.all(
                          //               color: Colors.purple[900],
                          //               style: BorderStyle.solid,
                          //               width: 0.7,
                          //             ),
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(10))),
                          //         child: Checkbox(
                          //             value: _checkbtn,
                          //             onChanged: (stat) {
                          //               setState(() {
                          //                 _checkbtn = stat;
                          //               });
                          //             }),
                          //       ),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          SizedBox(
                            height: 20,
                          ),
                          sms
                              ? Text(
                                  !_checkbtn
                                      ? "    إرسال للجميع    "
                                      : " إرسال للفرد",
                                  style: TextStyle(
                                      fontFamily: "Hacen",
                                      fontSize: 30.0,
                                      color: Colors.orange))
                              : Container(),
                          //     ],
                          //   ),
                          // ),
                          _checkbtn || history && !sms || !history && !sms
                              ? Container(
                                  width: 300.0,
                                  height: 60.0,
                                  margin: EdgeInsets.only(top: 1.0),
                                  // decoration: BoxDecoration(border:Border.all(style: BorderStyle.solid,width: 0.2,),
                                  //                 borderRadius: BorderRadius.all(Radius.circular(5)),color: Colors.blue[50]) ,//ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                                  padding: EdgeInsets.all(7.0),
                                  child: DropdownSearch<String>(
                                    //  textDirectionSearchBox: TextDirection.rtl,
                                    showSearchBox: true,
                                    // validator: (v) => v == null ? "يرجى اختيار  الاتجاه": null,
                                    // label: "الإسم الكامل",
                                    mode: Mode.DIALOG,
                                    showSelectedItem: true,
                                    items: donatersList,
                                    popupItemBuilder:
                                        (context, item, isSelected) {
                                      return Center(
                                          child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            style: BorderStyle.solid,
                                            width: 0.2,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Text(
                                            item,
                                            textAlign: TextAlign.right,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ));
                                    },
                                    // styleSearchBox: TextStyle(fontFamily: 'Hacen',fontSize: 20),
                                    searchBoxDecoration: InputDecoration(
                                        labelText: "الإسم الكامل",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.purple,
                                                style: BorderStyle.solid,
                                                width: 10.0))),
                                    //  dropdownSearchDecoration: InputDecoration(hintStyle: TextStyle(fontFamily: 'Hacen'), border:InputBorder.none,suffixIcon: Icon(Icons.arrow_drop_down,color: Colors.purple,),),
                                    showClearButton: false,
                                    onChanged: (newValue) {
                                      setState(() {
                                        donater = newValue.toString();
                                      });
                                    },

                                    // popupItemDisabled: (String s) => s.startsWith('I'),
                                    selectedItem: donater,
                                  ),
                                  //     child:TextFormField(
                                  //       style: TextStyle(fontFamily: "Hacen",fontSize: 15.0),
                                  //   keyboardType: TextInputType.text,
                                  //   validator: (input){
                                  //     if(input.isEmpty ){
                                  //       return "فارغ";
                                  //     }
                                  //   },
                                  //   onSaved: (input){ setState(() { donater = input!.trim() ; donater = donater.trimLeft(); donater = donater.trimRight(); });},
                                  //   //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                                  //   //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                                  //   decoration: InputDecoration(
                                  //     border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(5)) ),
                                  //         labelStyle: TextStyle(fontFamily: 'Hacen'),
                                  //     labelText: ' الاسم الكامل',
                                  //     //hintText: widget.userData != null?widget.userData.get("first name"):""
                                  //   ),
                                  // ),
                                )
                              : Container(),
                          sms
                              ? Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                    // height:
                                    // MediaQuery.of(context).size.height * 0.5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    // decoration: BoxDecoration(
                                    //   border: Border.all(
                                    //     color: Colors.black,
                                    //     style: BorderStyle.solid,
                                    //     width: 0.2,
                                    //   ),
                                    color: Colors.white,
                                    // ),
                                    padding: EdgeInsets.all(4.0),
                                    child: TextFormField(
                                      style: TextStyle(fontFamily: "Hacen"),
                                      keyboardType: TextInputType.text,
                                      controller: _csms,
                                      // expands: true,
                                      maxLines: 3,
                                      minLines: 1,
                                      validator: (input) {
                                        if (input!.isEmpty) {
                                          return "فارغ";
                                        }
                                      },
                                      onSaved: (input) {
                                        setState(() {
                                          _smsTxt = input!.trim();
                                        });
                                      },
                                      // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                                      //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          labelStyle:
                                              TextStyle(fontFamily: 'Hacen'),
                                          labelText: 'رسالة',
                                          counterText: ''),
                                    ),
                                  ))
                              : Container(),
                        ]),
                      )))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                          color: Colors.blueGrey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                donater,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Hacen",
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Column(children: dates)
                            ],
                          ))),
              actions: <Widget>[
                !aff
                    ? RaisedButton(
                        padding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(55.0),
                        ),
                        color: Colors.orange,
                        child: Center(
                          child: Text(
                            !sms ? "بحث" : "إرسال",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'Hacen',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        onPressed: () {
                          try {
                            NetState().isConnected().then((state) async {
                              final formState2 = _formkey2.currentState;
                              if (formState2!.validate()) {
                                if (state) {
                                  formState2.save();
                                  if (history) {
                                    dates.clear();
                                    db
                                        .getDatagroup("donaters/$donater/dates")
                                        .then((snap) {
                                      setState(() {
                                        for (var snapx in snap.docs) {
                                          db
                                              .getData(snapx.id,
                                                  "donaters/$donater/dates")
                                              .then((sna) {
                                            String prix = "";
                                            if (sna
                                                .data()
                                                .keys
                                                .contains('montant')) {
                                              prix = sna.get('montant') + " دج";
                                            }

                                            dates.add(Card(
                                                color: Colors.white,
                                                elevation: 3.0,
                                                child: ListTile(
                                                    leading: CircleAvatar(
                                                      child: Icon(
                                                        Icons.calendar_today,
                                                        color: Colors.white,
                                                      ),
                                                      backgroundColor:
                                                          Colors.blue,
                                                    ),
                                                    title: Column(children: [
                                                      Text(snapx.id,
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                        prix,
                                                        style: TextStyle(
                                                            fontSize: 15.0),
                                                      ),
                                                    ]))));
                                          });
                                        }
                                        aff = true;
                                        pr.style(
                                            message: '...بحث',
                                            progressWidget: Image.asset(
                                              'images/ring.gif',
                                            ),
                                            textAlign: TextAlign.center);
                                        pr.show().then((_) {
                                          sleep().whenComplete(() {
                                            _search(
                                                context, true, false, false);
                                            setState(() {
                                              rm = false;
                                            });
                                          });
                                        });
                                      });
                                    });
                                  } else {
                                    db
                                        .getData(donater, "donaters")
                                        .then((snap) {
                                      setState(() {
                                        rm = true;
                                        donater = 'الإسم';
                                      });
                                      if (!sms) {
                                        setState(() {
                                          _cfname.text = snap.get("fullName");
                                          _cphone.text = snap.get("phone");
                                          _cpositeDate.text =
                                              snap.get("positeDate");
                                          _cnextPositeDate.text =
                                              snap.get("nextPositeDate");
                                          _cPrix.text = snap.get("montant");
                                        });
                                      } else {
                                        if (_checkbtn) {
                                          pr.style(
                                              message: '...إرسال ',
                                              progressWidget: Image.asset(
                                                'images/ring.gif',
                                              ),
                                              textAlign: TextAlign.center);
                                          pr.show().then((stat) {
                                            sendAndRetrieveMessage(
                                                snap.get("phone"), _smsTxt);
                                            pr.hide();
                                            pr.style(
                                                message: 'تم الإرسال بنجاح',
                                                progressWidget: Image.asset(
                                                    'images/done.gif'),
                                                textAlign: TextAlign.center);
                                            pr.show().then((stat) {
                                              setState(() {
                                                donater = 'الإسم';
                                                _csms.text = "";
                                                _cfname.text = '';
                                                _cphone.text = '';
                                                _cpositeDate.text = '';
                                                _cnextPositeDate.text = '';
                                                _cPrix.text = '';
                                                rm = false;
                                                sleep();
                                              });
                                            });
                                          });
                                        } else {
                                          db
                                              .getDatagroup("donaters")
                                              .then((snap) {
                                            pr.style(
                                                message: '...إرسال ',
                                                progressWidget: Image.asset(
                                                  'images/ring.gif',
                                                ),
                                                textAlign: TextAlign.center);
                                            pr.show().then((stat) {
                                              for (var item in snap.docs) {
                                                db
                                                    .getData(item.id.toString(),
                                                        "donaters")
                                                    .then((snapx) {
                                                  sendAndRetrieveMessage(
                                                      snapx.get("phone"),
                                                      _smsTxt);
                                                });
                                              }
                                              pr.hide();
                                              pr.style(
                                                  message: 'تم الإرسال بنجاح',
                                                  progressWidget: Image.asset(
                                                      'images/done.gif'),
                                                  textAlign: TextAlign.center);
                                              pr.show().then((stat) {
                                                setState(() {
                                                  _csms.text = "";
                                                  rm = false;
                                                  _cfname.text = '';
                                                  _cphone.text = '';
                                                  _cpositeDate.text = '';
                                                  _cnextPositeDate.text = '';
                                                  _cPrix.text = '';
                                                  sleep();
                                                });
                                              });
                                            });
                                          });
                                        }
                                      }
                                    });
                                    Navigator.of(context).pop();
                                  }
                                }
                              }
                            });
                          } catch (e) {
                            pr.hide().then((_) => Alert(
                                  context: context,
                                  title: "خطأ",
                                  message: "تعذر الإتصال بالسرفر",
                                  info: true,
                                ).show());
                          }
                        },
                      )
                    : Container(),
                RaisedButton(
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(55.0),
                  ),
                  color: Colors.orange,
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
                    aff = false;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _notif(context, bool newDonaters) {
    setState(() {
      if (newDonaters) {
        notifNewDonaters = 0;
      } else {
        notifNum = 0;
      }
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: Color.fromARGB(255, 36, 52, 71),
              shape: Border.all(color: Colors.orange, width: 2),
              contentPadding: EdgeInsets.all(0),
              title: Text(
                !newDonaters
                    ? "إشعارات تجديد الإشتراك"
                    : "إشعارات طلبات التسجيل",
                textAlign: TextAlign.center,
              ),
              titleTextStyle: TextStyle(
                  fontFamily: "Hacen",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 2.5,
                    ),
                    color: Colors.blueGrey),
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    children: !newDonaters ? DLA : newDonatersList,
                  ),
                ),
              ),
              // SingleChildScrollView(
              // padding: EdgeInsets.all(10.0),
              // child:Column(
              //   children: !newDonaters?DLA:newDonatersList

              //   )
              // ),
              actions: <Widget>[
                RaisedButton(
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.orange,
                  child: Center(
                    child: new Text(
                      !newDonaters ? "  إرسال SMS " : '   قبول الكل   ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Hacen',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  onPressed: !newDonaters
                      ? () {
                          pr.style(
                              message: 'تم إرسال \n ${DLA.length} SMS مشتركين',
                              progressWidget: Image.asset('images/done.gif'),
                              textAlign: TextAlign.center);
                          pr.show().whenComplete(() => sleep());
                        }
                      : () => addAllNewDonaters(),
                ),
                RaisedButton(
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.orange,
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
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onBackPressed(),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Colors.blueGrey,
                body: Form(
                  key: _formkey,

                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        !widget.add
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: InkWell(
                                        onTap: _onBackPressed,
                                        child: Icon(
                                          Icons.exit_to_app,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: InkWell(
                                          onTap: () => _notif(context, false),
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              Icon(
                                                Icons.notifications,
                                                size: 30,
                                                color: Colors.green,
                                              ),
                                              Positioned(
                                                  width: 20,
                                                  height: 20,
                                                  top: 1,
                                                  right: 2,
                                                  child: notifNum != 0
                                                      ? CircleAvatar(
                                                          child: Text(
                                                              notifNum
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          backgroundColor:
                                                              Colors.red)
                                                      : Container()),
                                            ],
                                          )),
                                    ),
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: InkWell(
                                          onTap: () => _notif(context, true),
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              Icon(
                                                Icons.people,
                                                size: 30,
                                                color: Colors.green,
                                              ),
                                              Positioned(
                                                  width: 20,
                                                  height: 20,
                                                  top: 1,
                                                  right: 2,
                                                  child: notifNewDonaters != 0
                                                      ? CircleAvatar(
                                                          child: Text(
                                                              notifNewDonaters
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          backgroundColor:
                                                              Colors.red)
                                                      : Container()),
                                            ],
                                          )),
                                    ),
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: InkWell(
                                        onTap: () => _search(
                                            context, true, false, false),
                                        child: Icon(
                                          Icons.history,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: InkWell(
                                        onTap: () => _search(
                                            context, false, false, false),
                                        child: Icon(
                                          Icons.search,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: InkWell(
                                        onTap: () =>
                                            Nav().nav(SearchAll(), context),
                                        child: Icon(
                                          Icons.library_books,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: InkWell(
                                          onTap: () => _search(
                                              context, false, true, false),
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              Icon(
                                                Icons.people,
                                                size: 30,
                                                color: Colors.green,
                                              ),
                                              Positioned(
                                                width: 20,
                                                height: 20,
                                                top: 1,
                                                right: 2,
                                                child: Icon(
                                                  Icons.message,
                                                  size: 20,
                                                  color: Colors.orange,
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: InkWell(
                                          onTap: () => _search(
                                              context, false, true, true),
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 30,
                                                color: Colors.green,
                                              ),
                                              Positioned(
                                                width: 20,
                                                height: 20,
                                                top: 1,
                                                right: 2,
                                                child: Icon(
                                                  Icons.message,
                                                  size: 20,
                                                  color: Colors.orange,
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ])
                            : Container(),
                        const SizedBox(height: 10),
                        Center(
                          child: Image.asset(
                            "images/logo.png",
                            width: 150,
                            height: 150,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 300.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                style: BorderStyle.solid,
                                width: 0.2,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.blue[
                                  50]), //ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                          padding: EdgeInsets.all(4.0),
                          child: TextFormField(
                            style:
                                TextStyle(fontFamily: "Hacen", fontSize: 15.0),
                            keyboardType: TextInputType.text,
                            controller: _cfname,
                            validator: (input) {
                              if (input!.isEmpty) {
                                return "فارغ";
                              }
                            },
                            onSaved: (input) {
                              setState(() {
                                _fname = input!.trim();
                              });
                            },
                            //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                            //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              labelStyle: TextStyle(fontFamily: 'Hacen'),
                              labelText: ' الاسم الكامل',
                              //hintText: widget.userData != null?widget.userData.get("first name"):""
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 300.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                style: BorderStyle.solid,
                                width: 0.2,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.blue[
                                  50]), //ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                          padding: EdgeInsets.all(4.0),
                          child: TextFormField(
                            style: TextStyle(fontFamily: "Hacen"),
                            keyboardType: TextInputType.phone,
                            controller: _cphone,
                            maxLength: 10,
                            validator: (input) {
                              if (input!.isEmpty) {
                                return "فارغ";
                              }
                            },
                            onSaved: (input) {
                              setState(() {
                                _phone = input!.trim();
                              });
                            },
                            // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                            //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                labelStyle: TextStyle(fontFamily: 'Hacen'),
                                labelText: 'رقم الهاتف',
                                counterText: ''),
                          ),
                        ),
                        const SizedBox(height: 10),
                        !widget.add
                            ? Container(
                                width: 300.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      width: 0.2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.blue[
                                        50]), //ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                                padding: EdgeInsets.all(4.0),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontFamily: "Hacen", fontSize: 15.0),
                                  keyboardType: TextInputType.number,
                                  controller: _cpositeDate,
                                  maxLength: 10,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return "فارغ";
                                    }
                                  },
                                  onSaved: (input) {
                                    setState(() {
                                      _positeDate = input!.trim();
                                    });
                                  },
                                  //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                                  //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                                  inputFormatters: [maskTextInputFormatter],
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      labelStyle:
                                          TextStyle(fontFamily: 'Hacen'),
                                      labelText: 'تاريخ دفع الإشتراك',
                                      hintText: '01-01-2020',
                                      hintStyle:
                                          TextStyle(color: Colors.black26),
                                      counterText: ''),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 20),
                        !widget.add
                            ? Container(
                                width: 300.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      width: 0.2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.blue[
                                        50]), //ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                                padding: EdgeInsets.all(4.0),
                                child: TextFormField(
                                  style: TextStyle(fontFamily: "Hacen"),
                                  keyboardType: TextInputType.number,
                                  controller: _cnextPositeDate,
                                  inputFormatters: [maskTextInputFormatter2],
                                  maxLength: 10,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return "فارغ";
                                    }
                                  },
                                  onSaved: (input) {
                                    setState(() {
                                      _nextPositeDate = input!.trim();
                                    });
                                  },
                                  // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                                  //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      labelStyle:
                                          TextStyle(fontFamily: 'Hacen'),
                                      labelText: 'تاريخ تجديد الإشتراك',
                                      hintText: '01-01-2020',
                                      hintStyle:
                                          TextStyle(color: Colors.black26),
                                      counterText: ''),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 20),
                        !widget.add
                            ? Container(
                                width: 300.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      width: 0.2,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.blue[
                                        50]), //ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                                padding: EdgeInsets.all(4.0),
                                child: TextFormField(
                                  style: TextStyle(fontFamily: "Hacen"),
                                  keyboardType: TextInputType.number,
                                  controller: _cPrix,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return "فارغ";
                                    }
                                  },
                                  onSaved: (input) {
                                    setState(() {
                                      _prix = input!.trim();
                                    });
                                  },
                                  // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                                  //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    labelStyle: TextStyle(fontFamily: 'Hacen'),
                                    labelText: 'مبلغ الإشتراك' + '  (دج)',
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 20),
                        !rm || _sms
                            ? RaisedButton(
                                onPressed: () => _next(false),
                                padding: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(55.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(0.0),
                                  height: 50.0,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        width: 0.5,
                                      ),
                                      color: Colors.green,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                    child: Text(!widget.add ? 'حفظ' : "تسجيل",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Hacen",
                                            fontSize: 20)),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                    onPressed: () => _next(false),
                                    padding: const EdgeInsets.all(0.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(55.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(0.0),
                                      height: 50.0,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            style: BorderStyle.solid,
                                            width: 0.5,
                                          ),
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Center(
                                        child: Text(
                                            !widget.add ? 'حفظ' : "تسجيل",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Hacen",
                                                fontSize: 20)),
                                      ),
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      _next(true);
                                    },
                                    padding: const EdgeInsets.all(0.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(55.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(0.0),
                                      width: 150,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            style: BorderStyle.solid,
                                            width: 0.5,
                                          ),
                                          color: Colors.redAccent[200],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Center(
                                        child: Text('حذف',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Hacen",
                                                fontSize: 20)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        widget.add
                            ? RaisedButton(
                                onPressed: () {
                                  Nav().nav(LoginUI2(), context);
                                },
                                padding: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(55.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(0.0),
                                  height: 50.0,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        width: 0.5,
                                      ),
                                      color: Colors.redAccent[200],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                    child: Text('خروج',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Hacen",
                                            fontSize: 20)),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ), //
                ), // This trai
              )),
        ));
  }
}

//   Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//   if (message.containsKey('data')) {
//     // Handle data message

//     final dynamic data = message['data'];
//   }

//   if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//            ////////////print("onLaunch: $message");
//         @override
//         Widget build(BuildContext context){
//           return Alert(context:context,title:'ناس الخير',message:message['data']['extradata'],info:false, yesFunction: (){
//             Navigator.of(context).pop();
//           }).show() ;
//         }
//   }

//   // Or do other work.
// }
// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//   Future<AudioPlayer> playLocalAsset() async {
//     AudioCache cache = new AudioCache();
//     return await cache.play("notif.wav");
//   }

//   if (message.containsKey('data')) {
//     // Handle data message
//     // playLocalAsset();
//     // final dynamic data = message['data'];
//     if (message['notification']['title'] == "adminx") {
//       playLocalAsset();
//       for (var address in message['notification']['body'].split("#").toList()) {
//         // sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");
//         print(address);
//       }
//     }
//   }

//   if (message.containsKey('notification')) {
//     if (message['notification']['title'] == "adminx") {
//       playLocalAsset();
//       for (var address in message['notification']['body'].split("#").toList()) {
//         // sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");
//         print(address);
//       }
//     }
//     // playLocalAsset();
//     // // Handle notification message
//     // final dynamic notification = message['notification'];
//     //        ////////////print("onLaunch: $message");
//     //     @override
//     //     Widget build(BuildContext context){
//     //        return   Alert(context:context,title:'ناس الخير',message:message['data']['extradata'],info:false, yesFunction: (){
//     //         Navigator.of(context).pop();
//     //       }).show() ;
//     //     }
//   }

// //  final assetsAudioPlayer = AssetsAudioPlayer();

// //     assetsAudioPlayer.open(
// //         Audio("assets/notif.wav"),
// //     );

//   // //print("sound played");

//   // return null;

//   // Or do other work.
// }
