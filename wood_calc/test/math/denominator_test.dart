import 'package:flutter_test/flutter_test.dart';
import 'package:parameterized_test/parameterized_test.dart';
import 'package:wood_calc/math/math.dart';

import 'compare.dart';

void main() {
  group('Denominator tests', () {
    group('.findByValue', () {
      test('returns null for missing values', () {
        expect(Denominator.findByValue(17), isNull);
        expect(Denominator.findByValue(73), isNull);
        expect(Denominator.findByValue(256), isNull);
      });
      test('returns matching Denominator', () {
        expect(Denominator.findByValue(2), equals(Denominator.half));
        expect(Denominator.findByValue(4), equals(Denominator.quarter));
        expect(Denominator.findByValue(8), equals(Denominator.eighth));
        expect(Denominator.findByValue(16), equals(Denominator.sixteenth));
        expect(Denominator.findByValue(32), equals(Denominator.thirtySecond));
        expect(Denominator.findByValue(64), equals(Denominator.sixtyFourth));
        expect(Denominator.findByValue(128), equals(Denominator.oneTwentyEighth));
      });
    });

    group('.previous', () {
      test('returns self for half', () {
        expect(Denominator.half.previous(), Denominator.half);
      });
      test('returns exepected value', () {
        expect(Denominator.quarter.previous(), Denominator.half);
        expect(Denominator.eighth.previous(), Denominator.quarter);
        expect(Denominator.sixteenth.previous(), Denominator.eighth);
        expect(Denominator.thirtySecond.previous(), Denominator.sixteenth);
        expect(Denominator.sixtyFourth.previous(), Denominator.thirtySecond);
        expect(Denominator.oneTwentyEighth.previous(), Denominator.sixtyFourth);
      });
    });

    group('.next', () {
      test('returns self for oneTwentyEight', () {
        expect(Denominator.oneTwentyEighth.next(), Denominator.oneTwentyEighth);
      });
      test('returns exepected value', () {
        expect(Denominator.half.next(), Denominator.quarter);
        expect(Denominator.quarter.next(), Denominator.eighth);
        expect(Denominator.eighth.next(), Denominator.sixteenth);
        expect(Denominator.sixteenth.next(), Denominator.thirtySecond);
        expect(Denominator.thirtySecond.next(), Denominator.sixtyFourth);
        expect(Denominator.sixtyFourth.next(), Denominator.oneTwentyEighth);
      });
    });

    parameterizedTest(
        '.compareTo returns expected results',
        // List of values to test
        [
          [Denominator.half, Denominator.quarter, CompareResult.lessThan],
          [Denominator.quarter, Denominator.eighth, CompareResult.lessThan],
          [Denominator.eighth, Denominator.sixteenth, CompareResult.lessThan],
          [Denominator.sixteenth, Denominator.thirtySecond, CompareResult.lessThan],
          [Denominator.thirtySecond, Denominator.sixtyFourth, CompareResult.lessThan],
          [Denominator.sixtyFourth, Denominator.oneTwentyEighth, CompareResult.lessThan],
          [Denominator.half, Denominator.half, CompareResult.equalTo],
          [Denominator.quarter, Denominator.quarter, CompareResult.equalTo],
          [Denominator.eighth, Denominator.eighth, CompareResult.equalTo],
          [Denominator.sixteenth, Denominator.sixteenth, CompareResult.equalTo],
          [Denominator.thirtySecond, Denominator.thirtySecond, CompareResult.equalTo],
          [Denominator.sixtyFourth, Denominator.sixtyFourth, CompareResult.equalTo],
          [Denominator.oneTwentyEighth, Denominator.oneTwentyEighth, CompareResult.equalTo],
          [Denominator.quarter, Denominator.half, CompareResult.greaterThan],
          [Denominator.eighth, Denominator.quarter, CompareResult.greaterThan],
          [Denominator.sixteenth, Denominator.eighth, CompareResult.greaterThan],
          [Denominator.thirtySecond, Denominator.sixteenth, CompareResult.greaterThan],
          [Denominator.sixtyFourth, Denominator.thirtySecond, CompareResult.greaterThan],
          [Denominator.oneTwentyEighth, Denominator.sixtyFourth, CompareResult.greaterThan],
        ],
        // Test function accepting the provided parameters
        (Denominator a, Denominator b, CompareResult want) {
      final result = CompareResult.fromInt(a.compareTo(b));
      expect(result, equals(want));
    });
  });
}
