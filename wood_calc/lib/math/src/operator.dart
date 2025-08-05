enum Operator {
  add("+"),
  subtract("-"),
  multiply("*"),
  divide("/"),
  equals("=");

  const Operator(this._str);

  final String _str;

  @override
  String toString() => _str;
}
