part of super_fire;

enum RealOrderType {
  byChild,
  byValue,
  byPriority,
  byKey,
}

enum QueryRange {
  startAfter,
  endAt,
  startAt,
  endBefore,
  equalTo,
}

@immutable
class RealQueryModel{
  // -----------------------------------------------------------------------------
  const RealQueryModel({
    required this.path,
    this.idFieldName,
    this.limit = 5,
    this.readFromBeginningOfOrderedList = true,
    this.orderType,
    this.fieldNameToOrderBy,
    this.queryRange,
  });
  // -----------------------------------------------------------------------------
  final String path;
  final int? limit;
  final String? idFieldName;
  final bool readFromBeginningOfOrderedList;
  final RealOrderType? orderType;
  final String? fieldNameToOrderBy;
  final QueryRange? queryRange;
  // -----------------------------------------------------------------------------

  /// ASCENDING QUERY

  // --------------------
  /// TESTED : WORKS PERFECT
  static RealQueryModel createAscendingQueryModel({
    required String path,
    required String idFieldName,
    String? fieldNameToOrderBy,
    int limit = 5,
  }){
    return RealQueryModel(
      path: path,
      limit: limit,
      idFieldName: idFieldName, /// should be docID : 'id'
      fieldNameToOrderBy: fieldNameToOrderBy,
      orderType: RealOrderType.byChild,
      queryRange: QueryRange.startAfter,
      // readFromBeginningOfOrderedList: true,
    );
  }
  // -----------------------------------------------------------------------------

  /// QUERY CREATOR

  // --------------------
  /// TESTED : WORKS PERFECT
  static f_db.Query? createOfficialRealQuery({
    required RealQueryModel? queryModel,
    Map<String, dynamic>? lastMap,
    Map<String, dynamic>? endAt,
  }){
    f_db.Query? _query;

    if (queryModel != null){

      _query = _OfficialReal._getRefByPath(path: queryModel.path);

      /// ORDER BY
      if (queryModel.orderType != null && _query != null){

        /// BY CHILD
        if (queryModel.orderType == RealOrderType.byChild){
          assert(queryModel.fieldNameToOrderBy != null, 'queryModel.fieldNameToOrderBy can not be null');
          // final String _lastNode = ChainPathConverter.getLastPathNode(queryModel.path);
          _query = _query.orderByChild(queryModel.fieldNameToOrderBy!);//queryModel.fieldNameToOrderBy);
        }

        /// BY KEY
        if (queryModel.orderType == RealOrderType.byKey){
          _query = _query.orderByKey();
        }

        /// BY VALUE
        if (queryModel.orderType == RealOrderType.byValue){
          _query = _query.orderByValue();
        }

        /// BY PRIORITY
        if (queryModel.orderType == RealOrderType.byPriority){
          _query = _query.orderByPriority();
        }

      }

      /// QUERY RANGE
      if (queryModel.queryRange != null && lastMap != null && _query != null){

        /// START AFTER
        if (queryModel.queryRange == QueryRange.startAfter){
          _query = _query.startAfter(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

        /// END AT
        if (queryModel.queryRange == QueryRange.endAt){
          _query = _query.endAt(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

        /// END BEFORE
        if (queryModel.queryRange == QueryRange.endBefore){
          _query = _query.endBefore(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

        /// EQUAL TO
        if (queryModel.queryRange == QueryRange.equalTo){
          _query = _query.equalTo(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

      }


      /// LIMIT
      if (queryModel.limit != null && _query != null){

        /// GET MAPS FROM BEGINNING OF THE ORDERED LIST
        if (queryModel.readFromBeginningOfOrderedList == true){
          _query = _query.limitToFirst(queryModel.limit!);
        }

        /// GET MAPS FROM THE END OF THE ORDERED LIST
        else {
          _query = _query.limitToLast(queryModel.limit!);
        }

      }

    }

    return _query;
  }
  // --------------------
  /// TASK : TEST
  static f_d.Query? createNativeRealQuery({
    required RealQueryModel? queryModel,
    Map<String, dynamic>? lastMap,
    Map<String, dynamic>? endAt,
  }){
    f_d.Query? _query;

    if (queryModel != null){

      _query = _NativeReal._getRefByPath(path: queryModel.path);

      /// ORDER BY
      if (queryModel.orderType != null && _query != null){

        /// BY CHILD
        if (queryModel.orderType == RealOrderType.byChild){
          assert(queryModel.fieldNameToOrderBy != null, 'queryModel.fieldNameToOrderBy can not be null');
          // final String _lastNode = ChainPathConverter.getLastPathNode(queryModel.path);
          _query = _query.orderByChild(queryModel.fieldNameToOrderBy!);//queryModel
          // .fieldNameToOrderBy);
        }

        /// BY KEY
        if (queryModel.orderType == RealOrderType.byKey){
          _query = _query.orderByKey();
        }

        /// BY VALUE
        if (queryModel.orderType == RealOrderType.byValue){
          _query = _query.orderByValue();
        }

        /// BY PRIORITY
        if (queryModel.orderType == RealOrderType.byPriority){
          _query = _query.orderByPriority();
        }

      }

      /// QUERY RANGE
      if (queryModel.queryRange != null && lastMap != null && _query != null){

        /// START AFTER
        if (queryModel.queryRange == QueryRange.startAfter){
          _query = _query.startAt(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

        /// END AT
        if (queryModel.queryRange == QueryRange.endAt){
          _query = _query.endAt(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

        /// END BEFORE
        if (queryModel.queryRange == QueryRange.endBefore){
          _query = _query.endAt(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

        /// EQUAL TO
        if (queryModel.queryRange == QueryRange.equalTo){
          _query = _query.equalTo(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

      }


      /// LIMIT
      if (queryModel.limit != null && _query != null){

        /// GET MAPS FROM BEGINNING OF THE ORDERED LIST
        if (queryModel.readFromBeginningOfOrderedList == true){
          _query = _query.limitToFirst(queryModel.limit!);
        }

        /// GET MAPS FROM THE END OF THE ORDERED LIST
        else {
          _query = _query.limitToLast(queryModel.limit!);
        }

      }

    }

    return _query;
  }
  // -----------------------------------------------------------------------------

  /// REAL PATH

  // --------------------
  /// TESTED : WORKS PERFECT
  static String createRealPath({
    required String coll,
    String? doc,
    String? key, // what is this ? sub node / doc field
  }){

    String _path = coll;

    if (doc != null){

      _path = '$_path/$doc';

      if (key != null){
        _path = '$_path/$key';
      }

    }

    return _path;
  }
  // -----------------------------------------------------------------------------

  /// BLOGGING

  // --------------------
  /// TESTED : WORKS PERFECT
  void blogModel(){
    blog('RealQueryModel ------------------------> START');
    blog('path               : $path');
    blog('keyField           : $idFieldName');
    blog('fieldNameToOrderBy : $fieldNameToOrderBy');
    blog('orderType          : $orderType');
    blog('range              : $queryRange');
    blog('limitToFirst       : $readFromBeginningOfOrderedList');
    blog('limit              : $limit');
    blog('RealQueryModel ------------------------> END');
  }
  // -----------------------------------------------------------------------------

  /// EQUALITY

  // --------------------
  /// TESTED : WORKS PERFECT
  static bool checkQueriesAreIdentical({
    required RealQueryModel? model1,
    required RealQueryModel? model2,
  }){
  bool _identical = false;

  if (model1 == null && model2 == null){
    _identical = true;
  }

  else if (model1 != null && model2 != null){

    if (
      model1.path == model2.path &&
      model1.limit == model2.limit &&
      model1.idFieldName == model2.idFieldName &&
      model1.readFromBeginningOfOrderedList == model2.readFromBeginningOfOrderedList &&
      model1.orderType == model2.orderType &&
      model1.fieldNameToOrderBy == model2.fieldNameToOrderBy &&
      model1.queryRange == model2.queryRange
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
    if (other is RealQueryModel){
      _areIdentical = checkQueriesAreIdentical(
        model1: this,
        model2: other,
      );
    }

    return _areIdentical;
  }
  // --------------------
  @override
  int get hashCode =>
      path.hashCode^
      idFieldName.hashCode^
      limit.hashCode^
      readFromBeginningOfOrderedList.hashCode^
      orderType.hashCode^
      fieldNameToOrderBy.hashCode^
      queryRange.hashCode;
  // -----------------------------------------------------------------------------

}
