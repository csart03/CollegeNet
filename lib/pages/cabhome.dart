import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/cabsharing.dart';
import 'package:collegenet/screens/allchats.dart';
import 'package:collegenet/services/auth.dart';
import 'package:collegenet/widgets/cabposts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/allgrps.dart';

class HomeCabs extends StatefulWidget {
  static const routeName = '/cabhome';
  HomeCabs({
    this.auth,
    this.onSignedOut,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final User user;
  @override
  _HomeCabsState createState() => _HomeCabsState();
}

class _HomeCabsState extends State<HomeCabs> {
  //added because primary swatch does not accept colors, only materialcolor
  Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (ctx) => AllCabs(),
      child: MaterialApp(
        title: 'Cab',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff1a2639, color),
          accentColor: Colors.orange,
          fontFamily: 'Chelsea',
        ),
        home: CabSharing(
          auth: widget.auth,
          onSignedOut: widget.onSignedOut,
          user: widget.user,
        ),
        routes: {
          AllChats.routeName: (ctx) => AllChats(),
          CabPosts.routeName: (context) => CabPosts(),
        },
      ),
    );
  }
}
