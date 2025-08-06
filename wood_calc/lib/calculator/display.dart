import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/math/src/measurement.dart';
import 'package:wood_calc/models/models.dart';

import 'text.dart';

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
            child: _TextDisplay(),
          ),
        ],
      ),
    );
  }
}

class _TextDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<EntrySequenceModel, MeasurementInputModel>(
        builder: (BuildContext context, EntrySequenceModel entrySeq, MeasurementInputModel inputModel, Widget? chiild) {
      // Existing entries in the sequence
      final entries = List<Widget>.of(entrySeq.sequence.map((e) => InputEntryText(entry: e)));

      // In progress input
      if (!inputModel.isEmpty) {
        var total = 0;
        for (var number in inputModel.digits) {
          total = total * 10 + number;
        }
        entries.add(MeasurementText(measurement: Measurement(total, inputModel.fraction)));
      }

      if (entries.isEmpty) {
        // No previous entries and no input in progress, so display a placeholder.
        entries.add(Text("0", style: Theme.of(context).textTheme.headlineLarge));
      }

      return Row(children: entries);
    });
  }
}
