import 'package:built_collection/built_collection.dart';

class Stack<E> {
  final List<E> _items = <E>[];
  Stack();

  void push(E item) => _items.add(item);
  E pop() => _items.removeLast();

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  E get last => _items.last;

  int get length => _items.length;

  BuiltList<E> toBuiltList() => BuiltList<E>.of(_items);
}
