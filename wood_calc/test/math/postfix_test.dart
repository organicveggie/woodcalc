import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:wood_calc/math/math.dart';

void main() {
  group('Create PostfixExpression', () {
    const measure2in = Measurement.fromInches(2);
    const measure3in = Measurement.fromInches(3);
    const measure8in = Measurement.fromInches(8);

    group('with single operator', () {
      parameterizedTest(
          'returns correct postfix',
          // List of values to test
          [
            [
              measure3in,
              Operator.add,
              measure8in,
              BuiltList<ExpressionEntry>.of([measure3in, measure8in, Operator.add]),
            ],
            [
              measure8in,
              Operator.subtract,
              measure8in,
              BuiltList<ExpressionEntry>.of([measure8in, measure8in, Operator.subtract]),
            ],
          ],
          // Test function accepting the provided parameters
          (Measurement a, Operator op, Measurement b, BuiltList<ExpressionEntry> want) {
        final postfix = PostfixExpression.fromInfix(BuiltList<ExpressionEntry>.of([a, op, b]));
        expect(postfix.items, equals(want));
      });
    });

    group('with two operators', () {
      parameterizedTest(
          'returns correct postfix',
          // List of values to test
          [
            [
              measure8in,
              Operator.add,
              measure3in,
              Operator.add,
              measure2in,
              BuiltList<ExpressionEntry>.of([measure8in, measure3in, Operator.add, measure2in, Operator.add]),
            ],
            [
              measure8in,
              Operator.add,
              measure3in,
              Operator.multiply,
              measure2in,
              BuiltList<ExpressionEntry>.of([measure8in, measure3in, measure2in, Operator.multiply, Operator.add]),
            ],
          ],
          // Test function accepting the provided parameters
          (Measurement a, Operator op1, Measurement b, Operator op2, Measurement c, BuiltList<ExpressionEntry> want) {
        final pf = PostfixExpression.fromInfix(BuiltList<ExpressionEntry>.of([a, op1, b, op2, c]));
        expect(pf.items, equals(want));
      });
    });

    group('with parentheses', () {
      parameterizedTest(
          'returns correct postfix',
          // List of values to test
          [
            [
              BuiltList.of([
                Operator.leftParen,
                measure3in,
                Operator.add,
                measure8in,
                Operator.rightParen,
                Operator.multiply,
                measure2in
              ]),
              BuiltList.of([
                measure3in,
                measure8in,
                Operator.add,
                measure2in,
                Operator.multiply,
              ])
            ],
            [
              BuiltList.of([
                measure3in,
                Operator.multiply,
                Operator.leftParen,
                measure8in,
                Operator.add,
                measure2in,
                Operator.rightParen
              ]),
              BuiltList.of([measure3in, measure8in, measure2in, Operator.add, Operator.multiply]),
            ],
            [
              BuiltList.of([
                Operator.leftParen,
                measure3in,
                Operator.multiply,
                Operator.leftParen,
                measure8in,
                Operator.add,
                measure2in,
                Operator.rightParen,
                Operator.add,
                measure2in,
                Operator.rightParen,
                Operator.multiply,
                measure3in
              ]),
              BuiltList.of([
                measure3in,
                measure8in,
                measure2in,
                Operator.add,
                Operator.multiply,
                measure2in,
                Operator.add,
                measure3in,
                Operator.multiply
              ]),
            ],
          ], (BuiltList<ExpressionEntry> infix, BuiltList<ExpressionEntry> want) {
        final pf = PostfixExpression.fromInfix(infix);
        expect(pf.items, equals(want));
      });
    });
  });
}
