import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:wood_calc/math/math.dart';

import 'compare.dart';

void main() {
  group('Fraction tests', () {
    group('.normalize', () {
      parameterizedTest(
        'returns expected results',
        // List of values to test
        [
          [Fraction(2, Denominator.quarter), Fraction(1, Denominator.half)],
          [Fraction(2, Denominator.eighth), Fraction(1, Denominator.quarter)],
          [Fraction(2, Denominator.sixteenth), Fraction(1, Denominator.eighth)],
          [Fraction(2, Denominator.thirtySecond), Fraction(1, Denominator.sixteenth)],
          [Fraction(2, Denominator.sixtyFourth), Fraction(1, Denominator.thirtySecond)],
          [Fraction(2, Denominator.oneTwentyEighth), Fraction(1, Denominator.sixtyFourth)],
          [Fraction(4, Denominator.eighth), Fraction(1, Denominator.half)],
          [Fraction(6, Denominator.eighth), Fraction(3, Denominator.quarter)],
          [Fraction(3, Denominator.eighth), Fraction(3, Denominator.eighth)],
          [Fraction(1, Denominator.half), Fraction(1, Denominator.half)],
          [Fraction(1, Denominator.quarter), Fraction(1, Denominator.quarter)],
          [Fraction(1, Denominator.eighth), Fraction(1, Denominator.eighth)],
          [Fraction(1, Denominator.sixteenth), Fraction(1, Denominator.sixteenth)],
          [Fraction(1, Denominator.thirtySecond), Fraction(1, Denominator.thirtySecond)],
          [Fraction(1, Denominator.sixtyFourth), Fraction(1, Denominator.sixtyFourth)],
          [Fraction(1, Denominator.oneTwentyEighth), Fraction(1, Denominator.oneTwentyEighth)],
        ],
        // Test function accepting the provided parameters
        (Fraction value, Fraction want) {
          expect(value.normalize(), equals(want));
        },
        customDescriptionBuilder: (groupDesc, index, values) => '${values[0].asString()} => ${values[1].asString()}',
      );
    });

    group('.denormalize', () {
      parameterizedTest(
          'throws an exceptionion with an invalid parameter',
          // List of values to test
          [
            [Denominator.quarter, Denominator.half],
            [Denominator.eighth, Denominator.quarter],
            [Denominator.sixteenth, Denominator.eighth],
            [Denominator.thirtySecond, Denominator.sixteenth],
            [Denominator.sixtyFourth, Denominator.thirtySecond],
            [Denominator.oneTwentyEighth, Denominator.sixtyFourth],
          ],
          // Test function accepting the provided parameters
          (Denominator first, Denominator second) {
        final f = Fraction(3, first);
        expect(() => f.denormalize(second), throwsArgumentError);
      });

      parameterizedTest(
          'returns expected value',
          // List of values to test
          [
            [Fraction(1, Denominator.half), Denominator.eighth, Fraction(4, Denominator.eighth)],
            [Fraction(1, Denominator.quarter), Denominator.eighth, Fraction(2, Denominator.eighth)],
            [Fraction(1, Denominator.eighth), Denominator.thirtySecond, Fraction(4, Denominator.thirtySecond)],
          ],
          // Test function accepting the provided parameters
          (Fraction first, Denominator newDenominator, Fraction want) {
        expect(first.denormalize(newDenominator), equals(want));
      },
          customDescriptionBuilder: (groupDesc, index, values) =>
              '${values[0].asString()} denormalize ${values[1].value} => ${values[2].asString()}');
    });

    group('.add', () {
      parameterizedTest(
          'returns value',
          // List of values to test
          [
            [Fraction(1, Denominator.eighth), Fraction(1, Denominator.eighth), Fraction(2, Denominator.eighth)],
            [
              Fraction(3, Denominator.thirtySecond),
              Fraction(1, Denominator.sixteenth),
              Fraction(5, Denominator.thirtySecond)
            ],
            [Fraction(3, Denominator.eighth), Fraction(1, Denominator.eighth), Fraction(4, Denominator.eighth)],
          ],
          // Test function accepting the provided parameters
          (Fraction first, Fraction second, Fraction want) {
        expect(first.add(second), equals(want));
      },
          customDescriptionBuilder: (groupDesc, index, values) =>
              '${values[0].asString()} + ${values[1].asString()} = ${values[2].asString()}');

      test('null returns original', () {
        final f = Fraction(3, Denominator.eighth);
        expect(f.add(null), equals(f));
      });
    });

    group('.sub', () {
      parameterizedTest(
          'returns value',
          // List of values to test
          [
            [Fraction(3, Denominator.eighth), Fraction(1, Denominator.eighth), Fraction(2, Denominator.eighth)],
            [Fraction(5, Denominator.sixteenth), Fraction(1, Denominator.eighth), Fraction(3, Denominator.sixteenth)],
          ],
          // Test function accepting the provided parameters
          (Fraction first, Fraction second, Fraction want) {
        expect(first.sub(second).asString(), equals(want.asString()));
      },
          customDescriptionBuilder: (groupDesc, index, values) =>
              '${values[0].asString()} - ${values[1].asString()} = ${values[2].asString()}');

      test('null returns original', () {
        final f = Fraction(3, Denominator.eighth);
        expect(f.sub(null), equals(f));
      });
    });

    group('.mul', () {
      parameterizedTest(
          'returns expected value',
          // List of values to test
          [
            [Fraction(1, Denominator.half), 2, Fraction(2, Denominator.half)],
            [Fraction(1, Denominator.quarter), 3, Fraction(3, Denominator.quarter)],
            [Fraction(5, Denominator.eighth), 4, Fraction(20, Denominator.eighth)],
          ],
          // Test function accepting the provided parameters
          (Fraction a, int multiplier, Fraction want) {
        expect(a.mul(multiplier), equals(want));
      });
    });

    group('.compareTo', () {
      parameterizedTest(
          'returns correct relationship',
          // List of values to test
          [
            [Fraction(3, Denominator.eighth), Fraction(5, Denominator.eighth), CompareResult.lessThan],
            [Fraction(3, Denominator.eighth), Fraction(3, Denominator.eighth), CompareResult.equalTo],
            [Fraction(5, Denominator.eighth), Fraction(3, Denominator.eighth), CompareResult.greaterThan],
            [Fraction(1, Denominator.quarter), Fraction(1, Denominator.eighth), CompareResult.greaterThan],
            [Fraction(7, Denominator.sixteenth), Fraction(15, Denominator.thirtySecond), CompareResult.lessThan],
          ],
          // Test function accepting the provided parameters
          (Fraction a, Fraction b, CompareResult want) {
        final result = CompareResult.fromInt(a.compareTo(b));
        expect(result, equals(want));
      });
    });
  });
}
