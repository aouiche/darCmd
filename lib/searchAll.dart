import 'package:flutter/material.dart';
import 'package:naskhir/db.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'menu.dart';
import 'nav.dart';


 


class SearchAll extends StatefulWidget {
  @override
  _SearchAllState createState() => new _SearchAllState();
}

class _SearchAllState extends State<SearchAll> {
DB db = new  DB();
  List<Widget> DLA = new List();
  
  ProgressDialog pr; 
  @override
  void initState() { 
    super.initState();
    pr = new ProgressDialog(context,isDismissible: true,type: ProgressDialogType.Normal ); 
       db.getDatagroup("donaters").then((snap){
    pr.style(message: '...بحث',progressWidget: Image.asset( 'images/ring.gif',),textAlign: TextAlign.center); 
        pr.show().then((_){
          int i = 1;
     for (var item in snap.documents) {  
       db.getData(item.documentID.toString(), "donaters").then((snapx){ 
           setState(() { 
           DLA.add(
                             Card( 
                          color: Colors.white,
                          elevation: 3.0,
                          child: ListTile(contentPadding: EdgeInsets.all(5),
                            leading: CircleAvatar(child:Text(i.toString(),style:TextStyle(color:Colors.white)),backgroundColor: Colors.blue,), //Text(i.toString(),style: TextStyle(fontSize: 15.0),),
                            title:  Column(
                              children:[
                                Text(snapx.documentID,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold)),
                                Text(snapx.data["phone"],style: TextStyle(fontSize: 18.0),),
                              Column(
                              children:[
                                  ExpansionTile(
                                title: Text(
                                  " تواريخ الإشتراك",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                                children: dates(item.documentID),
                            ),
                              ]
                            ), ]
                            ),
                             
                         
                          )                           
                          )                           
                           );
              sleep();
           }); 
         i++; 
       });
        
     }
     });
   });
  }

 List<Widget> dates(documentID){
    List<Widget> subDLA = new List();
           db.getDatagroup("donaters/${documentID}/dates").then((snapxx){ 
         setState(() {
           for (var items in snapxx.documents) {    
             db.getData(items.documentID,"donaters/${documentID}/dates").then((sna){ 
                 String prix = "";
               if (sna.data.keys.contains('montant')) {
                prix = sna.data['montant'];                 
               } 
               if ((items.documentID == "بداية الإشتراك"&& sna.data["nextPositeDate"]== "بداية الإشتراك") || (items.documentID.isEmpty && sna.data["nextPositeDate"]== null)){
           subDLA.add(Text("بداية الإشتراك  :  نهاية الإشتراك",style: TextStyle(fontSize: 14,color: Colors.black),));
                 
               } else {
           subDLA.add(Text("${items.documentID}  :  ${sna.data["nextPositeDate"]} \n مبلغ الإشتراك: $prix\n"+"_"*30,style: TextStyle(fontSize: 14,color: Colors.black),));
               } 
         });
           }
      //  return subDLA;
         });

       });
       return subDLA;
  }
   _onBackPressed() {     
     Nav().nav(Menu(add: false,), context);
          //  Navigator.of(context).push(new MaterialPageRoute( 
          // builder: (BuildContext context)=> new LoginUI()));
            }
          Future sleep() {
  return new Future.delayed(const Duration(seconds: 2), (){ 
    pr.hide();
    // Nav().nav(LoginUI(), context); 
    });
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> _onBackPressed() ,
      child:   
      Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold( 
        body: 
        SingleChildScrollView(
            child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            Center(child: Text("القائمة الأساسية",style: TextStyle(fontFamily: "Hacen",fontSize: 25),),),
          Container(
            height: MediaQuery.of(context).size.height*0.8,
            width: MediaQuery.of(context).size.width*0.9,
             decoration: BoxDecoration(border:Border.all(color: Colors.black,style: BorderStyle.solid,width: 2.5,),color: Colors.blueGrey
                                   ) ,
            padding: EdgeInsets.all(5),
            child: 
           SingleChildScrollView(
            child:Column(
              children: DLA,
            ), 
            ), 
          ),
            SizedBox(height: 15,),
              RaisedButton(
                onPressed:()=>_onBackPressed(),
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
                      Text('خروج',style: TextStyle(color: Colors.white,fontFamily: "Hacen",fontSize: 20)),                     
                ),
              ),
              ),  
          ],
        
        ),
        ),

      )
      )
      ); 
  }
}

 