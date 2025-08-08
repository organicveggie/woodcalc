import 'package:built_collection/built_collection.dart';
import 'package:wood_calc/collections/collections.dart';

import 'expression.dart';
import 'measurement.dart';

abstract class ExpressionNode {
  Measurement evaluate();
}

class OperandExpressionNode implements ExpressionNode {
  final Measurement operand;
  const OperandExpressionNode(this.operand);

  @override
  Measurement evaluate() => operand;
}

class OperatorExpressionNode implements ExpressionNode {
  final Operator operator;
  final ExpressionNode left;
  final ExpressionNode right;

  const OperatorExpressionNode(this.operator, this.left, this.right);

  @override
  Measurement evaluate() {
    // TODO: Evaluate should handle invalid trees
    final leftMeasure = left.evaluate();
    final rightMeasure = right.evaluate();
    return leftMeasure.applyOp(operator, rightMeasure);
  }
}

class ExpressionTree {
  final ExpressionNode root;
  const ExpressionTree(this.root);

  factory ExpressionTree.fromPostfix(BuiltList<ExpressionEntry> postfix) {
    // TODO: Building expression tree from postfix should handle invalid
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

  Measurement evaluate() {
    // TODO: Evaluate should handle invalid trees
    return root.evaluate();
  }
}
