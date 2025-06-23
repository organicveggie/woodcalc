enum CompareResult {
  lessThan,
  equalTo,
  greaterThan;

  static CompareResult fromInt(int i) {
    return switch (i) { < 0 => CompareResult.lessThan, > 0 => CompareResult.greaterThan, _ => CompareResult.equalTo };
  }
}
