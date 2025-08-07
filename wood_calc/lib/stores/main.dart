import 'package:built_collection/built_collection.dart';
import 'package:mobx/mobx.dart';
import 'package:wood_calc/math/math.dart';
import 'package:wood_calc/models/models.dart';

part 'main.g.dart';

// ignore: library_private_types_in_public_api
class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  @readonly
  DisplayMode _displayMode = DisplayMode.totalInches;

  @readonly
  MeasurementInput _activeInput = MeasurementInput.empty();

  @readonly
  EntrySequence _entrySequence = EntrySequence.empty();

  @computed
  bool get canApplyOperator {
    if (_entrySequence.isEmpty && _activeInput.isEmpty) return false;
    return true;
  }

  @computed
  bool get canEquals {
    if (_entrySequence.length < 2) return false;
    if (_entrySequence.length == 2 && _activeInput.isEmpty) return false;
    if (_entrySequence.lastEntry is! NumberEntryModel && _activeInput.isEmpty) return false;
    return true;
  }

  @computed
  bool get canMultiply {
    if (_entrySequence.isEmpty && _activeInput.isEmpty) return false;
    if (_entrySequence.lastNumberEntryModel == null && _activeInput.isEmpty) return false;
    return true;
  }

  @computed
  BuiltList<EntryModel> get entries => _entrySequence.sequence;

  @computed
  bool get hasInputData => (_activeInput.isNotEmpty || _entrySequence.isNotEmpty);

  @computed
  bool get hasInputs => _activeInput.isNotEmpty;

  @computed
  bool get hasEntrySequence => _entrySequence.isNotEmpty;

  @computed
  BuiltList<int> get inputDigits => _activeInput.digits;

  @computed
  Fraction? get inputFraction => _activeInput.fraction;

  @action
  void addInputDigit(int digit) {
    _activeInput = _activeInput.addDigit(digit);
  }

  @action
  void addOperator(Operator op) {
    if (_activeInput.isEmpty) {
      if (_entrySequence.isEmpty) {
        // TODO: Display error
        return;
      }
      if (_entrySequence.lastOperatorEntryModel != null) {
        if (_entrySequence.lastOperatorEntryModel!.operator == op) {
          return;
        }
        _entrySequence = _entrySequence.replaceLastOperator(OperatorEntryModel(op));
      } else {
        _entrySequence = _entrySequence.addOperatorEntry(OperatorEntryModel(op));
      }
      return;
    }

    _entrySequence = _entrySequence
        .addNumberEntry(NumberEntryModel(_activeInput.toMeasurement()))
        .addOperatorEntry(OperatorEntryModel(op));
    _activeInput = MeasurementInput.empty();
  }

  @action
  void backspace() {
    if (_activeInput.isNotEmpty) {
      _activeInput = _activeInput.removeLastDigit();
      return;
    }
    if (_entrySequence.isEmpty) return;

    final lastEntry = _entrySequence.lastEntry;
    _entrySequence = _entrySequence.removeLastEntry();
    if (lastEntry is NumberEntryModel) {
      _activeInput = MeasurementInput.fromMeasurement(lastEntry.measurement);
      return;
    }
    if (lastEntry is! OperatorEntryModel) {
      // TODO: throw exception because this should never happen
      return;
    }

    // If we just removed an operator and the entry sequence still includes a number,
    // move that measurement into the input field so that the next BackSpace removes
    // the last digit of the measurement.
    if (_entrySequence.isNotEmpty && _entrySequence.lastEntry is NumberEntryModel) {
      final nextLastEntry = _entrySequence.lastEntry as NumberEntryModel;
      _entrySequence = _entrySequence.removeLastEntry();
      _activeInput = MeasurementInput.fromMeasurement(nextLastEntry.measurement);
      return;
    }
  }

  @action
  void clearAll() {
    _activeInput = MeasurementInput.empty();
    _entrySequence = EntrySequence.empty();
  }

  @action
  void calculateEquals() {
    if (_activeInput.isEmpty) {
      if (_entrySequence.length < 3) {
        // TODO: Display error
        return;
      }
      if (_entrySequence.lastEntry is! NumberEntryModel) {
        // TODO: Display error
        return;
      }

      final first = _entrySequence.entryAt(_entrySequence.length - 3) as NumberEntryModel;
      final op = _entrySequence.secondLast() as OperatorEntryModel;
      final second = _entrySequence.lastEntry as NumberEntryModel;
      final result = first.measurement.applyOp(op.operator, second.measurement);
      _entrySequence = _entrySequence.addOperatorEntry(EqualsOperatorEntryModel(result));
      return;
    }

    if (_entrySequence.lastEntry is! OperatorEntryModel) {
      return;
    }
    final firstNumber = _entrySequence.secondLast();
    if (firstNumber == null || firstNumber is! NumberEntryModel) {
      return;
    }

    final op = _entrySequence.lastEntry as OperatorEntryModel;
    final inputMeasurement = _activeInput.toMeasurement();

    final result = firstNumber.measurement.applyOp(op.operator, inputMeasurement);

    _entrySequence = _entrySequence
        .addNumberEntry(NumberEntryModel(inputMeasurement))
        .addOperatorEntry(EqualsOperatorEntryModel(result));
    _activeInput = MeasurementInput.empty();
  }

  @action
  void toggleDisplayMode() {
    _displayMode = switch (_displayMode) {
      DisplayMode.feetAndInches => DisplayMode.totalInches,
      _ => DisplayMode.feetAndInches,
    };
  }
}
