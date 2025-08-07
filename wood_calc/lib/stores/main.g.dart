// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainStore on _MainStore, Store {
  Computed<bool>? _$canApplyOperatorComputed;

  @override
  bool get canApplyOperator => (_$canApplyOperatorComputed ??= Computed<bool>(
          () => super.canApplyOperator,
          name: '_MainStore.canApplyOperator'))
      .value;
  Computed<bool>? _$canEqualsComputed;

  @override
  bool get canEquals => (_$canEqualsComputed ??=
          Computed<bool>(() => super.canEquals, name: '_MainStore.canEquals'))
      .value;
  Computed<bool>? _$canMultiplyComputed;

  @override
  bool get canMultiply =>
      (_$canMultiplyComputed ??= Computed<bool>(() => super.canMultiply,
              name: '_MainStore.canMultiply'))
          .value;
  Computed<BuiltList<EntryModel>>? _$entriesComputed;

  @override
  BuiltList<EntryModel> get entries => (_$entriesComputed ??=
          Computed<BuiltList<EntryModel>>(() => super.entries,
              name: '_MainStore.entries'))
      .value;
  Computed<bool>? _$hasInputDataComputed;

  @override
  bool get hasInputData =>
      (_$hasInputDataComputed ??= Computed<bool>(() => super.hasInputData,
              name: '_MainStore.hasInputData'))
          .value;
  Computed<bool>? _$hasInputsComputed;

  @override
  bool get hasInputs => (_$hasInputsComputed ??=
          Computed<bool>(() => super.hasInputs, name: '_MainStore.hasInputs'))
      .value;
  Computed<bool>? _$hasEntrySequenceComputed;

  @override
  bool get hasEntrySequence => (_$hasEntrySequenceComputed ??= Computed<bool>(
          () => super.hasEntrySequence,
          name: '_MainStore.hasEntrySequence'))
      .value;
  Computed<BuiltList<int>>? _$inputDigitsComputed;

  @override
  BuiltList<int> get inputDigits => (_$inputDigitsComputed ??=
          Computed<BuiltList<int>>(() => super.inputDigits,
              name: '_MainStore.inputDigits'))
      .value;
  Computed<Fraction?>? _$inputFractionComputed;

  @override
  Fraction? get inputFraction => (_$inputFractionComputed ??=
          Computed<Fraction?>(() => super.inputFraction,
              name: '_MainStore.inputFraction'))
      .value;

  late final _$_displayModeAtom =
      Atom(name: '_MainStore._displayMode', context: context);

  DisplayMode get displayMode {
    _$_displayModeAtom.reportRead();
    return super._displayMode;
  }

  @override
  DisplayMode get _displayMode => displayMode;

  @override
  set _displayMode(DisplayMode value) {
    _$_displayModeAtom.reportWrite(value, super._displayMode, () {
      super._displayMode = value;
    });
  }

  late final _$_activeInputAtom =
      Atom(name: '_MainStore._activeInput', context: context);

  MeasurementInput get activeInput {
    _$_activeInputAtom.reportRead();
    return super._activeInput;
  }

  @override
  MeasurementInput get _activeInput => activeInput;

  @override
  set _activeInput(MeasurementInput value) {
    _$_activeInputAtom.reportWrite(value, super._activeInput, () {
      super._activeInput = value;
    });
  }

  late final _$_entrySequenceAtom =
      Atom(name: '_MainStore._entrySequence', context: context);

  EntrySequence get entrySequence {
    _$_entrySequenceAtom.reportRead();
    return super._entrySequence;
  }

  @override
  EntrySequence get _entrySequence => entrySequence;

  @override
  set _entrySequence(EntrySequence value) {
    _$_entrySequenceAtom.reportWrite(value, super._entrySequence, () {
      super._entrySequence = value;
    });
  }

  late final _$_MainStoreActionController =
      ActionController(name: '_MainStore', context: context);

  @override
  void addInputDigit(int digit) {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.addInputDigit');
    try {
      return super.addInputDigit(digit);
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addOperator(Operator op) {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.addOperator');
    try {
      return super.addOperator(op);
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void backspace() {
    final _$actionInfo =
        _$_MainStoreActionController.startAction(name: '_MainStore.backspace');
    try {
      return super.backspace();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAll() {
    final _$actionInfo =
        _$_MainStoreActionController.startAction(name: '_MainStore.clearAll');
    try {
      return super.clearAll();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void calculateEquals() {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.calculateEquals');
    try {
      return super.calculateEquals();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleDisplayMode() {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.toggleDisplayMode');
    try {
      return super.toggleDisplayMode();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
canApplyOperator: ${canApplyOperator},
canEquals: ${canEquals},
canMultiply: ${canMultiply},
entries: ${entries},
hasInputData: ${hasInputData},
hasInputs: ${hasInputs},
hasEntrySequence: ${hasEntrySequence},
inputDigits: ${inputDigits},
inputFraction: ${inputFraction}
    ''';
  }
}
