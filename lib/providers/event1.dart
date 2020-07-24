import 'package:flutter/foundation.dart';

class Event2 with ChangeNotifier {
  final String id;
  final String imageId;
  final String title;
  // final String imageId;
  final String description;
  final String imageURL;
  final int noOfPraticipants;
  final String fee;
  String startDate;
  String startTime;
  final int count;
  bool isGoing;
  Event2({
    @required this.id,
    @required this.imageId,
    @required this.title,
    @required this.description,
    @required this.imageURL,
    @required this.noOfPraticipants,
    @required this.fee,
    @required this.startDate,
    @required this.startTime,
    @required this.count,
    // @required this.imageId,
    this.isGoing = false,
  });
  void toggleGoingStatus() async {
    isGoing = !isGoing;
    notifyListeners();
  }
}
