import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegenet/models/users.dart';
import 'package:collegenet/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

final userRef = Firestore.instance.collection('users');

class ProfilePage extends StatefulWidget {
  ProfilePage({
    this.auth,
    this.onSignedOut,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final User user;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool load = false;
  int randnum = 1;
  String filepath;
  int temp;

  @override
  void initState() {
    //  getUserById();
    super.initState();
    temp = widget.user.id.codeUnitAt(0);
    randnum = 1 + (temp - 48);
    temp = randnum.ceil();
    // print(temp);
    filepath = 'assets/images/avatars/av$temp.png';
  }
  // getUserById() async {
  //   final String id="IAmNjAE45F5hW24GuFE4";
  //   final DocumentSnapshot doc = await userRef.document(id);
  //     print(doc.data);
  //     print(doc.documentID);
  //     print(doc.exists);
  // }

  void getUsers() async {
    final QuerySnapshot snapshot =
        await userRef.where("isAdmin", isEqualTo: false).getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) {
      // print(doc.data);
      // print(doc.documentID);
      // print(doc.exists);
    });
  }

  void _logoutUser() async {
    try {
      setState(() => load = true);
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      setState(() => load = false);
      print("error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1a2639),
        title: Text(
          'Profile Page',
          style: TextStyle(
            fontFamily: 'Chelsea',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              colors: [
                Colors.cyan[100],
                Colors.orange[100],
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  AvatarGlow(
                    glowColor: Colors.cyan[400],
                    repeat: true,
                    showTwoGlows: true,
                    endRadius: 100.0,
                    child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(filepath),
                        radius: 50.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.user.username,
                    style: TextStyle(
                      fontFamily: 'Alegreya',
                      fontSize: 32.0,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.user.college,
                    style: TextStyle(
                      fontFamily: 'Alegreya',
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.user.batch,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RaisedButton.icon(
                    color: Colors.grey[350],
                    onPressed: _logoutUser,
                    icon: Icon(AntDesign.logout),
                    label: Text(
                      "SignOut",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Alegreya',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
