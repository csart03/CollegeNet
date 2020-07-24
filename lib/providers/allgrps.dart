import 'package:flutter/material.dart';
import './cabgrp.dart';
import '../helpers/db_helper.dart';

class AllCabs with ChangeNotifier {
  List<CabGroup> _items = [];
  void addEvent(CabGroup cg) {
    final ncg = CabGroup(
      chatRoomId: cg.chatRoomId,
      source: cg.source,
      destination: cg.destination,
      leavetime: cg.leavetime,
    );
    _items.add(ncg);
    notifyListeners();
    DBHelper.insert('cabinfo', {
      'source': ncg.source,
      'destination': ncg.destination,
      'leavetime': ncg.leavetime,
      'chatroomid': ncg.chatRoomId,
    });
  }

  List<CabGroup> get items {
    return [..._items];
  }

  Future<void> fetchAndSetItems() async {
    final dataList = await DBHelper.getData('cabinfo');
    _items = dataList
        .map((item) => CabGroup(
              chatRoomId: item['chatroomid'],
              source: item['source'],
              destination: item['destination'],
              leavetime: item['leavetime'],
            ))
        .toList();
    notifyListeners();
  }
}
