import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/math/math.dart';
import 'package:wood_calc/models/models.dart';

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
    return Consumer<SettingsModel>(builder: (BuildContext context, SettingsModel settings, Widget? chiild) {
      return Text(
        measurementAsText(settings, measurement),
        style: Theme.of(context).textTheme.headlineLarge,
      );
    });
  }

  String measurementAsText(SettingsModel settings, Measurement measurement) {
    final fraction = (measurement.fraction == null) ? "" : " ${measurement.fraction!.asString()}";
    return switch (settings.displayMode) {
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
