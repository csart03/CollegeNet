import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  String username, college = 'IIIT-H', batch = 'UG2k15';
  List<String> collegeList = [
    'IIIT-H',
    'IIT-B',
    'IIIT-D',
    'IIT-HYD',
    'BITS PILANI',
    'BITS HYDERABAD',
    'BITS GOA',
    'IIT-KGP',
    'IIT-D',
    'IIT-K',
    'IIT-M',
    'IIT-G',
    'IIT-R',
  ];
  List<String> batchList = [
    'UG2k15',
    'UG2K16',
    'UG2K17',
    'UG2K18',
    'UG2K19',
    'UG2K20',
    'PG2K18',
    'PG2K19',
    'PG2K20',
  ];

  submit() {
    _formKey.currentState.save();
    var data = [username, college, batch];
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe2ded3),
      appBar: AppBar(
        backgroundColor: Color(0xff1a2639),
        automaticallyImplyLeading: false,
        title: Text(
          'Set Up your Profile',
          style: TextStyle(
            fontFamily: 'Chelsea',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "Create a username",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            onSaved: (val) => username = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Username",
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Must be at least 3 characters",
                            ),
                            maxLength: 14,
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          // TextFormField(
                          //   onSaved: (val1) => college = val1,
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     labelText: "College",
                          //     labelStyle: TextStyle(fontSize: 15.0),
                          //     hintText: "Must be at least 3 characters",
                          //   ),
                          // ),
                          //DropDown list for colleges
                          DropdownButton<String>(
                            items: collegeList.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String selectedOption) {
                              setState(() {
                                this.college = selectedOption;
                              });
                            },
                            value: college,
                          ),
                          DropdownButton<String>(
                            items: batchList.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String selectedOption) {
                              setState(() {
                                this.batch = selectedOption;
                              });
                            },
                            value: batch,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
