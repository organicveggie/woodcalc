import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/models/models.dart';

import 'buttons.dart';

abstract class FunctionButton {}

class FeetInchesButton extends BaseIconInputButton implements FunctionButton {
  const FeetInchesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(builder: (BuildContext context, SettingsModel settings, Widget? child) {
      return makeButton(
        context: context,
        icon: settings.displayMode == DisplayMode.totalInches ? Icon(Symbols.barefoot) : Icon(Symbols.measuring_tape),
        isEnabled: () => true,
        onPressed: () {
          settings.displayMode = switch (settings.displayMode) {
            DisplayMode.feetAndInches => DisplayMode.totalInches,
            DisplayMode.totalInches => DisplayMode.feetAndInches,
          };
        },
      );
    });
  }
}
