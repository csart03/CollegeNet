import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';
import './event_item.dart';

class EventsGrid extends StatelessWidget {
  final bool showg;
  EventsGrid(this.showg);
  @override
  Widget build(BuildContext context) {
    final eventsData = Provider.of<Events>(context);
    final events = showg ? eventsData.goingones : eventsData.items;
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: events.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: events[i],
        child: EventItem(
            // events[i].id,
            // events[i].title,
            // events[i].imageURL,
            ),
      ),
    );
  }
}
