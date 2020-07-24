import 'dart:io';
import 'package:collegenet/pages/editpost.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/loading.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class FilePost extends StatefulWidget {
  final String postId;
  final String userId;
  final String username;
  final String caption;
  final String content;
  final String mediaUrl;
  final String college;
  final bool isLocal;
  final bool isFile;
  final String fileExtension;
  final VoidCallback rebuild;

  FilePost({
    this.postId,
    this.userId,
    this.username,
    this.caption,
    this.content,
    this.mediaUrl,
    this.college,
    this.isLocal,
    this.fileExtension,
    this.isFile,
    this.rebuild,
  });
  factory FilePost.fromDocument(DocumentSnapshot doc) {
    return new FilePost(
      postId: doc['postId'],
      userId: doc['userId'],
      username: doc['username'],
      caption: doc['caption'],
      content: doc['content'],
      mediaUrl: doc['mediaUrl'],
      college: doc['college'],
      isLocal: doc['isLocal'],
      fileExtension: doc['fileExtension'],
      isFile: doc['isFile'],
    );
  }
  @override
  _FilePostState createState() => _FilePostState();
}

class _FilePostState extends State<FilePost> {
  Dio dio = Dio();
  String details;
  bool isFilePostOwner;
  String filepath;
  int temp;
  String percentage;
  String dirloc =
      '/storage/emulated/0/Android/data/com.example.collegenet/files/';
  var randnum = 1;
  bool isDownloaded = false;
  bool downloading = false;
  downloadFile() async {
    setState(() {
      downloading = true;
    });
    // await Permission.storage.request();
    await Permission.storage.shouldShowRequestRationale;
    try {
      FileUtils.mkdir([dirloc]);
      await dio.download(
          widget.mediaUrl, dirloc + widget.postId + widget.fileExtension,
          onReceiveProgress: (receivedBytes, totalBytes) {
        setState(() {
          downloading = true;
          percentage =
              ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print("Error: " + e.toString());
    }
    setState(() {
      downloading = false;
      isDownloaded = true;
    });
  }

  IconData returnIcon() {
    switch (widget.fileExtension) {
      case ".jpg":
        {
          return FontAwesome5.file_image;
        }
        break;
      case ".jpeg":
        {
          return FontAwesome5.file_image;
        }
        break;
      case ".png":
        {
          return FontAwesome5.file_image;
        }
        break;
      case ".svg":
        {
          return FontAwesome5.file_image;
        }
        break;
      case ".mp3":
        {
          return FontAwesome5.file_audio;
        }
        break;
      case ".wav":
        {
          return FontAwesome5.file_audio;
        }
        break;
      case ".pdf":
        {
          return FontAwesome5.file_pdf;
        }
        break;
      case ".zip":
        {
          return FontAwesome5.file_archive;
        }
        break;
      case ".pptx":
        {
          return FontAwesome5.file_powerpoint;
        }
        break;
      case ".rar":
        {
          return FontAwesome5.file_archive;
        }
        break;
      case ".xlsx":
        {
          return FontAwesome5.file_excel;
        }
        break;
      case ".docx":
        {
          return FontAwesome5.file_word;
        }
      case ".mp4":
        {
          return FontAwesome5.file_video;
        }
        break;
      case ".mkv":
        {
          return FontAwesome5.file_video;
        }
        break;
      default:
        {
          return FontAwesome5.file;
        }
    }
  }

  createPostInFirestore({String ownerId, String postid}) async {
    String reportid = "Posts--" + postid + "--" + currentUser.id;
    await reportRef.document(reportid).setData({
      "postid": postid,
      "reportingUserId": currentUser.id,
      "ContentOwnerId": userId,
    });
    // setState(() {
    //   reportid = "Announcements--" + postid + "--" + currentUser.id;
    // });
    widget.rebuild();
    // Navigator.pop(context);
  }

  handleReport() async {
    await createPostInFirestore(
      postid: widget.postId,
      ownerId: widget.userId,
    );
  }

  reportAnnouncementPost() async {
    await localPostsRef.document(widget.postId).get().then((doc) {
      if (doc.exists) {
        handleReport();
      }
    });
    widget.rebuild();
  }

  handleReportFilePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Report this File ?"),
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

  frontView() {
    // print('enter front view');
    return Material(
      color: Colors.white.withOpacity(0.65),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 70.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.orange[500],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(22)),
              ),
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(filepath),
                    radius: 25,
                  ),
                ),
                title: Text(
                  widget.caption.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                contentPadding: EdgeInsets.all(5),
                dense: true,
                subtitle: (widget.isFile)
                    ? Text(
                        "Type of File : ${widget.fileExtension}",
                        style: TextStyle(
                          color: Color(0xffefecec),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      )
                    : Text(
                        "Resource link",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                trailing: isFilePostOwner
                    ? IconButton(
                        icon: Icon(
                          SimpleLineIcons.options_vertical,
                          size: 25,
                        ),
                        onPressed: () => handleDeleteFilePost(context))
                    : IconButton(
                        icon: Icon(
                          Icons.report,
                          size: 25,
                        ),
                        onPressed: () => handleReportFilePost(context)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xff497285).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 144,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Center(
                  child: Text(
                    widget.content,
                    style: TextStyle(
                      color: Color(0xff38486f),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 2),
            Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xfffc8a15).withOpacity(0.7),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22)),
              ),
              child: Text(
                "Tap to See More",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  backView() {
    // return Text('back');
    return Material(
      color: Colors.white.withOpacity(0.65),
      borderRadius: BorderRadius.circular(24),
      shadowColor: Colors.amber.withOpacity(0.9),
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color(0xff1a2639),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Center(
                child: Text(
                  "  UPLOADED BY:  ",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 30,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            downloading ? linearProgress() : Container(),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.username,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'CybertoothLight'),
              ),
            ),
            SizedBox(height: 30.0),
            (widget.isFile)
                ? (isDownloaded == false)
                    ? Center(
                        child: RaisedButton(
                          elevation: 10,
                          highlightColor: Colors.orange[50],
                          hoverColor: Colors.orange,
                          color: Colors.black,
                          textColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'Download File',
                            style:
                                TextStyle(fontFamily: 'Lato', fontSize: 25.0),
                          ),
                          onPressed: downloading ? null : () => downloadFile(),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            returnIcon(),
                            size: 35.0,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            elevation: 10,
                            highlightColor: Colors.orange[50],
                            hoverColor: Colors.orange,
                            color: Colors.black,
                            textColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () async {
                              String filePath =
                                  dirloc + widget.postId + widget.fileExtension;
                              try {
                                await OpenFile.open(filePath);
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Text(
                              'Open File',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                        ],
                      )
                : Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.lerp(
                            BorderRadius.circular(10),
                            BorderRadius.circular(10),
                            10),
                      ),
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            ' Click Here to open link ',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 25.0,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        onTap: () async {
                          String url = widget.mediaUrl;
                          if (!url.startsWith("http")) {
                            url = "https://" + url;
                          }
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ),
                  ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  buildPostHeader() {
    // print(content)
    // print(isFile);
    isFilePostOwner = (widget.userId == currentUser.id);
    details = widget.content;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 330,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff155263),
                    Color(0xff2d4059),
                    Color(0xffff9a3c),
                    Color(0xffffc93c),
                  ]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.orange[900],
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
            child: FlipCard(
                direction: FlipDirection.VERTICAL,
                front: frontView(),
                back: backView()),
          ),
        ),
      ),
    );
  }

  deleteFilePost() async {
    await localPostsRef.document(widget.postId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    await userWisePostsRef
        .document(userId)
        .collection("posts")
        .document(widget.postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    widget.rebuild();
    if (widget.isFile) {
      await storageRef
          .child("post_${widget.postId}" + "${widget.fileExtension}")
          .delete();
    }
  }

  handleDeleteFilePost(BuildContext parentContext) async {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(15),
            title: Center(
              child: Text(
                "Options",
                style: TextStyle(fontSize: 24, fontFamily: 'Lora'),
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deleteFilePost();
                },
                child: Center(
                  child: Text(
                    "Delete",
                    style: TextStyle(fontSize: 16, fontFamily: 'Lora'),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditPost(
                              postId: widget.postId,
                              caption: widget.caption,
                              content: widget.content,
                              mediaUrl: widget.mediaUrl,
                              isLocal: widget.isLocal,
                              isFile: widget.isFile,
                              fileExtension: widget.fileExtension,
                              rebuild: widget.rebuild,
                            )),
                  );
                },
                child: Center(
                  child: Text(
                    "Edit",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        });
  }

  checkifdownloaded() async {
    String filePath = dirloc + widget.postId + widget.fileExtension;
    if (await File(filePath).exists()) {
      setState(() {
        isDownloaded = true;
      });
    } else {
      setState(() {
        isDownloaded = false;
      });
    }
  }

  @override
  void initState() {
    //  getUserById();
    super.initState();
    setState(() {
      isDownloaded = false;
      checkifdownloaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    temp = widget.userId.codeUnitAt(0);
    randnum = 1 + (temp - 48);
    temp = randnum.ceil();
    filepath = 'assets/images/avatars/av$temp.png';
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPostHeader(),
        ],
      ),
    );
  }
}
