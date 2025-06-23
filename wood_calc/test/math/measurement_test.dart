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
