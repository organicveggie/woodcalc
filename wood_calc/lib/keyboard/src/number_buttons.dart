import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wood_calc/stores/main.dart';

import 'buttons.dart';

class NumberButton extends TextInputButton {
  NumberButton({super.key, required this.number}) : super(text: number.toString());

  final int number;

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MainStore>();

    return makeButton(
      context: context,
      isEnabled: () => true,
      onPressed: () => store.addInputDigit(number),
    );
  }
}
