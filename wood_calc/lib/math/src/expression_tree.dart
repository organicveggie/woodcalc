import 'package:built_collection/built_collection.dart';
import 'package:wood_calc/collections/collections.dart';

import 'expression.dart';
import 'measurement.dart';

abstract class ExpressionNode {}

class OperandExpressionNode implements ExpressionNode {
  final Measurement operand;
  const OperandExpressionNode(this.operand);
}

class OperatorExpressionNode implements ExpressionNode {
  final Operator operator;
  final ExpressionNode left;
  final ExpressionNode right;

  const OperatorExpressionNode(this.operator, this.left, this.right);
}

class ExpressionTree {
  final ExpressionNode root;
  const ExpressionTree(this.root);

  factory ExpressionTree.fromPostfix(BuiltList<ExpressionEntry> postfix) {
    final stack = Stack<ExpressionNode>();

    for (final item in postfix) {
      if (item is Measurement) {
        stack.push(OperandExpressionNode(item));
        continue;
      }

      final right = stack.pop();
      final left = stack.pop();
      stack.push(OperatorExpressionNode(item as Operator, left, right));
    }

    return ExpressionTree(stack.pop());
  }
}
