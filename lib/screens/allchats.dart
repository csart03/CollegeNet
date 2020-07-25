import 'package:collegenet/screens/chat_screen.dart';
import 'package:collegenet/widgets/appdrawer_cab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/allgrps.dart';
import '../providers/cabgrp.dart';

class AllChats extends StatelessWidget {
  static const routeName = '/all-chats';

  @override
  Widget build(BuildContext context) {
    final cabdata = Provider.of<AllCabs>(context);
    final cabs = cabdata.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      drawer: CabAppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                          itemCount: cabdata.items.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              ChangeNotifierProvider.value(
                                value: cabs[index],
                                child: ChatTile(),
                              ))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cab = Provider.of<CabGroup>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatRoomId: cab.chatRoomId,
            ),
          ),
        );
      },
      onLongPress: () {},
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    'assets/images/taxicab.jpg',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${cab.source} to ${cab.destination} on ${cab.leavetime}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Enter Chat Room',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
