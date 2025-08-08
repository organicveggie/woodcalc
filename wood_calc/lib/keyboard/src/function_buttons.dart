import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:wood_calc/models/models.dart';
import 'package:wood_calc/stores/main.dart';

import 'buttons.dart';

abstract class FunctionButton {}

class FeetInchesButton extends BaseIconInputButton implements FunctionButton {
  FeetInchesButton({super.key})
      : _iconFeetInches = Icon(Symbols.barefoot),
        _iconTotalInches = Icon(Symbols.measuring_tape);

  final Icon _iconFeetInches;
  final Icon _iconTotalInches;

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MainStore>();
    return Observer(builder: (_) {
      return makeButton(
        context: context,
        icon: store.displayMode == DisplayMode.totalInches ? _iconFeetInches : _iconTotalInches,
        isEnabled: () => true,
        onPressed: () => store.toggleDisplayMode(),
      );
    });
  }
}
