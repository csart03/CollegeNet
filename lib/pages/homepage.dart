import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegenet/pages/cabhome.dart';
import 'package:collegenet/pages/hostevent.dart';
import 'package:collegenet/pages/profilepage.dart';
import 'package:collegenet/services/auth.dart';
import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/globalfiles.dart';
// import 'package:collegenet/pages/activeevents.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collegenet/pages/setupusername.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import '../services/loading.dart';
import 'announcements.dart';

final usersRef = Firestore.instance.collection("users");
final localPostsRef = Firestore.instance.collection("localPosts");
final userWisePostsRef = Firestore.instance.collection("userWisePosts");
final StorageReference storageRef = FirebaseStorage.instance.ref();
final announcementRef = Firestore.instance.collection("announcements");
final reportRef = Firestore.instance.collection("reports");

User currentUser;
String userId;

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut, this.pageIndex});
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final int pageIndex;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables
  PageController pageController;
  int pageIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pageIndex = widget.pageIndex;
    print(pageIndex);
    createUserInFirestore();
    pageController = PageController(initialPage: pageIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  createUserInFirestore() async {
    setState(() {
      isLoading = true;
    });
    //Check if user exist in user database according to ID

    userId = await widget.auth.getCurrentUser();
    DocumentSnapshot doc = await usersRef.document(userId).get();
    setState(() {
      isLoading = false;
    });
    //if user doesn't exist then go to create account page
    if (!doc.exists) {
      final data = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      print(data);

      //get username from create account, use it to make new document in users collection
      setState(() {
        isLoading = true;
      });
      usersRef.document(userId).setData({
        "id": userId,
        "username": data[0],
        "college": data[1],
        "batch": data[2],
      });
      doc = await usersRef.document(userId).get();
    }
    currentUser = User.fromDocument(doc);
    setState(() {
      isLoading = false;
    });
    print(currentUser.username);
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
    // pageController.animateToPage(pageIndex,
    // duration: Duration(milliseconds: 500),
    // curve: Curves.easeIn);
    print(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? circularProgress()
        : Scaffold(
            body: PageView(
                children: <Widget>[
                  GlobalFiles(
                    auth: widget.auth,
                    onSignedOut: widget.onSignedOut,
                    user: currentUser,
                  ),
                  HostEvent(
                    auth: widget.auth,
                    onSignedOut: widget.onSignedOut,
                    user: currentUser,
                  ),
                  HomeCabs(
                    auth: widget.auth,
                    onSignedOut: widget.onSignedOut,
                    user: currentUser,
                  ),
                  Announcements(
                    auth: widget.auth,
                    onSignedOut: widget.onSignedOut,
                    user: currentUser,
                  ),
                  ProfilePage(
                    auth: widget.auth,
                    onSignedOut: widget.onSignedOut,
                    user: currentUser,
                  ),
                ],
                controller: pageController,
                onPageChanged: onPageChanged,
                physics: NeverScrollableScrollPhysics()),
            bottomNavigationBar: CupertinoTabBar(
                currentIndex: pageIndex,
                onTap: onTap,
                activeColor: Colors.orange[500],
                backgroundColor: Colors.black,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.chrome_reader_mode)),
                  BottomNavigationBarItem(icon: Icon(Icons.event_note)),
                  BottomNavigationBarItem(icon: Icon(Icons.directions_car)),
                  BottomNavigationBarItem(
                      icon: Icon(LineAwesomeIcons.bullhorn)),
                  BottomNavigationBarItem(icon: Icon(MaterialIcons.person)),
                ]));
  }
}
