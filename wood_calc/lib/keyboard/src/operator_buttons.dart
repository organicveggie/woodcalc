import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/math/math.dart';
import 'package:wood_calc/models/models.dart';

import 'buttons.dart';

abstract class OperatorButton {
  bool isEnabled(EntrySequenceModel entrySeq, MeasurementInputModel inputModel);
  void onPressed(final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel);
}

class IconOperatorButton extends IconInputButton implements OperatorButton {
  const IconOperatorButton({super.key, required super.icon});

  @override
  Widget build(BuildContext context) {
    return Consumer2<EntrySequenceModel, MeasurementInputModel>(builder: (final BuildContext context,
        final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel, Widget? child) {
      return makeIconButton(
          context: context,
          isEnabled: () => isEnabled(entrySeq, inputModel),
          onPressed: () => onPressed(entrySeq, inputModel));
    });
  }

  @override
  bool isEnabled(EntrySequenceModel entrySeq, MeasurementInputModel inputModel) => true;
  @override
  void onPressed(final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel) {}
}

class TextOperatorButton extends TextInputButton implements OperatorButton {
  const TextOperatorButton({super.key, required super.text});

  @override
  Widget build(BuildContext context) {
    return Consumer2<EntrySequenceModel, MeasurementInputModel>(builder: (final BuildContext context,
        final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel, Widget? child) {
      return makeButton(
          context: context,
          isEnabled: () => isEnabled(entrySeq, inputModel),
          onPressed: () => onPressed(entrySeq, inputModel));
    });
  }

  @override
  bool isEnabled(EntrySequenceModel entrySeq, MeasurementInputModel inputModel) => true;
  @override
  void onPressed(final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel) {}
}

class BackspaceOperatorButton extends IconOperatorButton {
  const BackspaceOperatorButton({super.key}) : super(icon: const Icon(Symbols.backspace));

  @override
  void onPressed(final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel) {
    if (!inputModel.isEmpty) {
      return inputModel.removeLastDigit();
    }
    if (entrySeq.isEmpty) {
      return;
    }

    final lastEntry = entrySeq.removeLastEntry();
    if (lastEntry is NumberEntryModel) {
      return inputModel.fromMeasurement(lastEntry.measurement);
    }
    if (lastEntry is! OperatorEntryModel) {
      // this should never happen
      return;
    }

    // If we just removed an operator and the entry sequence still includes a number,
    // move that measurement into the input field so that the next BackSpace removes
    // the last digit of the measurement.
    if (!entrySeq.isEmpty && entrySeq.lastEntry is NumberEntryModel) {
      final nextLastEntry = entrySeq.removeLastEntry() as NumberEntryModel;
      return inputModel.fromMeasurement(nextLastEntry.measurement);
    }
  }
}

class ClearOperatorButton extends TextOperatorButton {
  const ClearOperatorButton({super.key, required super.text});

  @override
  void onPressed(final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel) {
    entrySeq.clear();
    inputModel.clear();
  }
}

class EqualOperatorButton extends IconOperatorButton {
  const EqualOperatorButton({super.key}) : super(icon: const Icon(Symbols.equal));

  @override
  void onPressed(final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel) {
    if (inputModel.isEmpty) {
      if (entrySeq.length < 3) {
        return;
      }
      if (entrySeq.lastEntry is! NumberEntryModel) {
        return;
      }

      final first = entrySeq.entryAt(entrySeq.length - 3) as NumberEntryModel;
      final op = entrySeq.secondLast() as OperatorEntryModel;
      final second = entrySeq.lastEntry as NumberEntryModel;
      final result = _applyOp(first.measurement, second.measurement, op.operator);
      entrySeq.addOperatorEntry(EqualsOperatorEntryModel(result));
      return;
    }

    if (entrySeq.lastEntry is! OperatorEntryModel) {
      return;
    }
    final firstNumber = entrySeq.secondLast();
    if (firstNumber == null || firstNumber is! NumberEntryModel) {
      return;
    }

    final op = entrySeq.lastEntry as OperatorEntryModel;
    final inputMeasurement = inputModel.toMeasurement();

    final result = _applyOp(firstNumber.measurement, inputMeasurement, op.operator);

    entrySeq.addNumberEntry(NumberEntryModel(inputMeasurement));
    entrySeq.addOperatorEntry(EqualsOperatorEntryModel(result));
    inputModel.clear();
  }

  Measurement _applyOp(Measurement first, Measurement second, Operator op) {
    return switch (op) {
      Operator.add => first.add(second),
      Operator.subtract => first.sub(second),
      _ => second,
    };
  }
}

class PlusOperatorButton extends IconOperatorButton {
  const PlusOperatorButton({super.key}) : super(icon: const Icon(Symbols.add));

  @override
  void onPressed(final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel) {
    if (inputModel.isEmpty) {
      if (entrySeq.isEmpty) {
        return;
      }

      final lastEntry = entrySeq.lastEntry;
      if (lastEntry is OperatorEntryModel) {
        if (lastEntry.operator == Operator.add) {
          return;
        }
        return entrySeq.replaceLastOperator(OperatorEntryModel(Operator.add));
      }

      return entrySeq.addOperatorEntry(OperatorEntryModel(Operator.add));
    }

    final newMeasurement = inputModel.toMeasurement();
    entrySeq.addNumberEntry(NumberEntryModel(newMeasurement));
    entrySeq.addOperatorEntry(OperatorEntryModel(Operator.add));
    inputModel.clear();
  }
}
