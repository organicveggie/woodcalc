import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';

import '../math/math.dart';

class MeasurementInputModel with ChangeNotifier {
  final Queue<int> _digits;
  Fraction? _fraction;

  MeasurementInputModel() : _digits = ListQueue.of(<int>[]);

  List<int> get digits => UnmodifiableListView(_digits);

  Fraction? get fraction => _fraction;

  bool get isEmpty => _digits.isEmpty && (_fraction == null);

  set fraction(Fraction? f) {
    _fraction = f;
    notifyListeners();
  }

  void addDigit(int digit) {
    _digits.add(digit);
    notifyListeners();
  }

  void removeLastDigit() {
    _digits.removeLast();
    notifyListeners();
  }

  void fromMeasurement(Measurement m) {
    final inchStr = m.totalInches.toString();
    for (final c in inchStr.characters) {
      _digits.add(int.parse(c));
    }
    _fraction = m.fraction;
    notifyListeners();
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

  void clear() {
    _digits.clear();
    _fraction = null;
    notifyListeners();
  }
}

abstract class EntryModel {}

class EntrySequenceModel with ChangeNotifier {
  final Queue<EntryModel> _sequence;
  final Queue<Measurement> _runningTotal;

  EntrySequenceModel()
      : _sequence = ListQueue.of(<EntryModel>[]),
        _runningTotal = ListQueue.of([Measurement.zero]);

  UnmodifiableListView<EntryModel> get sequence => UnmodifiableListView(_sequence);

  Measurement get measurement => _runningTotal.last;

  void addNumberEntry(NumberEntryModel entry, Measurement newTotal) {
    _sequence.add(entry);
    _runningTotal.add(newTotal);
    notifyListeners();
  }

  void addOperatorEntry(OperatorEntryModel entry) {
    _sequence.add(entry);
    notifyListeners();
  }

  void replaceLastOperator(OperatorEntryModel entry) {
    _sequence.removeLast();
    addOperatorEntry(entry);
  }

  void clear() {
    _sequence.clear();
    _runningTotal.clear();
    notifyListeners();
  }

  bool get isEmpty => _sequence.isEmpty;
  EntryModel get lastEntry => _sequence.last;
  int get length => _sequence.length;

  EntryModel? entryAt(int index) => _sequence.elementAtOrNull(index);

  EntryModel? secondLast() => (length < 2) ? null : entryAt(length - 2);

  EntryModel removeLastEntry() {
    final entry = _sequence.removeLast();
    if (entry is NumberEntryModel) {
      _runningTotal.removeLast();
    }

    notifyListeners();
    return entry;
  }
}

class NumberEntryModel extends EntryModel {
  final Measurement measurement;
  NumberEntryModel(this.measurement);
}

enum Operator {
  add("+"),
  subtract("-"),
  equals("=");

  const Operator(this._str);

  final String _str;

  @override
  String toString() => _str;
}

class OperatorEntryModel extends EntryModel {
  final Operator operator;
  OperatorEntryModel(this.operator);

  @override
  String toString() => operator.toString();
}

enum DisplayMode {
  feetAndInches,
  totalInches,
}

class SettingsModel extends ChangeNotifier {
  DisplayMode _displayMode = DisplayMode.totalInches;

  DisplayMode get displayMode => _displayMode;
  set displayMode(DisplayMode newMode) {
    _displayMode = newMode;
    notifyListeners();
  }
}
