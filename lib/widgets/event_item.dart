import 'package:flutter/material.dart';
import '../screens/event_detail.dart';
import '../providers/event1.dart';
import 'package:provider/provider.dart';

class EventItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // EventItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final event = Provider.of<Event2>(context);
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              EventDetailScreen.routeName,
              arguments: event.id,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: DecorationImage(
                  image: NetworkImage(event.imageURL), fit: BoxFit.cover),
            ),
            child: Container(
              margin: EdgeInsets.only(
                top: 170,
                left: 20,
              ),
              child: Text(
                event.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 10,
              ),
              height: 60,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    event.startDate,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 105,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              height: 60,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.watch,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    event.startTime,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15),
              height: 30,
              child: Text(
                '${event.count} interested',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
        Divider(
          thickness: 5,
        ),
      ],
    );
  }
}
