part of fire;

enum FireComparison {
  ///
  greaterThan,
  ///
  greaterOrEqualThan,
  ///
  lessThan,
  ///
  lessOrEqualThan,
  /// WHEN : dynamic x on db == (x);
  equalTo,
  ///
  notEqualTo,
  /// WHEN : dynamic x on db is null == (true)
  nullValue,
  ///
  whereIn,
  ///
  whereNotIn,
  /// WHEN : List<dynamic>['a', 'b', 'c'] on db contains ('b') or not.
  arrayContains,
  ///
  arrayContainsAny,
}
