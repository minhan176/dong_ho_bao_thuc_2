import 'package:dong_ho_bao_thuc/screens/home_screen.dart';
import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration(seconds: 2),
        () => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen())));
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
            left: 0,
            right: 0,
            bottom: 50,
            child: Text('Loading',
                textAlign: TextAlign.center, style: Styles.titleLarge))
      ],
    ));
  }
}
