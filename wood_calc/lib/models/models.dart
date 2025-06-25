import 'dart:collection';
import 'package:flutter/material.dart';

import '../math/math.dart';

class MeasurementInputModel with ChangeNotifier {
  final Queue<int> _digits;
  Fraction? _fraction;

  MeasurementInputModel() : _digits = ListQueue.of(<int>[]);

  List<int> get digits => UnmodifiableListView(_digits);

  Fraction? get fraction => _fraction;

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

  void removeLastEntry() {
    final entry = _sequence.removeLast();
    if (entry is NumberEntryModel) {
      _runningTotal.removeLast();
    }

    notifyListeners();
  }
}

class NumberEntryModel extends EntryModel {
  final Measurement measurement;
  NumberEntryModel(this.measurement);
}

enum Operator {
  add,
  subtract,
  equals,
}

class OperatorEntryModel extends EntryModel {
  final Operator operator;
  OperatorEntryModel(this.operator);
}

enum DisplayMode {
  feetAndInches,
  totalInches,
}

class SettingsModel extends ChangeNotifier {
  DisplayMode _displayMode = DisplayMode.feetAndInches;

  DisplayMode get displayMode => _displayMode;
  set displayMode(DisplayMode newMode) {
    _displayMode = newMode;
    notifyListeners();
  }
}
