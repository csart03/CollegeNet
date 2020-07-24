import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';
import '../widgets/user_event_item.dart';
import '../widgets/app_drawer.dart';
import 'host_page.dart';

class UserEventsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refreshEvents(BuildContext context) async {
    await Provider.of<Events>(context).fetchAndSetOwnersEvents();
  }

  @override
  Widget build(BuildContext context) {
    // _refreshEvents(context);
    final evntsData = Provider.of<Events>(context);
    // _refreshEvents(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events hosted by you'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(NewEvent.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshEvents(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: evntsData.ownerItems.length,
            itemBuilder: (_, i) => Column(
              children: <Widget>[
                UserEventItem(
                  evntsData.ownerItems[i].id,
                  evntsData.ownerItems[i].title,
                  evntsData.ownerItems[i].imageURL,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
