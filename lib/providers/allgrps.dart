import 'package:flutter/material.dart';
import './cabgrp.dart';
import '../helpers/db_helper.dart';

class AllCabs with ChangeNotifier {
  List<CabGroup> _items = [];
  List<dynamic> _crid = [];
  void addEvent(CabGroup cg) {
    final ncg = CabGroup(
      chatRoomId: cg.chatRoomId,
      source: cg.source,
      destination: cg.destination,
      leavetime: cg.leavetime,
    );
    _items.add(ncg);
    _crid.add(cg.chatRoomId);
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

  List<String> get crids {
    return [..._crid];
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

  Future<void> fetchAndSetcrids() async {
    final dataList = await DBHelper.getData('cabinfo');
    _crid = dataList.map((item) => item['chatroomid']).toList();
    notifyListeners();
  }
}
