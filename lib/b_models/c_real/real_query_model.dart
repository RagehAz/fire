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

class RealQueryModel{
  // -----------------------------------------------------------------------------
  const RealQueryModel({
    required this.path,
    this.keyFieldName,
    this.limit = 5,
    this.readFromBeginningOfOrderedList = true,
    this.orderType,
    this.fieldNameToOrderBy,
    this.queryRange,
  });
  // -----------------------------------------------------------------------------
  final String path;
  final int? limit;
  final String? keyFieldName;
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
    required String keyFieldName,
    String? fieldNameToOrderBy,
    int limit = 5,
  }){
    return RealQueryModel(
      path: path,
      limit: limit,
      keyFieldName: keyFieldName, /// should be docID : 'id'
      fieldNameToOrderBy: 'spaceTime',
      orderType: RealOrderType.byChild,
      queryRange: QueryRange.startAfter,
      // readFromBeginningOfOrderedList: true,
    );
  }
  // -----------------------------------------------------------------------------

  /// QUERY CREATOR

  // --------------------
  /// TASK : TEST
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
            key: lastMap[queryModel.keyFieldName],
          );
        }

        /// END AT
        if (queryModel.queryRange == QueryRange.endAt){
          _query = _query.endAt(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.keyFieldName],
          );
        }

        /// END BEFORE
        if (queryModel.queryRange == QueryRange.endBefore){
          _query = _query.endBefore(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.keyFieldName],
          );
        }

        /// EQUAL TO
        if (queryModel.queryRange == QueryRange.equalTo){
          _query = _query.equalTo(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.keyFieldName],
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
            key: lastMap[queryModel.keyFieldName],
          );
        }

        /// END AT
        if (queryModel.queryRange == QueryRange.endAt){
          _query = _query.endAt(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.keyFieldName],
          );
        }

        /// END BEFORE
        if (queryModel.queryRange == QueryRange.endBefore){
          _query = _query.endAt(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.keyFieldName],
          );
        }

        /// EQUAL TO
        if (queryModel.queryRange == QueryRange.equalTo){
          _query = _query.equalTo(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.keyFieldName],
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
  /// TASK : TEST
  void blogModel(){
    blog('RealQueryModel ------------------------> START');
    blog('path               : $path');
    blog('keyField           : $keyFieldName');
    blog('fieldNameToOrderBy : $fieldNameToOrderBy');
    blog('orderType          : $orderType');
    blog('range              : $queryRange');
    blog('limitToFirst       : $readFromBeginningOfOrderedList');
    blog('limit              : $limit');
    blog('RealQueryModel ------------------------> END');
  }
  // -----------------------------------------------------------------------------
}
