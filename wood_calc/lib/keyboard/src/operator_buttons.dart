import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:wood_calc/math/math.dart';
import 'package:wood_calc/stores/main.dart';

import 'buttons.dart';

class AddOperatorButton extends IconInputButton {
  const AddOperatorButton({super.key}) : super(icon: const Icon(Symbols.add));

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MainStore>();
    return Observer(
        builder: (_) => makeIconButton(
              context: context,
              isEnabled: () => store.canApplyOperator,
              onPressed: () => store.addOperator(Operator.add),
            ));
  }
}

class BackspaceOperatorButton extends IconInputButton {
  const BackspaceOperatorButton({super.key}) : super(icon: const Icon(Symbols.backspace));

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MainStore>();
    return Observer(
        builder: (_) => makeIconButton(
              context: context,
              isEnabled: () => store.hasInputData,
              onPressed: () => store.backspace(),
            ));
  }
}

class ClearOperatorButton extends TextInputButton {
  const ClearOperatorButton({super.key, required super.text});

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MainStore>();
    return Observer(
        builder: (_) => makeButton(
              context: context,
              isEnabled: () => store.hasInputData,
              onPressed: () => store.clearAll(),
            ));
  }
}

class EqualOperatorButton extends IconInputButton {
  const EqualOperatorButton({super.key}) : super(icon: const Icon(Symbols.equal));

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MainStore>();
    return Observer(
        builder: (_) => makeIconButton(
              context: context,
              isEnabled: () => store.canEquals,
              onPressed: () => store.calculateEquals(),
            ));
  }
}

class MultiplyOperatorButton extends IconInputButton {
  const MultiplyOperatorButton({super.key}) : super(icon: const Icon(Symbols.close));

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MainStore>();
    return Observer(
        builder: (_) => makeIconButton(
              context: context,
              isEnabled: () => store.canApplyOperator,
              onPressed: () => store.addOperator(Operator.multiply),
            ));
  }
}

class SubtractOperatorButton extends IconInputButton {
  const SubtractOperatorButton({super.key}) : super(icon: const Icon(Symbols.remove));

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<MainStore>();
    return Observer(
        builder: (_) => makeIconButton(
              context: context,
              isEnabled: () => store.canApplyOperator,
              onPressed: () => store.addOperator(Operator.subtract),
            ));
  }
}
