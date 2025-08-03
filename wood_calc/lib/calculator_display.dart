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
            // child: Consumer3<SettingsModel, EntrySequenceModel, MeasurementInputModel>(builder: (BuildContext context,
            //     SettingsModel settings, EntrySequenceModel entrySeq, MeasurementInputModel inputModel, Widget? child) {
            //   return Text(
            //     entryText(settings, entrySeq),
            //     style: Theme.of(context).textTheme.headlineLarge,
            //   );
            // }),
          ),
        ],
      ),
    );
  }

  String entryText(SettingsModel settings, EntrySequenceModel entrySeq) {
    final fraction = (entrySeq.measurement.fraction == null) ? "" : " ${entrySeq.measurement.fraction!.asString()}";
    return switch (settings.displayMode) {
      DisplayMode.feetAndInches => "${entrySeq.measurement.feet}' ${entrySeq.measurement.inches}$fraction\"",
      _ => "${entrySeq.measurement.totalInches}$fraction\"",
    };
  }
}

class _CalculatorDisplayText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<EntrySequenceModel, MeasurementInputModel>(
      builder: (BuildContext context, EntrySequenceModel entrySeq, MeasurementInputModel inputModel, Widget? chiild) {
        if (entrySeq.isEmpty) {
          if (inputModel.isEmpty) {
            // No previous entries and no input in progress
            return Text(
              "0",
              style: Theme.of(context).textTheme.headlineLarge,
            );
          }

          // No previous entries, but input in progress
          var total = 0;
          for (var number in inputModel.digits) {
            total = total * 10 + number;
          }
          return _MeasurementText(Measurement(total, inputModel.fraction));
        }

        // Exactly one entry in the sequence
        if (entrySeq.length == 1) {
          if (entrySeq.lastEntry is OperatorEntryModel) {
            return Text(
              entrySeq.lastEntry.toString(),
              style: Theme.of(context).textTheme.headlineLarge,
            );
          }

          final number = entrySeq.lastEntry as NumberEntryModel;
          return _MeasurementText(number.measurement);
        }

        // Multiple entries in the entry sequence.
        // No input text.
        if (inputModel.isEmpty) {
          return Column(children: [
            Row(children: [
              _entryText(context, entrySeq.entryAt(entrySeq.length - 2)!),
            ]),
            Row(
              children: [
                _entryText(context, entrySeq.lastEntry),
              ],
            ),
          ]);
        }

        // Previous entry sequences AND input text in progress.
        var total = 0;
        for (var number in inputModel.digits) {
          total = total * 10 + number;
        }
        return Column(
          children: [
            Row(children: [_entryText(context, entrySeq.entryAt(entrySeq.length - 2)!)]),
            Row(children: [_entryText(context, entrySeq.lastEntry)]),
            Row(children: [_MeasurementText(Measurement(total, inputModel.fraction))]),
          ],
        );
      },
    );
  }

  Widget _entryText(final BuildContext context, final EntryModel entry) {
    if (entry is NumberEntryModel) {
      return _MeasurementText(entry.measurement);
    }

    return Text(entry.toString(), style: Theme.of(context).textTheme.headlineLarge);
  }
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
