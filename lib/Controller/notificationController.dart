// ignore_for_file: file_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationController {
  FirebaseMessaging firebaseMessaging =  FirebaseMessaging.instance;

  /// Guards against overlapping permission requests. The controller is created
  /// in multiple places (login + auth flows), and firing a second
  /// `requestPermission` while the first is still running throws
  /// "A request for permissions is already running". Static so it holds across
  /// separate instances.
  static bool _isRequesting = false;

  void requestNotificationPermission()async{
    if (_isRequesting) return;
    _isRequesting = true;
    try {
      NotificationSettings notificationSettings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        criticalAlert: true,
        provisional: true,
        sound: true
      );
      if(notificationSettings.authorizationStatus== AuthorizationStatus.authorized){

      }
    } catch (e) {
      if (kDebugMode) {
        print("requestNotificationPermission error: ${e.toString()}");
      }
    } finally {
      _isRequesting = false;
    }
  }
  Future<String?> getToken()async{

    try{
      return await firebaseMessaging.getToken();
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      return "";
    }

  }
}