import 'package:dong_ho_bao_thuc/app_model.dart';
import 'package:dong_ho_bao_thuc/pages/bam_gio.dart';
import 'package:dong_ho_bao_thuc/pages/bao_thuc.dart';
import 'package:dong_ho_bao_thuc/pages/dong_ho.dart';
import 'package:dong_ho_bao_thuc/pages/hen_gio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
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
                color: isActive ? Colors.yellow.shade600 : Colors.white,
                size: 26,
              ),
            ),
            if (label.isNotEmpty) ...[
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.yellow.shade600 : Colors.white,
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
      Positioned.fill(
          child: Image.asset(
        'images/bg.jpg',
        fit: BoxFit.cover,
      )),
      // Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //       colors: [
      //         Color(0xFF2C2C2C), // Xám đậm
      //         Color(0xFFB0B0B0), // Xám trung bình
      //         Color(0xFFE0E0E0), // Xám nhạt
      //       ],
      //       stops: [0.0, 0.5, 1.0],
      //     ),
      //   ),
      // ),
      Positioned.fill(
        child: Column(
          children: [
            Expanded(
                child: SafeArea(
              child: GlassmorphicContainer(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.all(12),
                borderRadius: 35,
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
                child: _PageStack(),
              ),
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: GlassmorphicContainer(
                width: double.infinity,
                height: 60,
                borderRadius: 35,
                //padding: EdgeInsets.all(8),
                blur: 14,
                alignment: Alignment.center,
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
            SizedBox(height: 30)
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
