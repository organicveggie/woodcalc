import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/models/models.dart';

class CalculatorDisplay extends StatelessWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.grey),
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: 220,
      child: Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
            child: Consumer2<SettingsModel, EntrySequenceModel>(
                builder: (BuildContext context, SettingsModel settings, EntrySequenceModel entrySeq, Widget? child) {
              return Text(
                entryText(settings, entrySeq),
                style: Theme.of(context).textTheme.headlineLarge,
              );
            }),
          ),
        ],
      )),
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
