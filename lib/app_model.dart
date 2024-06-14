import 'package:flutter/material.dart';

import 'data.dart';

class AppModel with ChangeNotifier {
  List<BaoThuc> _baoThucList = [];
  List<BaoThuc> get baoThucList => _baoThucList;
  set baoThucList(List<BaoThuc> list) {
    _baoThucList = list;
    notifyListeners();
  }
}
