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
  bool get canUseDenominator => ((_activeInput.isNotEmpty && _activeInput.fraction == null) || _activeInput.isEmpty);

  @computed
  bool get canEquals {
    if (_entrySequence.length < 2) return false;
    if (_entrySequence.length == 2 && _activeInput.isEmpty) return false;
    if (_entrySequence.lastEntry is! NumberEntryModel && _activeInput.isEmpty) return false;
    return true;
  }

  @computed
  bool get canMultiply => canApplyOperator;

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
  void addInputDenominator(Denominator d) {
    if (_activeInput.isEmpty) {
      _activeInput = MeasurementInput.fromFraction(Fraction(1, d));
    } else {
      final m = _activeInput.toMeasurement();
      if (m.fraction != null) {
        // TODO: Display error on double fractions.
      } else {
        final newMeasurement = Measurement.fromFraction(Fraction(m.totalInches, d));
        _activeInput = MeasurementInput.fromMeasurement(newMeasurement);
      }
    }
  }

  @action
  void addOperator(Operator op) {
    if (_activeInput.isEmpty) {
      if (_entrySequence.isEmpty) {
        // TODO: Display error on missing entry sequence
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
      if (_activeInput.fraction != null) {
        _activeInput = MeasurementInput(_activeInput.digits, null);
      } else {
        _activeInput = _activeInput.removeLastDigit();
      }
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
      // TODO: Display error when missing an OperatorEntry
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
    // TODO: Catch invalid input before calculating equals result

    if (_activeInput.isNotEmpty) {
      _entrySequence = _entrySequence.addNumberEntry(NumberEntryModel(_activeInput.toMeasurement()));
      _activeInput = MeasurementInput.empty();
    }

    final postfix = PostfixExpression.fromInfix(_entrySequence.toExpressionEntryList());
    final tree = ExpressionTree.fromPostfix(postfix.items);
    // TODO: Catch errors evaluating expression tree
    _entrySequence = _entrySequence.addOperatorEntry(EqualsOperatorEntryModel(tree.evaluate()));
  }

  @action
  void toggleDisplayMode() {
    _displayMode = switch (_displayMode) {
      DisplayMode.feetAndInches => DisplayMode.totalInches,
      _ => DisplayMode.feetAndInches,
    };
  }
}
