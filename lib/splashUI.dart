import 'package:naskhir/inbox.dart';
import 'package:naskhir/loginUI.dart';
import 'package:naskhir/loginUI2.dart';

import 'menu.dart';
import 'nav.dart';
import 'package:flutter/material.dart';

// import 'login.dart';



class SplashUI extends StatelessWidget {

     Future sleep(context){
   Future.delayed(const Duration(seconds: 3), () {
    //  Nav().nav(Inbox(), context);            
     Nav().nav(LoginUI2(), context);            

  });
     } 
//   Navigator.of(context).push(MaterialPageRoute( 
//               builder: (BuildContext context)=> new Login()
//           )));
// }
    
  @override
  Widget build(BuildContext context) {
     sleep(context);
    return Scaffold(
    body:
     Stack(
       fit: StackFit.expand,
      children: [
        Image.asset("images/splash.png",fit: BoxFit.fill,),
        // Positioned(
        //   top: MediaQuery.of(context).size.height*0.5,          
        //   left: MediaQuery.of(context).size.width*0.15,          
        //   child:
        //   Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //    Text("ناس الخير",style: TextStyle(fontFamily: "Hacen",fontSize: 40,color: Colors.white,fontWeight: FontWeight.w800),),
        //    Text("dz",style: TextStyle(fontFamily: "Com",fontSize: 40,color: Colors.white,fontWeight: FontWeight.normal),),

        //     ],
        //   )
        //   ),


        Positioned(
          top: MediaQuery.of(context).size.height*0.65,
          left: 0,
          right: 0,
          child:
           Image.asset("images/loading.gif",width: 200,height: 100,),
          ),
          
      ],

    )
    );
  }
}