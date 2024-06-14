import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:dong_ho_bao_thuc/data.dart';
import 'package:dong_ho_bao_thuc/screens/add_alarm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaoThucRung extends StatefulWidget {
  const BaoThucRung({super.key, required this.alarmSettings});
  final AlarmSettings alarmSettings;

  @override
  State<BaoThucRung> createState() => _BaoThucRungState();
}

class _BaoThucRungState extends State<BaoThucRung> {
  bool _baoLai = true;

  Future<void> _loadBaoLai() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _baoLai = prefs.getBool('bao_lai') ?? true;
    });
  }

  @override
  void initState() {
    _loadBaoLai();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
            child: Image.asset(
          'images/splash.jpg',
          fit: BoxFit.cover,
        )),
        Positioned(
          right: 0,
          left: 0,
          bottom: 50,
          child: Column(
            children: [
              _baoLai
                  ? InkWell(
                      onTap: () {
                        final now = DateTime.now();
                        Alarm.set(
                          alarmSettings: widget.alarmSettings.copyWith(
                            dateTime: DateTime(
                              now.year,
                              now.month,
                              now.day,
                              now.hour,
                              now.minute,
                            ).add(const Duration(minutes: 5)),
                          ),
                        ).then((_) => Navigator.pop(context));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color:
                                      Colors.pinkAccent.shade700.withAlpha(50))
                            ],
                            color: Colors.pinkAccent.shade700.withAlpha(10)),
                        height: 160,
                        width: 160,
                        alignment: Alignment.center,
                        child: Text(
                          'Báo lại sau',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.pink.shade400,
                  ),
                ),
                onPressed: () async {
                  BaoThuc? baoThuc;
                  final baoThucList = await getBaoThucList();
                  for (final bt in baoThucList) {
                    if (bt.id == widget.alarmSettings.id) {
                      baoThuc = bt;
                    }
                  }
                  if (baoThuc == null) {
                    await deleteBaoThuc(widget.alarmSettings.id);
                  } else {
                    baoThuc.lapLai = baoThuc.lapLai.substring(1) +
                        baoThuc.lapLai.substring(0, 1);
                    widget.alarmSettings.dateTime
                        .next(int.parse(baoThuc.lapLai.characters.first));
                    Alarm.set(
                        alarmSettings: widget.alarmSettings.copyWith(
                            dateTime: widget.alarmSettings.dateTime.next(
                                int.parse(baoThuc.lapLai.characters.first))));

                    insertBaoThuc(baoThuc);
                  }
                  Alarm.stop(widget.alarmSettings
                          .copyWith(
                            vibrate: false,
                          )
                          .id)
                      .then((_) => Navigator.pop(context));
                },
                child: Text(
                  'Tắt',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
