import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class NewMessage extends StatefulWidget {
  NewMessage({this.chatRoomId});
  final String chatRoomId;
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance
        .collection('Chat Rooms/${widget.chatRoomId}/messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
    });
    _controller.clear();
    final fbm = FirebaseMessaging();
    // FirebaseMessaging fbm = new FirebaseMessaging();
    List<dynamic> listusers;
    QuerySnapshot qshot = await Firestore.instance
        .collection('Chat Rooms/${widget.chatRoomId}/users')
        .getDocuments();
    listusers = qshot.documents.map((doc) => doc.data['id']).toList();
    print(listusers);
    listusers.remove(await fbm.getToken());
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAADv72LYA:APA91bHbzyFNDQNote1_fjfE06fpaE2jWyqv1m-Px80ZzkeqM44kaHfissjXw6siv7oWYrFht2wGqLUfSv7RgH4YfD8qe7zAdZTJACwGgqdMI52BBrBQPi5Z6QlRY50ER2lDBf8GxokM',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'Message from ${userData['username']}',
            'body': '$_enteredMessage',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'screen': '2',
          },
          'registration_ids': listusers,
        },
      ),
    );
    print("sadaa");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
