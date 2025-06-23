import 'fraction.dart';

class Measurement implements Comparable<Measurement> {
  final int feet;
  final int inches;
  final Fraction? fraction;

  final int totalInches;

  Measurement(this.totalInches, this.fraction)
      : feet = totalInches ~/ 12,
        inches = totalInches % 12;

  Measurement.fromInches(int totalInches) : this(totalInches, null);

  Measurement add(Measurement other) => Measurement(totalInches + other.totalInches, fraction?.add(other.fraction));

  Measurement sub(Measurement other) => Measurement(totalInches - other.totalInches, fraction?.sub(other.fraction));

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
