import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:wood_calc/math/math.dart';
import 'package:wood_calc/models/models.dart';
import 'package:wood_calc/stores/main.dart';

class InputEntryText extends StatelessWidget {
  const InputEntryText({super.key, required this.entry});

  final EntryModel entry;

  @override
  Widget build(BuildContext context) {
    if (entry is NumberEntryModel) {
      return MeasurementText(measurement: (entry as NumberEntryModel).measurement);
    }
    if (entry is EqualsOperatorEntryModel) {
      final model = entry as EqualsOperatorEntryModel;
      return Row(
        children: [
          OperatorText(operator: model.operator),
          MeasurementText(measurement: model.measurement),
        ],
      );
    }
    if (entry is OperatorEntryModel) {
      return OperatorText(operator: (entry as OperatorEntryModel).operator);
    }

    return Text(entry.toString(), style: Theme.of(context).textTheme.headlineLarge);
  }
}

class MeasurementText extends StatelessWidget {
  const MeasurementText({super.key, required this.measurement});

  final Measurement measurement;

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MainStore>();
    return Observer(
        builder: (_) => Text(
              measurementAsText(store.displayMode, measurement),
              style: Theme.of(context).textTheme.headlineLarge,
            ));
  }

  String measurementAsText(DisplayMode mode, Measurement measurement) {
    if ((measurement.totalInches == 0) && (measurement.fraction == null)) return "0\"";

    final fraction = (measurement.fraction == null) ? "" : " ${measurement.fraction!.asString()}";
    if (measurement.totalInches == 0) {
      return "$fraction\"";
    }
    return switch (mode) {
      DisplayMode.feetAndInches => "${measurement.feet}' ${measurement.inches}$fraction\"",
      _ => "${measurement.totalInches}$fraction\"",
    };
  }
}

class OperatorText extends StatelessWidget {
  const OperatorText({super.key, required this.operator});

  final Operator operator;

  @override
  Widget build(BuildContext context) {
    return Text(operator.toString(), style: Theme.of(context).textTheme.headlineLarge);
  }
}
