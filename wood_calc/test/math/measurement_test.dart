import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:wood_calc/math/math.dart';

import 'compare.dart';

void main() {
  group('Measurement tests', () {
    group('creation', () {
      parameterizedTest(
          'has correct values',
          // List of values to test
          [
            [Measurement.fromInches(7), 0, 7],
            [Measurement.fromInches(13), 1, 1],
            [Measurement.fromInches(36), 3, 0],
          ],
          // Test function accepting the provided parameters
          (Measurement m, int feet, int inches) {
        expect(m.feet, equals(feet));
        expect(m.inches, equals(inches));
      }, customDescriptionBuilder: (groupDesc, index, values) {
        return '${values[0].inchesToString()} => ${values[1]}\' ${values[2]}"';
      });
    });

    group('from fraction', () {
      parameterizedTest(
          'normalizes correctly',
          // List of values to test
          [
            [Fraction(1, Denominator.half), Measurement(0, Fraction(1, Denominator.half))],
            [Fraction(3, Denominator.half), Measurement(1, Fraction(1, Denominator.half))],
            [Fraction(2, Denominator.half), Measurement(1, null)],
            [Fraction(10, Denominator.quarter), Measurement(2, Fraction(1, Denominator.half))],
          ],
          // Test function accepting the provided parameters
          (Fraction f, Measurement want) {
        expect(Measurement.fromFraction(f), equals(want));
      });
    });

    group('.mul', () {
      parameterizedTest(
          'with null fraction',
          // List of values to test
          [
            [Measurement.fromInches(3), Measurement.fromInches(2), Measurement.fromInches(6)],
            [Measurement.fromInches(6), Measurement.fromInches(4), Measurement.fromInches(24)],
          ],
          // Test function accepting the provided parameters
          (Measurement first, Measurement multiplier, Measurement want) {
        expect(first.mul(multiplier), equals(want));
      });
      parameterizedTest(
          'with fraction',
          // List of values to test
          [
            [
              Measurement(3, Fraction(1, Denominator.quarter)),
              Measurement.fromInches(2),
              Measurement(6, Fraction(1, Denominator.half))
            ],
            [
              Measurement(6, Fraction(3, Denominator.eighth)),
              Measurement.fromInches(4),
              Measurement(25, Fraction(1, Denominator.half))
            ],
          ],
          // Test function accepting the provided parameters
          (Measurement first, Measurement multiplier, Measurement want) {
        expect(first.mul(multiplier), equals(want));
      });
    });

    group('.compareTo', () {
      parameterizedTest(
          'returns correct relationship',
          // List of values to test
          [
            [Measurement.fromInches(3), Measurement.fromInches(8), CompareResult.lessThan],
            [Measurement.fromInches(8), Measurement.fromInches(3), CompareResult.greaterThan],
            [Measurement.fromInches(4), Measurement.fromInches(4), CompareResult.equalTo],
            [Measurement.fromInches(17), Measurement.fromInches(21), CompareResult.lessThan],
            [
              Measurement(0, Fraction(3, Denominator.eighth)),
              Measurement(0, Fraction(3, Denominator.sixteenth)),
              CompareResult.greaterThan
            ],
            [Measurement(0, Fraction(3, Denominator.eighth)), Measurement.fromInches(1), CompareResult.lessThan],
          ],
          // Test function accepting the provided parameters
          (Measurement a, Measurement b, CompareResult want) {
        final result = CompareResult.fromInt(a.compareTo(b));
        expect(result, equals(want));
      });
    });
  });
}
