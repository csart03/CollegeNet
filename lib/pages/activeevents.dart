import 'package:collegenet/models/users.dart';
import 'package:flutter/material.dart';
import 'package:collegenet/services/auth.dart';

class ActiveEvents extends StatefulWidget {
  ActiveEvents({
    this.auth,
    this.onSignedOut,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final User user;
  @override
  _ActiveEventsState createState() => _ActiveEventsState();
}

class _ActiveEventsState extends State<ActiveEvents> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Chelsea',
          ),
        ),
        centerTitle: true,
      ),
      body: Text("ActiveEvents"),
    );
  }
}