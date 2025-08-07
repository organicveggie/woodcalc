import 'dart:collection';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:wood_calc/math/math.dart';

class MeasurementInput {
  final BuiltList<int> _digits;
  final Fraction? _fraction;

  const MeasurementInput(this._digits, this._fraction);
  MeasurementInput.empty() : this(BuiltList<int>([]), null);
  factory MeasurementInput.fromMeasurement(Measurement m) {
    final newDigits = <int>[];
    final inchStr = m.totalInches.toString();
    for (final c in inchStr.characters) {
      newDigits.add(int.parse(c));
    }
    return MeasurementInput(newDigits.build(), m.fraction);
  }

  BuiltList<int> get digits => _digits;
  Fraction? get fraction => _fraction;

  bool get isEmpty => _digits.isEmpty && (_fraction == null);
  bool get isNotEmpty => _digits.isNotEmpty || (_fraction != null);

  MeasurementInput setFraction(Fraction? f) => MeasurementInput(_digits, f);

  MeasurementInput addDigit(int digit) {
    final newList = _digits.toBuilder();
    newList.add(digit);
    return MeasurementInput(newList.build(), _fraction);
  }

  MeasurementInput removeLastDigit() {
    final newList = _digits.toBuilder();
    newList.removeLast();
    return MeasurementInput(newList.build(), _fraction);
  }

  Measurement toMeasurement() {
    var totalInches = 0;
    for (var i = 0; i < _digits.length; i++) {
      final d = _digits.elementAt(i);
      final powerNum = (_digits.length - i - 1);
      final tenPow = pow(10, powerNum) as int;
      final digitValue = d * tenPow;
      totalInches = totalInches + digitValue;
    }
    return Measurement(totalInches, _fraction);
  }
}

abstract class EntryModel {}

class EntrySequence {
  final BuiltList<EntryModel> _sequence;

  EntrySequence(this._sequence);
  EntrySequence.empty() : this(BuiltList.of([]));

  BuiltList<EntryModel> get sequence => _sequence;

  EntrySequence addNumberEntry(NumberEntryModel entry) {
    final entries = _sequence.toBuilder();
    entries.add(entry);
    return EntrySequence(entries.build());
  }

  EntrySequence addOperatorEntry(OperatorEntryModel entry) {
    final entries = _sequence.toBuilder();
    entries.add(entry);
    return EntrySequence(entries.build());
  }

  bool get isEmpty => _sequence.isEmpty;
  bool get isNotEmpty => _sequence.isNotEmpty;

  EntryModel get lastEntry => _sequence.last;

  NumberEntryModel? get lastNumberEntryModel =>
      (_sequence.lastOrNull is NumberEntryModel) ? (_sequence.last as NumberEntryModel) : null;
  OperatorEntryModel? get lastOperatorEntryModel =>
      (_sequence.lastOrNull is OperatorEntryModel) ? (_sequence.last as OperatorEntryModel) : null;

  int get length => _sequence.length;

  EntryModel? entryAt(int index) => _sequence.elementAtOrNull(index);

  EntryModel? secondLast() => (length < 2) ? null : entryAt(length - 2);

  EntrySequence removeLastEntry() {
    final entries = _sequence.toBuilder();
    entries.removeLast();
    return EntrySequence(entries.build());
  }

  EntrySequence replaceLastOperator(OperatorEntryModel entry) {
    final entries = _sequence.toBuilder();
    entries.removeLast();
    entries.add(entry);
    return EntrySequence(entries.build());
  }
}

class NumberEntryModel extends EntryModel {
  final Measurement measurement;
  NumberEntryModel(this.measurement);
}

class OperatorEntryModel extends EntryModel {
  final Operator operator;
  OperatorEntryModel(this.operator);

  @override
  String toString() => operator.toString();
}

class EqualsOperatorEntryModel extends OperatorEntryModel {
  final Measurement measurement;
  EqualsOperatorEntryModel(this.measurement) : super(Operator.equals);
}

enum DisplayMode {
  feetAndInches,
  totalInches,
}
