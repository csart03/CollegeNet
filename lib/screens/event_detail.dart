import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';
import 'package:diagonal/diagonal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetailScreen extends StatefulWidget {
  static const routeName = '/event-detail';

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool show = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getvalue();
    });
  }

  getvalue() async {
    final eventid = ModalRoute.of(context).settings.arguments as String;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(eventid) == false) {
      prefs.setBool(eventid, false);
    }
    setState(() {
      show = prefs.getBool(eventid);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(show);
    final eventid = ModalRoute.of(context).settings.arguments as String;
    final loadedEvent =
        Provider.of<Events>(context, listen: false).findById(eventid);
    loadedEvent.isGoing = show;
    print(show);
    Future<void> setCount() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool f = prefs.getBool(eventid);
      // print(f);
      await Provider.of<Events>(context).updateCounter(
        loadedEvent.id,
        f,
        loadedEvent,
      );
      prefs.setBool(loadedEvent.id, !prefs.getBool(loadedEvent.id));
      show = prefs.getBool(loadedEvent.id);
      // loadedEvent.isGoing = !show;
      // print(prefs.getBool(loadedEvent.id));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                new Diagonal(
                  child: Container(
                    height: 370,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 0.4, 1],
                        colors: [
                          Colors.green,
                          Colors.lightGreen,
                          Colors.greenAccent,
                        ],
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 45,
                      ),
                      child: Text(
                        'UPCOMING EVENT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  clipHeight: 370.0,
                ),
                new Container(
                  margin: EdgeInsets.only(
                    top: 100,
                  ),
                  child: Center(
                    child: Material(
                      elevation: 15.0,
                      child: Image.network(
                        loadedEvent.imageURL,
                        width: 305,
                        height: 230,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                        left: 20,
                      ),
                      width: MediaQuery.of(context).size.width * 1 / 2,
                      child: Text(
                        loadedEvent.title,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                  ),
                  child: Text(
                    loadedEvent.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                  ),
                  child: Text(
                    "Participants allowed per team : ${loadedEvent.noOfPraticipants}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 15,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.notifications_none,
                        color: Colors.deepOrange,
                        size: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ChangeNotifierProvider.value(
                        value: loadedEvent,
                        child: Text(
                          loadedEvent.isGoing
                              ? "You and ${loadedEvent.count - 1} other people will attend"
                              : "${loadedEvent.count} people will attend",
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        if (await canLaunch(loadedEvent.fee)) {
                          await launch(loadedEvent.fee);
                        } else {
                          throw 'Could not launch ${loadedEvent.fee}';
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 2 / 5,
                        height: 60,
                        margin: EdgeInsets.only(
                          top: 30,
                          left: 30,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "REGISTER",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        // print("adwdaw");
                        setCount();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 2 / 5,
                        height: 60,
                        margin: EdgeInsets.only(
                          top: 30,
                          left: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "JOIN EVENT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
