import 'package:dong_ho_bao_thuc/pages/bam_gio.dart';
import 'package:dong_ho_bao_thuc/pages/bao_thuc.dart';
import 'package:dong_ho_bao_thuc/pages/dong_ho.dart';
import 'package:dong_ho_bao_thuc/pages/hen_gio.dart';
import 'package:dong_ho_bao_thuc/screens/settings.dart';
import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset('images/app_bar_large.jpg'),
                Positioned.fill(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Đồng hồ',
                                  style: Styles.titleLarge
                                      .copyWith(color: Colors.white),
                                ),
                                IconButton(
                                  icon:
                                      Icon(Icons.settings, color: Colors.white),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Settings())),
                                )
                              ],
                            ),
                          ),
                          TabBar(
                              unselectedLabelColor: Colors.white,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: Colors.white,
                              labelStyle:
                                  Styles.label.copyWith(color: Colors.white),
                              dividerHeight: 0,
                              tabs: [
                                Tab(
                                  icon: Icon(Icons.alarm, color: Colors.white),
                                  text: 'Báo thức',
                                ),
                                Tab(
                                  icon: Icon(Icons.watch_later_outlined),
                                  text: 'Đồng hồ',
                                ),
                                Tab(
                                  icon: Icon(Icons.hourglass_bottom),
                                  text: 'Hẹn giờ',
                                ),
                                Tab(
                                  icon: Icon(Icons.watch_sharp),
                                  text: 'Bấm giờ',
                                )
                              ]),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
                child: TabBarView(children: [
              BaoThucPage(),
              DongHoPage(),
              HenGioPage(),
              BamGioPage()
            ]))
          ],
        ),
      ),
    );
  }
}
