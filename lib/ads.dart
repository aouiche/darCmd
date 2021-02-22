import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class Ads{
    AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;
    GlobalKey<ScaffoldState> scaffoldState;
    AdmobInterstitial initState(){
      return AdmobInterstitial(
      // adUnitId: "ca-app-pub-3940256099942544/1033173712",
      adUnitId: "ca-app-pub-7073082185265481/8906171086",
      listener: 
      (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    }
      dispose(){
      return interstitialAd.dispose();
    }
     load(){
      return interstitialAd.load();
    }
   show(){
      return interstitialAd.show();
    }
    Future<bool>  isLoaded()async{
      return await  interstitialAd.isLoaded;
    }
    
void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType ) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!'); 
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }
   void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}