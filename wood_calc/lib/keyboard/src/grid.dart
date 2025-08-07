import 'package:flutter/material.dart';

import 'function_buttons.dart';
import 'number_buttons.dart';
import 'operator_buttons.dart';

class KeyboardGrid extends StatelessWidget {
  const KeyboardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FractionColumnWidth(0.25),
        1: FractionColumnWidth(0.25),
        2: FractionColumnWidth(0.25),
        3: FractionColumnWidth(0.25),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            ClearOperatorButton(text: "C"),
            Container(),
            Container(),
            Container(
              constraints: BoxConstraints(minHeight: 100),
            ),
          ],
        ),
        TableRow(
          children: [
            NumberButton(number: 7),
            NumberButton(number: 8),
            NumberButton(number: 9),
            MultiplyOperatorButton(),
          ],
        ),
        TableRow(
          children: [
            NumberButton(number: 4),
            NumberButton(number: 5),
            NumberButton(number: 6),
            SubtractOperatorButton(),
          ],
        ),
        TableRow(
          children: [
            NumberButton(number: 3),
            NumberButton(number: 2),
            NumberButton(number: 1),
            AddOperatorButton(),
          ],
        ),
        TableRow(
          children: [
            FeetInchesButton(),
            NumberButton(number: 0),
            BackspaceOperatorButton(),
            EqualOperatorButton(),
          ],
        ),
      ],
    );
  }
}
