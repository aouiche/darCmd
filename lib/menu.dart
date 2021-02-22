import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:naskhir/random_string.dart';
import 'package:naskhir/searchAll.dart'; 
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sms_maintained/sms.dart'; 
import 'alert.dart';
import 'db.dart';
import 'loginUI.dart';
import 'loginUI2.dart';
import 'nav.dart';
import 'netState.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;


SmsSender sender = SmsSender();
 sendSms(address,msg){
    SmsMessage message = SmsMessage(address, msg,);
    
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
    sender.sendSms(message);
}

class Menu extends StatefulWidget {
  bool add;
  Menu({this.add});
  @override
  _MenuState createState() => new _MenuState();
}

class _MenuState extends State<Menu> {
   var _formkey = GlobalKey<FormState>(); 
   var _formkey2 = GlobalKey<FormState>(); 
   DB db = new  DB();
  String _fname, _phone,_positeDate,_nextPositeDate,_prix;
    ProgressDialog pr; 
  TextEditingController _cfname = TextEditingController();
  TextEditingController _cphone = TextEditingController();
  TextEditingController _cpositeDate = TextEditingController();
  TextEditingController _cnextPositeDate = TextEditingController();
  TextEditingController _cPrix = TextEditingController();
  var maskTextInputFormatter = MaskTextInputFormatter(mask: "##-##-####", filter: { "#": RegExp(r'[0-9]') });
  var maskTextInputFormatter2 = MaskTextInputFormatter(mask: "##-##-####", filter: { "#": RegExp(r'[0-9]') }); 
    final FirebaseMessaging dbMsg = FirebaseMessaging();  
  final String serverToken = "AAAAj6Cyvng:APA91bENrwHlkauLFLnA91lACnHvq0UVaexYxKA8jXiqLIj7zv6DCkmW2bLqf90mOmk5G6Uez8Rzcxtsyfh9_g0ZNS7eO4ihiJu939XzrBJl7Ad8PRDEFxjpDeuROY3YZAwb-QHW4-IU";
   List<Widget> DLA = new List();
   List<String> DLAnumber = new List();
   List<Widget> newDonatersList = new List();
   List<String> donatersList = new List();
   int notifNum = 0;
   int notifNewDonaters = 0;
   String donater;
   bool rm;  
    
    
    @override
  void initState() {
    // TODO: implement initState
    super.initState(); 
     pr = new ProgressDialog(context,isDismissible: true,type: ProgressDialogType.Normal ); 
    
    setState(() {
   _fname ='';
   _positeDate ='';
   _nextPositeDate =''; 
   _phone=''; 
   _prix = '';
   rm = false;
    });
 
init();
  //  if (!widget.add) {
  //    dbMsg.subscribeToTopic("adminx");
  //  }
//  dbMsg.getToken().then((token){
//   //  db.updateData("thanks", "donaters", {"token":token});
//         //print("*"*100);
//         //print(token);
//         //print("*"*100);
   
//  });
  //  dbMsg.configure(
  //      onMessage: (Map<String, dynamic> message) async {
  //        if (message['notification']['title'] == "adminx") {
  //        playLocalAsset();
  //        for ( var address in message['notification']['body'].split("#").toList()) {
  //          sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");           
  //        }
  //        }
        
  //      },
  //      onBackgroundMessage: myBackgroundMessageHandler,
  //      onLaunch: (Map<String, dynamic> message) async {
  //          if (message['notification']['title'] == "adminx") {
  //        playLocalAsset();
  //        for ( var address in message['notification']['body'].split("#").toList()) {
  //          sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");           
  //        }
  //        }
  //      },
  //      onResume: (Map<String, dynamic> message) async {
  //          if (message['notification']['title'] == "adminx") {
  //        playLocalAsset();
  //        for ( var address in message['notification']['body'].split("#").toList()) {
  //          sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");           
  //        }
  //        }
  //      },
      
  //    );
  //  dbMsg.requestNotificationPermissions(const IosNotificationSettings(sound: true,badge: true,alert: true));

  }

init()async{
    var now = new DateTime.now(); 
   int month = now.month;
   String mm;
   if (month < 10) {
     mm ="0"+month.toString();     
   }else{
     mm = month.toString();
   }  
   setState(() {
     DLA.clear();
     DLAnumber.clear();
     newDonatersList.clear();
   });
       
   db.getDatagroup("donaters").then((snap){
     for (var item in snap.documents) {
         donatersList.add(item.documentID.toString());
       db.getData(item.documentID.toString(), "donaters").then((snapx){
           
          //  print("_"*100);
          //  print("${now.day}-$mm-${now.year}");
          //  print("_"*100);
        
         if (snapx.data["nextPositeDate"] == "${now.day}-$mm-${now.year}") { 
          //  sendSms(snapx.data["phone"], "تذكير دفع الاشتراك بجمعية ناس الخير");  
           setState(() {
             notifNum++;
             DLAnumber.add(snapx.data["phone"]);
           DLA.add(
                             Card( 
                          color: Colors.white,
                          elevation: 3.0,
                          child: ListTile(
                            leading: CircleAvatar(child:Icon(Icons.notifications_active,color: Colors.white,),backgroundColor: Colors.blue,),
                             title:  Column(
                              children:[
                                Text(snapx.documentID,style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold)),
                                Text(snapx.data["phone"],style: TextStyle(fontSize: 15.0),),
                              ])
                         
                          )                           
                          )                           
                           );
             
           });
         }
       });
     }      
   });

  db.getDatagroup("newDonaters").then((snap){
     for (var item in snap.documents) {
       db.getData(item.documentID.toString(), "newDonaters").then((snapx){ 
           setState(() {
             notifNewDonaters++;
           newDonatersList.add(
                             Card( 
                          color: Colors.white,
                          elevation: 3.0,
                          child: ListTile(
                             title:  Column(
                              children:[
                                Text(snapx.documentID,style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold)),
                                Text(snapx.data["phone"],style: TextStyle(fontSize: 15.0),),
                              ]),
                               leading: InkWell(   
                    child:CircleAvatar(child:Icon(Icons.add,color: Colors.white,),backgroundColor: Colors.blue,), 
              onTap: (){
                newDonatersList.removeAt(notifNewDonaters); 
                    Map<String,dynamic> formData = {
                      'fullName': snapx.data["fullName"], 
                      'phone': snapx.data["phone"], 
                      'positeDate': "بداية الإشتراك",  
                      'nextPositeDate': "بداية الإشتراك",    
          };
                  db.setData('بداية الإشتراك',"donaters/${snapx.data["fullName"]}/dates", formData);
             db.setData('${snapx.data["fullName"]}',"donaters", formData); 
             db.deleteDataDoc("newDonaters",'${snapx.data["fullName"]}',); 
             donatersList.add(snapx.data["fullName"].toString());
             sendAndRetrieveMessage(snapx.data["phone"]);
            //  sendSms(snapx.data["phone"],"تم قبول طلب الاشتراك في جمعية ناس الخير");
              pr.hide();
              pr.style(message: 'تم التسجيل بنجاح',progressWidget: Image.asset( 'images/done.gif'),textAlign: TextAlign.center);
              pr.show().then((stat){  
                _cfname.text = snapx.data["fullName"];
                _cphone.text = snapx.data["phone"];
                init();
                // _cpositeDate.text = "";
                // _cnextPositeDate.text = "";  
                sleep();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }); 
              },
            ),
                          )                           
                          )                           
                           );
             
           }); 
       });
     }
   });
}


  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("notif.wav");
}
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
  return new Future.delayed(const Duration(seconds: 2), (){ 
    pr.hide();
    // Nav().nav(LoginUI(), context); 
    });
}

      sendAndRetrieveMessage(token) async {
  //  await dbMsg.requestNotificationPermissions(
  //    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
  //  );
   try {
   await http.post(
     'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAj6Cyvng:APA91bENrwHlkauLFLnA91lACnHvq0UVaexYxKA8jXiqLIj7zv6DCkmW2bLqf90mOmk5G6Uez8Rzcxtsyfh9_g0ZNS7eO4ihiJu939XzrBJl7Ad8PRDEFxjpDeuROY3YZAwb-QHW4-IU',
      },
      body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': "تم قبول طلب الاشتراك في جمعية ناس الخير",
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
  return   Alert(context: context, title:"خطأ", message:":(  تحقق من شبكتك ",info:true).show();
   }

 }
  _next(bool remove) {
      final formState = _formkey.currentState;  
          
      setState(() { 
      if(formState.validate()){
        try{ 
        NetState().isConnected().then((state)async{ 
                    if(state){ 
        pr.style(message: '...تسجيل ',progressWidget: Image.asset( 'images/ring.gif',),textAlign: TextAlign.center); 
        pr.show().then((stat){   
                      
        formState.save();   
        
        if (remove) {
          db.deleteDataDoc('donaters','$_fname');   
           pr.hide();
              pr.style(message: 'تم الحذف بنجاح',progressWidget: Image.asset( 'images/done.gif'),textAlign: TextAlign.center);     
        } else {
        
          if (widget.add) {
            bool existe = false;
            int i = 1;
            db.getDatagroup("donaters").then((snp){
                for (var itm in snp.documents) {
                  db.getData(itm.documentID, "donaters").then((snpx){ 
                if (_phone == snpx.data["phone"]) {
                  setState(() {
                    
                      existe = true;
                  });
                }                    
                    setState(() {
                      
                  i++;
                    });
                  }).whenComplete((){

                    
                //    print("*"*100);  
                //     print(existe); 
                //     print(i ); 
                //     print( snp.documents.length); 
                // print("*"*100);
            if (existe && i == snp.documents.length) {
                   pr.hide(); 
              pr.style(message:  'هذا الرقم مسجل',progressWidget: Image.asset( 'images/error.gif'),textAlign: TextAlign.center);
               pr.show().then((stat){ 
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
          else if(i == snp.documents.length){
          Map<String,dynamic> formData = {
                      'fullName': _fname, 
                      'phone': _phone,  
                     
          }; 
        //         fname = fname.trim();
        //   List<String> _e = fname.split(""); 
        //  _e.removeWhere((element) => element==" ");
        //  fname = _e.join("");
          
             db.setData('$_fname',"newDonaters", formData);
             dbMsg.subscribeToTopic(_phone);
                 pr.hide(); 
              pr.style(message:  'تم التسجيل بنجاح',progressWidget: Image.asset( 'images/done.gif'),textAlign: TextAlign.center);
              pr.show().then((stat){ 
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
               Map<String,dynamic> formData = {
                      'fullName': _fname, 
                      'phone': _phone, 
                      'positeDate': _positeDate, 
                      'nextPositeDate': _nextPositeDate,  
                      'montant': _prix,
          }; 
           db.setData('$_positeDate',"donaters/$_fname/dates", formData);
             db.setData('$_fname',"donaters", formData);
          pr.hide(); 
              pr.style(message:  'تم التسجيل بنجاح',progressWidget: Image.asset( 'images/done.gif'),textAlign: TextAlign.center);
              pr.show().then((stat){ 
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
            }catch(_){
               pr.hide().then((_) =>
          Alert(context:context,title:"خطأ" , message:"تعذر الإتصال بالسرفر",info:true,).show()
          );
            }   
      }
 
          // Alert(context:context,title:"خطأ" , message:"نسيت أحد الحقول فارغا أو ام لم يحدد",info:true,).show();
      });  
    }

    bool aff = false;
    
     List<Widget> dates = new List() ; 
  _search(context,bool history){
    // flutter defined function
    
    showDialog(
      context:  context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return  Directionality(
      textDirection: TextDirection.rtl,
      child:AlertDialog( contentPadding: EdgeInsets.all(0),
          // elevation: 10.0, 
          // titleTextStyle: TextStyle(color:Colors.white,fontSize: 30.0,fontFamily: 'Hacen'),          
          // contentTextStyle: TextStyle(color:Colors.white,fontSize: 20.0,fontFamily: 'Hacen'),
          // title: new Text(this.title != null ?this.title:""),
          content: !aff?Form(
        key: _formkey2,
        child:Container(
                    width: 300.0,
                    height: 60.0,
                    margin: EdgeInsets.only(top:10.0),
                    // decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.2,),
                    //                 borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.blue[50]) ,//ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                    padding: EdgeInsets.all(4.0),
                    child: DropdownSearch<String>(
                      //  textDirectionSearchBox: TextDirection.rtl,
                        showSearchBox: true, 
                        // validator: (v) => v == null ? "يرجى اختيار  الاتجاه": null,
                        hint: "الإسم الكامل",
                        mode: Mode.BOTTOM_SHEET,
                        showSelectedItem: true,
                        items: donatersList, 
                         popupItemBuilder: (context, item, isSelected){
                           return Center(child:Container(  
                            height: MediaQuery.of(context).size.height*0.07,   
                            width:  MediaQuery.of(context).size.width*0.9,                   
                            decoration: BoxDecoration(border:Border.all(color: Colors.black,style: BorderStyle.solid,width: 0.2,),
                                     color: Colors.white,
                            ),
                            child:Center(child:
                            Text(item,textAlign: TextAlign.right,style: TextStyle(color: Colors.black),),
                            ),
                            )  
                            );  
                         },
                        // styleSearchBox: TextStyle(fontFamily: 'Hacen',fontSize: 20),
                         searchBoxDecoration: InputDecoration(labelText:  "الإسم الكامل",labelStyle: TextStyle(fontWeight: FontWeight.bold) ,border: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple,style: BorderStyle.solid,width: 10.0))),
                        //  dropdownSearchDecoration: InputDecoration(hintStyle: TextStyle(fontFamily: 'Hacen'), border:InputBorder.none,suffixIcon: Icon(Icons.arrow_drop_down,color: Colors.purple,),),
                        showClearButton: false,
                        onChanged:(newValue) { 
                          setState(() {
                            donater= newValue.toString();  
                          }); 
                        }
                          ,
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
                //   onSaved: (input){ setState(() { donater = input.trim() ; donater = donater.trimLeft(); donater = donater.trimRight(); });},
                //   //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                //   //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(50)) ),
                //         labelStyle: TextStyle(fontFamily: 'Hacen'),
                //     labelText: ' الاسم الكامل',
                //     //hintText: widget.userData != null?widget.userData.data["first name"]:""
                //   ), 
                // ),  
              ),
              ):SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child:
                  Container(
                    color: Colors.blueGrey,
                    padding: EdgeInsets.all(10.0),
                    child:Column(
                    children: [
                  Text(donater,style:TextStyle(fontSize: 18,fontFamily: "Hacen",fontWeight: FontWeight.bold,decoration: TextDecoration.underline,color: Colors.white),textAlign: TextAlign.center,),
                  Column(
                        children: dates
                          
                      )
                    ],
                  )
                      )
                      )
              ,
                actions: <Widget>[   
            !aff?RaisedButton(
               padding: const EdgeInsets.all(0.0),
                             shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(55.0),
                          ),  
                    color: Colors.purple, 
                     child:Center(
                     child: Text("بحث",style: TextStyle(color:Colors.white,fontSize: 20.0,fontFamily: 'Hacen',fontWeight: FontWeight.w700),),
                   ), 
              onPressed:(){
                final formState2 = _formkey2.currentState;
                 if(formState2.validate()){
                  try{ 
                  NetState().isConnected().then((state)async{ 
                    if(state){ 
                      formState2.save();
                      rm = true;
              if (history) {      
                  dates.clear();                                   
                  db.getDatagroup("donaters/$donater/dates").then((snap){
                    setState(() {
                       for (var snapx in snap.documents) {
                          db.getData(snapx.documentID,"donaters/$donater/dates").then((sna){ 
                            String prix = "";
                          if (sna.data.keys.contains('montant')) {
                            prix = sna.data['montant'] +" دج";                 
                          } 
                          
                         dates.add(
                             Card( 
                          color: Colors.white,
                          elevation: 3.0,
                          child: ListTile(
                            leading:  CircleAvatar(child:Icon(Icons.calendar_today,color: Colors.white,),backgroundColor: Colors.blue,), 
                             title:  Column(
                              children:[
                                Text(snapx.documentID,style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold)),
                                Text(prix,style: TextStyle(fontSize: 15.0),),
                              ])
                          )                           
                          )                           
                           ); 
                  });
                       }
                       aff = true;
                        pr.style(message: '...بحث',progressWidget: Image.asset( 'images/ring.gif',),textAlign: TextAlign.center); 
                        pr.show().then((_){
                       sleep().whenComplete(() => _search(context, true));
                        
                    });
                    });
                  });
                    
              } else { 
                
                db.getData(donater, "donaters").then((snap){
                      //print("*"*100);
                      //print(donater); 
                      //print("*"*100);
                    setState(() {
                      _cfname.text = snap.data["fullName"];
                      _cphone.text = snap.data["phone"];
                      _cpositeDate.text = snap.data["positeDate"];
                      _cnextPositeDate.text = snap.data["nextPositeDate"];
                      _cPrix.text = snap.data["montant"];
                    });
                    
                });
                     Navigator.of(context).pop();
              }
                    }
                  });
                  }catch (e) {
                           pr.hide().then((_) =>
          Alert(context:context,title:"خطأ" , message:"تعذر الإتصال بالسرفر",info:true,).show()
          );
                     }
                 }
              } ,       
            ):Container(),
          RaisedButton(
               padding: const EdgeInsets.all(0.0),
                             shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(55.0),
                          ),  
                    color: Colors.purple, 
                    child:Center(
                     child: new Text("إغلاق",style: TextStyle(color:Colors.white,fontSize: 20.0,fontFamily: 'Hacen',fontWeight: FontWeight.w700),),
                   ), 
              onPressed: (){
                aff = false;
                Navigator.of(context).pop();
              },
            )  ,
 
          ],
              ),
      );
  }
  );
  }

 _notif(context,bool newDonaters){  
   setState(() {
     if (newDonaters) {
     notifNewDonaters = 0;       
     } else {
     notifNum = 0;
     }
   }); 
 showDialog(
      context:  context,
      builder: (BuildContext context) {
        // return object of type Dialog 
        return  Directionality(
      textDirection: TextDirection.rtl,
      child:AlertDialog( contentPadding: EdgeInsets.all(0), 
                    title: Text(!newDonaters?"إشعارات تجديد الإشتراك":"إشعارات طلبات التسجيل",textAlign: TextAlign.center,),
                    titleTextStyle:  TextStyle(fontFamily: "Hacen",fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),                    
                        content:  
                         Container(
            height: MediaQuery.of(context).size.height*0.8,
            width: MediaQuery.of(context).size.width*0.9,
             decoration: BoxDecoration(border:Border.all(color: Colors.black,style: BorderStyle.solid,width: 2.5,),color: Colors.blueGrey
                                   ) ,
            padding: EdgeInsets.all(5),
            child: 
           SingleChildScrollView(
            child:Column(
             children: !newDonaters?DLA:newDonatersList,
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
               !newDonaters?RaisedButton(
               padding: const EdgeInsets.all(0.0),
                             shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),  
                    color: Colors.purple, 
                    child:Center(
                     child: new Text("  إرسال SMS ",style: TextStyle(color:Colors.white,fontSize: 20.0,fontFamily: 'Hacen',fontWeight: FontWeight.w700),),
                   ), 
              onPressed: (){
                for (var numb in DLAnumber) {
                 sendSms(numb, "تذكير دفع الاشتراك بجمعية ناس الخير"); 
                  
                }
                pr.style(message: 'تم إرسال \n ${DLA.length} SMS مشتركين',progressWidget: Image.asset( 'images/done.gif'),textAlign: TextAlign.center);
              pr.show().whenComplete(() => sleep());
              },
            ):Container()  ,
          RaisedButton(
                        padding: const EdgeInsets.all(0.0),
                                      shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(55.0),
                                    ),  
                              color: Colors.purple, 
                              child:Center(
                              child: new Text("إغلاق",style: TextStyle(color:Colors.white,fontSize: 20.0,fontFamily: 'Hacen',fontWeight: FontWeight.w700),),
                            ), 
                        onPressed: () => Navigator.of(context).pop(),
                      )  ,
          
          ],
              ),
      );
  }
  );

 }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> _onBackPressed() ,
      child: GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },child:      
      Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold( 
      body:Form(
        key: _formkey,

        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),            
               !widget.add?Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
            // margin: EdgeInsets.only(), 
            child: 
          InkWell(
            onTap: _onBackPressed, 
            child:
          Icon(Icons.exit_to_app,size: 30,color: Colors.green,), 
          ),
          ),             
              const SizedBox(width: 10),            
               Container(
            // margin: EdgeInsets.only(), 
            child: 
          InkWell(
            onTap:()=> _notif(context,false), 
            child: 
           Stack(
             children: [
          Icon(Icons.notifications,size: 30,color: Colors.green,),  
          Positioned(  
            width: 20,
            height: 20,          
            child: 
          notifNum!=0? CircleAvatar(child:Text(notifNum.toString(),style:TextStyle(color:Colors.white)),backgroundColor: Colors.red):Container()
          ),
             ],
           )   
            
          ),
          ),
            const SizedBox(width: 10),            
               Container(
            // margin: EdgeInsets.only(), 
            child: 
          InkWell(
            onTap:()=> _notif(context,true), 
            child: 
           Stack(
             children: [
          Icon(Icons.people,size: 30,color: Colors.green,),  
          Positioned(  
            width: 20,
            height: 20,          
            child: 
          notifNewDonaters!=0? CircleAvatar(child:Text(notifNewDonaters.toString(),style:TextStyle(color:Colors.white)),backgroundColor: Colors.red):Container()
          ),
             ],
           )   
            
          ),
          ),
            const SizedBox(width: 10),            
               Container(
            // margin: EdgeInsets.only(), 
            child: 
          InkWell(
            onTap:()=> _search(context,true), 
            child:
          Icon(Icons.history,size: 30,color: Colors.green,), 
          ),
          ),
            const SizedBox(width: 10),            
               Container(
            // margin: EdgeInsets.only(), 
            child: 
          InkWell(
            onTap:()=> _search(context,false), 
            child:
          Icon(Icons.search,size: 30,color: Colors.green,), 
          ),
          ),
 
            const SizedBox(width: 10),            
               Container(
            // margin: EdgeInsets.only(), 
            child: 
          InkWell(
            onTap:()=>  Nav().nav( SearchAll(), context), 
            child:
          Icon(Icons.library_books ,size: 30,color: Colors.green,), 
          ),
          ),

            ]): 
             Container( ), 
              const SizedBox(height: 10),            
            Center( 
            child:
          Image.asset("images/logo.png",width: 150,height: 150,),
          ),
              const SizedBox(height: 10),            

               Container(
                    width: 300.0,
                    height: 60.0,
                    decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.2,),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.blue[50]) ,//ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                    padding: EdgeInsets.all(4.0),
                    child:TextFormField(
                      style: TextStyle(fontFamily: "Hacen",fontSize: 15.0),
                  keyboardType: TextInputType.text,    
                  controller: _cfname,
                  validator: (input){
                    if(input.isEmpty ){
                      return "فارغ";
                    }
                  },
                  onSaved: (input){ setState(() { _fname = input.trim() ;});},
                  //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                  //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(50)) ),
                        labelStyle: TextStyle(fontFamily: 'Hacen'),
                    labelText: ' الاسم الكامل',
                    //hintText: widget.userData != null?widget.userData.data["first name"]:""
                  ), 
                ),  
              ), 
              const SizedBox(height: 20),
            Container(
                    width: 300.0,
                    height: 60.0,
                    decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.2,),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.blue[50]) ,//ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                    padding: EdgeInsets.all(4.0),
                    child:TextFormField(
                      style: TextStyle(fontFamily: "Hacen"),
                  keyboardType: TextInputType.phone,   
                  controller: _cphone,
                      maxLength: 10,
                  validator: (input){
                    if(input.isEmpty  ){
                      return "فارغ";
                    }
                  },
                  onSaved: (input){ setState(() { _phone = input.trim() ; });},
                  // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                  //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(50)) ),
                        labelStyle: TextStyle(fontFamily: 'Hacen'),
                    labelText: 'رقم الهاتف',
                    counterText: ''
                  ),
                ), 
              ),
                 
              const SizedBox(height: 10),            

             !widget.add?  Container(
                    width: 300.0,
                    height: 60.0,
                    decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.2,),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.blue[50]) ,//ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                    padding: EdgeInsets.all(4.0),
                    child:TextFormField(
                      style: TextStyle(fontFamily: "Hacen",fontSize: 15.0),
                  keyboardType: TextInputType.number,                      
                  controller: _cpositeDate,
                  maxLength: 10,
                  validator: (input){ 
                    if(input.isEmpty ){
                      return "فارغ";
                    }
                  }, 
                  onSaved: (input){ setState(() { _positeDate = input.trim() ; });},
                  //textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                  //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                  inputFormatters: [maskTextInputFormatter],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(50)) ),
                        labelStyle: TextStyle(fontFamily: 'Hacen'),
                    labelText: 'تاريخ دفع الإشتراك',
                    hintText: '01-01-2020',
                    hintStyle: TextStyle(color: Colors.black26),
                    counterText: ''
                  ), 
                ),  
              ):Container(), 
              const SizedBox(height: 20),
           !widget.add? Container(
                    width: 300.0,
                    height: 60.0,
                    decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.2,),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.blue[50]) ,//ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                    padding: EdgeInsets.all(4.0),
                    child:TextFormField(
                      style: TextStyle(fontFamily: "Hacen"),
                  keyboardType: TextInputType.number,  
                  controller: _cnextPositeDate,
                  inputFormatters: [maskTextInputFormatter2],
                  maxLength: 10,
                  validator: (input){
                    if(input.isEmpty  ){
                      return "فارغ";
                    }
                  },
                  onSaved: (input){ setState(() { _nextPositeDate = input.trim() ; });},
                  // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                  //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(50)) ),
                        labelStyle: TextStyle(fontFamily: 'Hacen'),
                    labelText: 'تاريخ تجديد الإشتراك',
                    hintText: '01-01-2020',
                    hintStyle: TextStyle(color: Colors.black26),
                    counterText: ''
                  ),
                ), 
              ):Container(),
                
                   const SizedBox(height: 20),
           !widget.add? Container(
                    width: 300.0,
                    height: 60.0,
                    decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.2,),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),color: Colors.blue[50]) ,//ShapeDecoration(shape: Border.all(color: Colors.grey[350],style: BorderStyle.solid,width: 0.2,),color: Colors.grey[350],),

                    padding: EdgeInsets.all(4.0),
                    child:TextFormField(
                      style: TextStyle(fontFamily: "Hacen"),
                  keyboardType: TextInputType.number,  
                  controller: _cPrix, 
                  validator: (input){
                    if(input.isEmpty  ){
                      return "فارغ";
                    }
                  },
                  onSaved: (input){ setState(() { _prix = input.trim() ; });},
                  // textDirection: widget.lang == 'arb'?TextDirection.rtl:TextDirection.ltr,
                  //textAlign: widget.lang == 'arb'?TextAlign.right:TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(50)) ),
                        labelStyle: TextStyle(fontFamily: 'Hacen'),
                    labelText: 'مبلغ الإشتراك'+'  (دج)',  
                  ),
                ), 
              ):Container(),
                
              const SizedBox(height: 20),
             !rm? RaisedButton(
                onPressed:()=>_next(false),
                padding: const EdgeInsets.all(0.0),
                  shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(55.0),
                          ),
                child:Container(
                   padding: const EdgeInsets.all(0.0), 
                    height: 50.0,
                    width: 300,                    
                      decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.5,),color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(50))) ,
                      child:Center( 
                      child: 
                      Text(!widget.add?'حفظ':"تسجيل",style: TextStyle(color: Colors.white,fontFamily: "Hacen",fontSize: 20)),                     
                ),
              ),
              ):Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                onPressed:()=>_next(false),
                padding: const EdgeInsets.all(0.0),
                  shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(55.0),
                          ),
                child:Container(
                   padding: const EdgeInsets.all(0.0), 
                    height: 50.0,
                    width: 150,                    
                      decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.5,),color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(50))) ,
                      child:Center( 
                      child: 
                      Text(!widget.add?'حفظ':"تسجيل",style: TextStyle(color: Colors.white,fontFamily: "Hacen",fontSize: 20)),                     
                ),
              ),
              ),
                  RaisedButton(
                onPressed:(){
                  _next(true);
                },
                padding: const EdgeInsets.all(0.0),
                  shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(55.0),
                          ),
                child:Container(
                   padding: const EdgeInsets.all(0.0), 
                     width: 150,    
                    height: 50.0,                
                      decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.5,),color: Colors.redAccent[200],
                                    borderRadius: BorderRadius.all(Radius.circular(50))) ,
                      child:Center( 
                      child: 
                      Text('حذف',style: TextStyle(color: Colors.white,fontFamily: "Hacen",fontSize: 20)),                     
                ),
              ),
              ),

                ],
              ),
            SizedBox(height: 20,),
             widget.add? RaisedButton(
                onPressed:(){
                  Nav().nav(LoginUI2(), context);
                },
                padding: const EdgeInsets.all(0.0),
                  shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(55.0),
                          ),
                child:Container(
                   padding: const EdgeInsets.all(0.0), 
                    height: 50.0,      
                    width: 300,       
                      decoration: BoxDecoration(border:Border.all(color: Colors.blue[50],style: BorderStyle.solid,width: 0.5,),color: Colors.redAccent[200],
                                    borderRadius: BorderRadius.all(Radius.circular(50))) ,
                      child:Center( 
                      child: 
                      Text('خروج',style: TextStyle(color: Colors.white,fontFamily: "Hacen",fontSize: 20)),                     
                ),
              ),
              ):Container(), 
            ],
          ),
        ), //
      ),// This trai
      )
      ),
      )
    );
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
//   Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//     Future<AudioPlayer> playLocalAsset() async {
//     AudioCache cache = new AudioCache();
//     return await cache.play("notif.wav");
// }
//   if (message.containsKey('data')) {
//     // Handle data message
//     // playLocalAsset();
//     // final dynamic data = message['data'];
//         if (message['notification']['title'] == "adminx") {
//          playLocalAsset();
//          for ( var address in message['notification']['body'].split("#").toList()) {
//            sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");           
//          }
//          }
//   }

//   if (message.containsKey('notification')) {
//         if (message['notification']['title'] == "adminx") {
//          playLocalAsset();
//          for ( var address in message['notification']['body'].split("#").toList()) {
//            sendSms(address, "تذكير دفع الاشتراك بجمعية ناس الخير");           
//          }
//          }
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

//     // //print("sound played");

//     // return null;

//   // Or do other work.
// }