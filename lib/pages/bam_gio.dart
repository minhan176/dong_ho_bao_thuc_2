import 'dart:async';

import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BamGioPage extends StatefulWidget {
  const BamGioPage({super.key});

  @override
  State<BamGioPage> createState() => _BamGioPageState();
}

class _BamGioPageState extends State<BamGioPage>
    with AutomaticKeepAliveClientMixin {
  Duration _duration = Duration.zero;
  bool _isPause = true;
  final _milliSeconds = Duration(milliseconds: 100);
  List<String> _bamGios = [];

  Future<void> _loadBamGio() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bamGios = prefs.getStringList('bamgio') ?? [];
    });
  }

  Future<void> _saveBamGio() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('bamgio', _bamGios);
    });
  }

  @override
  void initState() {
    _loadBamGio();
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
              child: Text(
                  _duration.inHours < 10
                      ? _duration.toString().substring(0, 10)
                      : _duration.toString().substring(0, 11),
                  style: TextStyle(fontSize: 40))),
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(_isPause ? Icons.play_circle_outline : Icons.pause,
                    size: 40, color: Colors.pink),
                onPressed: () async {
                  if (_isPause) {
                    setState(() {
                      _isPause = false;
                    });

                    Timer.periodic(_milliSeconds, (timer) {
                      if (_isPause) {
                        timer.cancel();
                        return;
                      }
                      if (mounted) {
                        setState(() {
                          _duration += _milliSeconds;
                        });
                      }
                    });
                  } else {
                    setState(() {
                      _isPause = true;
                    });
                    _bamGios.add(_duration.inHours < 10
                        ? _duration.toString().substring(0, 10)
                        : _duration.toString().substring(0, 11));
                    _saveBamGio();
                    return;
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: Icon(Icons.refresh, size: 40, color: Colors.purple),
                onPressed: () {
                  setState(() {
                    _duration = Duration.zero;
                    _isPause = true;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _bamGios.isNotEmpty
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
                                children: _bamGios
                                    .map((duration) {
                                      return Container(
                                        height: 50,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _bamGios.remove(duration);
                                                _saveBamGio();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: _isPause
                                                  ? () async {
                                                      setState(() {
                                                        if (duration.length ==
                                                            10) {
                                                          _duration = Duration(
                                                              hours: int.parse(
                                                                  duration.substring(
                                                                      0, 1)),
                                                              minutes: int.parse(
                                                                  duration.substring(
                                                                      2, 4)),
                                                              seconds: int.parse(
                                                                  duration
                                                                      .substring(
                                                                          5, 7)),
                                                              milliseconds:
                                                                  int.parse(
                                                                      duration.substring(8, 10)));
                                                        } else {
                                                          _duration = Duration(
                                                              hours: int.parse(
                                                                  duration.substring(
                                                                      0, 2)),
                                                              minutes: int.parse(
                                                                  duration.substring(
                                                                      3, 5)),
                                                              seconds: int.parse(
                                                                  duration
                                                                      .substring(
                                                                          6, 8)),
                                                              milliseconds:
                                                                  int.parse(
                                                                      duration.substring(9, 11)));
                                                        }

                                                        _isPause = false;
                                                      });

                                                      Timer.periodic(
                                                          _milliSeconds,
                                                          (timer) {
                                                        if (_isPause) {
                                                          timer.cancel();
                                                          return;
                                                        }
                                                        if (mounted) {
                                                          setState(() {
                                                            _duration +=
                                                                _milliSeconds;
                                                          });
                                                        }
                                                      });
                                                    }
                                                  : null,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                    .reversed
                                    .toList(),
                              ),
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
