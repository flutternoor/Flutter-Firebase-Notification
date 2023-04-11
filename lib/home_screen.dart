// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_firebase_notification/notification_services.dart';
// import 'package:http/http.dart' as http;

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   NotificationServies notificationServies = NotificationServies();

//   @override
//   void initState() {
//     super.initState();
//     // notificationServies.getNotificationPermission();
//     notificationServies.requestNotificationPermission();
//     notificationServies.firebaseInit(context);
//     notificationServies.setupInteractMessage(context);
//     notificationServies.isTokenRefresh();
//     notificationServies.getDeviceToken().then((value) {
//        print('device token');
//        print(value.toString());
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Notifications'),
//       ),
//       body: Center(child: TextButton(onPressed: (){
//          notificationServies.getDeviceToken().then((value)async {
//           var data = {
//               'to' : value.toString(),
//               'priority' : 'high' ,
//               'notification' : {
//                 'title' : 'Noor' ,
//                 'body' : 'Flutter Developer' ,
               
//             },
//                'data' : {
//                 'type' : 'msg' ,
//                 'id' : '12345' ,
//               }
//             };
//              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//             body: jsonEncode(data) ,
//               headers: {
//                 'Content-Type' : 'application/json; charset=UTF-8',
//                 'Authorization' : 'key=AAAAts2ysMc:APA91bG6BManVoulr6_zGxQqhNm8b5D3NXtdy9m5THuZ4jQttF5U_Jq0BFJNZJJkO_xl5juBl2J4w7jPU42hhufgjtTtiqpf-BmKlOCjOQTy40MMVs7mZAmI83XE4AR1l_ThnWlH6qod'
//               }
//             );

//          });



//       }, 
      
      
//       child: Text('Send Notification')),),
//     );
//   }
// }



import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_notification/notification_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationServies notificationServices = NotificationServies();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(onPressed: (){

          // send notification from one device to another
          notificationServices.getDeviceToken().then((value)async{

            var data = {
              'to' : value.toString(),
              'notification' : {
                'title' : 'Noor taj' ,
                'body' : 'Add some description' ,
            },
              'android': {
                'notification': {
                  'notification_count': 23,
                },
              },
              'data' : {
                'foo' : 'bar' ,
              }
            };

            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(data) ,
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization' : 'key=AAAAts2ysMc:APA91bG6BManVoulr6_zGxQqhNm8b5D3NXtdy9m5THuZ4jQttF5U_Jq0BFJNZJJkO_xl5juBl2J4w7jPU42hhufgjtTtiqpf-BmKlOCjOQTy40MMVs7mZAmI83XE4AR1l_ThnWlH6qod'
              }
            ).then((value){

            }).onError((error, stackTrace){
              print(error);
            });
          });
        },
            child: const Text('Send Notifications')),
      ),
    );
  }
}