import 'package:flutter/material.dart';

import 'home/home_screen.dart';

class WoodCalcApp extends StatelessWidget {
  const WoodCalcApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wood Calc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'Wood Calc'),
    );
  }
}
