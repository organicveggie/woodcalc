import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/models/models.dart';
import 'package:wood_calc/stores/main.dart';

import 'app.dart';

void main() {
  GetIt.I.registerSingleton<MainStore>(MainStore());
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
