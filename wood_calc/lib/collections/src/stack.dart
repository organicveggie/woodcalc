class Stack<E> {
  final List<E> _items = <E>[];
  Stack();

  void push(E item) => _items.add(item);
  E pop() => _items.removeLast();

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  E get last => _items.last;

  int get length => _items.length;
}
