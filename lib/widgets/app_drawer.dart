import 'package:flutter/material.dart';
import '../screens/host_page.dart';
import '../screens/users_events_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Events Manager'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Live Events'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Host an Event'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(NewEvent.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Events'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserEventsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
