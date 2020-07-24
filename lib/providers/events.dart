import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/screens/host_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './event1.dart';
import '../models/http_exception.dart';
import '../helpers/dbevents.dart';

class Events with ChangeNotifier {
  List<Event2> _items = [];
  List<Event2> _owneritems = [];
  List<Event2> get ownerItems {
    return [..._owneritems];
  }

  List<Event2> get items {
    return [..._items];
  }

  List<Event2> get goingones {
    return _items.where((eitem) => eitem.isGoing).toList();
  }

  Event2 findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetEvents() async {
    const url = 'https://collegenet-69.firebaseio.com/events.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Event2> loadedEvents = [];
      extractedData.forEach((prodId, prodData) {
        loadedEvents.add(Event2(
          id: prodId,
          imageId: prodData['imageId'],
          title: prodData['title'],
          noOfPraticipants: prodData['noOfPraticipants'],
          fee: prodData['fee'],
          startDate: prodData['startDate'],
          // endDate: prodData['endDate'],
          startTime: prodData['startTime'],
          // endTime: prodData['endTime'],
          isGoing: prodData['isGoing'],
          description: prodData['description'],
          imageURL: prodData['imageURL'],
          count: prodData['count'],
        ));
      });
      _items = loadedEvents;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetOwnersEvents() async {
    final dataList = await DBEvents.getData('events');
    List<dynamic> oitems = dataList.map((item) => item['id']).toList();
    // print(oitems);
    const url = 'https://collegenet-69.firebaseio.com/events.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Event2> loadedEvents = [];
      extractedData.forEach((prodId, prodData) {
        // print(prodId);
        if (oitems.contains(prodId))
          loadedEvents.add(Event2(
            id: prodId,
            imageId: prodData['imageId'],
            title: prodData['title'],
            // imageId: prodData['imageId'],
            noOfPraticipants: prodData['noOfPraticipants'],
            fee: prodData['fee'],
            startDate: prodData['startDate'],
            startTime: prodData['startTime'],
            isGoing: false,
            description: prodData['description'],
            imageURL: prodData['imageURL'],
            count: prodData['count'],
          ));
      });
      _owneritems = loadedEvents;
      // print(_owneritems.length);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // Future<void> fetchAndSetOwnersEvents() async {
  //   const url = 'https://collegenet-69.firebaseio.com/events.json';
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Event2> loadedEvents = [];
  //     extractedData.forEach((prodId, prodData) {
  //       if (prodId == currentUser.id)
  //         loadedEvents.add(Event2(
  //           id: prodId,
  //           imageId: prodData['imageId'],
  //           title: prodData['title'],
  //           noOfPraticipants: prodData['noOfPraticipants'],
  //           fee: prodData['fee'],
  //           startDate: prodData['startDate'],
  //           startTime: prodData['startTime'],
  //           isGoing: prodData['isGoing'],
  //           description: prodData['description'],
  //           imageURL: prodData['imageURL'],
  //           count: prodData['count'],
  //         ));
  //     });
  //     _items = loadedEvents;
  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Future<void> addEvent(Event2 evnt) async {
    const url = 'https://collegenet-69.firebaseio.com/events.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': evnt.title,
          'imageId': evnt.imageId,
          'description': evnt.description,
          'noOfPraticipants': evnt.noOfPraticipants,
          'imageURL': evnt.imageURL,
          'startDate': evnt.startDate,
          'startTime': evnt.startTime,
          'count': evnt.count,
          'fee': evnt.fee,
          'isGoing': evnt.isGoing,
          // 'imageId': evnt.imageId,
        }),
      );
      final newEvent = Event2(
        title: evnt.title,
        imageId: evnt.imageId,
        description: evnt.description,
        fee: evnt.fee,
        id: json.decode(response.body)['name'],
        imageURL: evnt.imageURL,
        noOfPraticipants: evnt.noOfPraticipants,
        startDate: evnt.startDate,
        startTime: evnt.startTime,
        count: evnt.count,
        // imageId: evnt.imageId,
      );
      _items.add(newEvent);
      // _items.add(value);
      notifyListeners();
      DBEvents.insert('events', {
        'id': newEvent.id,
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateEvent(String id, Event2 newEvent) async {
    final evntIdx = _items.indexWhere((evnt) => evnt.id == id);
    if (evntIdx >= 0) {
      final url = 'https://collegenet-69.firebaseio.com/events/$id.json';
      http.patch(url,
          body: json.encode({
            'title': newEvent.title,
            'imageId': newEvent.imageId,
            'description': newEvent.description,
            'imageURL': newEvent.imageURL,
            'startDate': newEvent.startDate,
            'startTime': newEvent.startTime,
            'fee': newEvent.fee,
            'count': newEvent.count,
            // 'imageId': newEvent.imageId,
            'noOfPraticipants': newEvent.noOfPraticipants,
          }));
      _items[evntIdx] = newEvent;
      notifyListeners();
    }
  }

  Future<void> updateCounter(String id, bool f, Event2 newEvent) async {
    final evntIdx = _items.indexWhere((event) => event.id == id);
    if (evntIdx >= 0) {
      final url = 'https://collegenet-69.firebaseio.com/events/$id.json';
      http.patch(
        url,
        body: json.encode(
          {
            'title': newEvent.title,
            'description': newEvent.description,
            'imageURL': newEvent.imageURL,
            'startDate': newEvent.startDate,
            'startTime': newEvent.startTime,
            'fee': newEvent.fee,
            'count': f ? newEvent.count - 1 : newEvent.count + 1,
            'imageId': newEvent.imageId,
            'noOfPraticipants': newEvent.noOfPraticipants,
          },
        ),
      );
      final evnt = Event2(
        title: newEvent.title,
        description: newEvent.description,
        fee: newEvent.fee,
        id: newEvent.id,
        imageURL: newEvent.imageURL,
        noOfPraticipants: newEvent.noOfPraticipants,
        startDate: newEvent.startDate,
        startTime: newEvent.startTime,
        count: f ? newEvent.count - 1 : newEvent.count + 1,
        isGoing: !f,
        imageId: newEvent.imageId,
      );
      _items[evntIdx] = evnt;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String id) async {
    final url = 'https://collegenet-69.firebaseio.com/events/$id.json';
    final existingEventIndex = _items.indexWhere((evnt) => evnt.id == id);
    var existingEvent = _items[existingEventIndex];
    final deletedImageId = existingEvent.imageId;
    _items.removeAt(existingEventIndex);
    var eoI = _owneritems.indexWhere((oid) => oid.id == id);
    _owneritems.removeAt(eoI);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingEventIndex, existingEvent);
      notifyListeners();
      throw HttpException('Could not delete event.');
    }
    await eventsfileRef.document(deletedImageId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    await userWisePostsRef
        .document(userId)
        .collection("eventsfile")
        .document(deletedImageId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    existingEvent = null;
    DBEvents.delete('events', id);
    notifyListeners();
  }
}
