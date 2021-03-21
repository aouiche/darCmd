import 'dart:async';
import 'dart:io';
import 'package:workmanager/workmanager.dart';
import 'package:darcmd/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'local_notif.dart';
import 'netState.dart';

String _timer = '';
String _numOfTime = '';
BuildContext _context;
var _formkey = GlobalKey<FormState>();

StreamController<String> streamController = new StreamController.broadcast();

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    LocalNotification.Initializer();
    LocalNotification(title: 'test', body: 'run on background')
        .ShowOneTimeNotification(DateTime.now());
    Pump()._setTime();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    // isInDebugMode:
    //     true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  await Workmanager.registerOneOffTask(
    "cmdPump",
    "simplePeriodicTask",
    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    // frequency: Duration(hours: 1),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'Bun',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: ' Home Controle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics = false;
  bool isAuth = false;

  void _checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      print("error biome trics $e");
    }

    print("biometric is available: $canCheckBiometrics");

    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      print("error enumerate biometrics $e");
    }

    print("following biometrics are available");
    if (availableBiometrics.isNotEmpty) {
      availableBiometrics.forEach((ab) {
        print("\ttech: $ab");
      });
    } else {
      print("no biometrics are available");
    }

    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Touch your finger on the sensor to login',
          useErrorDialogs: true,
          stickyAuth: false,
          androidAuthStrings:
              AndroidAuthMessages(signInTitle: "Login to HomePage"));
    } catch (e) {
      print("error using biometric auth: $e");
    }
    setState(() {
      // isAuth = authenticated ? true : false;
      isAuth = true;
    });

    print("authenticated: $authenticated");
  }

  @override
  Widget build(BuildContext context) {
    return isAuth
        ? HomeCMD()
        : Scaffold(
            backgroundColor: Colors.black,
            body: Center(
                child: InkWell(
              onTap: () {
                _checkBiometric();
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2.5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.fingerprint,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      "Login with Fingerprint",
                      style: TextStyle(color: Colors.blueAccent),
                    )
                  ],
                ),
              ),
            )),
          );
  }
}

class HomeCMD extends StatefulWidget {
  @override
  _HomeCMDState createState() => new _HomeCMDState();
}

class _HomeCMDState extends State<HomeCMD> {
  List<bool> btnStat = [false, false, false, false, false];
  List<String> namex = ["DOOR"];
  String _rslt = '0';
  // List<String> namex = ["DOOR", "SALA", "BED ROOM", "HOLL", "PUMP"];
  List<String> ipx = [
    "192.168.1.110",
  ];
  // ProgressDialog pr;
//  List<String> ipx = [
//     "192.168.1.110",
//     "192.168.1.111",
//     "192.168.1.113",
//     "192.168.1.116",
//     "192.168.1.112"
//   ];

  DateTime now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Creating a StreamController...");
    //First subscription
    streamController.stream.listen((data) {
      setState(() {
        _rslt = data;
      });
    }, onDone: () {
      print("Task Done1");
    }, onError: (error) {
      print("Some Error1");
    });
    //Second subscription

    print("code controller is here");

    // pr = new ProgressDialog(context,
    //     isDismissible: true, type: ProgressDialogType.Normal);
  }

  @override
  void dispose() {
    streamController.close(); //Streams must be closed when not needed
    super.dispose();
  }

  cmd(String ip, String order) async {
    await http.get("http://$ip:8886/$order");
  }

  List<Widget> layout() {
    List<Widget> widgetx = new List();
    for (var i = 0; i < ipx.length; i++) {
      widgetx.add(Column(children: [
        SizedBox(
          height: 20,
        ),
        !btnStat[i]
            ? InkWell(
                onTap: () {
                  cmd(ipx[i], 'open');
                  setState(() {
                    btnStat[i] = true;
                  });
                },
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      Image.asset(
                        "images/btnOn.png",
                        width: 120.0,
                        height: 120.0,
                      ),
                      Text(
                        namex[i],
                        style: TextStyle(fontSize: 20),
                      ),
                    ])))
            : InkWell(
                onTap: () {
                  cmd(ipx[i], 'close');
                  setState(() {
                    btnStat[i] = false;
                  });
                },
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      Image.asset(
                        "images/btnOff.png",
                        width: 120.0,
                        height: 120.0,
                      ),
                      Text(
                        namex[i],
                        style: TextStyle(fontSize: 20),
                      ),
                    ]))),
        SizedBox(
          height: 20,
        ),
      ]));
    }
    widgetx.add(
      Form(
        key: _formkey,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
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
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                validator: (input) {
                  if (input.isEmpty) {
                    return "فارغ";
                  }
                },
                onSaved: (input) => _timer = input.trim(),
                //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    labelText: 'time',
                    labelStyle: TextStyle(fontFamily: 'Hacen')),
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
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
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                // obscureText: true,
                validator: (input) {
                  if (input.isEmpty) {
                    return "فارغ";
                  }
                },
                onSaved: (input) => _numOfTime = input.trim(),
                // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    labelText: 'Number of times',
                    labelStyle: TextStyle(fontFamily: 'Hacen')),
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {
                Pump()._setTime();
              },
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Text('set',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'index of cycle :\n $_rslt',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        )),
      ),
    );
    return widgetx;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return WillPopScope(
      onWillPop: () => Alert(
          context: context,
          title: now.hour.toString() +
              now.minute.toString() +
              now.second.toString(),
          message: "Are you sure you want to get out",
          info: false,
          yesFunction: () => SystemChannels.platform
              .invokeMethod<void>('SystemNavigator.pop')).show(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home A3"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Center(
              child: Column(
            children: layout(),
          )),
        ),
      ),
    );
  }
}

class Pump {
  ProgressDialog pr = new ProgressDialog(_context,
      isDismissible: true, type: ProgressDialogType.Normal);
  _setTime() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        ////print("55555");
        NetState().isConnected().then((state) async {
          if (state) {
            try {
              pr.style(
                  message: '...تهيئة',
                  progressWidget: Image.asset('images/ring.gif'),
                  textAlign: TextAlign.center);
              pr.show().whenComplete(() {
                Timer(Duration(seconds: 2), () {
                  pr.hide();
                });
              });
              int i = 1;
              print('*' * 50);
              print("on");
              print('*' * 50);
              while (i <= int.parse(_numOfTime)) {
                await cmdPump(int.parse(_timer)).whenComplete(() {
                  print('*' * 50);
                  print("on");
                  print('*' * 50);
                  print(i);
                  streamController.add(i.toString());
                  // setState(() {
                  i++;
                  // });
                });
                // }
              }
              pr.style(
                  message: 'إنتهت العملية بنجاح',
                  progressWidget: Image.asset('images/done.gif'),
                  textAlign: TextAlign.center);
              pr.show().whenComplete(() {
                Timer(Duration(seconds: 5), () {
                  pr.hide();
                });
              });
              // else {}
            } catch (e) {
              // pr.hide().then((_) =>
              Alert(
                      context: _context,
                      title: "خطأ",
                      message: "أعد تشغيل التطبيق",
                      info: true)
                  .show();
            }
          } else {
            Alert(
                    context: _context,
                    title: "خطأ",
                    message: ":(  تحقق من شبكتك ",
                    info: true)
                .show();
          }
        });
      } on SocketException catch (_) {
        Alert(
                context: _context,
                title: "خطأ",
                message: ":(  تحقق من شبكتك ",
                info: true)
            .show();
      }
    }
  }

  Future cmdPump(time) async {
    return new Future.delayed(Duration(seconds: time), () {
      // setState(() {
      print('*' * 50);
      print("off");
      print('*' * 50);
    });
    // });
  }
}
