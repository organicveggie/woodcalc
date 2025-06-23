import 'denominator.dart';

class Fraction implements Comparable<Fraction> {
  final int numerator;
  final Denominator denominator;

  Fraction(this.numerator, this.denominator);

  Fraction normalize() {
    if (numerator % 2 == 0 && denominator != Denominator.half) {
      return Fraction(numerator >> 1, denominator.previous()).normalize();
    }
    return this;
  }

  Fraction denormalize(Denominator newDenominator) {
    if (denominator.compareTo(newDenominator) >= 0) {
      throw ArgumentError(
          "new denominator ${newDenominator.value} must be greater than the current denominator ${denominator.value}");
    }
    final bitShiftDiff = newDenominator.bitShift - denominator.bitShift;
    return Fraction(numerator << bitShiftDiff, newDenominator);
  }

  Fraction add(Fraction? other) {
    if (other == null) {
      return this;
    }

    final f1 = (denominator.compareTo(other.denominator) >= 0) ? this : denormalize(other.denominator);
    final f2 = (other.denominator.compareTo(denominator) >= 0) ? other : other.denormalize(denominator);
    return Fraction(f1.numerator + f2.numerator, f1.denominator);
  }

  Fraction sub(Fraction? other) {
    if (other == null) {
      return this;
    }
    return add(Fraction(-other.numerator, other.denominator));
  }

  String asString() => '$numerator/${denominator.value}';

  @override
  bool operator ==(Object other) =>
      other is Fraction && other.numerator == numerator && other.denominator == denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  int compareTo(Fraction other) {
    if (other.denominator == denominator) {
      return numerator - other.numerator;
    }

    final f1 = (denominator.compareTo(other.denominator) >= 0) ? this : denormalize(other.denominator);
    final f2 = (other.denominator.compareTo(denominator) >= 0) ? other : other.denormalize(denominator);
    return f1.numerator - f2.numerator;
  }
}
