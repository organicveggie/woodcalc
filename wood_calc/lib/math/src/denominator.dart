enum Denominator implements Comparable<Denominator> {
  half(bitShift: 1),
  quarter(bitShift: 2),
  eighth(bitShift: 3),
  sixteenth(bitShift: 4),
  thirtySecond(bitShift: 5),
  sixtyFourth(bitShift: 6),
  oneTwentyEighth(bitShift: 7);

  const Denominator({required this.bitShift}) : value = 1 << bitShift;

  static Denominator? findByValue(int v) {
    if (v % 2 != 0) {
      return null;
    }
    for (var d in Denominator.values) {
      if (d.value == v) {
        return d;
      }
    }
    return null;
  }

  final int bitShift;
  final int value;

  Denominator previous() {
    if (this == Denominator.half) {
      return this;
    }
    return Denominator.findByValue(value >> 1) ?? this;
  }

  Denominator next() {
    if (this == Denominator.oneTwentyEighth) {
      return this;
    }
    return Denominator.findByValue(value << 1) ?? this;
  }

  @override
  int compareTo(Denominator other) => value - other.value;
}
