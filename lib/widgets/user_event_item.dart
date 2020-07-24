import 'package:flutter/material.dart';
import '../screens/host_page.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';

class UserEventItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserEventItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(NewEvent.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                 await Provider.of<Events>(context, listen: false).deleteEvent(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting Failed',textAlign: TextAlign.center,),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
