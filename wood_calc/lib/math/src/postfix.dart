import 'dart:collection';
import 'package:built_collection/built_collection.dart';
import 'package:wood_calc/collections/collections.dart';

import 'expression.dart';

class PostfixExpression {
  final BuiltList<ExpressionEntry> items;
  const PostfixExpression(this.items);

  factory PostfixExpression.fromInfix(BuiltList<ExpressionEntry> expression) {
    final output = Queue<ExpressionEntry>();
    final stack = Stack<OperatorExpression>();

    // TODO: Building postfix should handle invalid expressions
    for (final item in expression) {
      if (item is OperandExpression) {
        output.addLast(item);
        continue;
      }

      final opItem = item as OperatorExpression;

      // Parentheses
      if (opItem == Operator.leftParen) {
        stack.push(opItem);
        continue;
      }
      if (opItem == Operator.rightParen) {
        // Pop operators off the stack until we get to the previous
        // left parentheses.
        while (stack.isNotEmpty) {
          final stackOp = stack.pop();
          if (stackOp == Operator.leftParen) {
            break;
          }
          output.addLast(stackOp);
        }
        continue;
      }

      // Item must be a regular operator.
      while (stack.isNotEmpty && stack.last.comparePrecedence(opItem) != Precedence.lower) {
        output.addLast(stack.pop());
      }
      stack.push(opItem);
    }
    while (stack.isNotEmpty) {
      output.add(stack.pop());
    }

    return PostfixExpression(BuiltList<ExpressionEntry>.of(output));
  }
}
