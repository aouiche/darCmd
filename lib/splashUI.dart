import 'package:twiza/inbox.dart';
import 'package:twiza/loginUI.dart';
import 'package:twiza/loginUI2.dart';

import 'menu.dart';
import 'nav.dart';
import 'package:flutter/material.dart';

// import 'login.dart';

class SplashUI extends StatefulWidget {
  @override
  _SplashUIState createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> {
  VideoPlayerController _controller;
  Future sleep(context) async {
    Future.delayed(const Duration(seconds: 3), () {
      // Nav().nav(
      //     Menu(
      //       add: false,
      //     ),
      //     context);
      // Nav().nav(LoginUI2(), context);
      Nav().nav(Inbox(name: 'Abdoullahi ‎Abdelwahheb ‎', phone: '0698782358'),
          context);
    });
  }
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    sleep(context);
    return MaterialApp(
      title: 'Video Demo',
      home:  Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
        );
   
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}