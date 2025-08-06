import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wood_calc/math/math.dart';

void main() {
  const measure1in = Measurement.fromInches(1);
  const measure2in = Measurement.fromInches(2);
  const measure3in = Measurement.fromInches(3);
  const measure8in = Measurement.fromInches(8);

  group('Create expression tree', () {
    test('with two operands', () {
      final tree = ExpressionTree.fromPostfix(BuiltList<ExpressionEntry>.of([
        measure2in,
        measure3in,
        Operator.add,
      ]));

      expect(tree.root, isA<OperatorExpressionNode>());
      final opNode = tree.root as OperatorExpressionNode;
      expect(opNode.operator, equals(Operator.add));
      checkOperand(opNode.left, measure2in);
      checkOperand(opNode.right, measure3in);
    });

    group('with three operands', () {
      test('and left parentheses', () {
        final tree = ExpressionTree.fromPostfix(BuiltList<ExpressionEntry>.of([
          measure3in,
          measure8in,
          Operator.add,
          measure2in,
          Operator.multiply,
        ]));

        expect(tree.root, isA<OperatorExpressionNode>());
        final opNode = tree.root as OperatorExpressionNode;
        expect(opNode.operator, equals(Operator.multiply));
        expect(opNode.left, isA<OperatorExpressionNode>());
        checkOperand(opNode.right, measure2in);

        final leftTree = opNode.left as OperatorExpressionNode;
        expect(leftTree.operator, equals(Operator.add));
        checkOperand(leftTree.left, measure3in);
        checkOperand(leftTree.right, measure8in);
      });
      test('and right parentheses', () {
        final tree = ExpressionTree.fromPostfix(BuiltList<ExpressionEntry>.of([
          measure2in,
          measure3in,
          measure8in,
          Operator.add,
          Operator.multiply,
        ]));

        expect(tree.root, isA<OperatorExpressionNode>());
        final opNode = tree.root as OperatorExpressionNode;
        expect(opNode.operator, equals(Operator.multiply));
        expect(opNode.right, isA<OperatorExpressionNode>());
        checkOperand(opNode.left, measure2in);

        final rightTree = opNode.right as OperatorExpressionNode;
        expect(rightTree.operator, equals(Operator.add));
        checkOperand(rightTree.left, measure3in);
        checkOperand(rightTree.right, measure8in);
      });
    });

    group('with four operands', () {
      test('and two sets of parantheses', () {
        final tree = ExpressionTree.fromPostfix(BuiltList<ExpressionEntry>.of([
          measure1in,
          measure2in,
          Operator.add,
          measure3in,
          measure8in,
          Operator.add,
          Operator.multiply,
        ]));

        expect(tree.root, isA<OperatorExpressionNode>());
        final opNode = tree.root as OperatorExpressionNode;
        expect(opNode.operator, equals(Operator.multiply));
        expect(opNode.left, isA<OperatorExpressionNode>());
        expect(opNode.right, isA<OperatorExpressionNode>());

        final leftNode = opNode.left as OperatorExpressionNode;
        expect(leftNode.operator, equals(Operator.add));
        checkOperand(leftNode.left, measure1in);
        checkOperand(leftNode.right, measure2in);

        final rightNode = opNode.right as OperatorExpressionNode;
        expect(rightNode.operator, equals(Operator.add));
        checkOperand(rightNode.left, measure3in);
        checkOperand(rightNode.right, measure8in);
      });
    });
  });
}

checkOperand(ExpressionNode got, OperandExpression want) {
  expect(got, isA<OperandExpressionNode>());

  final opNode = got as OperandExpressionNode;
  expect(opNode.operand, equals(want));
}
