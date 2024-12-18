import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:login_app/screens/halaman_dua.dart';
import 'package:login_app/screens/login.dart';
import 'package:login_app/screens/mainmenu.dart';
import 'package:login_app/screens/dasboard.dart';
import 'package:login_app/screens/menuitem.dart';
import 'package:login_app/screens/report_borrow.dart';
import 'package:login_app/screens/userr.dart';

import 'storages/user_local.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserLocal db = UserLocal();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: db.hasLogin ? '/dasboard' : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/dasboard': (context) => const HomePage(),
        '/mainmenu': (context) => const MainMenu(),
        '/halaman_dua': (context) => const HalamanDua(),
        '/menuitem': (context) => const MenuItem(),
        '/userr': (context) => const userItem(),
      },
    );
  }
}
