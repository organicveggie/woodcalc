import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wood_calc/stores/main.dart';

class NumberButton extends StatelessWidget {
  const NumberButton({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final store = GetIt.I<MainStore>();

    return Container(
      constraints: BoxConstraints(minHeight: 100),
      padding: EdgeInsets.all(10),
      child: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          onPressed: () => store.addInputDigit(number),
          child: Text(
            "$number",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
    );
  }
}
