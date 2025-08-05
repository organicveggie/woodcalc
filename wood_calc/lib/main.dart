import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:wood_calc/calculator_display.dart';
import 'package:wood_calc/math/math.dart';
import 'package:wood_calc/models/models.dart';

typedef VoidFN = void Function();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EntrySequenceModel()),
        ChangeNotifierProvider(create: (context) => MeasurementInputModel()),
        ChangeNotifierProvider(create: (context) => SettingsModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wood Calc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainAppPanel(title: 'Wood Calc'),
    );
  }
}

class MainAppPanel extends StatefulWidget {
  const MainAppPanel({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainAppPanel> createState() => _MainAppPanelState();
}

class _MainAppPanelState extends State<MainAppPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(child: CalculatorDisplay()),
            ]),
            ButtonGrid(),
          ],
        ),
      ),
    );
  }
}

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

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
            OperatorButton(icon: const Icon(Symbols.close)),
          ],
        ),
        TableRow(
          children: [
            NumberButton(number: 4),
            NumberButton(number: 5),
            NumberButton(number: 6),
            OperatorButton(icon: const Icon(Symbols.remove)),
          ],
        ),
        TableRow(
          children: [
            NumberButton(number: 3),
            NumberButton(number: 2),
            NumberButton(number: 1),
            PlusOpButton(),
          ],
        ),
        TableRow(
          children: [
            FeetInchesButton(),
            NumberButton(number: 0),
            BackspaceOpButton(),
            EqualOpButton(),
          ],
        ),
      ],
    );
  }
}

class NumberButton extends StatelessWidget {
  const NumberButton({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Consumer<MeasurementInputModel>(
        builder: (BuildContext context, MeasurementInputModel inputModel, Widget? child) {
      return Container(
        constraints: BoxConstraints(minHeight: 100),
        padding: EdgeInsets.all(10),
        child: Center(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            onPressed: () {
              inputModel.addDigit(number);
            },
            child: Text(
              "$number",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      );
    });
  }
}

abstract class BaseOperationButton extends StatelessWidget {
  const BaseOperationButton({super.key});

  Widget makeButton({required BuildContext context, required Icon icon, VoidFN? onPressed}) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: Center(
        child: IconButton(
          style: IconButton.styleFrom(
            padding: EdgeInsets.all(10),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: CircleBorder(),
          ),
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}

abstract class BaseOpButton extends StatelessWidget {
  const BaseOpButton({super.key, required this.icon});

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Consumer2<EntrySequenceModel, MeasurementInputModel>(builder: (final BuildContext context,
        final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel, Widget? child) {
      return Container(
        constraints: BoxConstraints(
          minHeight: 100,
        ),
        child: Center(
          child: IconButton(
            style: IconButton.styleFrom(
              padding: EdgeInsets.all(10),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: CircleBorder(),
            ),
            onPressed: isEnabled(entrySeq, inputModel)
                ? () {
                    onPressed(entrySeq, inputModel);
                  }
                : null,
            icon: icon,
          ),
        ),
      );
    });
  }

  bool isEnabled(EntrySequenceModel entrySeq, MeasurementInputModel inputModel) => true;
  void onPressed(final EntrySequenceModel entrySeq, final MeasurementInputModel inputModel);
}

class PlusOpButton extends BaseOpButton {
  const PlusOpButton({super.key}) : super(icon: const Icon(Symbols.add));

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

class EqualOpButton extends BaseOpButton {
  const EqualOpButton({super.key}) : super(icon: const Icon(Symbols.equal));

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

class BackspaceOpButton extends BaseOpButton {
  const BackspaceOpButton({super.key}) : super(icon: const Icon(Symbols.backspace));

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

class OperatorButton extends BaseOpButton {
  const OperatorButton({super.key, required super.icon});

  @override
  void onPressed(EntrySequenceModel entrySeq, MeasurementInputModel inputModel) => {};

  @override
  bool isEnabled(EntrySequenceModel entrySeq, MeasurementInputModel inputModel) => false;
}

abstract class _TextOperatorButton extends StatelessWidget {
  const _TextOperatorButton({super.key, required this.text});

  final String text;

  Widget makeButton(BuildContext context, void Function() onPressed) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(minHeight: 100),
      padding: EdgeInsets.all(10),
      child: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
          ),
          onPressed: () => onPressed(),
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
    );
  }
}

class ClearOperatorButton extends _TextOperatorButton {
  const ClearOperatorButton({super.key, required super.text});

  @override
  Widget build(BuildContext context) {
    return Consumer2<EntrySequenceModel, MeasurementInputModel>(
        builder: (BuildContext context, EntrySequenceModel entrySeq, MeasurementInputModel inputModel, Widget? child) {
      return makeButton(context, () {
        entrySeq.clear();
        inputModel.clear();
      });
    });
  }
}

class FeetInchesButton extends BaseOperationButton {
  const FeetInchesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(builder: (BuildContext context, SettingsModel settings, Widget? child) {
      return makeButton(
        context: context,
        icon: settings.displayMode == DisplayMode.totalInches ? Icon(Symbols.barefoot) : Icon(Symbols.measuring_tape),
        onPressed: () {
          settings.displayMode = switch (settings.displayMode) {
            DisplayMode.feetAndInches => DisplayMode.totalInches,
            DisplayMode.totalInches => DisplayMode.feetAndInches,
          };
        },
      );
    });
  }
}
