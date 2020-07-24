import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/add_localfiles.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/auth.dart';
import 'package:collegenet/services/loading.dart';
import 'package:flutter/material.dart';
import 'package:collegenet/widgets/filepost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/loading.dart';

class LocalFiles extends StatefulWidget {
  LocalFiles({
    this.auth,
    this.onSignedOut,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final User user;
  @override
  _LocalFilesState createState() => _LocalFilesState();
}

class _LocalFilesState extends State<LocalFiles> {
  bool isLoading = false;
  String userId = currentUser.id;
  List<FilePost> posts = [];

  buildfileposts() {
    if (isLoading) {
      return circularProgress();
    } else {
      List<FilePost> fileposts = [];
      for (var i = 0; i < posts.length; i++) {
        if (posts[i] != null) {
          fileposts.add(posts[i]);
        }
      }
      return Column(
        children: posts,
      );
    }
  }

  getFileposts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await localPostsRef
        .where("college", isEqualTo: currentUser.college)
        .getDocuments();
    setState(() {
      isLoading = false;
      posts =
          snapshot.documents.map((doc) => FilePost.fromDocument(doc)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getFileposts();
  }

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text(
    "College Files",
    style: TextStyle(
      fontFamily: 'Chelsea',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: Colors.orange[800],
            title: cusSearchBar,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: this.cusIcon,
                  onPressed: () {
                    if (this.cusIcon.icon == Icons.search) {
                      setState(() {
                        this.cusIcon = Icon(Icons.cancel);
                        this.cusSearchBar = TextField(
                          decoration: InputDecoration(
                            hintText: "Search here",
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          textInputAction: TextInputAction.go,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        );
                      });
                    } else {
                      setState(() {
                        this.cusIcon = Icon(Icons.search);
                        this.cusSearchBar = Text(
                          "College Files",
                          style: TextStyle(
                            fontFamily: 'Chelsea',
                          ),
                        );
                      });
                    }
                  }),
            ]),
        body: isLoading
            ? circularProgress()
            : Container(
                child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: buildfileposts(),
                  ),
                ),
              )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          foregroundColor: Colors.orange,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddLocalFile(),
              ),
            );
          },
        ));
  }
}
