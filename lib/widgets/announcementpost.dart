import 'package:collegenet/pages/homepage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementPost extends StatefulWidget {
  final String postid;
  final String userId;
  final String username;
  final String caption;
  final String content;
  final String college;
  final String target;
  final VoidCallback rebuild;
  AnnouncementPost({
    this.postid,
    this.userId,
    this.username,
    this.caption,
    this.content,
    this.college,
    this.target,
    this.rebuild,
  });
  factory AnnouncementPost.fromDocument(DocumentSnapshot doc) {
    return new AnnouncementPost(
      postid: doc['postid'],
      userId: doc['userId'],
      username: doc['username'],
      caption: doc['caption'],
      content: doc['content'],
      college: doc['college'],
      target: doc['target'],
    );
  }
  @override
  _AnnouncementPostState createState() => _AnnouncementPostState();
}

class _AnnouncementPostState extends State<AnnouncementPost> {
  String details;
  bool isAnnouncementPostOwner;
  int temp;
  String percentage;
  double randnum = 1;

  buildAnnouncementTile() {
    isAnnouncementPostOwner = (widget.userId == currentUser.id);
    details = widget.content;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.green[200], Colors.blue[200]]),
//          color: Colors.black,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.greenAccent,
                  spreadRadius: 1,
                  offset: Offset(4, 4),
                ),
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.white,
                  spreadRadius: 1,
                  offset: Offset(-4, -4),
                )
              ]),
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              color: Colors.white.withOpacity(0.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xff2d4059),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(22)),
                      ),
                      child: ListTile(
                        leading: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.speaker_notes),
                        ),
                        title: Text(
                          widget.caption.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(6),
                        dense: true,
                        trailing: isAnnouncementPostOwner
                            ? IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.orange,
                                onPressed: () =>
                                    handleDeleteAnnouncement(context))
                            : IconButton(
                                icon: Icon(Icons.report),
                                color: Colors.orange,
                                onPressed: () =>
                                    handleReportAnnouncement(context)),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 182,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          widget.content,
                          style: TextStyle(
                            color: Colors.black,
//                              fontWeight: FontWeight.bold,
                            // fontFamily: 'Chelsea',
                            // fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  deleteAnnouncementPost() async {
    await announcementRef.document(widget.postid).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    await userWisePostsRef
        .document(userId)
        .collection("announcements")
        .document(widget.postid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    widget.rebuild();
  }

  createPostInFirestore({String ownerId, String postid}) async {
    String reportid = "Announcements-" + postid + "-" + currentUser.id;
    await reportRef.document(reportid).setData({
      "postid": postid,
      "reportingUserId": currentUser.id,
      "ContentOwnerId": userId,
    });
    // setState(() {
    //   reportid = "Announcements-" + postid + "-" + currentUser.id;
    // });
    widget.rebuild();
    // Navigator.pop(context);
  }

  handleReport() async {
    await createPostInFirestore(
      postid: widget.postid,
      ownerId: widget.userId,
    );
  }

  reportAnnouncementPost() async {
    await announcementRef.document(widget.postid).get().then((doc) {
      if (doc.exists) {
        handleReport();
      }
    });
    widget.rebuild();
  }

  handleDeleteAnnouncement(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Delete this announcement ?"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deleteAnnouncementPost();
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  handleReportAnnouncement(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Report this announcement ?"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  reportAnnouncementPost();
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    //  getUserById();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    temp = widget.userId.codeUnitAt(0);
    randnum = 1 + (temp - 48) / 12;
    temp = randnum.ceil();
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildAnnouncementTile(),
        ],
      ),
    );
  }
}
