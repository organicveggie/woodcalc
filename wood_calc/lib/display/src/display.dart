import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:wood_calc/math/src/measurement.dart';
import 'package:wood_calc/stores/main.dart';

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
    final store = GetIt.I<MainStore>();
    return Observer(
      builder: (_) {
        final entries = List<Widget>.of(store.entries.map((e) => InputEntryText(entry: e)));

        // In progress input
        if (store.hasInputs) {
          var total = 0;
          for (var number in store.inputDigits) {
            total = total * 10 + number;
          }
          entries.add(MeasurementText(measurement: Measurement(total, store.inputFraction)));
        }

        if (entries.isEmpty) {
          // No previous entries and no input in progress, so display a placeholder.
          entries.add(Text("0\"", style: Theme.of(context).textTheme.headlineLarge));
        }

        return Row(children: entries);
      },
    );
  }
}
