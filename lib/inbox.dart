// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:twiza/controllers/MenuController.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:twiza/loginUI2.dart';
import 'package:twiza/screens/main/main_screen.dart';
// import 'package:twiza/random_string.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'alert.dart';
import 'alert.dart';
import 'db.dart';
// import 'loginUI.dart';
import 'nav.dart';
// import 'netState.dart';
// import 'package:http/http.dart' as http;
// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';

class Inbox extends StatefulWidget {
  var auth;
  Inbox({this.auth});
  @override
  _InboxState createState() => new _InboxState();
}

class _InboxState extends State<Inbox> {
  _onBackPressed() {
    Nav().nav(LoginUI2(), context);
    //  Navigator.of(context).push(new MaterialPageRoute(
    // builder: (BuildContext context)=> new LoginUI()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => MenuController(),
              ),
            ],
            child: MainScreen(
              auth: widget.auth,
            ),
          ),
        ), //
      ),
    );
  }
}
