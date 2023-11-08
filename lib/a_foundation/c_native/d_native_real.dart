part of super_fire;

/// => TAMAM
class _NativeReal {
  // -----------------------------------------------------------------------------

  const _NativeReal();

  // -----------------------------------------------------------------------------
  static int timeout = 30;
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
    await _NativeFirebase.getReal()?.purgeOutstandingWrites();
  }
  // -----------------------------------------------------------------------------
  static Future<void> goOnline() async {
    await _NativeFirebase.getReal()?.goOnline();
  }
  // --------------------
  static Future<void> goOffline() async {
    await _NativeFirebase.getReal()?.goOffline();
  }
  // -----------------------------------------------------------------------------

  /// REF

  // --------------------
  /// TESTED : WORKS PERFECT
  static f_d.DatabaseReference? _createPathAndGetRef({
    required String coll,
    String? doc,
    String? key,
  }){
    final String path = RealQueryModel.createRealPath(
      coll: coll,
      doc: doc,
      key: key,
    );
    return _NativeFirebase.getReal()?.reference().child(path);
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static f_d.DatabaseReference? _getRefByPath({
    required String path,
  }){
    return _NativeFirebase.getReal()?.reference().child(path);
  }
  // -----------------------------------------------------------------------------

  /// CREATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>?> createDoc({
    required String coll,
    required Map<String, dynamic>? map,
    String? doc,
  }) async {

    Map<String, dynamic>? _output;

   if (doc == null){
     _output = await _createUnNamedDoc(
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
  static Future<Map<String, dynamic>?> _createUnNamedDoc({
    required String? coll,
    required Map<String, dynamic>? map,
  }) async {

    Map<String, dynamic>? _output;

    if (map != null && coll != null){

      await tryAndCatch(
        invoker: 'NativeReal._createUnNamedDoc',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          final f_d.DatabaseReference? _ref = _createPathAndGetRef(coll: coll,)?.push();

          final String? _docID = _ref?.key;

          await _ref?.set(Mapper.removePair(
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
  static Future<Map<String, dynamic>?> _createNamedDoc({
    required String coll,
    required String doc,
    required Map<String, dynamic>? map,
  }) async {
    Map<String, dynamic>? _uploaded;

    if (map != null) {

      final f_d.DatabaseReference? _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
      );

      await tryAndCatch(
        invoker: 'NativeReal._createNamedDoc',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          await _ref?.set(Mapper.removePair(
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
  static Future<Map<String, dynamic>?> createDocInPath({
    required String pathWithoutDocName,
    required Map<String, dynamic>? map,
    String? doc,
  }) async {

    Map<String, dynamic>? _output;

    if (map != null) {

      String? _docID;

      await tryAndCatch(
        invoker: 'NativeReal.createDocInPath',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          final bool _isDocNamed = doc != null;
          final String _path = _isDocNamed ? '$pathWithoutDocName/$doc' : pathWithoutDocName;

          /// GET PATH
          f_d.DatabaseReference? _ref = _getRefByPath(
            path: _path,
          );

          if (doc == null) {
            _ref = _ref?.push();
            _docID = _ref?.key;
          }
          else {
            _docID = doc;
          }

          /// CREATE
          await _ref?.set(Mapper.removePair(
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
  static Future<Map<String, dynamic>?> createColl({
    required String? coll,
    required Map<String, dynamic>? map,
  }) async {
    Map<String, dynamic>? _output;

    if (map != null && coll != null) {

      await tryAndCatch(
        invoker: 'NativeReal.createColl',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          final f_d.DatabaseReference? _ref = _createPathAndGetRef(
            coll: coll,
          );

          blog('NativeReal.createColl $_ref');

          await _ref?.set(Mapper.removePair(
            map: map,
            fieldKey: 'id',
          ));

          _output = Mapper.insertPairInMap(
            map: map,
            key: 'id',
            value: coll,
            overrideExisting: true,
          );

          blog('NativeReal.createColl DONE : $_output');

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
    required RealQueryModel? realQueryModel,
    Map<String, dynamic>? startAfter,
  }) async {

    List<Map<String, dynamic>> _output = <Map<String, dynamic>>[];

    await tryAndCatch(
      invoker: 'NativeReal.readPathMaps',
      timeout: timeout,
      onError: _onRealError,
      functions: () async {

        final f_d.Query? _query = RealQueryModel.createNativeRealQuery(
          queryModel: realQueryModel,
          lastMap: startAfter,
        );

        final f_d.DataSnapshot? _dataSnapshot = await _query?.once();

        _output = _NativeFireMapper.getMapsFromDataSnapshot(
          snapshot: _dataSnapshot,
        );

      },
    );

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>?> readPathMap({
    required String path,
  }) async {

    Map<String, dynamic>? _output = {};

    await tryAndCatch(
      invoker: 'NativeReal.readPathMap',
      timeout: timeout,
      onError: _onRealError,
      functions: () async {

        final f_d.DatabaseReference? _ref = _getRefByPath(path: path);

        final f_d.DataSnapshot? _snap = await _ref?.once();

        _output = _NativeFireMapper.getMapFromDataSnapshot(
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
    required String path,
  }) async {

    /// THIS METHOD DOES NOT ADD DOC ID

    dynamic _output;

    if (TextCheck.isEmpty(path) == false){

      final f_d.DatabaseReference? _ref = _getRefByPath(path: path);

      await tryAndCatch(
        invoker: 'NativeReal.readPath',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {

          final f_d.DataSnapshot? snapshot = await _ref?.once();

          _output = snapshot?.value;

        },
      );

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>?> readDoc({
    required String coll,
    required String doc,
  }) async {

    final Map<String, dynamic>? _map = await readPathMap(
        path: '$coll/$doc',
    );

    return _map;
  }
  // -----------------------------------------------------------------------------

  /// UPDATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>?> updateColl({
    required String coll,
    required Map<String, dynamic>? map,
  }) async {
    Map<String, dynamic>? _output;

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
  static Future<Map<String, dynamic>?> updateDoc({
    required String coll,
    required String doc,
    required Map<String, dynamic>? map,
  }) async {
    Map<String, dynamic>? _output;

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
  static Future<Map<String, dynamic>?> updateDocInPath({
    required String path,
    required Map<String, dynamic>? map,
  }) async {
    Map<String, dynamic>? _output;

    if (map != null){

      final String? _pathWithoutDocName = TextMod.removeTextAfterLastSpecialCharacter(
        text: path,
        specialCharacter: '/',
      );
      final String? _docName = TextMod.removeTextBeforeLastSpecialCharacter(
          text: path,
          specialCharacter: '/',
      );

      if (
          TextCheck.isEmpty(_pathWithoutDocName) == false
          &&
          TextCheck.isEmpty(_docName) == false
      ){

        _output = await createDocInPath(
          pathWithoutDocName: _pathWithoutDocName!,
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
    required String? coll,
    required String? doc,
    required String? field,
    required dynamic value,
  }) async {

    if (value != null && coll != null && doc != null && field != null){

      final f_d.DatabaseReference? _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
        key: field,
      );

      await tryAndCatch(
          invoker: 'NativeReal.updateDocField',
          timeout: timeout,
          onError: _onRealError,
          functions: () async {
            await _ref?.set(value).then((_) {}).catchError((error) {

              blog('NativeReal.updateDocField : '
                  'value : $value : '
                  'type : ${value.runtimeType} : '
                  'error : $error'
              );

              _onRealError(error.toString());

            });
          });
    }
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> incrementDocFields({
    required String coll,
    required String doc,
    required Map<String, int>? incrementationMap,
    required bool isIncrementing,
  }) async {

    if (incrementationMap != null){

      final Map<String, dynamic>? _map = await readDoc(
        coll: coll,
        doc: doc,
      );

      final Map<String, dynamic> _updatesMap = _NativeFireMapper.incrementFields(
        baseMap: _map,
        incrementationMap: incrementationMap,
        isIncrementing: isIncrementing,
      );

      await updateDoc(
          coll: coll,
          doc: doc,
          map: _updatesMap,
      );

    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> incrementPathFields({
    required String path,
    required Map<String, int>? incrementationMap,
    required bool isIncrementing,
  }) async {

    if (incrementationMap != null){

      final Map<String, dynamic>? _map = await readPathMap(
        path: path,
      );

      final Map<String, dynamic> _updatesMap = _NativeFireMapper.incrementFields(
        baseMap: _map,
        incrementationMap: incrementationMap,
        isIncrementing: isIncrementing,
      );

      await updateDocInPath(
          path: path,
          map: _updatesMap,
      );

    }

  }
  // -----------------------------------------------------------------------------

  /// DELETE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteDoc({
    required String coll,
    required String doc,
  }) async {

    final f_d.DatabaseReference? _ref = _createPathAndGetRef(
      coll: coll,
      doc: doc,
    );

    await tryAndCatch(
      invoker: 'NativeReal.deleteDoc',
      timeout: timeout,
      onError: _onRealError,
      functions: () async {

        await _ref?.remove();

      },
    );

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteField({
    required String? coll,
    required String? doc,
    required String? field,
  }) async {

     if (coll != null && doc != null && field != null){

      final f_d.DatabaseReference? _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
        key: field,
      );

      await tryAndCatch(
          invoker: 'NativeReal.deleteField',
          timeout: timeout,
          onError: _onRealError,
          functions: () async {
            await _ref?.set(null).then((_) {}).catchError((error) {
              // The write failed...
            });
          }
      );

     }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deletePath({
    required String pathWithDocName,
  }) async {

    if (TextCheck.isEmpty(pathWithDocName) == false){

      final f_d.DatabaseReference? _ref = _getRefByPath(
        path: pathWithDocName,
      );

      await tryAndCatch(
        invoker: 'NativeReal.deletePath',
        timeout: timeout,
        onError: _onRealError,
        functions: () async {
          await _ref?.remove();
        },
      );

    }

  }
  // -----------------------------------------------------------------------------

  /// CLONE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> clonePath({
    required String oldPath,
    required String newPath,
  }) async {

    final Object? _object = await readPath(path: oldPath);

    if (_object != null){

      final f_d.DatabaseReference? _ref = _getRefByPath(
        path: newPath,
      );

      await tryAndCatch(
          invoker: 'NativeReal.clonePath',
          timeout: timeout,
          onError: _onRealError,
          functions: () async {
            await _ref?.set(_object);
          });
    }

  }
  // -----------------------------------------------------------------------------

}
