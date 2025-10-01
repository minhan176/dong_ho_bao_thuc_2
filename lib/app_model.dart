import 'package:flutter/material.dart';

import 'data.dart';

class AppModel with ChangeNotifier {

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) => notify(() => _selectedIndex = value);

  List<BaoThuc> _baoThucList = [];
  List<BaoThuc> get baoThucList => _baoThucList;
  set baoThucList(List<BaoThuc> list) => notify(() => _baoThucList = list);

  void notify(VoidCallback stateChange) {
    stateChange.call();
    notifyListeners();
  }

}
