import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:dong_ho_bao_thuc/app_model.dart';
import 'package:dong_ho_bao_thuc/data.dart';
import 'package:dong_ho_bao_thuc/screens/add_alarm.dart';
import 'package:dong_ho_bao_thuc/screens/bao_thuc_rung.dart';
import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
          MaterialPageRoute(builder: (BuildContext context) {
        return AddAlarm(
            alarmSettings: settings,
            lapLaiList: lapLaiList,
            lapLaiString: lapLaiString);
      }));
    } else {
      res = await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
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
    return Column(children: [
      Expanded(
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
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            //color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                deleteAlarm(alarms[index].id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    'images/delete.jpg',
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      alarms[index].notificationBody,
                                      style: Styles.label,
                                    ),
                                    Text(
                                      TimeOfDay(
                                        hour: alarms[index].dateTime.hour,
                                        minute: alarms[index].dateTime.minute,
                                      ).format(context),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.pinkAccent[700]),
                                    ),
                                    Text(
                                      ngayLap,
                                      style: Styles.label,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                              ),
                              onPressed: () {
                                navigateToAlarmScreen(alarms[index]);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'Không có báo thức nào',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
      ),
      Container(
        height: 100,
        alignment: Alignment.center,
        child: FilledButton(
            onPressed: () {
              navigateToAlarmScreen(null);
            },
            child: Icon(Icons.add)),
      )
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
