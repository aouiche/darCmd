import 'package:darcmd/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
void main() {
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
    isAuth = authenticated ? true : false;
    // isAuth = true;
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
    
    List<bool>btnStat = [false,false,false,false,false];
    List<String>namex = ["DOOR","SALA","BED ROOM","HOLL","PUMP"];
    List<String>ipx = ["192.168.1.110","192.168.1.111","192.168.1.113","192.168.1.116","192.168.1.112"];

    cmd(String ip, String order)async{
  await http.get("http://$ip:8886/$order");
}

List<Widget> layout(){
  List<Widget> widgetx = new List();
  for (var i = 0; i < ipx.length; i++) {
    
 widgetx.add(
          Column(
          children: [ SizedBox(height: 20,),            
             !btnStat[i]?
               InkWell(
                    onTap: (){
                      cmd(ipx[i],'open');
                      setState(() {
                        btnStat[i] = true;
                      });
                    },child:Center(
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [ 
                        Image.asset("images/btnOn.png",width: 120.0,height: 120.0,),      
                        Text(namex[i],style: TextStyle(fontSize: 20),),
                        ])
                      )
                  ):
                  InkWell(
                    onTap: (){
                         cmd(ipx[i],'close');
                      setState(() {
                        btnStat[i] = false;
                      });
                    },
                    child:Center(
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [  
                        Image.asset("images/btnOff.png",width: 120.0,height: 120.0,),
                        Text(namex[i],style: TextStyle(fontSize: 20),),
                         ])
                      )
                  ),

                  SizedBox(height: 20,), 
          ])
        );
        }
        return widgetx;
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>   Alert(context: context, title:"Home A3", message:"Are you sure you want to get out",info:false ,yesFunction: ()=>
                              SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop')).show() ,   
          child: Scaffold(
      appBar: AppBar(
        title: Text("Home A3"),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child:Center(
        child: Column(
          children: layout(),
        )
      ),
      ),
      ),
    );
  }
}
