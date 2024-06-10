part of super_fire;

@immutable
class FireFinder {
  /// --------------------------------------------------------------------------
  const FireFinder({
    required this.field,
    required this.comparison,
    required this.value,
  });
  /// --------------------------------------------------------------------------
  final String field; /// fire field name
  final FireComparison comparison; /// fire equality comparison type
  final dynamic value; /// search value
  // -----------------------------------------------------------------------------

  /// OFFICIAL QUERY CREATOR

  // --------------------
  /// TESTED : WORKS PERFECT
  static cloud.Query<Map<String, dynamic>> createOfficialQueryByFinder({
    required cloud.Query<Map<String, dynamic>> query,
    required FireFinder finder,
  }){

    cloud.Query<Map<String, dynamic>> _output = query;

    /// IF EQUAL TO
    if (finder.comparison == FireComparison.equalTo) {
      _output = _output.where(finder.field, isEqualTo: finder.value);
    }

    /// IF GREATER THAN
    if (finder.comparison == FireComparison.greaterThan) {
      _output = _output.where(finder.field, isGreaterThan: finder.value);
    }

    /// IF GREATER THAN OR EQUAL
    if (finder.comparison == FireComparison.greaterOrEqualThan) {
      _output = _output.where(finder.field, isGreaterThanOrEqualTo: finder.value);
    }

    /// IF LESS THAN
    if (finder.comparison == FireComparison.lessThan) {
      _output = _output.where(finder.field, isLessThan: finder.value);
    }

    /// IF LESS THAN OR EQUAL
    if (finder.comparison == FireComparison.lessOrEqualThan) {
      _output = _output.where(finder.field, isLessThanOrEqualTo: finder.value);
    }

    /// IF IS NOT EQUAL TO
    if (finder.comparison == FireComparison.notEqualTo) {
      _output = _output.where(finder.field, isNotEqualTo: finder.value);
    }

    /// IF IS NULL
    if (finder.comparison == FireComparison.nullValue) {
      _output = _output.where(finder.field, isNull: finder.value);

    }

    /// IF whereIn
    if (finder.comparison == FireComparison.whereIn) {
      _output = _output.where(finder.field, whereIn: finder.value);
    }

    /// IF whereNotIn
    if (finder.comparison == FireComparison.whereNotIn) {
      _output = _output.where(finder.field, whereNotIn: finder.value);
    }

    /// IF array contains
    if (finder.comparison == FireComparison.arrayContains) {
      _output = _output.where(finder.field, arrayContains: finder.value);
    }

    /// IF array contains any
    if (finder.comparison == FireComparison.arrayContainsAny) {
      return _output.where(finder.field, arrayContainsAny: finder.value);
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static cloud.Query<Map<String, dynamic>> createOfficialCompositeQueryByFinders({
    required cloud.Query<Map<String, dynamic>> query,
    required List<FireFinder> finders,
  }){

    cloud.Query<Map<String, dynamic>> _output = query;

    if (Lister.checkCanLoop(finders) == true){

      for (final FireFinder finder in finders){
        _output = createOfficialQueryByFinder(
          query: _output,
          finder: finder,
        );
      }

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// NATIVE QUERY CREATOR


  // -----------------------------------------------------------------------------

  /// QUERY CREATOR

  // --------------------
  /// TESTED : WORKS PERFECT
  static bool checkFindersAreIdentical(FireFinder? finder1, FireFinder? finder2){
    bool _identical = false;

    if (finder1 == null && finder2 == null){
      _identical = true;
    }

    else if (finder1 != null && finder2 != null){

      if (
          finder1.field == finder2.field &&
          finder1.comparison == finder2.comparison &&
          finder1.value == finder2.value
      ){
        _identical = true;
      }

    }

    return _identical;

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static bool checkFindersListsAreIdentical(List<FireFinder>? finders1, List<FireFinder>? finders2){
    bool _output = false;

    if (finders1 == null && finders2 == null){
      _output = true;
    }
    else if (finders1 != null && finders1.isEmpty && finders2 != null && finders2.isEmpty){
      _output = true;
    }
    else if (finders1 != null && finders2 != null){

      if (finders1.length != finders2.length){
        _output = false;
      }

      else {

        for (int i = 0; i < finders1.length; i++){

          final bool _areIdentical = checkFindersAreIdentical(
            finders1[i],
            finders2[i],
          );

          if (_areIdentical == false){
            _output = false;
            break;
          }

          else {
            _output = true;
          }

        }

      }


    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// OVERRIDES

  // --------------------
  /*
   @override
   String toString() => 'MapModel(key: $key, value: ${value.toString()})';
   */
  // --------------------
  @override
  bool operator == (Object other){

    if (identical(this, other)) {
      return true;
    }

    bool _areIdentical = false;
    if (other is FireFinder){
      _areIdentical = checkFindersAreIdentical(
        this,
        other,
      );
    }

    return _areIdentical;
  }
  // --------------------
  @override
  int get hashCode =>
      field.hashCode^
      comparison.hashCode^
      value.hashCode;
  // -----------------------------------------------------------------------------
}
