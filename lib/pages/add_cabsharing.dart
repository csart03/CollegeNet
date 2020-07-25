import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/providers/allgrps.dart';
import 'package:collegenet/providers/cabgrp.dart';
import 'package:collegenet/services/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'cabsharing.dart';

class AddCab extends StatefulWidget {
  AddCab({
    this.rebuild,
  });
  final VoidCallback rebuild;
  @override
  _AddCabState createState() => _AddCabState();
}

class _AddCabState extends State<AddCab> {
  bool isUploading = false;
  String postId = Uuid().v4();
  TextEditingController srcControl = TextEditingController();
  TextEditingController destControl = TextEditingController();
  TextEditingController contactControl = TextEditingController();
  TextEditingController addnlControl = TextEditingController();
  TextEditingController countControl = TextEditingController();
  bool isEmptysrc = false, isEmptydest = false;
  String date = "Not Set", time = "Not Set";
  DateTime lDate, finaldate;
  String userId = currentUser.id,
      username = currentUser.username,
      college = currentUser.college;

  void handleUpload() async {
    setState(() {
      isUploading = true;
    });
    Timestamp leavetime = Timestamp.fromDate(finaldate);
    final chatroom = await Firestore.instance.collection('Chat Rooms').add(
      {
        'created At': Timestamp.now(),
      },
    );
    final fbm = FirebaseMessaging();
    await Firestore.instance
        .collection('Chat Rooms/${chatroom.documentID}/users')
        .add(
      {
        'id': await fbm.getToken(),
      },
    );
    Provider.of<AllCabs>(context).addEvent(
      CabGroup(
        chatRoomId: chatroom.documentID,
        source: srcControl.text,
        destination: destControl.text,
        leavetime: date + " " + time,
      ),
    );
    cabPostsRef.document(postId).setData({
      "college": college,
      "facebook": "blahblah",
      "userId": userId,
      "username": username,
      "source": srcControl.text,
      "destination": destControl.text,
      "contact": contactControl.text,
      "leavetime": leavetime,
      "count": int.parse(countControl.text),
      "postId": postId,
      "users": userId,
      "chatRoomId": chatroom.documentID,
    });
    setState(() {
      isUploading = false;
      postId = Uuid().v4();
    });
    widget.rebuild();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? circularProgress()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Color(0xff1a2639),
              title: Text(
                'New Share',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'SaucerBB',
                ),
              ),
              centerTitle: true,
            ),
            body: Container(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: 900,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.cyan[100],
                        Colors.blue[100],
                        Colors.orange[300],
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 300.0,
                          child: TextField(
                            controller: srcControl,
                            decoration: InputDecoration(
                              labelText: "Source",
                              hintText: "College",
                              errorText: isEmptysrc
                                  ? "You cannot leave Title blank"
                                  : "",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent,
                                    width: 40.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300.0,
                          child: TextField(
                            controller: destControl,
                            decoration: InputDecoration(
                              labelText: "Destination",
                              hintText: "Airport",
                              errorText: isEmptydest
                                  ? "You cannot leave Title blank"
                                  : "",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent,
                                    width: 40.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: ButtonTheme(
                            disabledColor: Colors.grey,
                            buttonColor: Colors.lightBlue[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: RaisedButton(
                              child: Text("Set Date"),
                              onPressed: () => showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2021),
                              ).then((value) {
                                if (value == null)
                                  return null;
                                else {
                                  setState(() {
                                    date = DateFormat.yMd().format(value);
                                    lDate = value;
                                  });
                                }
                              }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          "Date of Cab: " + date,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          child: ButtonTheme(
                            disabledColor: Colors.grey,
                            buttonColor: Colors.lightBlue[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: RaisedButton(
                              child: Text(
                                "Set Time",
                              ),
                              onPressed: () => showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                if (value == null)
                                  return null;
                                else {
                                  setState(() {
                                    time = value.format(context);
                                    finaldate = DateTime(
                                        lDate.year,
                                        lDate.month,
                                        lDate.day,
                                        value.hour,
                                        value.minute);
                                  });
                                }
                              }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Time of Cab Leaving: " + time,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300.0,
                          child: TextField(
                            maxLength: 1,
                            controller: countControl,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: "Count",
                              hintText: "People already in, including yourself",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent,
                                    width: 40.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300.0,
                          child: TextField(
                            maxLength: 10,
                            controller: contactControl,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: "Contact Number",
                              hintText: "82941xxxxx",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent,
                                    width: 40.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextField(
                            controller: addnlControl,
                            decoration: InputDecoration(
                              labelText: "Additional Info",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent,
                                    width: 40.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ButtonTheme(
                            disabledColor: Colors.grey,
                            buttonColor: Colors.orange[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: RaisedButton(
                              onPressed:
                                  isUploading ? null : () => handleUpload(),
                              child: Text(
                                'Upload',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
