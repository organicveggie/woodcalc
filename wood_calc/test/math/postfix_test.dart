import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:wood_calc/math/math.dart';

void main() {
  group('Stack', () {
    late Stack<int> stack;
    setUp(() {
      stack = Stack();
    });

    test('empty stack', () {
      expect(stack.length, equals(0));
      expect(stack.isEmpty, equals(true));
      expect(stack.isNotEmpty, equals(false));
    });
    group('push/pop', () {
      test('one item', () {
        stack.push(42);
        expect(stack.length, equals(1));
        expect(stack.isEmpty, equals(false));
        expect(stack.isNotEmpty, equals(true));

        final got = stack.pop();
        expect(got, equals(42));
        expect(stack.isEmpty, equals(true));
      });

      test('multiple items', () {
        expect(stack.isEmpty, equals(true));
        stack.push(42);
        stack.push(13);
        stack.push(735);
        expect(stack.isEmpty, equals(false));
        expect(stack.length, equals(3));

        expect(stack.pop(), equals(735));
        expect(stack.pop(), equals(13));
        expect(stack.pop(), equals(42));
        expect(stack.isEmpty, equals(true));
      });

      test('multiple items interleaved', () {
        expect(stack.isEmpty, equals(true));
        stack.push(42);
        stack.push(13);
        stack.pop();
        stack.push(735);
        stack.push(17);

        expect(stack.pop(), equals(17));
        expect(stack.pop(), equals(735));
        expect(stack.isEmpty, equals(false));
        expect(stack.length, equals(1));
      });
    });
  });

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
  });
}
