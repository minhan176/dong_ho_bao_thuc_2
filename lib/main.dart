import 'package:alarm/alarm.dart';
import 'package:dong_ho_bao_thuc/app_model.dart';
import 'package:dong_ho_bao_thuc/data.dart';
import 'package:dong_ho_bao_thuc/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  tz.initializeTimeZones();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();

  database = openDatabase(
    join(await getDatabasesPath(), 'bao_thuc.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE bao_thuc(id INTEGER PRIMARY KEY, lap_lai TEXT)',
      );

      return;
    },
    version: 1,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: CupertinoApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
            primaryColor: Color.fromRGBO(255, 255, 255, 1),
            brightness: Brightness.dark),
        home: SplashScreen(),
      ),
    );
  }
}
