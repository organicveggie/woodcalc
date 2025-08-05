import 'dart:collection';
import 'package:built_collection/built_collection.dart';

import 'expression.dart';

class PostfixExpression {
  final BuiltList<ExpressionEntry> items;
  const PostfixExpression(this.items);

  factory PostfixExpression.fromInfix(BuiltList<ExpressionEntry> expression) {
    final output = Queue<ExpressionEntry>();
    final stack = Stack<OperatorExpression>();

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

class Stack<E> {
  final List<E> _items = <E>[];
  Stack();

  void push(E item) => _items.add(item);
  E pop() => _items.removeLast();

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  E get last => _items.last;

  int get length => _items.length;
}
