import 'expression.dart';
import 'fraction.dart';

class Measurement implements Comparable<Measurement>, OperandExpression {
  static const Measurement zero = Measurement(0, null);

  final int feet;
  final int inches;
  final Fraction? fraction;

  final int totalInches;

  const Measurement(this.totalInches, this.fraction)
      : feet = totalInches ~/ 12,
        inches = totalInches % 12;

  const Measurement.fromInches(int totalInches) : this(totalInches, null);

  factory Measurement.fromFraction(Fraction? f) {
    if (f == null) {
      return Measurement.fromInches(0);
    }
    final totalInches = f.numerator ~/ f.denominator.value;
    final newNumerator = f.numerator - totalInches * f.denominator.value;
    final newFraction = (newNumerator > 0) ? Fraction(newNumerator, f.denominator).normalize() : null;
    return Measurement(totalInches, newFraction);
  }

  Measurement add(Measurement other) => Measurement(totalInches + other.totalInches, fraction?.add(other.fraction));

  Measurement sub(Measurement other) => Measurement(totalInches - other.totalInches, fraction?.sub(other.fraction));

  Measurement mul(Measurement other) {
    if (fraction == null && other.fraction != null) {
      return other.mul(this);
    }

    final newFraction = fraction?.mul(other.totalInches);
    final newFractionMeasure = Measurement.fromFraction(newFraction);
    final newTotal = totalInches * other.totalInches;
    return newFractionMeasure.add(Measurement.fromInches(newTotal));
  }

  Measurement div(Measurement other) {
    // TODO: Finish division calculation
    return Measurement.fromInches(totalInches ~/ other.totalInches);
  }

  Measurement applyOp(Operator op, Measurement other) {
    return switch (op) {
      Operator.add => add(other),
      Operator.subtract => sub(other),
      Operator.multiply => mul(other),
      Operator.divide => div(other),
      _ => other,
    };
  }

  String inchesToString() {
    if (fraction != null) {
      return '$totalInches" ${fraction!.asString()}"';
    }
    return '$totalInches"';
  }

  @override
  int compareTo(Measurement other) {
    if (feet != other.feet) {
      return feet - other.feet;
    }

    if (inches != other.inches) {
      return inches - other.inches;
    }

    if (fraction != null && other.fraction != null) {
      return fraction!.compareTo(other.fraction!);
    }
    return 0;
  }

  @override
  int get hashCode => Object.hash(totalInches, fraction);

  @override
  bool operator ==(Object other) =>
      other is Measurement && other.totalInches == totalInches && other.fraction == fraction;

  @override
  String toString() {
    final s = '$feet\' $inches"';
    if (fraction != null) {
      return '$s ${fraction!.asString()}';
    }
    return s;
  }
}
