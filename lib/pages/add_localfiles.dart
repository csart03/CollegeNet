// import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/loading.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:uuid/uuid.dart';

import 'homepage.dart';

String cnt = "No file chosen";

class AddLocalFile extends StatefulWidget {
  // AddLocalFile({this.currentUser});
  // final User currentUser;
  final VoidCallback rebuild;
  AddLocalFile({
    this.rebuild,
  });
  @override
  _AddLocalFileState createState() => _AddLocalFileState();
}

class _AddLocalFileState extends State<AddLocalFile> {
  File file;
  int length = 0;
  bool isUploading = false;
  bool toggleValue = false;
  String postId = Uuid().v4();
  TextEditingController captionControl = TextEditingController();
  TextEditingController contentControl = TextEditingController();
  TextEditingController linkControl = TextEditingController();
  bool isEmptyTitle = false, isEmptyLink = false, isEmptyDes = false;
  List<String> categoryList = [
    'Notes',
    'E-books',
    'Resource Links',
    'Repository',
    'Mess Menu',
    'Other'
  ];
  bool ug2k19, ug2k20, ug2k18, ug2k17, ug2k16, pg2k18, pg2k19, pg2k20;

  initialzeBatches() {
    setState(() {
      ug2k19 =
          ug2k20 = ug2k18 = ug2k17 = ug2k16 = pg2k18 = pg2k19 = pg2k20 = false;
    });
  }

  String userId = currentUser.id,
      username = currentUser.username,
      college = currentUser.college,
      category = 'Other';
  String getExtension(File file) {
    int len = file.path.length;
    int idx = file.path.lastIndexOf('.');
    String ext = '';
    for (; idx < len; idx++) {
      ext = ext + file.path[idx];
    }
    print(ext);
    return ext;
  }

  @override
  void initState() {
    super.initState();
    cnt = "No file chosen";
    initialzeBatches();
  }

  Future<String> uploadImage(File file) async {
    if (file != null) {
      StorageUploadTask uploadTask =
          storageRef.child("post_$postId" + getExtension(file)).putFile(file);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      return downloadUrl;
    } else {
      return null;
    }
  }

  createPostInFirestore(
      {String mediaURL,
      String caption,
      String content,
      String fileExtension,
      bool isFile,
      String category,
      List<String> selectedbatch}) {
    localPostsRef.document(postId).setData({
      "postId": postId,
      "userId": userId,
      "username": username,
      "mediaUrl": mediaURL,
      "caption": caption,
      "content": content,
      "college": college,
      "isLocal": true,
      "isFile": isFile,
      "fileExtension": fileExtension,
      "isApproved": false,
      "category": category,
      "selectedbatch": selectedbatch,
    });
    userWisePostsRef
        .document(userId)
        .collection("posts")
        .document(postId)
        .setData({
      "postId": postId,
      "userId": userId,
      "username": username,
      "mediaUrl": mediaURL,
      "caption": caption,
      "content": content,
      "college": college,
      "isFile": isFile,
      "isLocal": true,
      "fileExtension": fileExtension,
      "isApproved": false,
      "category": category,
      "selectedbatch": selectedbatch,
    });
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
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
    List<bool> batchlist = [
      ug2k19,
      ug2k20,
      ug2k18,
      ug2k17,
      ug2k16,
      pg2k18,
      pg2k19,
      pg2k20
    ];
    List<String> batchliststr = [
      'ug2k19',
      'ug2k20',
      'ug2k18',
      'ug2k17',
      'ug2k16',
      'pg2k18',
      'pg2k19',
      'pg2k20'
    ];
    List<String> selectedbatch = [];
    for (var i = 0; i < batchlist.length; i++) {
      if (batchlist[i]) {
        selectedbatch.add(batchliststr[i].toUpperCase());
        // print(selectedbatch[0]);
      }
    }

    print(toggleValue.toString() + "check ");
    if (toggleValue) {
      String mediaURL = await uploadImage(file);
      print(mediaURL);
      if (mediaURL != null) {
        createPostInFirestore(
          mediaURL: mediaURL,
          caption: captionControl.text,
          content: contentControl.text,
          fileExtension: getExtension(file),
          isFile: toggleValue,
          category: category,
          selectedbatch: selectedbatch,
        );
      } else {
        setState(() {
          cnt = "No file chosen.";
        });
      }
    } else {
      String mediaURL = linkControl.text;
      createPostInFirestore(
        mediaURL: mediaURL,
        caption: captionControl.text,
        content: contentControl.text,
        fileExtension: "",
        isFile: toggleValue,
        category: category,
        selectedbatch: selectedbatch,
      );
    }
  }

  handleBatch(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
                contentPadding: EdgeInsets.all(15),
                title: Center(
                  child: Text(
                    "Select Batches",
                    style: TextStyle(fontSize: 22, fontFamily: 'Lora'),
                  ),
                ),
                children: <Widget>[
                  Center(
                    child: CheckboxListTile(
                      value: ug2k16,
                      title: Text('UG2K16'),
                      onChanged: (value) {
                        setState(() {
                          ug2k16 = value;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: CheckboxListTile(
                      value: ug2k17,
                      title: Text('UG2K17'),
                      onChanged: (value) {
                        setState(() {
                          ug2k17 = value;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: CheckboxListTile(
                      value: ug2k18,
                      title: Text('UG2K18'),
                      onChanged: (value) {
                        setState(() {
                          ug2k18 = value;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: CheckboxListTile(
                      value: ug2k19,
                      title: Text('UG2K19'),
                      onChanged: (value) {
                        setState(() {
                          ug2k19 = value;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: CheckboxListTile(
                      value: ug2k20,
                      title: Text('UG2K20'),
                      onChanged: (value) {
                        setState(() {
                          ug2k20 = value;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: CheckboxListTile(
                      value: pg2k18,
                      title: Text('PG2K18'),
                      onChanged: (value) {
                        setState(() {
                          pg2k18 = value;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: CheckboxListTile(
                      value: pg2k19,
                      title: Text('PG2K19'),
                      onChanged: (value) {
                        setState(() {
                          pg2k19 = value;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: CheckboxListTile(
                      value: pg2k20,
                      title: Text('PG2K20'),
                      onChanged: (value) {
                        setState(() {
                          pg2k20 = value;
                        });
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Done'),
                  )
                ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? circularProgress()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff1a2639),
              title: Text(
                'Upload files',
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
                      SizedBox(height: 20.0),
                      Text(
                        "Do you wish to Upload a file or a Link?",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Lato',
                        ),
                      ),
                      Switch(
                        value: toggleValue,
                        onChanged: (value) {
                          setState(() {
                            toggleValue = !toggleValue;
                          });
                        },
                        activeTrackColor: Colors.blue[200],
                        activeColor: Colors.blueAccent[200],
                      ),
                      Text(
                        toggleValue == false
                            ? 'Current Selection: Link'
                            : 'Current Selection: File',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Lato',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      toggleValue
                          ? Center(
                              child: ButtonTheme(
                                disabledColor: Colors.grey,
                                buttonColor: Colors.lightBlue[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: RaisedButton(
                                  child: Text(
                                    'Choose File',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                  onPressed: () async {
                                    file = await FilePicker.getFile();
                                    setState(() {
                                      if (file == null) {
                                        cnt = "No file chosen";
                                      } else {
                                        String fileName =
                                            file.path.split('/').last;
                                        cnt = "$fileName";
                                        print(file);
                                      }
                                    });
                                  },
                                ),
                              ),
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
                      // SizedBox(height: 20),
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
                      toggleValue ? SizedBox(height: 20) : Text(''),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Category: ',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          DropdownButton<String>(
                            items: categoryList.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String selectedOption) {
                              setState(() {
                                this.category = selectedOption;
                              });
                            },
                            value: category,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RaisedButton(
                          onPressed: () => handleBatch(context),
                          child: Text('Select Target Batches'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                                      isEmptyLink = linkControl.text.isEmpty;
                                    });
                                    bool isSubmit =
                                        !(isEmptyDes | isEmptyTitle);
                                    if (!toggleValue) {
                                      isSubmit = isSubmit & !isEmptyLink;
                                    } else {
                                      isSubmit = isSubmit & !(file == null);
                                    }
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
