import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

String cnt = "No notice";

class AddAnnouncement extends StatefulWidget {
  final VoidCallback rebuild;
  AddAnnouncement({this.rebuild});
  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  String postid = Uuid().v4();
  TextEditingController contentControl = TextEditingController();
  TextEditingController captionControl = TextEditingController();
  TextEditingController targetControl = TextEditingController();
  bool isUploading = false;
  String userId = currentUser.id,
      username = currentUser.username,
      college = currentUser.college;
  bool isEmptyTitle = false, isEmptyDes = false;

  @override
  void initState() {
    super.initState();
    cnt = "No notice";
  }

  createPostInFirestore(
      {String caption,
      String content,
      String target,
      Timestamp nowtime}) async {
    await announcementRef.document(postid).setData({
      "postid": postid,
      "userId": userId,
      "username": username,
      "caption": caption,
      "content": content,
      "college": college,
      "target": target,
      "nowtime": nowtime,
    });
    setState(() {
      postid = Uuid().v4();
      isUploading = false;
      captionControl.clear();
      contentControl.clear();
      targetControl.clear();
    });
    widget.rebuild();
    Navigator.pop(context);
  }

  handleUpload() async {
    setState(() {
      isUploading = true;
    });
    Timestamp nowTime = Timestamp.now();
    createPostInFirestore(
      caption: captionControl.text,
      content: contentControl.text,
      target: targetControl.text,
      nowtime: nowTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? circularProgress()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff1a2639),
              title: Text(
                'Make Announcement',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'SaucerBB',
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
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
                          controller: captionControl,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            labelText: "Caption",
                            hintText: "Max character limit: 30",
                            errorText: isEmptyTitle ||
                                    (captionControl.text.length > 30)
                                ? (isEmptyTitle
                                    ? "You cannot leave caption blank"
                                    : "Caption size should be less than 30")
                                : "",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepOrangeAccent, width: 40.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 350.0,
                        height: 100.0,
                        child: TextField(
                          controller: contentControl,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Foundation.clipboard_notes),
                            labelText: "Announcement Content",
                            hintText: "Max character limit: 160",
                            errorText: isEmptyDes ||
                                    (contentControl.text.length > 160)
                                ? (isEmptyDes
                                    ? "You cannot leave content blank"
                                    : "Content size should be less than 160")
                                : "",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepOrangeAccent, width: 40.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 350.0,
                        height: 100.0,
                        child: TextField(
                          controller: targetControl,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Foundation.torsos_all),
                            labelText: "The announcement is for?",
                            hintText: "(Optional)",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepOrangeAccent, width: 40.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ButtonTheme(
                          disabledColor: Colors.grey,
                          buttonColor: Colors.orange[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: RaisedButton(
                            onPressed: isUploading
                                ? null
                                : () {
                                    setState(() {
                                      isEmptyTitle =
                                          captionControl.text.isEmpty;
                                      isEmptyDes = contentControl.text.isEmpty;
                                    });
                                    bool isSubmit =
                                        !(isEmptyDes | isEmptyTitle);
                                    if (isSubmit) handleUpload();
                                  },
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
          );
  }
}
