import 'package:collegenet/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPass extends StatefulWidget {
  final AuthImplementation auth;
  final Function(String) forgotmessage;
  ForgotPass({
    this.auth,
    this.forgotmessage,
  });
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailCont = TextEditingController();
  String message = "";
  Future<void> resetPassword(String email) async {
    message =
        "Password Reset Email has been successfully sent to ${emailCont.text}";
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      message =
          "Email address has been badly formatted or has not been registered";
    }
    widget.forgotmessage(message);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1a2639),
        title: Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'Chelsea',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 900,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter your email",
                  style: TextStyle(fontFamily: 'Lato', fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(225, 95, 27, .3),
                      blurRadius: 5,
                      offset: Offset(4, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: emailCont,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                onPressed: () => resetPassword(emailCont.text),
                child: Text('Send Reset Email'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
