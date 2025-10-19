import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:dong_ho_bao_thuc/app_model.dart';
import 'package:dong_ho_bao_thuc/data.dart';
import 'package:dong_ho_bao_thuc/screens/add_alarm.dart';
import 'package:dong_ho_bao_thuc/screens/bao_thuc_rung.dart';
import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:oc_liquid_glass/oc_liquid_glass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:liquid_glass_ui_design/liquid_glass_ui.dart';

class BaoThucPage extends StatefulWidget {
  const BaoThucPage({super.key});

  @override
  State<BaoThucPage> createState() => _BaoThucPageState();
}

class _BaoThucPageState extends State<BaoThucPage>
    with AutomaticKeepAliveClientMixin {
  late List<AlarmSettings> alarms;
  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BaoThucRung(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    var res;
    List<bool> lapLaiList = [false, false, false, false, false, false, false];
    String lapLaiString = '';
    if (settings != null) {
      BaoThuc? baoThuc;
      for (final bt in context.read<AppModel>().baoThucList) {
        if (bt.id == settings.id) {
          baoThuc = bt;
        }
      }
      if (baoThuc != null) {
        lapLaiString = baoThuc.lapLai;
        final characters = lapLaiString.characters.toList();
        for (int i = 0; i < characters.length; i++) {
          final kiTu = characters[i];
          switch (kiTu) {
            case '0':
              lapLaiList[0] = true;
            case '1':
              lapLaiList[1] = true;
            case '2':
              lapLaiList[2] = true;
            case '3':
              lapLaiList[3] = true;
            case '4':
              lapLaiList[4] = true;
            case '5':
              lapLaiList[5] = true;
            case '6':
              lapLaiList[6] = true;
          }
        }
      }

      res = await Navigator.push(context,
          CupertinoPageRoute(builder: (BuildContext context) {
        return AddAlarm(
            alarmSettings: settings,
            lapLaiList: lapLaiList,
            lapLaiString: lapLaiString);
      }));
    } else {
      res = await Navigator.push(context,
          CupertinoPageRoute(builder: (BuildContext context) {
        return AddAlarm(
            alarmSettings: settings,
            lapLaiList: lapLaiList,
            lapLaiString: lapLaiString);
      }));
    }
    if (res != null && res == true) loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  void deleteAlarm(int alarmId) {
    Alarm.stop(alarmId).then((res) async {
      if (res) {
        deleteBaoThuc(alarmId);
        context.read<AppModel>().baoThucList = await getBaoThucList();
        loadAlarms();
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: alarms.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: alarms.length,
                //separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  var ngayLap = '';
                  BaoThuc? baoThuc;

                  for (final bt in context.read<AppModel>().baoThucList) {
                    if (bt.id == alarms[index].id) {
                      baoThuc = bt;
                    }
                  }
                  if (baoThuc == null) {
                    ngayLap = 'Một lần';
                  } else {
                    final characters = baoThuc.lapLai.characters.toList();
                    if (characters.length == 7) {
                      ngayLap = 'Mỗi ngày';
                    } else {
                      for (int i = 0; i < characters.length; i++) {
                        final kiTu = characters[i];
                        switch (kiTu) {
                          case '0':
                            ngayLap += 'CN';
                          case '1':
                            ngayLap += 'T2';
                          case '2':
                            ngayLap += 'T3';
                          case '3':
                            ngayLap += 'T4';
                          case '4':
                            ngayLap += 'T5';
                          case '5':
                            ngayLap += 'T6';
                          case '6':
                            ngayLap += 'T7';
                        }
                      }
                      ngayLap = StringUtils.addCharAtPosition(ngayLap, ", ", 2,
                          repeat: true);
                    }
                  }
                  return InkWell(
                    key: Key(alarms[index].id.toString()),
                    onTap: () {
                      navigateToAlarmScreen(alarms[index]);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
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
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  deleteAlarm(alarms[index].id);
                                },
                                icon: Icon(CupertinoIcons.delete),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        TimeOfDay(
                                          hour: alarms[index].dateTime.hour,
                                          minute: alarms[index].dateTime.minute,
                                        ).format(context),
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            height: 1.2),
                                      ),
                                      Text(
                                        alarms[index].notificationBody != ''
                                            ? alarms[index].notificationBody +
                                                ', ' +
                                                ngayLap
                                            : ngayLap,
                                        style: Styles.label.copyWith(height: 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.pencil_outline,
                                ),
                                onPressed: () {
                                  navigateToAlarmScreen(alarms[index]);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  'Không có báo thức nào',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                ),
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
                onPressed: () {
                  navigateToAlarmScreen(null);
                },
                icon: Icon(Icons.add),
                label: Text('Thêm báo thức'),
              ),
            ),
          ))
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
