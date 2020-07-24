// import 'package:collegenet/homepage.dart';
// import 'package:collegenet/loginsignup.dart';
import 'package:collegenet/mapping.dart';
import 'package:flutter/material.dart';
import 'package:collegenet/services/auth.dart';

void main() {
  runApp(SummerApp());
}

class SummerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "College Net",
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
