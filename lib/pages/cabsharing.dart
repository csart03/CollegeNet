import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/add_cabsharing.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/auth.dart';
import 'package:collegenet/widgets/appdrawer_cab.dart';
import 'package:collegenet/widgets/cabposts.dart';
import 'package:flutter/material.dart';
import '../services/loading.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

final cabPostsRef = Firestore.instance.collection("CabPosts");
final places = [];
enum PageType {
  allPosts,
  myPosts,
}
PageType status;
String pageName;
QuerySnapshot snapshot;
String init = "";
List<Widget> cabposts = [];

class CabSharing extends StatefulWidget {
  static const routeName = '/cabshare';
  CabSharing({
    this.auth,
    this.onSignedOut,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  final User user;
  @override
  _CabSharingState createState() => _CabSharingState();
}

class _CabSharingState extends State<CabSharing> {
  bool isLoading = false;
  List<CabPosts> posts = [];

  buildCabPosts() {
    cabposts.clear();
    posts.clear();
    List<DocumentSnapshot> l = snapshot.documents, revlist = [], userpost = [];
    for (var i = l.length - 1; i >= 0; i--) {
      if (l[i].data['userid'] == widget.user.id) {
        print("1");
        userpost.add(l[i]);
      } else {
        revlist.add(l[i]);
        print("2");
      }
    }
    l = revlist;
    for (var i = 0; i < l.length; i++) {
      posts.add(CabPosts(
        postId: l[i].data['postId'],
        userId: l[i].data['userId'],
        username: l[i].data['username'],
        destination: l[i].data['destination'],
        source: l[i].data['source'],
        facebook: l[i].data['facebook'],
        college: l[i].data['college'],
        count: l[i].data['count'],
        leavetime: l[i].data['leavetime'],
        contact: l[i].data['contact'],
        users: l[i].data['users'],
        chatRoomId: l[i].data['chatRoomId'],
        rebuild: getCabposts,
      ));
    }
    // List<DocumentSnapshot> l = snapshot.documents;
    for (var i = 0; i < posts.length; i++) {
      if (posts[i] != null) {
        cabposts.add(posts[i]);
        cabposts.add(SizedBox(
          height: 20,
        ));
        // print(posts[i].caption);
      }
    }
    setState(() {
      init = '';
    });
    // print(posts[0].whatsapp);
  }

  getCabposts() async {
    setState(() {
      isLoading = true;
    });
    snapshot = await cabPostsRef
        .where("college", isEqualTo: currentUser.college)
        .orderBy('leavetime')
        .getDocuments();

    setState(() {
      isLoading = false;
    });
    List<DocumentSnapshot> l = snapshot.documents;
    places.clear();
    String cap, cap1;
    for (var i = 0; i < l.length; i++) {
      cap = l[i].data['source'].toString().toLowerCase();
      cap1 = l[i].data['destination'].toString().toLowerCase();
      if (!places.contains(cap)) places.add(cap);
      if (!places.contains(cap1)) places.add(cap1);
    }
    for (var i = 0; i < places.length; i++) {
      print(places[i]);
    }
    buildCabPosts();
  }

  @override
  void initState() {
    getCabposts();
    super.initState();
  }

  double h = 72;
  Widget cusSearchBar = Text(
    "Cabs",
    style: TextStyle(
      fontFamily: 'Chelsea',
    ),
  );
  Widget filter = Text("");
  search() async {
    cabposts.clear();
    final pl = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirstRoute()),
    );
    posts.clear();
    List<DocumentSnapshot> l = snapshot.documents;
    if (pl == null) {
      buildCabPosts();
      return;
    }
    print(pl[2]);
    if (pl[2] == "All Dates") {
      for (var i = 0; i < l.length; i++) {
        String cap = l[i].data['source'].toString().toLowerCase();
        String cap1 = l[i].data['destination'].toString().toLowerCase();
        if (cap.contains(pl[0]) && cap1.contains(pl[1])) {
          posts.add(CabPosts(
            postId: l[i].data['postId'],
            userId: l[i].data['userId'],
            username: l[i].data['username'],
            destination: l[i].data['destination'],
            source: l[i].data['source'],
            facebook: l[i].data['facebook'],
            college: l[i].data['college'],
            count: l[i].data['count'],
            leavetime: l[i].data['leavetime'],
            contact: l[i].data['contact'],
            users: l[i].data['users'],
            chatRoomId: l[i].data['chatRoomId'],
            rebuild: getCabposts,
          ));
        }
      }
    } else {
      for (var i = 0; i < l.length; i++) {
        String cap = l[i].data['source'].toString().toLowerCase();
        String cap1 = l[i].data['destination'].toString().toLowerCase();
        DateTime cap2 = l[i].data['leavetime'].toDate();
        String cap3 = DateFormat.yMMMd().format(cap2);
        if (cap.contains(pl[0]) && cap1.contains(pl[1]) && cap3 == pl[2]) {
          posts.add(CabPosts(
            postId: l[i].data['postId'],
            userId: l[i].data['userId'],
            username: l[i].data['username'],
            destination: l[i].data['destination'],
            source: l[i].data['source'],
            facebook: l[i].data['facebook'],
            college: l[i].data['college'],
            count: l[i].data['count'],
            leavetime: l[i].data['leavetime'],
            contact: l[i].data['contact'],
            users: l[i].data['users'],
            chatRoomId: l[i].data['chatRoomId'],
            rebuild: getCabposts,
          ));
        }
      }
    }
    cabposts.add(Center(
        child: RaisedButton(
            child: Text("Show All"),
            onPressed: () {
              buildCabPosts();
            })));
    for (var i = 0; i < posts.length; i++) {
      if (posts[i] != null) {
        cabposts.add(posts[i]);
        cabposts.add(SizedBox(
          height: 20,
        ));
      }
      print(posts.length);
      if (posts.length == 1) cabposts.add(Text("No Result Found"));
    }
    setState(() {
      init = '';
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddCab(
              rebuild: getCabposts,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.bounceInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xffe2ded3),
      drawer: CabAppDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff1a2639),
        title: Center(child: Text("Cabs")),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                search();
              })
        ],
      ),
      body: isLoading
          ? circularProgress()
          : Container(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: cabposts,
                  )),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 28,
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.amberAccent[400],
        onPressed: () {
          Navigator.push(
            context,
            _createRoute(),
          );
        },
      ),
    );
  }
}

class CitiesService {
  static List<String> cities = [];
  static List<String> getSuggestions(String query) {
    cities.clear();
    for (var i = 0; i < places.length; i++) {
      cities.add(places[i]);
    }
    List<String> matches = List();
    matches.addAll(cities);
    print(matches);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class FirstRoute extends StatefulWidget {
  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String _selectedCity;
  final TextEditingController _typeAheadController1 = TextEditingController();
  String _selectedCity1;
  String date = "All Dates", time = "All Dates";
  DateTime lDate, finaldate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search for cabs"),
          centerTitle: true,
        ),
        body: Form(
          key: this._formKey,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                Text('Pick Starting Location?'),
                SizedBox(
                  height: 10,
                ),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: this._typeAheadController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: 'Starting Location')),
                  suggestionsCallback: (pattern) {
                    return CitiesService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeAheadController.text = suggestion;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select a place';
                    }
                    return "";
                  },
                  onSaved: (value) => this._selectedCity = value,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text('Pick Final Location?'),
                SizedBox(
                  height: 10,
                ),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: this._typeAheadController1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: 'Destination')),
                  suggestionsCallback: (pattern) {
                    return CitiesService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeAheadController1.text = suggestion;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select a place';
                    }
                  },
                  onSaved: (value) => this._selectedCity1 = value,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("(*Optional) Do You wish to Choose Date ?"),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: ButtonTheme(
                    disabledColor: Colors.grey,
                    buttonColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: RaisedButton(
                      child: Text("Choose date"),
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
                            date = DateFormat.yMMMd().format(value);
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
                  "Searching For : " + date,
                  style: TextStyle(
                    fontFamily: 'Lato',
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                RaisedButton(
                  child: Text('Search'),
                  onPressed: () {
                    if (this._formKey.currentState.validate()) {
                      this._formKey.currentState.save();
                      dynamic l = [_selectedCity, _selectedCity1, date];
                      Navigator.pop(context, l);
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
