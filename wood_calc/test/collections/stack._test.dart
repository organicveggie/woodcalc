import 'package:flutter_test/flutter_test.dart';
import 'package:wood_calc/collections/collections.dart';

void main() {
  group('Stack', () {
    late Stack<int> stack;
    setUp(() {
      stack = Stack();
    });

    test('empty stack', () {
      expect(stack.length, equals(0));
      expect(stack.isEmpty, equals(true));
      expect(stack.isNotEmpty, equals(false));
    });
    group('push/pop', () {
      test('one item', () {
        stack.push(42);
        expect(stack.length, equals(1));
        expect(stack.isEmpty, equals(false));
        expect(stack.isNotEmpty, equals(true));

        final got = stack.pop();
        expect(got, equals(42));
        expect(stack.isEmpty, equals(true));
      });

      test('multiple items', () {
        expect(stack.isEmpty, equals(true));
        stack.push(42);
        stack.push(13);
        stack.push(735);
        expect(stack.isEmpty, equals(false));
        expect(stack.length, equals(3));

        expect(stack.pop(), equals(735));
        expect(stack.pop(), equals(13));
        expect(stack.pop(), equals(42));
        expect(stack.isEmpty, equals(true));
      });

      test('multiple items interleaved', () {
        expect(stack.isEmpty, equals(true));
        stack.push(42);
        stack.push(13);
        stack.pop();
        stack.push(735);
        stack.push(17);

        expect(stack.pop(), equals(17));
        expect(stack.pop(), equals(735));
        expect(stack.isEmpty, equals(false));
        expect(stack.length, equals(1));
      });
    });
  });
}
