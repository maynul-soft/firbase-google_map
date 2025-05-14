import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase_database/main.dart';

class Fcm {
  Future<void>init ()async{
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('🔔 User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('🚫 User denied permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      debugPrint('❓ Permission not determined yet');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('⚠️ Provisional permission granted');
    }

   FirebaseMessaging.instance.getInitialMessage();

   FirebaseMessaging.onMessage.listen(_handledMessageInOpenedApp);
   FirebaseMessaging.onMessageOpenedApp.listen(_handledMessage);
   FirebaseMessaging.onBackgroundMessage(_handledBackgroundNotification);

  }
  void _handledMessage(RemoteMessage message){
   String handledMessage = '''
   Title: ${message.notification?.title}
   Body: ${message.notification?.body}
   ''';
   debugPrint(handledMessage);
  }
  void _handledMessageInOpenedApp(RemoteMessage message) {
    String handledMessage = '''
    Title: ${message.notification?.title}
    Body: ${message.notification?.body}
    Body: ${message.notification?.body}    
  ''';
    debugPrint(handledMessage);

    // Try to get the Scaffold context in an active screen
    final navigator = Navigator.of(MyApp.navigatorKey.currentContext!);
    if (navigator.canPop()) {
      ScaffoldMessenger.of(navigator.context).showSnackBar(
          SnackBar(content: Text('Title: ${message.notification?.title}\nBody: ${message.notification?.body}'))
      );
    }
  }
}

@pragma('vm:entry-point')
Future<void>_handledBackgroundNotification(RemoteMessage message)async{

}