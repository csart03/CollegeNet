// import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/loading.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'homepage.dart';

String cnt = "No file chosen";

class EditPost extends StatefulWidget {
  EditPost({
    this.postId,
    this.caption,
    this.content,
    this.mediaUrl,
    this.isLocal,
    this.fileExtension,
    this.isFile,
    this.rebuild,
  });
  final String postId;
  final String caption;
  final String content;
  final String mediaUrl;
  final bool isLocal;
  final bool isFile;
  final String fileExtension;
  final VoidCallback rebuild;

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  Dio dio = Dio();
  File file;
  int length = 0;
  bool isUploading = false;
  bool toggleValue = false;
  bool isnewfile = false;
  String postId = Uuid().v4();
  TextEditingController captionControl = TextEditingController();
  TextEditingController contentControl = TextEditingController();
  TextEditingController linkControl = TextEditingController();
  String userId = currentUser.id,
      username = currentUser.username,
      college = currentUser.college;
  bool isEmptyTitle = false, isEmptyLink = false, isEmptyDes = false;

  String getExtension(File file) {
    if (file != null) {
      int len = file.path.length;
      int idx = file.path.lastIndexOf('.');
      String ext = '';
      for (; idx < len; idx++) {
        ext = ext + file.path[idx];
      }
      print(ext);
      return ext;
    } else {
      return widget.fileExtension;
    }
  }

  String percentage;
  String dirloc =
      '/storage/emulated/0/Android/data/com.example.collegenet/files/';
  double randnum = 1;
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
    super.initState();
    cnt = "No new file chosen";
    captionControl.text = widget.caption;
    contentControl.text = widget.content;
    linkControl.text = widget.mediaUrl;
    toggleValue = widget.isFile;
    if (toggleValue) {
      checkifdownloaded();
    }
  }

  Future<String> uploadImage(File file) async {
    if (file != null) {
      StorageUploadTask uploadTask = storageRef
          .child("post_${widget.postId}" + getExtension(file))
          .putFile(file);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      return downloadUrl;
    } else {
      return null;
    }
  }

  editPostInFirestore({
    String mediaURL,
    String caption,
    String content,
    String fileExtension,
  }) {
    localPostsRef.document(widget.postId).updateData({
      "mediaUrl": mediaURL,
      "caption": caption,
      "content": content,
      "fileExtension": fileExtension,
    });
    userWisePostsRef
        .document(userId)
        .collection("posts")
        .document(widget.postId)
        .updateData({
      "mediaUrl": mediaURL,
      "caption": caption,
      "content": content,
      "fileExtension": fileExtension,
    });
    setState(() {
      file = null;
      isUploading = false;
      captionControl.clear();
      contentControl.clear();
      linkControl.clear();
    });
    widget.rebuild();
    Navigator.pop(context);
  }

  handleUpload() async {
    setState(() {
      isUploading = true;
    });
    print(toggleValue.toString() + "check ");
    if (toggleValue) {
      String mediaURL = widget.mediaUrl;
      if (file != null) {
        storageRef
            .child("post_${widget.postId}" + "${widget.fileExtension}")
            .delete();
        print("post_${widget.postId}" + "${widget.fileExtension}");
        mediaURL = await uploadImage(file);
      }
      // print(mediaURL);
      if (mediaURL != null) {
        editPostInFirestore(
          mediaURL: mediaURL,
          caption: captionControl.text,
          content: contentControl.text,
          fileExtension: getExtension(file),
        );
      } else {
        setState(() {
          cnt = "No new file chosen.";
        });
      }
    } else {
      String mediaURL = linkControl.text;
      editPostInFirestore(
        mediaURL: mediaURL,
        caption: captionControl.text,
        content: contentControl.text,
        fileExtension: "",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isUploading | downloading)
        ? circularProgress()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff1a2639),
              title: Text(
                'Edit Post',
                style: TextStyle(
                  fontSize: 30.0,
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
                            prefixIcon: Icon(Icons.title),
                            labelText: "Title",
                            hintText: "My New Post",
                            errorText: isEmptyTitle
                                ? "You cannot leave Title blank"
                                : "",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepOrangeAccent, width: 40.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      toggleValue
                          ? Column(
                              children: <Widget>[
                                Center(
                                  child: ButtonTheme(
                                    disabledColor: Colors.grey,
                                    buttonColor: Colors.lightBlue[100],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: RaisedButton(
                                      child: Text(
                                        'View Current File',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (!isDownloaded) {
                                          downloadFile();
                                        }
                                        String filePath = dirloc +
                                            widget.postId +
                                            widget.fileExtension;
                                        try {
                                          await OpenFile.open(filePath);
                                        } catch (e) {
                                          print(e.toString());
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: ButtonTheme(
                                    disabledColor: Colors.grey,
                                    buttonColor: Colors.lightBlue[100],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: RaisedButton(
                                      child: Text(
                                        'Replace File',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                      onPressed: () async {
                                        file = await FilePicker.getFile();
                                        setState(() {
                                          isnewfile = true;
                                          if (file == null) {
                                            cnt = "No file chosen";
                                          } else {
                                            String fileName =
                                                file.path.split('/').last;
                                            cnt = "$fileName";
                                            // print(file);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              width: 350.0,
                              child: TextField(
                                controller: linkControl,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesome.external_link),
                                  labelText: "Link",
                                  hintText: "www.google.com",
                                  errorText: isEmptyLink
                                      ? "You cannot leave Link blank"
                                      : "",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 40.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 20),
                      toggleValue
                          ? Center(
                              child: Container(
                                child: Text(
                                  '$cnt',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 20),
                      Container(
                        width: 350.0,
                        height: 100.0,
                        child: TextField(
                          controller: contentControl,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Foundation.clipboard_notes),
                            labelText: "Description",
                            hintText: "Enter your description here",
                            errorText: isEmptyDes
                                ? "You cannot leave Title blank"
                                : "",
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
                                : () async {
                                    setState(() {
                                      isEmptyTitle =
                                          captionControl.text.isEmpty;
                                      isEmptyDes = contentControl.text.isEmpty;
                                      isEmptyLink = linkControl.text.isEmpty;
                                    });
                                    bool isSubmit =
                                        !(isEmptyDes | isEmptyTitle);
                                    if (!toggleValue) {
                                      isSubmit = isSubmit & !isEmptyLink;
                                    }
                                    if ((file != null) & isSubmit) {
                                      String filePath = dirloc +
                                          widget.postId +
                                          widget.fileExtension;
                                      var oldfile = File(filePath);
                                      if (await oldfile.exists()) {
                                        await oldfile.delete();
                                      }
                                    }
                                    if (isSubmit) handleUpload();
                                  },
                            child: Text(
                              'Update',
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
