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
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "", _password = "";
  bool load=false;

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
        setState(() => load = true);
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
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  //Design
  @override
  Widget build(BuildContext context) {
    return (load == true)
        ? circularProgress()
        : Scaffold(
      appBar: AppBar(
        title: Text(
          'College Net',
          style: TextStyle(
            fontFamily: 'Chelsea',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
          ),
        ),
      ),
    );
  }

  

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 12.0,
      ),
      logo(),
      SizedBox(height: 12.0),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? 'Email is req' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 12.0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? 'Password is req' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
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
          color: Colors.pink,
          textColor: Colors.white,
          onPressed: validateAndSubmit,
        ),
        SizedBox(height: 15.0),
        RaisedButton(
          child: Text('Don\'t have an account? Register',
              style: TextStyle(
                fontSize: 15.0,
              )),
          color: Colors.red[400],
          textColor: Colors.white,
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        RaisedButton(
          child: Text('Register',
              style: TextStyle(
                fontSize: 20.0,
              )),
          color: Colors.pink,
          textColor: Colors.white,
          onPressed: validateAndSubmit,
        ),
        SizedBox(height: 15.0),
        RaisedButton(
          onPressed: moveToLogin,
          child: Text('Already have an account? Login',
              style: TextStyle(
                fontSize: 15.0,
              )),
          color: Colors.red[400],
          textColor: Colors.white,
        )
      ];
    }
  }

  Widget logo() {
    return Hero(
        tag: Text('icon'),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 110.0,
          child: Image.asset('assets/images/logo1.jpg'),
        ));
  }
}
