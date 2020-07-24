import '../chat/new_message.dart';
import 'package:flutter/material.dart';
import '../chat/messages.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    this.chatRoomId,
    this.destination,
    this.source,
    this.leavetime,
  });
  final String chatRoomId;
  final String source;
  final String destination;
  final String leavetime;
  static const routeName = '/chat-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(
                chatRoomId: chatRoomId,
              ),
            ),
            NewMessage(
              chatRoomId: chatRoomId,
            ),
          ],
        ),
      ),
    );
  }
}
