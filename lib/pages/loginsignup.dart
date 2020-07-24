import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/forgotpass.dart';
import 'package:collegenet/services/auth.dart';
import 'package:collegenet/services/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({
    this.onSignedIn,
    this.auth,
    this.user,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  final User user;
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

enum FormType { login, register }

class _LoginSignupPageState extends State<LoginSignupPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  FormType _formType = FormType.login;
  String _email = "", _password = "";
  bool load = false;
  String text1 = "Sign In", text2 = "Welcome Back";
  String errMsg = "";
  List<Color> loginColor = [
    Colors.orange[900],
    Colors.orange[600],
    Colors.orange[300],
  ],
      registerColor = [Colors.blueGrey, Colors.lightBlueAccent],
      color;
  bool visibleMessage = false;
  //Methods
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        setState(() {
          load = true;
          _email = emailCont.text;
          _password = passCont.text;
        });
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
          print("Register userId = " + userId);
        } else {
          String userId = await widget.auth.signUp(_email, _password);
          print("Register userId = " + userId);
        }
        widget.onSignedIn();
      } catch (e) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => errorWidget()),
        );
        setState(() {
          load = false;
          errMsg = e.message;
        });
        print("error :" + e.toString());
      }
    }
  }

  void moveToRegister() {
    emailCont.clear();
    passCont.clear();
    setState(() {
      _formType = FormType.register;
      text1 = "Sign Up";
      text2 = "Welcome Onboard";
      color = registerColor;
    });
  }

  void moveToLogin() {
    emailCont.clear();
    passCont.clear();
    setState(() {
      _formType = FormType.login;
      text1 = "Sign In";
      text2 = "Welcome Back";
      color = loginColor;
    });
  }

  @override
  void initState() {
    super.initState();
    color = loginColor;
  }

  //Design
  @override
  Widget build(BuildContext context) {
    return (load == true)
        ? circularProgress()
        : Scaffold(
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: color,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // visibleMessage ? SizedBox(height: 40) : Container(),
                  visibleMessage
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  errMsg,
                                  style: TextStyle(fontSize: 14),
                                )),
                                IconButton(
                                    icon: Icon(Entypo.squared_cross),
                                    onPressed: () {
                                      setState(() {
                                        visibleMessage = false;
                                      });
                                    })
                              ],
                            ),
                          ),
                        )
                      : Text(''),
                  visibleMessage
                      ? SizedBox(height: 20)
                      : SizedBox(
                          height: 40,
                        ),
                  // logo(),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            text2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontFamily: 'Fenix'),
                          ),
                        ),
                        // SizedBox(width:50.0),
                        // logo(),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            text1,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Lato'),
                          ),
                        ),
                        logo(),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: createInputs() + createButtons(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 15.0,
      ),
      Form(
        key: formKey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(225, 95, 27, .3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: emailCont,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    return value.isEmpty ? 'Email is req' : null;
                  },
                  onSaved: (value) {
                    return _email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: passCont,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    return value.isEmpty ? 'Password is req' : null;
                  },
                  onSaved: (value) {
                    return _password = value;
                  },
                ),
              ),
              // errorWidget(),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 40.0,
      ),
    ];
  }

  errorWidget() {
    if (errMsg.length > 0 && errMsg != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            colors: [
              Colors.cyan[100],
              Colors.orange[200],
            ],
          ),
        ),
        child: AlertDialog(
          title: Text("Error"),
          content: Text(errMsg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                emailCont.clear();
                passCont.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Text('Sign In',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
            ),
            color: Colors.orange[800],
            textColor: Colors.white,
            onPressed: validateAndSubmit,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print("forgot");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPass(
                        auth: widget.auth,
                        forgotmessage: (e) {
                          setState(() {
                            visibleMessage = true;
                            errMsg = e;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Text(
                  "Forgot Your Password?",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.0),
        RaisedButton(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Text('Don\'t have an account? Sign Up',
                style: TextStyle(
                  fontSize: 17.0,
                )),
          ),
          color: Colors.orange[600],
          textColor: Colors.white,
          onPressed: moveToRegister,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        )
      ];
    } else {
      return [
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Text('Sign Up',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
            ),
            color: Color(0xff48b6d1),
            textColor: Colors.white,
            onPressed: validateAndSubmit,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        SizedBox(height: 25.0),
        Container(
          // width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Text('Already Have an account, Sign In',
                  style: TextStyle(
                    fontSize: 17.0,
                  )),
            ),
            color: Color(0xff0096d1),
            textColor: Colors.white,
            onPressed: moveToLogin,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        )
      ];
    }
  }

  Widget logo() {
    return Center(
      child: Hero(
          tag: Text('icon'),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 70.0,
            child: Image.asset('assets/images/logo1.jpg'),
          )),
    );
  }
}
