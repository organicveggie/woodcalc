import 'package:flutter/material.dart';
import 'package:wood_calc/display/display.dart';
import 'package:wood_calc/keyboard/keyboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: CalculatorDisplay()),
            ]),
            KeyboardGrid(),
          ],
        ),
      ),
    );
  }
}
