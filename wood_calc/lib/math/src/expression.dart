abstract class ExpressionEntry {}

abstract class OperandExpression implements ExpressionEntry {}

abstract class OperatorExpression implements ExpressionEntry {
  /// Returns the relative precedence of the current operator to the other operator.
  Precedence comparePrecedence(OperatorExpression other);
}

enum Operator implements OperatorExpression {
  add("+", Tier.one),
  subtract("-", Tier.one),
  multiply("*", Tier.two),
  divide("/", Tier.two),
  equals("=", Tier.notApplicable),
  leftParen("(", Tier.notApplicable),
  rightParen(")", Tier.notApplicable);

  const Operator(this._str, this._tier);

  final String _str;
  final Tier _tier;

  @override
  String toString() => _str;

  @override
  Precedence comparePrecedence(OperatorExpression other) {
    final otherOp = other as Operator;
    final result = _tier.compareTo(otherOp._tier);
    if (result > 0) return Precedence.higher;
    if (result < 0) return Precedence.lower;
    return Precedence.equal;
  }
}

enum Tier implements Comparable<Tier> {
  four(4),
  three(3),
  two(2),
  one(1),
  notApplicable(0);

  final int _value;

  const Tier(this._value);

  @override
  int compareTo(Tier other) {
    return _value - other._value;
  }
}

enum Precedence {
  higher,
  lower,
  equal,
}
