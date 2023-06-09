// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';
// import 'dart:math';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_firebase_notification/message_screen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServies{

// FirebaseMessaging messaging = FirebaseMessaging.instance;
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   void getNotificationPermission()async{
//    NotificationSettings settings = await messaging.requestPermission(
//     alert:  true,
//     announcement: true,
//     badge: true,
//     carPlay: true,
//     criticalAlert: true,
//     sound: true,
//     provisional: true,
//    );
//    if(settings.authorizationStatus == AuthorizationStatus.authorized){
//     print('user graned permission');

//    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
//         print('user graned provisional permission');


//    }else{
//     print('user denied permission');

//    }

//   }
 
 
//  ////initialization Notification method
//   void initLocalNotifications(BuildContext context ,RemoteMessage message) async{
//   var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_lancher');
//   var iosInitializationSetting  = const DarwinInitializationSettings();
//   var initializationSetting = InitializationSettings(
//     android:  androidInitializationSettings,
//     iOS: iosInitializationSetting,
//   );
//   await flutterLocalNotificationsPlugin.initialize(initializationSetting,
//  onDidReceiveBackgroundNotificationResponse: (payload) {
//   handleMessage(context, message);
   
//  },
//   );
//   }
 
//   void firebaseInit(BuildContext context){
//     FirebaseMessaging.onMessage.listen((message) {
//       if (kDebugMode) {
//         print("<<<<<<<<<<<<<<<<<<<<${message.notification!.title.toString()}>>>>>>>>>>>>>>>>.");
//         print("<<<<<<<<<<<<<<<<<<<<${message.notification!.body.toString()}>>>>>>>>>>>>>>>>.");
//         print("<<<<<<<<<<<<<<<<<<<<${message.data.toString()}>>>>>>>>>>>>>>>>.");

//       }
//        if(Platform.isAndroid){
//      initLocalNotifications(context, message);
//       // initLocalNotification(BuildContext context, message);
//       showNotification(message);
//        }else{
//         showNotification(message);
//        }



//      });
//   }
//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       Random.secure().nextInt(100000).toString(),
//       'High Improtant Notification',
//       importance: Importance.max,
//       );
//     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
//       channel.id.toString(),
//       channel.name.toString(),
//       channelDescription: 'your channel discription',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//        );

//    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
//       presentAlert:  true,
//       presentBadge: true,
//       presentSound: true,
//     );


//       NotificationDetails notificationDetails =  NotificationDetails(
//         android: androidNotificationDetails,
//         iOS: darwinNotificationDetails,
//       );


//        Future.delayed(Duration.zero,(){
//         flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails
        
//         );
//        }
       
//         );

//   }

//   Future<String> getDiviceToken() async{
//    String? token =await messaging.getToken();
//    return token!;
//   }
//    void isTokenRefresh() async{
//    messaging.onTokenRefresh.listen((event) { 
//     event.toString();
//    });
//   }

//    //handle tap on notification when app is in background or terminated
//   Future<void> setupInteractMessage(BuildContext context)async{

//     // when app is terminated
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

//     if(initialMessage != null){
//       handleMessage(context, initialMessage);
//     }


//     //when app in background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });

//   }
//   void handleMessage(BuildContext context ,RemoteMessage message){

//     if(message.data['type']=='msg'){

//       Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageScreen(id: message.data['id'])));
//     }
//   }

// }



import 'dart:io';
import 'dart:math';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_notification/message_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class NotificationServies {

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance ;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin();

  // function to request notifications permissions
  void requestNotificationPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true ,
      announcement: true ,
      badge: true ,
      carPlay:  true ,
      criticalAlert: true ,
      provisional: true ,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('user granted provisional permission');
    }else {
     // AppSettings.openNotificationSettings();
      print('user denied permission');
    }
  }


  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings ,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
      onDidReceiveNotificationResponse: (payload){
          // handle interaction when app is active for android
          handleMessage(context, message);
      }
    );
  }

  void firebaseInit(BuildContext context){


    FirebaseMessaging.onMessage.listen((message) {

      RemoteNotification? notification = message.notification ;
      AndroidNotification? android = message.notification!.android ;


      if (kDebugMode) {

        print("notifications title:"+notification!.title.toString());
        print("notifications body:"+notification.body.toString());
        print('count:'+android!.count.toString());
        
        print("notifications channel id:"+message.notification!.android!.channelId.toString());
        print("notifications click action:"+message.notification!.android!.clickAction.toString());
        print("notifications color:"+message.notification!.android!.color.toString());
        print("notifications count:"+message.notification!.android!.count.toString());
      }


      if(Platform.isAndroid){
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }


  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message)async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString() ,
      importance: Importance.max  ,
      showBadge: true ,
    );

     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString() ,
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high ,
      ticker: 'ticker' ,
    //  icon: largeIconPath
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true ,
      presentBadge: true ,
      presentSound: true
    ) ;

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero , (){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });

  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context)async{

    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }


    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

  }


  void handleMessage(BuildContext context, RemoteMessage message) {

    if(message.data['type'] == 'msg'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MessageScreen(
            id: message.data['id'] ,
          ),
          ));
    }
  }


}