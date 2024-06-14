import 'dart:async';
import 'dart:math';
import 'package:dong_ho_bao_thuc/screens/home_screen.dart';
import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class HenGioPage extends StatefulWidget {
  const HenGioPage({super.key});

  @override
  State<HenGioPage> createState() => _HenGioPageState();
}

const _oneSecond = Duration(seconds: 1);

class _HenGioPageState extends State<HenGioPage>
    with AutomaticKeepAliveClientMixin {
  Duration _duration = Duration.zero;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  bool _isPause = true;
  bool _isRestart = true;
  int _ranNum = 0;
  bool _isFirst = true;

  void initialTimer() async {
    final androidInitilize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOSinitilize = new DarwinInitializationSettings();
    final initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _flutterLocalNotificationsPlugin!.initialize(initilizationsSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin!.show(
        0, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context, MaterialPageRoute<void>(builder: (context) => HomeScreen()));
  }

  void deleteTimer(int notifyId) async {
    await _flutterLocalNotificationsPlugin!.cancel(notifyId);
  }

  Future<bool> _loadHenGio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hen_gio') ?? true;
  }

  List<String> _histories = [];

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _histories = prefs.getStringList('history') ?? [];
    });
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('history', _histories);
    });
  }

  @override
  void initState() {
    _loadHistory();
    initialTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              alignment: Alignment.center,
              height: 200,
              child: _isRestart
                  ? CupertinoTimerPicker(
                      onTimerDurationChanged: (Duration value) {
                        setState(() {
                          _duration = value;
                          _isFirst = true;
                        });
                      },
                    )
                  : Text(
                      _duration.inHours < 10
                          ? _duration.toString().substring(0, 7)
                          : _duration.toString().substring(0, 8),
                      style: TextStyle(fontSize: 40))),
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(_isPause ? Icons.play_circle_outline : Icons.pause,
                    size: 40,
                    color:
                        _duration != Duration.zero ? Colors.pink : Colors.grey),
                onPressed: _duration != Duration.zero
                    ? () async {
                        if (_isPause) {
                          if (_isFirst) {
                            _histories.add(_duration.inHours < 10
                                ? _duration.toString().substring(0, 7)
                                : _duration.toString().substring(0, 8));
                            _saveHistory();
                          }
                          setState(() {
                            _isFirst = false;
                            _isPause = false;
                            _isRestart = false;
                          });
                          final hasSound = await _loadHenGio();
                          Random random = Random();
                          _ranNum = random.nextInt(100);
                          await _flutterLocalNotificationsPlugin!.zonedSchedule(
                              _ranNum,
                              'Hẹn Giờ',
                              "${_duration.inHours < 10 ? _duration.toString().substring(0, 7) : _duration.toString().substring(0, 8)}",
                              tz.TZDateTime.now(tz.local).add(Duration(
                                  milliseconds: _duration.inMilliseconds)),
                              NotificationDetails(
                                  android: AndroidNotificationDetails(
                                      'your channel id', 'your channel name',
                                      channelDescription:
                                          'your channel description',
                                      sound: hasSound
                                          ? RawResourceAndroidNotificationSound(
                                              "door")
                                          : null,
                                      autoCancel: false,
                                      playSound: hasSound ? true : false,
                                      priority: Priority.max)),
                              androidScheduleMode:
                                  AndroidScheduleMode.exactAllowWhileIdle,
                              uiLocalNotificationDateInterpretation:
                                  UILocalNotificationDateInterpretation
                                      .absoluteTime);

                          Timer.periodic(Duration(seconds: 1), (timer) {
                            //return;
                            if (_isPause) {
                              timer.cancel();
                              return;
                            }

                            if (mounted) {
                              setState(() {
                                _duration -= _oneSecond;
                              });
                            }
                            if (_duration == Duration.zero) {
                              if (mounted) {
                                setState(() {
                                  _isPause = true;
                                });
                              }
                              timer.cancel();
                            }
                          });
                        } else {
                          deleteTimer(_ranNum);
                          setState(() {
                            _isPause = true;
                            _isRestart = false;
                          });
                        }
                      }
                    : null,
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: Icon(Icons.refresh, size: 40, color: Colors.purple),
                onPressed: () {
                  if (!_isPause) {
                    deleteTimer(_ranNum);
                  }
                  setState(() {
                    _duration = Duration.zero;
                    _isPause = true;
                    _isRestart = true;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _histories.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 10,
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      height: 250,
                      child: Column(
                        children: [
                          Text(
                            'Lịch sử',
                            style: Styles.titleLarge,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: SeparatedColumn(
                                  separatorBuilder: () => Divider(),
                                  children: [
                                    ..._histories
                                        .map((duration) {
                                          return Container(
                                            height: 50,
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    _histories.remove(duration);
                                                    _saveHistory();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'images/delete.jpg',
                                                        height: 25,
                                                        width: 25,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  duration,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: _isPause
                                                      ? () async {
                                                          setState(() {
                                                            if (duration
                                                                    .length ==
                                                                7) {
                                                              _duration = Duration(
                                                                  hours: int.parse(
                                                                      duration
                                                                          .substring(
                                                                              0,
                                                                              1)),
                                                                  minutes: int.parse(
                                                                      duration
                                                                          .substring(
                                                                              2,
                                                                              4)),
                                                                  seconds: int.parse(
                                                                      duration.substring(
                                                                          5,
                                                                          7)));
                                                            } else {
                                                              _duration = Duration(
                                                                  hours: int.parse(
                                                                      duration
                                                                          .substring(
                                                                              0,
                                                                              2)),
                                                                  minutes: int.parse(
                                                                      duration
                                                                          .substring(
                                                                              3,
                                                                              5)),
                                                                  seconds: int.parse(
                                                                      duration.substring(
                                                                          6,
                                                                          8)));
                                                            }

                                                            _isFirst = false;
                                                            _isPause = false;
                                                            _isRestart = false;
                                                          });
                                                          final hasSound =
                                                              await _loadHenGio();
                                                          Random random =
                                                              Random();
                                                          _ranNum = random
                                                              .nextInt(100);
                                                          await _flutterLocalNotificationsPlugin!.zonedSchedule(
                                                              _ranNum,
                                                              'Hẹn Giờ',
                                                              "${_duration.inHours < 10 ? _duration.toString().substring(0, 7) : _duration.toString().substring(0, 8)}",
                                                              tz.TZDateTime.now(tz.local).add(Duration(
                                                                  milliseconds: _duration
                                                                      .inMilliseconds)),
                                                              NotificationDetails(
                                                                  android: AndroidNotificationDetails(
                                                                      'your channel id', 'your channel name',
                                                                      channelDescription:
                                                                          'your channel description',
                                                                      sound: hasSound
                                                                          ? RawResourceAndroidNotificationSound(
                                                                              "door")
                                                                          : null,
                                                                      autoCancel:
                                                                          false,
                                                                      playSound: hasSound
                                                                          ? true
                                                                          : false,
                                                                      priority: Priority
                                                                          .max)),
                                                              androidScheduleMode:
                                                                  AndroidScheduleMode
                                                                      .exactAllowWhileIdle,
                                                              uiLocalNotificationDateInterpretation:
                                                                  UILocalNotificationDateInterpretation.absoluteTime);

                                                          Timer.periodic(
                                                              _oneSecond,
                                                              (timer) {
                                                            if (_isPause) {
                                                              timer.cancel();
                                                              return;
                                                            }
                                                            if (mounted) {
                                                              setState(() {
                                                                _duration -=
                                                                    _oneSecond;
                                                              });
                                                            }
                                                            if (_duration ==
                                                                Duration.zero) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  _isPause =
                                                                      true;
                                                                });
                                                              }
                                                              timer.cancel();
                                                            }
                                                          });
                                                        }
                                                      : null,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ClipOval(
                                                      child: Image.asset(
                                                        'images/play.jpg',
                                                        height: 25,
                                                        width: 25,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        })
                                        .toList()
                                        .reversed,
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
