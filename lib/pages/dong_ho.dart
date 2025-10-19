import 'dart:async';
import 'dart:convert';

import 'package:dong_ho_bao_thuc/data.dart';
import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:oc_liquid_glass/oc_liquid_glass.dart';
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
                minuteHandColor: Colors.white,
                //digitalClockColor: Colors.white,
                numberColor: Colors.white,
                secondHandColor: Colors.yellow.shade600,
                hourHandColor: Colors.white,
                tickColor: Colors.white,
                showDigitalClock: false,
                showAllNumbers: true,
              ),
            ),
            Text(
              '${_dateTime.day} tháng ${_dateTime.month}, ${_dateTime.year}',
              textAlign: TextAlign.center,
              style:
                  Styles.titleSmall.copyWith(fontSize: 20, color: Colors.white),
            ),
            GlassmorphicFlexContainer(
              flex: 1,
              //margin: EdgeInsets.all(6),
              borderRadius: 35,
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(25),
              blur: 14,
              alignment: Alignment.bottomCenter,
              border: 2,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0FFFF).withOpacity(0.2),
                  Color(0xFF0FFFF).withOpacity(0.2),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0FFFF).withOpacity(1),
                  Color(0xFFFFFFF),
                  Color(0xFF0FFFF).withOpacity(1),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView(
                      children: _tzList
                          .map((title) {
                            var detroit = tz.getLocation(title);
                            var now = tz.TZDateTime.now(detroit);
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              child: OCLiquidGlassGroup(
                                  settings: OCLiquidGlassSettings(
                                    blendPx: 20,
                                    specAngle: 0.8,
                                    refractStrength: -0.060,
                                    distortFalloffPx: 35,
                                    blurRadiusPx: 2,
                                    specStrength: 4,
                                    specWidth: 1.5,
                                    specPower: 4,
                                  ),
                                  child: OCLiquidGlass(
                                    borderRadius: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                          Spacer(),
                                          Text(
                                            DateFormat('kk:mm').format(now),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _tzList.remove(title);
                                              _saveTZ();
                                            },
                                            icon: Icon(CupertinoIcons.delete_simple),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          })
                          .toList()
                          .reversed
                          .toList(),
                    ),
                  ),
                  Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        child: GlassmorphicContainer(
                          width: 160,
                          height: 45,
                          borderRadius: 35,
                          //padding: EdgeInsets.all(8),
                          blur: 14,
                          //alignment: Alignment.bottomCenter,
                          border: 2,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF0FFFF).withOpacity(0.2),
                              Color(0xFF0FFFF).withOpacity(0.2),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF0FFFF).withOpacity(1),
                              Color(0xFFFFFFF),
                              Color(0xFF0FFFF).withOpacity(1),
                            ],
                          ),
                          child: TextButton.icon(
                            onPressed: () async {
                              String? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddTimeZone()));
                              if (result != null) {
                                _tzList.add(result);
                                _saveTZ();
                              } else {
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.add),
                            label: Text('Thêm thành phố'),
                          ),
                        ),
                      ))
                ],
              ),
            ),
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
