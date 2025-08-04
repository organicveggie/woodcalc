import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/math/src/measurement.dart';
import 'package:wood_calc/models/models.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.grey),
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
            child: _CalculatorDisplayText(),
          ),
        ],
      ),
    );
  }
}

class _CalculatorDisplayText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<EntrySequenceModel, MeasurementInputModel>(
        builder: (BuildContext context, EntrySequenceModel entrySeq, MeasurementInputModel inputModel, Widget? chiild) {
      // Existing entries in the sequence
      final entries = List<Widget>.of(entrySeq.sequence.map((e) => _entryText(context, e)));

      // In progress input
      if (!inputModel.isEmpty) {
        var total = 0;
        for (var number in inputModel.digits) {
          total = total * 10 + number;
        }
        entries.add(_MeasurementText(Measurement(total, inputModel.fraction)));
      }

      if (entries.isEmpty) {
        // No previous entries and no input in progress, so display a placeholder.
        entries.add(Text("0", style: Theme.of(context).textTheme.headlineLarge));
      }

      return Row(children: entries);
    });
  }

  Widget _entryText(final BuildContext context, final EntryModel entry) {
    if (entry is NumberEntryModel) {
      return _MeasurementText(entry.measurement);
    }
    if (entry is EqualsOperatorEntryModel) {
      return Row(
        children: [
          _operatorText(context, entry),
          _MeasurementText(entry.measurement),
        ],
      );
    }
    if (entry is OperatorEntryModel) {
      return _operatorText(context, entry);
    }

    return Text(entry.toString(), style: Theme.of(context).textTheme.headlineLarge);
  }

  Widget _operatorText(final BuildContext context, final OperatorEntryModel entry) =>
      Text(entry.toString(), style: Theme.of(context).textTheme.headlineLarge);
}

class _MeasurementText extends StatelessWidget {
  const _MeasurementText(this.measurement);

  final Measurement measurement;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(builder: (BuildContext context, SettingsModel settings, Widget? chiild) {
      return Text(
        _measurementAsText(settings, measurement),
        style: Theme.of(context).textTheme.headlineLarge,
      );
    });
  }
}

String _measurementAsText(SettingsModel settings, Measurement measurement) {
  final fraction = (measurement.fraction == null) ? "" : " ${measurement.fraction!.asString()}";
  return switch (settings.displayMode) {
    DisplayMode.feetAndInches => "${measurement.feet}' ${measurement.inches}$fraction\"",
    _ => "${measurement.totalInches}$fraction\"",
  };
}
