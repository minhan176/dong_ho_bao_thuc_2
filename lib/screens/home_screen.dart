import 'package:dong_ho_bao_thuc/app_model.dart';
import 'package:dong_ho_bao_thuc/pages/bam_gio.dart';
import 'package:dong_ho_bao_thuc/pages/bao_thuc.dart';
import 'package:dong_ho_bao_thuc/pages/dong_ho.dart';
import 'package:dong_ho_bao_thuc/pages/hen_gio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oc_liquid_glass/oc_liquid_glass.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  changePage(int value) => context.read<AppModel>().selectedIndex = value;

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = context.watch<AppModel>().selectedIndex == index;
    return GestureDetector(
      onTap: () => changePage(index),
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withAlpha(100)
              : Colors.white.withAlpha(0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Icon(
                icon,
                color: isActive ? Colors.yellow[600] : Colors.white,
                size: 26,
              ),
            ),
            if (label.isNotEmpty) ...[
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.yellow[600] : Colors.white,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      // Positioned.fill(
      //     child: Image.asset(
      //   'images/background.jpg',
      //   fit: BoxFit.cover,
      // )),
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C2C2C), // Xám đậm
              Color(0xFFB0B0B0), // Xám trung bình
              Color(0xFFE0E0E0), // Xám nhạt
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
      ),
      Positioned.fill(
        child: Column(
          children: [
            Expanded(
                child: SafeArea(
                    child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                child: OCLiquidGlass(borderRadius: 40, child: _PageStack()),
              ),
            ))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: _buildNavItem(
                              CupertinoIcons.alarm_fill, 'Alarm', 0)),
                      Expanded(
                          child: _buildNavItem(
                              CupertinoIcons.clock_fill, 'Clock', 1)),
                      Expanded(
                          child: _buildNavItem(
                              CupertinoIcons.timer_fill, 'Timer', 2)),
                      Expanded(
                          child: _buildNavItem(
                              CupertinoIcons.stopwatch_fill, 'Stopwatch', 3)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30)
            // GlassmorphicContainer(
            //   height: 100,
            //   width: double.infinity,
            //   borderRadius: 35,
            //   //padding: EdgeInsets.all(25),
            //   blur: 90,
            //   //alignment: Alignment.bottomCenter,
            //   border: 2,
            //   linearGradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //       Color(0xFF0FFFF).withOpacity(0.2),
            //       Color(0xFF0FFFF).withOpacity(0.2),
            //     ],
            //   ),
            //   borderGradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //       Color.fromARGB(15, 255, 255, 255).withOpacity(1),
            //       Color.fromARGB(15, 255, 255, 255),
            //       Color.fromARGB(15, 255, 255, 255).withOpacity(1),
            //     ],
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       _buildNavItem(CupertinoIcons.alarm, 'Alarm', 0),
            //       _buildNavItem(CupertinoIcons.clock, 'Clock', 1),
            //       _buildNavItem(CupertinoIcons.timer, 'Timer', 2),
            //       _buildNavItem(CupertinoIcons.stopwatch, 'Stopwatch', 3),
            //     ],
            //   ),
            // ),
            // LiquidGlassEffect(
            //   borderRadius: 32,
            //   blurStrength: 20,
            //   surfaceOpacity: 0.6,
            //   reflectionIntensity: 0.2,

            //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 12,
            //     horizontal: 8,
            //   ),
            //   child: ,
            // ),
            //       child: SafeArea(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Column(
            //             children: [
            //               Expanded(
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       'Đồng h',
            //                       style: Styles.titleLarge
            //                           .copyWith(color: Colors.white),
            //                     ),
            //                     IconButton(
            //                       icon:
            //                           Icon(Icons.settings, color: Colors.white),
            //                       onPressed: () => Navigator.push(
            //                           context,
            //                           MaterialPageRoute(
            //                               builder: (context) => Settings())),
            //                     )
            //                   ],
            //                 ),
            //               ),

            //               TabBar(
            //                   unselectedLabelColor: Colors.white,
            //                   indicatorSize: TabBarIndicatorSize.tab,
            //                   indicatorColor: Colors.white,
            //                   labelStyle:
            //                       Styles.label.copyWith(color: Colors.white),
            //                   dividerHeight: 0,
            //                   tabs: [
            //                     Tab(
            //                       icon: Icon(Icons.alarm, color: Colors.white),
            //                       text: 'Báo thức',
            //                     ),
            //                     Tab(
            //                       icon: Icon(Icons.watch_later_outlined),
            //                       text: 'Đồng hồ',
            //                     ),
            //                     Tab(
            //                       icon: Icon(Icons.hourglass_bottom),
            //                       text: 'Hẹn giờ',
            //                     ),
            //                     Tab(
            //                       icon: Icon(Icons.watch_sharp),
            //                       text: 'Bấm giờ',
            //                     )
            //                   ]),
            //               SizedBox(
            //                 height: 5,
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    ]));
  }
}

class _PageStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int index = context.select((AppModel model) => model.selectedIndex);
    Widget? page;
    if (index == 0) page = BaoThucPage();
    if (index == 1) page = DongHoPage();
    if (index == 2) page = HenGioPage();
    if (index == 3) page = BamGioPage();
    return FocusTraversalGroup(child: page ?? Container());
  }
}
