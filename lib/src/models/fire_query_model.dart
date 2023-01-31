part of fire;

@immutable
class FireQueryModel {
  /// --------------------------------------------------------------------------
  const FireQueryModel({
    @required this.collRef,
    this.idFieldName ='id',
    this.limit,
    this.orderBy,
    this.finders,
    this.initialMaps,
  });
  /// --------------------------------------------------------------------------
  final CollectionReference<Object> collRef;
  final int limit;
  final QueryOrderBy orderBy;
  final List<FireFinder> finders;
  final List<Map<String, dynamic>> initialMaps;
  final String idFieldName;
  // -----------------------------------------------------------------------------

  /// QueryParameter CREATOR

  // --------------------
  /// TESTED : WORKS PERFECT
  FireQueryModel copyWith({
    CollectionReference<Object> collRef,
    String idFieldName,
    int limit,
    QueryOrderBy orderBy,
    List<FireFinder> finders,
    List<Map<String, dynamic>> initialMaps,
  }){
    return FireQueryModel(
      collRef: collRef ?? this.collRef,
      idFieldName: idFieldName ?? this.idFieldName,
      limit: limit ?? this.limit,
      orderBy: orderBy ?? this.orderBy,
      finders: finders ?? this.finders,
      initialMaps: initialMaps ?? this.initialMaps,
    );
  }
  // -----------------------------------------------------------------------------

  /// CHECKERS

  // --------------------
  /// TESTED : WORKS PERFECT
  static bool checkQueriesHaveNotChanged({
    @required FireQueryModel model1,
    @required FireQueryModel model2,
  }){
  bool _identical = false;

  if (model1 == null && model2 == null){
    _identical = true;
  }

  else if (model1 != null && model2 != null){

    if (
    model1.collRef?.path == model2.collRef?.path &&
    model1.idFieldName == model2.idFieldName &&
    model1.limit == model2.limit &&
    model1.orderBy?.descending == model2.orderBy?.descending &&
    model1.orderBy?.fieldName == model2.orderBy?.fieldName &&
    FireFinder.checkFindersListsAreIdentical(model1.finders, model2.finders) == true
    // model1.initialMaps == model2.initialMaps &&
    ){
      _identical = true;
    }

  }


  return _identical;
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
    if (other is FireQueryModel){
      _areIdentical = checkQueriesHaveNotChanged(
        model1: this,
        model2: other,
      );
    }

    return _areIdentical;
  }
  // --------------------
  @override
  int get hashCode =>
      collRef.hashCode^
      idFieldName.hashCode^
      limit.hashCode^
      orderBy.hashCode^
      finders.hashCode^
      // onDataChanged.hashCode^
      // startAfter.hashCode^
      initialMaps.hashCode;
// -----------------------------------------------------------------------------
}
