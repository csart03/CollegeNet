import 'package:collegenet/models/users.dart';
import 'package:collegenet/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/event_overview.dart';
import '../screens/event_detail.dart';
import '../providers/events.dart';
import '../screens/host_page.dart';
import '../screens/users_events_screen.dart';

class HostEvent extends StatefulWidget {
  static const routeName = '/evnthome';
  HostEvent({
    this.auth,
    this.onSignedOut,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final User user;
  @override
  _HostEventState createState() => _HostEventState();
}

class _HostEventState extends State<HostEvent> {
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
      builder: (ctx) => Events(),
      child: MaterialApp(
        title: 'Event Host',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff1a2639, color),
          accentColor: Colors.orange,
          fontFamily: 'Chelsea',
        ),
        home: EventOverview(),
        routes: {
          EventDetailScreen.routeName: (ctx) => EventDetailScreen(),
          NewEvent.routeName: (ctx) => NewEvent(),
          UserEventsScreen.routeName: (ctx) => UserEventsScreen(),
        },
      ),
    );
  }
}
