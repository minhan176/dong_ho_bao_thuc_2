import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:dong_ho_bao_thuc/app_model.dart';
import 'package:dong_ho_bao_thuc/data.dart';
import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return this.weekday == day
        ? this.add(
            Duration(days: 7),
          )
        : this.add(
            Duration(
              days: (day - this.weekday) % DateTime.daysPerWeek,
            ),
          );
  }
}

class AddAlarm extends StatefulWidget {
  AddAlarm(
      {super.key,
      required this.alarmSettings,
      required this.lapLaiList,
      required this.lapLaiString});
  final AlarmSettings? alarmSettings;
  final List<bool> lapLaiList;
  String lapLaiString;

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  bool loading = false;
  late Duration duration;
  late bool creating;
  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late String assetAudio;
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      duration = Duration(
          hours: selectedDateTime.hour, minutes: selectedDateTime.minute);
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      assetAudio = 'assets/alarm_remix.mp3';
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
      duration = Duration(
          hours: selectedDateTime.hour, minutes: selectedDateTime.minute);
      _controller.text = widget.alarmSettings!.notificationBody;

      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: (widget.lapLaiList.every((e) => e == false) ||
              selectedDateTime.weekday ==
                  int.parse(widget.lapLaiString.characters.first))
          ? selectedDateTime
          : selectedDateTime
              .next(int.parse(widget.lapLaiString.characters.first)),
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume,
      assetAudioPath: assetAudio,
      notificationTitle:
          'Báo thức: ${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')} đang rung!!',
      notificationBody: _controller.text,
      enableNotificationOnKill: true,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);
    final alarm = buildAlarmSettings();
    Alarm.set(alarmSettings: alarm).then((res) async {
      if (res) {
        if (widget.lapLaiList.every((e) => e == false)) {
        } else {
          final baoThuc = BaoThuc(id: alarm.id, lapLai: widget.lapLaiString);
          insertBaoThuc(baoThuc);
        }
        context.read<AppModel>().baoThucList = await getBaoThucList();
        Navigator.pop(context, true);
      }
      setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    String getButtonTitle(int index) {
      return switch (index) {
        0 => 'CN',
        1 => 'T2',
        2 => 'T3',
        3 => 'T4',
        4 => 'T5',
        5 => 'T6',
        6 => 'T7',
        _ => ''
      };
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Stack(
          children: [
            Image.asset(
              'images/app_bar_small.jpg',
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Text(
                  'Thêm báo thức',
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
            Positioned(
                right: 5,
                bottom: 0,
                child: IconButton(
                    onPressed: () {
                      saveAlarm();
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ))),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SeparatedColumn(
                separatorBuilder: () => Divider(),
                children: [
                  GestureDetector(
                    onTap: pickTime,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        TimeOfDay.fromDateTime(selectedDateTime)
                            .format(context),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.pinkAccent[700]),
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tiêu đề',
                          style: Styles.titleSmall,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                                hintText: 'Báo thức 1',
                                hintStyle:
                                    Styles.label.copyWith(color: Colors.grey),
                                isDense: true,
                                border: InputBorder.none),
                          ),
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Lặp lại', style: Styles.titleSmall),
                      Text(widget.lapLaiList.every((e) => e == false)
                          ? 'Một lần'
                          : 'Tùy chình'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 7; i++)
                        Expanded(
                          child: NgayThuButton(
                            isSelected: widget.lapLaiList[i],
                            title: getButtonTitle(i),
                            onPressed: () {
                              if (widget.lapLaiString.contains('$i')) {
                                widget.lapLaiString.replaceAll('$i', '');
                              } else {
                                widget.lapLaiString += '$i';
                              }
                              if (widget.lapLaiList[i] == true) {
                                setState(() {
                                  widget.lapLaiList[i] = false;
                                });
                              } else {
                                setState(() {
                                  widget.lapLaiList[i] = true;
                                });
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nhạc chuông',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      DropdownButton(
                        value: assetAudio,
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'assets/alarm_remix.mp3',
                            child: Text('Alarm Remix'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'assets/chiptune_alarm.mp3',
                            child: Text('Chiptune Alarm'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'assets/clock_short.mp3',
                            child: Text('Clock Short'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'assets/digital_alarm.mp3',
                            child: Text('Digital Alarm'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'assets/oversimplified_alarm.mp3',
                            child: Text('Oversimplified Alarm'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'assets/super_mario.mp3',
                            child: Text('Super Mario'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => assetAudio = value!),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Âm lượng',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Switch(
                            value: volume != null,
                            onChanged: (value) =>
                                setState(() => volume = value ? 0.5 : null),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: volume != null,
                        child: volume != null
                            ? SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      volume! > 0.7
                                          ? Icons.volume_up_rounded
                                          : volume! > 0.1
                                              ? Icons.volume_down_rounded
                                              : Icons.volume_mute_rounded,
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: volume!,
                                        onChanged: (value) {
                                          setState(() => volume = value);
                                        },
                                      ),
                                    ),
                                  ],
                                ))
                            : Container(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lặp lại nhạc chuông',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Switch(
                        value: loopAudio,
                        onChanged: (value) => setState(() => loopAudio = value),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rung',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Switch(
                        value: vibrate,
                        onChanged: (value) => setState(() => vibrate = value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class NgayThuButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final VoidCallback onPressed;

  const NgayThuButton({
    super.key,
    required this.isSelected,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isSelected ? Colors.pink : Colors.white,
          ),
          child: Text(title, style: TextStyle(color: Colors.black)),
          onPressed: onPressed),
    );
  }
}
