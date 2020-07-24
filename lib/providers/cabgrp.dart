import 'package:flutter/foundation.dart';

class CabGroup with ChangeNotifier {
  final String source;
  final String destination;
  final String leavetime;
  final String chatRoomId;
  CabGroup({
    this.source,
    this.chatRoomId,
    this.destination,
    this.leavetime,
  });
}
