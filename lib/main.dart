import 'package:fire_noti_f/about.dart';
import 'package:fire_noti_f/detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => MyHomePage(),
      '/about': (context) => AboutPage(),
      '/detail': (context) => DetailPage(),
    },
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingIos = IOSInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: initializationSettingAndroid, iOS: initializationSettingIos);
    flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onSelectNotification: onSelectMessage);
    _firebaseMessaging.getToken().then((value) => print(value));
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      showNotification(message['data']['title'],message['data']['body'],message['data']['figure']);
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch message $message");
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume message $message");
      if(message['data']['figure'] == "A")
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AboutPage()));
      else
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DetailPage()));
      // Navigator.push(context,MaterialPageRoute(builder: (context)=> AboutPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Container(child: Text("Home Page"))));
  }

  showNotification(title,body,payload) async {
    var androidPlatformChannelSpecific = AndroidNotificationDetails(
        'Channel_ID', 'channel name', 'channel Description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');
    var iosChannelSpecific = IOSNotificationDetails();
    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        NotificationDetails(
            android: androidPlatformChannelSpecific, iOS: iosChannelSpecific),payload: payload);
  }

  Future onSelectMessage(String payload) async {
    if(payload != null)
      if(payload == "A")
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AboutPage()));
      else
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DetailPage()));
  }
}
