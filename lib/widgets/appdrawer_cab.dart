import 'package:collegenet/providers/allgrps.dart';
import 'package:collegenet/screens/allchats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CabAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Main Page'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Live cabs'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Your chats'),
            onTap: () async {
              await Provider.of<AllCabs>(context).fetchAndSetItems();
              Navigator.of(context).pushReplacementNamed(AllChats.routeName);
            },
          ),
        ],
      ),
    );
  }
}
