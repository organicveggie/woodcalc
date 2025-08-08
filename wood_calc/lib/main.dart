import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wood_calc/stores/main.dart';

import 'app.dart';

void main() {
  GetIt.I.registerSingleton<MainStore>(MainStore());
  runApp(const WoodCalcApp());
}
