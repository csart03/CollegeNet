import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegenet/services/auth.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/pages/loginsignup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}
Future<dynamic> myBackgroundHandler(Map<String, dynamic> message) {
  return _MappingPageState()._showNotification(message);
}

class _MappingPageState extends State<MappingPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AuthStatus authStatus = AuthStatus.notSignedIn;
  int pageIndex = 0;
  Future onSelectNotification(String payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future _showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel desc',
      importance: Importance.Max,
      priority: Priority.High,
    );

    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
      0,
      '${message['notification']['title']}',
      '${message['notification']['body']}',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(initializationSettingsAndroid, null);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authStatus = (firebaseUserId == null)
            ? AuthStatus.notSignedIn
            : AuthStatus.signedIn;
      });
    });
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
        onMessage: (msg) {
          print("a");
          print(msg);
          if (msg['data']['screen'] == '2') {
            _showNotification(msg);
          }
          return;
        },
        onLaunch: (msg) async {
          pageIndex = int.parse(msg['data']['screen']);
          return;
        },
        onBackgroundMessage: myBackgroundHandler,
        onResume: (msg) async {
          print("dawdawd");
          pageIndex = int.parse(msg['data']['screen']);
          print(pageIndex);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                auth: widget.auth,
                onSignedOut: _signOut,
                pageIndex: pageIndex,
              ),
            ),
          );
          print(msg);
          return;
        });
    fbm.getToken().then((token) {
      update(token);
    });
  }

  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${token}').set({"token": 0});
    setState(() {});
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginSignupPage(auth: widget.auth, onSignedIn: _signedIn);
      case AuthStatus.signedIn:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signOut,
          pageIndex: pageIndex,
        );
    }
    return null;
  }
}
