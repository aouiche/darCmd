import 'dart:async';

// import 'package:page_transition/page_transition.dart';
import 'package:twiza/inbox.dart';
import 'package:twiza/loginUI.dart';
import 'package:twiza/loginUI2.dart';
import 'package:twiza/nav.dart';
import 'package:video_player/video_player.dart';

import 'menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/src/widgets/auth_card.dart';

// import 'login.dart';

class SplashUI extends StatefulWidget {
  @override
  _SplashUIState createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> {
  late VideoPlayerController _controller;
  final GlobalKey<AuthCardState> splashCardKey = GlobalKey();
  Future sleep(context) async {
    Future.delayed(const Duration(seconds: 7), () {
      // Nav().nav(
      //     Menu(
      //       add: false,
      //     ),
      //     context);
      Nav().nav(LoginUI2(), context);
      // Nav().nav(Inbox(name: 'Abdoullahi ‎Abdelwahheb ‎', phone: '0698782358'),
      // context);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/intro.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    sleep(context);
    return Center(
      key: splashCardKey,
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
