// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainStore on _MainStore, Store {
  late final _$displayModeAtom =
      Atom(name: '_MainStore.displayMode', context: context);

  @override
  DisplayMode get displayMode {
    _$displayModeAtom.reportRead();
    return super.displayMode;
  }

  @override
  set displayMode(DisplayMode value) {
    _$displayModeAtom.reportWrite(value, super.displayMode, () {
      super.displayMode = value;
    });
  }

  late final _$_MainStoreActionController =
      ActionController(name: '_MainStore', context: context);

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
displayMode: ${displayMode}
    ''';
  }
}
