part of super_fire;

/// => TAMAM
class _OfficialReal {
  // -----------------------------------------------------------------------------

  const _OfficialReal();

  // -----------------------------------------------------------------------------
  static int timeout = 10;
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _onRealError(String error) async {

    final bool _shouldPurge = TextCheck.stringContainsSubString(
        string: error,
        subString: 'Timeout',
    );

    if (_shouldPurge == true){
      await _purge();
    }
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _purge() async {
    await _OfficialFirebase.getReal().purgeOutstandingWrites();
  }
  // -----------------------------------------------------------------------------
  static Future<void> goOnline() async {
    await _OfficialFirebase.getReal().goOnline();
  }
  // --------------------
  static Future<void> goOffline() async {
    await _OfficialFirebase.getReal().goOffline();
  }
  // -----------------------------------------------------------------------------

  /// REF

  // --------------------
  /// TESTED : WORKS PERFECT
  static f_db.DatabaseReference _createPathAndGetRef({
    @required String coll,
    String doc,
    String key,
  }){
    final String path = RealQueryModel.createRealPath(
      coll: coll,
      doc: doc,
      key: key,
    );
    return _OfficialFirebase.getReal().ref(path);
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static f_db.DatabaseReference _getRefByPath({
    @required String path,
  }){
    assert(path != null, 'PATH SHOULD NOT BE NULL');
    return _OfficialFirebase.getReal().ref(path);
  }
  // -----------------------------------------------------------------------------

  /// CREATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> createDoc({
    @required String coll,
    @required Map<String, dynamic> map,
    String doc,
  }) async {

    Map<String, dynamic> _output;

   if (doc == null){
     _output = await _createUnnamedDoc(
       coll: coll,
       map: map,
     );
   }

   else {
     _output = await _createNamedDoc(
       coll: coll,
       doc: doc,
       map: map,
     );
   }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> _createUnnamedDoc({
    @required String coll,
    @required Map<String, dynamic> map,
  }) async {

    Map<String, dynamic> _output;

    if (map != null && coll != null){

      await tryAndCatch(
        invoker: 'OfficialReal._createUnnamedDoc',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          final f_db.DatabaseReference _ref = _createPathAndGetRef(coll: coll,).push();

          final String _docID = _ref.key;

          await _ref.set(Mapper.removePair(
              map: map,
              fieldKey: 'id',
          ));

          _output = Mapper.insertPairInMap(
            map: map,
            key: 'id',
            value: _docID,
            overrideExisting: true,
          );

        },
      );

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> _createNamedDoc({
    @required String coll,
    @required String doc,
    @required Map<String, dynamic> map,
  }) async {
    Map<String, dynamic> _uploaded;

    if (map != null) {

      final f_db.DatabaseReference _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
      );

      await tryAndCatch(
        invoker: 'OfficialReal._createNamedDoc',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          await _ref.set(Mapper.removePair(
            map: map,
            fieldKey: 'id',
          ));

          _uploaded = Mapper.insertPairInMap(
            map: map,
            key: 'id',
            value: doc,
            overrideExisting: true,
          );

        },
      );
    }

    return _uploaded;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> createDocInPath({
    @required String pathWithoutDocName,
    @required Map<String, dynamic> map,
    String doc,
  }) async {

    Map<String, dynamic> _output;

    if (map != null) {
      String _docID;

      await tryAndCatch(
        invoker: 'OfficialReal.createDocInPath',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          final bool _isDocNamed = doc != null;
          final String _path = _isDocNamed ? '$pathWithoutDocName/$doc' : pathWithoutDocName;

          /// GET PATH
          f_db.DatabaseReference _ref = _getRefByPath(
            path: _path,
          );

          if (doc == null) {
            _ref = _ref.push();
            _docID = _ref.key;
          }
          else {
            _docID = doc;
          }

          /// CREATE
          await _ref.set(Mapper.removePair(
            map: map,
            fieldKey: 'id',
          ));

          _output = Mapper.insertPairInMap(
            map: map,
            key: 'id',
            value: _docID,
            overrideExisting: true,
          );

        },
      );

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> createColl({
    @required String coll,
    @required Map<String, dynamic> map,
  }) async {
    Map<String, dynamic> _output;

    if (map != null && coll != null) {

      await tryAndCatch(
        invoker: 'OfficialReal.createColl',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          final f_db.DatabaseReference _ref = _createPathAndGetRef(
            coll: coll,
          );

          await _ref.set(Mapper.removePair(
            map: map,
            fieldKey: 'id',
          ));

          _output = Mapper.insertPairInMap(
            map: map,
            key: 'id',
            value: coll,
            overrideExisting: true,
          );

        },
      );
    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// READ

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<Map<String, dynamic>>> readPathMaps({
    @required RealQueryModel realQueryModel,
    Map<String, dynamic> startAfter,
  }) async {

    List<Map<String, dynamic>> _output = <Map<String, dynamic>>[];

    await tryAndCatch(
      invoker: 'OfficialReal.readPathMap',
      timeout: timeout,
      onError: _onRealError,
      functions: () async {

        final f_db.Query _query = RealQueryModel.createOfficialRealQuery(
          queryModel: realQueryModel,
          lastMap: startAfter,
        );

        final f_db.DatabaseEvent _event = await _query.once();

        _output = _OfficialFireMapper.getMapsFromDataSnapshot(
          snapshot: _event.snapshot,
          addDocID: true,
        );

      },
    );

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> readPathMap({
    @required String path,
  }) async {

    Map<String, dynamic> _output = {};

    await tryAndCatch(
      invoker: 'OfficialReal.readPathMap',
      timeout: timeout,
      onError: _onRealError,
      functions: () async {

        final f_db.DatabaseReference _ref = _getRefByPath(path: path);

        final f_db.DataSnapshot _snap = await _ref.get();

       _output = _OfficialFireMapper.getMapFromDataSnapshot(
          snapshot: _snap,
          addDocID: true,
        );

      },
    );

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<dynamic> readPath({
    /// looks like : 'collName/docName/...'
    @required String path,
  }) async {

    /// THIS METHOD DOES NOT ADD DOC ID

    dynamic _output;

    if (TextCheck.isEmpty(path) == false){

      final f_db.DatabaseReference _ref = _getRefByPath(path: path);

      await tryAndCatch(
        invoker: 'OfficialReal.readPath',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          final f_db.DatabaseEvent event = await _ref.once(f_db.DatabaseEventType.value);
          _output = event.snapshot.value;

        },
      );

    }

    if (_output is Map) {
      _output = Mapper.getMapFromIHLMOO(
        ihlmoo: _output,
      );
    }

    // blog('the readPath : ${_output.runtimeType} : $_output');

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> readDoc({
    @required String coll,
    @required String doc,
  }) async {

    final Map<String, dynamic> _map = await readPathMap(
        path: '$coll/$doc',
    );

    return _map;
  }
  // -----------------------------------------------------------------------------

  /// UPDATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> updateColl({
    @required String coll,
    @required Map<String, dynamic> map,
  }) async {
    Map<String, dynamic> _output;

    if (map != null){

      _output = await createColl(
        coll: coll,
        map: map,
      );

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> updateDoc({
    @required String coll,
    @required String doc,
    @required Map<String, dynamic> map,
  }) async {
    Map<String, dynamic> _output;

    if (map != null){

      _output = await createDoc(
        coll: coll,
        doc: doc,
        map: map,
      );

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> updateDocInPath({
    @required String path,
    @required Map<String, dynamic> map,
  }) async {
    Map<String, dynamic> _output;

    if (path != null && map != null){

      final String _pathWithoutDocName = TextMod.removeTextAfterLastSpecialCharacter(path, '/');
      final String _docName = TextMod.removeTextBeforeLastSpecialCharacter(path, '/');

      if (
          TextCheck.isEmpty(_pathWithoutDocName) == false
          &&
          TextCheck.isEmpty(_docName) == false
      ){

        _output = await createDocInPath(
          pathWithoutDocName: _pathWithoutDocName,
          doc: _docName,
          map: map,
        );

      }

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> updateDocField({
    @required String coll,
    @required String doc,
    @required String field,
    @required dynamic value,
  }) async {

    if (value != null && coll != null && doc != null && field != null){

      final f_db.DatabaseReference _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
        key: field,
      );

      await tryAndCatch(
          invoker: 'OfficialReal.updateDocField',
          timeout: timeout,
          onError: _onRealError,
          functions: () async {
            await _ref.set(value).then((_) {}).catchError((error) {
              _onRealError(error);
            });
          }
          );
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> incrementDocFields({
    @required String coll,
    @required String doc,
    @required Map<String, int> incrementationMap,
    @required bool isIncrementing,
  }) async {

    if (incrementationMap != null){

      final f_db.DatabaseReference _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
      );

      final Map<String, dynamic> _updatesMap = _OfficialFireMapper.createPathValueMapFromIncrementationMap(
        incrementationMap: incrementationMap,
        isIncrementing: isIncrementing,
      );

      await tryAndCatch(
        invoker: 'incrementDocFields',
        onError: _onRealError,
        functions: () async {

          await _ref.update(_updatesMap);

        },
      );

    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> incrementPathFields({
    @required String path,
    @required Map<String, int> incrementationMap,
    @required bool isIncrementing,
  }) async {

    if (incrementationMap != null){

      final f_db.DatabaseReference _ref = _getRefByPath(
        path: path,
      );

      final Map<String, dynamic> _updatesMap = _OfficialFireMapper.createPathValueMapFromIncrementationMap(
        incrementationMap: incrementationMap,
        isIncrementing: isIncrementing,
      );

      await tryAndCatch(
        invoker: 'incrementPathFields',
        onError: _onRealError,
        functions: () async {

          await _ref.update(_updatesMap);

        },
      );

    }

  }
  // -----------------------------------------------------------------------------

  /// DELETE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteDoc({
    @required String coll,
    @required String doc,
  }) async {

    final f_db.DatabaseReference _ref = _createPathAndGetRef(
      coll: coll,
      doc: doc,
    );

    await tryAndCatch(
      invoker: 'OfficialReal.deleteDoc',
      timeout: timeout,
      onError: _onRealError,
      functions: () async {

        await _ref.remove();

      },
    );

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteField({
    @required String coll,
    @required String doc,
    @required String field,
  }) async {

     if (coll != null && doc != null && field != null){

      final f_db.DatabaseReference _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
        key: field,
      );

      await tryAndCatch(
          invoker: 'OfficialReal.deleteField',
          timeout: timeout,
          onError: _onRealError,
          functions: () async {
            await _ref.set(null).then((_) {}).catchError((error) {
              // The write failed...
            });
          }
      );

     }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deletePath({
    @required String pathWithDocName,
  }) async {

    if (TextCheck.isEmpty(pathWithDocName) == false){

      final f_db.DatabaseReference _ref = _getRefByPath(
        path: pathWithDocName,
      );

      await tryAndCatch(
        invoker: 'OfficialReal.deletePath',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {
          await _ref.remove();
        },
      );

    }

  }
  // -----------------------------------------------------------------------------

  /// CLONE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> clonePath({
    @required String oldPath,
    @required String newPath,
  }) async {

    final Object _object = await readPath(path: oldPath);

    if (_object != null){

      final f_db.DatabaseReference _ref = _getRefByPath(
        path: newPath,
      );

      await tryAndCatch(
          invoker: 'OfficialReal.clonePath',
          timeout: timeout,
          onError: _onRealError,
          functions: () async {
            await _ref.set(_object);
          });
    }

  }
  // -----------------------------------------------------------------------------

}
