import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/models/models.dart';

import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EntrySequenceModel()),
        ChangeNotifierProvider(create: (context) => MeasurementInputModel()),
        ChangeNotifierProvider(create: (context) => SettingsModel()),
      ],
      child: const WoodCalcApp(),
    ),
  );
}
