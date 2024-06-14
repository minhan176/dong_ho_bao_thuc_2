import 'dart:async';
import 'dart:convert';

import 'package:dong_ho_bao_thuc/data.dart';
import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class DongHoPage extends StatefulWidget {
  const DongHoPage({super.key});

  @override
  State<DongHoPage> createState() => _DongHoPageState();
}

class _DongHoPageState extends State<DongHoPage> {
  List<String> _tzList = [];
  DateTime _dateTime = DateTime.now();

  Future<void> _loadTZ() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tzList = prefs.getStringList('timezone') ?? [];
    });
  }

  Future<void> _saveTZ() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('timezone', _tzList);
    });
  }

  @override
  void initState() {
    _loadTZ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SeparatedColumn(
          separatorBuilder: () {
            return SizedBox(
              height: 5,
            );
          },
          children: [
            Expanded(
              child: AnalogClock(
                datetime: _dateTime,
              ),
            ),
            Text(
              '${_dateTime.day} tháng ${_dateTime.month}, ${_dateTime.year}',
              textAlign: TextAlign.center,
              style: Styles.titleSmall.copyWith(fontSize: 20),
            ),
            _tzList.isNotEmpty
                ? Card(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      height: 200,
                      child: ListView(
                        children: _tzList
                            .map((title) {
                              var detroit = tz.getLocation(title);
                              var now = tz.TZDateTime.now(detroit);
                              return Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    Spacer(),
                                    Text(
                                      DateFormat('kk:mm').format(now),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _tzList.remove(title);
                                        _saveTZ();
                                      },
                                      child: ClipOval(
                                        child: Image.asset(
                                          'images/delete.jpg',
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            })
                            .toList()
                            .reversed
                            .toList(),
                      ),
                    ),
                  )
                : Container(),
            Container(
              height: 100,
              alignment: Alignment.center,
              child: FilledButton(
                  onPressed: () async {
                    String? result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddTimeZone()));
                    if (result != null) {
                      _tzList.add(result);
                      _saveTZ();
                    } else {
                      setState(() {});
                    }
                  },
                  child: Icon(Icons.add)),
            )
          ]),
    );
  }
}

class AddTimeZone extends StatefulWidget {
  const AddTimeZone({super.key});

  @override
  State<AddTimeZone> createState() => _AddTimeZoneState();
}

class _AddTimeZoneState extends State<AddTimeZone> {
  late TextEditingController _controller;
  final tzList = <String>[];
  List<String> searchList = <String>[];
  Future<DateTime> setup(String location) async {
    var detroit = tz.getLocation(location);
    return tz.TZDateTime.now(detroit);
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Object?> timeZoneMap =
        jsonDecode(documentJson) as Map<String, Object?>;
    List<dynamic>? timeZoneList = timeZoneMap['data'] as List<dynamic>?;
    if (timeZoneList != null) {
      for (final timeZone in timeZoneList) {
        for (final utc in timeZone['utc']) tzList.add(utc);
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Stack(
            children: [
              Image.asset(
                'images/app_bar_small.jpg',
                //fit: BoxFit.cover,
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Text(
                    'Chọn Thành Phố',
                    textAlign: TextAlign.center,
                    style: Styles.titleLarge.copyWith(
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                  left: 5,
                  bottom: 0,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ))),
            ],
          ),
          Expanded(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      final list = <String>[];
                      if (timeZoneList != null) {
                        for (final timeZone in timeZoneList) {
                          for (final utc in timeZone['utc'])
                            if (utc
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              list.add(utc);
                            }
                        }
                        searchList = list;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //isDense: true,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search',
                      hintStyle: Styles.label.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Scrollbar(
                child: _controller.text.isEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.all(8.0),
                        separatorBuilder: (context, int) => Divider(),
                        itemBuilder: (context, index) {
                          final tzTile = tzList[index];
                          return ListTile(
                              minTileHeight: 30,
                              dense: true,
                              title: Text(tzTile),
                              onTap: () {
                                Navigator.pop(context, tzTile);
                              });
                        },
                        itemCount: tzList.length,
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        separatorBuilder: (context, int) => Divider(),
                        itemBuilder: (context, index) {
                          final tzTile = searchList[index];
                          return ListTile(
                              minTileHeight: 30,
                              dense: true,
                              title: Text(tzTile),
                              onTap: () {
                                Navigator.pop(context, tzTile);
                              });
                        },
                        itemCount: searchList.length,
                      ),
              )),
            ],
          ))
        ]));
  }
}
