package com.code.twiza;

import io.flutter.app.FlutterApplication;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
// import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;


public class Application extends FlutterApplication implements PluginRegistrantCallback {

  @Override
  public void onCreate() {
    super.onCreate();
    // FlutterFirebaseMessagingService.setPluginRegistrant(this);
    FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    
    FirebaseCloudMessagingPluginRegistrant.registerWith(registry);
  }
  
}
