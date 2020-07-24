import 'package:collegenet/models/users.dart';
import 'package:collegenet/services/auth.dart';
import 'package:collegenet/services/loading.dart';
import 'package:flutter/material.dart';

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
  // final formKey = GlobalKey<FormState>();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  FormType _formType = FormType.login;
  String _email = "", _password = "";
  bool load = false;
  String text1 = "Login", text2 = "Welcome Back";

  //Methods
  bool validateAndSave() {
    // final form = formKey.currentState;
    // if (form.validate()) {
    //   form.save();
    //   return true;
    // } else {
    //   return false;
    // }
    return true;
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
        setState(() => load = false);
        print("error :" + e.toString());
      }
    }
  }

  void moveToRegister() {
    emailCont.clear();
    passCont.clear();
    // formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      text1 = "Register";
      text2 = "Welcome Onboard";
    });
  }

  void moveToLogin() {
    emailCont.clear();
    passCont.clear();
    // formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      text1 = "Login";
      text2 = "Welcome Back";
    });
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
                  colors: [
                    Colors.orange[900],
                    Colors.orange[600],
                    Colors.orange[300]
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 80),
                  // logo(),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              text1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontFamily: 'PermanentMarker'),
                            ),
                            // SizedBox(width:50.0),
                            logo(),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          text2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Lato'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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
      Container(
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
          ],
        ),
      ),
      SizedBox(
        height: 40.0,
      ),
    ];
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text('Login',
              style: TextStyle(
                fontSize: 20.0,
              )),
          color: Colors.orange[800],
          textColor: Colors.white,
          onPressed: validateAndSubmit,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        SizedBox(height: 15.0),
        RaisedButton(
          child: Text('Don\'t have an account? Register',
              style: TextStyle(
                fontSize: 15.0,
              )),
          color: Colors.orange[600],
          textColor: Colors.white,
          onPressed: moveToRegister,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        )
      ];
    } else {
      return [
        RaisedButton(
          child: Text('Register',
              style: TextStyle(
                fontSize: 20.0,
              )),
          color: Colors.orange[800],
          textColor: Colors.white,
          onPressed: validateAndSubmit,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        SizedBox(height: 15.0),
        RaisedButton(
          onPressed: moveToLogin,
          child: Text('Already have an account? Login',
              style: TextStyle(
                fontSize: 15.0,
              )),
          color: Colors.orange[600],
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
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
            radius: 60.0,
            child: Image.asset('assets/images/logo1.jpg'),
          )),
    );
  }
}
