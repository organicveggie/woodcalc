import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/models/models.dart';

class NumberButton extends StatelessWidget {
  const NumberButton({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Consumer<MeasurementInputModel>(
        builder: (BuildContext context, MeasurementInputModel inputModel, Widget? child) {
      return Container(
        constraints: BoxConstraints(minHeight: 100),
        padding: EdgeInsets.all(10),
        child: Center(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            onPressed: () {
              inputModel.addDigit(number);
            },
            child: Text(
              "$number",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      );
    });
  }
}
