part of super_fire;

/// => TAMAM
class OfficialReal {
  // -----------------------------------------------------------------------------

  const OfficialReal();

  // -----------------------------------------------------------------------------
  static int timeout = 60;
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _onRealError({
    required String error,
    required String path,
    required String invoker,
  }) async {

    final bool _writeCancelled = TextCheck.stringContainsSubString(
      string: error,
      subString: 'write-cancelled',
    );
    final bool _writeCancelled2 = TextCheck.stringContainsSubString(
        string: error,
        subString: 'The write was canceled by the user',
    );

    if (_writeCancelled || _writeCancelled2){
      blog('_onRealError : $error');
    }
    else {

      final String? deviceID = await DeviceChecker.getDeviceID();
      final String? deviceName = await DeviceChecker.getDeviceName();
      final String? _email = OfficialAuthing.getAuthEmail();

      await Errorize.throwMap(
        invoker: 'onRealErrorThrowing.$invoker',
        map: {
          'userID': OfficialAuthing.getUserID(),
          'hasID': OfficialAuthing.userHasID(),
          'email': _email,
          'userLastSignIn': Timers.cipherTime(time: OfficialAuthing.getLastSignIn(), toJSON: false),
          'deviceID': deviceID,
          'deviceName': deviceName,
          'deviceOS': DeviceChecker.getDeviceOS(),
          'errorTime': Timers.cipherTime(time: DateTime.now(), toJSON: false),
          'errorInvoker': invoker,
          'realPath': path,
          'error': error,
        },
      );

      if (kIsWeb == false){
        final bool _shouldPurge = TextCheck.stringContainsSubString(
          string: error,
          subString: 'Timeout',
        );

        if (_shouldPurge == true){
          await _purge();
        }
      }

    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _purge() async {

    /// purgeOutstandingWrites is not supported for web
    if (kIsWeb == false){
      await tryAndCatch(
        functions: () async {
          await OfficialFirebase.getReal()?.purgeOutstandingWrites();
        },
        invoker: '_purge',
      );
    }
  }
  // -----------------------------------------------------------------------------
  static Future<void> goOnline() async {
    await OfficialFirebase.getReal()?.goOnline();
  }
  // --------------------
  static Future<void> goOffline() async {
    await OfficialFirebase.getReal()?.goOffline();
  }
  // -----------------------------------------------------------------------------

  /// REF

  // --------------------
  /// TESTED : WORKS PERFECT
  static f_db.DatabaseReference? _createPathAndGetRef({
    required String coll,
    String? doc,
    String? key,
  }){
    final String path = RealQueryModel.createRealPath(
      coll: coll,
      doc: doc,
      key: key,
    );
    return OfficialFirebase.getReal()?.ref(path);
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static f_db.DatabaseReference? _getRefByPath({
    required String path,
  }){
    return OfficialFirebase.getReal()?.ref(path);
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
  static Future<Map<String, dynamic>?> _createUnnamedDoc({
    required String? coll,
    required Map<String, dynamic>? map,
  }) async {

    Map<String, dynamic>? _output;

    if (map != null && coll != null){

      await tryAndCatch(
        invoker: 'OfficialReal._createUnnamedDoc',
        timeout: timeout,
        onError: (String error) => _onRealError(
          error: error,
          path: coll,
          invoker: 'OfficialReal._createUnnamedDoc',
        ),
        functions: () async {

          final f_db.DatabaseReference? _ref = _createPathAndGetRef(coll: coll,)?.push();

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

      final f_db.DatabaseReference? _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
      );

      await tryAndCatch(
        invoker: 'OfficialReal._createNamedDoc',
        timeout: timeout,
        onError: (String error) => _onRealError(
          error: error,
          path: '$coll/$doc',
          invoker: 'OfficialReal._createNamedDoc',
        ),
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
    required String? pathWithoutDocName,
    required Map<String, dynamic>? map,
    String? doc,
  }) async {

    Map<String, dynamic>? _output;

    if (map != null && pathWithoutDocName != null) {
      String? _docID;

      final bool _isDocNamed = doc != null;
      final String _path = _isDocNamed ? '$pathWithoutDocName/$doc' : pathWithoutDocName;

      await tryAndCatch(
        invoker: 'OfficialReal.createDocInPath',
        timeout: timeout,
        onError: (String error) => _onRealError(
          error: error,
          path: _path,
          invoker: 'OfficialReal.createDocInPath',
        ),
        functions: () async {


          /// GET PATH
          f_db.DatabaseReference? _ref = _getRefByPath(
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
        invoker: 'OfficialReal.createColl',
        timeout: timeout,
        onError: (String error) => _onRealError(
          error: error,
          path: coll,
          invoker: 'OfficialReal.createColl',
        ),
        functions: () async {

          final f_db.DatabaseReference? _ref = _createPathAndGetRef(
            coll: coll,
          );

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
      invoker: 'OfficialReal.readPathMaps',
      timeout: timeout,
      onError: (String error) => _onRealError(
        error: error,
        path: realQueryModel?.path ?? '',
        invoker: 'OfficialReal.readPathMaps',
      ),
      functions: () async {

        final f_db.Query? _query = OfficialModelling.createOfficialRealQuery(
          queryModel: realQueryModel,
          lastMap: startAfter,
        );

        final f_db.DatabaseEvent? _event = await _query?.once();

        final f_db.DataSnapshot? snap = _event?.snapshot;

        if (snap != null) {
          _output = _OfficialFireMapper.getMapsFromDataSnapshot(
            snapshot: snap,
            addDocID: true,
          )!;
        }
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
      invoker: 'OfficialReal.readPathMap',
      timeout: timeout,
      onError: (String error) => _onRealError(
        error: error,
        path: path,
        invoker: 'OfficialReal.readPathMap',
      ),
      functions: () async {

        final f_db.DatabaseReference? _ref = _getRefByPath(path: path);

        final f_db.DataSnapshot? _snap = await _ref?.get();

        if (_snap != null){
         _output = _OfficialFireMapper.getMapFromDataSnapshot(
            snapshot: _snap,
            addDocID: true,
          );
        }

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

      final f_db.DatabaseReference? _ref = _getRefByPath(path: path);

      await tryAndCatch(
        invoker: 'OfficialReal.readPath',
        timeout: timeout,
        onError: (String error) => _onRealError(
          error: error,
          path: path,
          invoker: 'OfficialReal.readPath',
        ),
        functions: () async {

          final f_db.DatabaseEvent? event = await _ref?.once(
          // f_db.DatabaseEventType.value,
          );

          _output = event?.snapshot.value;

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
    required String? path,
    required Map<String, dynamic>? map,
  }) async {
    Map<String, dynamic>? _output;

    if (path != null && map != null){

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
  static Future<bool> updateDocField({
    required String? coll,
    required String? doc,
    required String? field,
    required dynamic value,
  }) async {
    bool _success = false;

    if (value != null && coll != null && doc != null && field != null){

      final f_db.DatabaseReference? _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
        key: field,
      );

      await tryAndCatch(
          invoker: 'OfficialReal.updateDocField',
          timeout: timeout,
          onError: (String error) => _onRealError(
            error: error,
            path: Pathing.fixPathFormatting('$coll/$doc/$field')!,
            invoker: 'OfficialReal.updateDocField',
          ),
          functions: () async {

            await _ref?.set(value);
            _success = true;
            //     .then((_) {}).catchError((error) {
            //   _onRealError(error);
            // })
            // ;
          }
          );
    }

    return _success;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> incrementDocFields({
    required String coll,
    required String doc,
    required Map<String, int>? incrementationMap,
    required bool isIncrementing,
  }) async {
    bool _success = false;

    if (incrementationMap != null){

      final f_db.DatabaseReference? _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
      );

      final Map<String, dynamic>? _updatesMap = _OfficialFireMapper.createPathValueMapFromIncrementationMap(
        incrementationMap: incrementationMap,
        isIncrementing: isIncrementing,
      );

      await tryAndCatch(
        invoker: 'incrementDocFields',
        onError: (String error) => _onRealError(
            error: error,
            path: '$coll/$doc',
            invoker: 'OfficialReal.incrementDocFields',
        ),
        functions: () async {

          if (_updatesMap != null && _ref != null){
            await _ref.update(_updatesMap);
            _success = true;
          }

        },
      );

    }

    return _success;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> incrementPathFields({
    required String path,
    required Map<String, int>? incrementationMap,
    required bool isIncrementing,
  }) async {
    bool _success = false;

    if (incrementationMap != null){

      final f_db.DatabaseReference? _ref = _getRefByPath(
        path: path,
      );

      final Map<String, dynamic>? _updatesMap = _OfficialFireMapper.createPathValueMapFromIncrementationMap(
        incrementationMap: incrementationMap,
        isIncrementing: isIncrementing,
      );

      await tryAndCatch(
        invoker: 'incrementPathFields',
        onError: (String error) => _onRealError(
          error: error,
          path: path,
          invoker: 'OfficialReal.incrementPathFields',
        ),
        functions: () async {

          if (_ref != null && _updatesMap != null){
            await _ref.update(_updatesMap);
            _success = true;
          }

        },
      );

    }

    return _success;
  }
  // -----------------------------------------------------------------------------

  /// DELETE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> deleteDoc({
    required String coll,
    required String doc,
  }) async {
    bool _success = false;

    final f_db.DatabaseReference? _ref = _createPathAndGetRef(
      coll: coll,
      doc: doc,
    );

    await tryAndCatch(
      invoker: 'OfficialReal.deleteDoc',
      timeout: timeout,
      onError: (String error) => _onRealError(
        error: error,
        path: '$coll/$doc',
        invoker: 'OfficialReal.deleteDoc',
      ),
      functions: () async {

        await _ref?.remove();
        _success = true;

      },
    );

    return _success;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> deleteField({
    required String? coll,
    required String? doc,
    required String? field,
  }) async {
    bool _success = false;

     if (coll != null && doc != null && field != null){

      final f_db.DatabaseReference? _ref = _createPathAndGetRef(
        coll: coll,
        doc: doc,
        key: field,
      );

      await tryAndCatch(
          invoker: 'OfficialReal.deleteField',
          timeout: timeout,
          onError: (String error) => _onRealError(
            error: error,
            path: '$coll/$doc/$field',
            invoker: 'OfficialReal.deleteField',
          ),
          functions: () async {
            await _ref?.set(null).then((_) {
              _success = true;
            }).catchError((error) {
              _success = false;
              // The write failed...
            });
          }
      );

     }

     return _success;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> deletePath({
    required String? pathWithDocName,
  }) async {
    bool _success = false;

    if (TextCheck.isEmpty(pathWithDocName) == false){

      final f_db.DatabaseReference? _ref = _getRefByPath(
        path: pathWithDocName!,
      );

      await tryAndCatch(
        invoker: 'OfficialReal.deletePath',
        timeout: timeout,
        onError: (String error) => _onRealError(
          error: error,
          path: pathWithDocName,
          invoker: 'OfficialReal.deletePath',
        ),
        functions: () async {
          await _ref?.remove();
          _success = true;
        },
      );

    }

    return _success;
  }
  // -----------------------------------------------------------------------------

  /// CLONE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> clonePath({
    required String oldPath,
    required String newPath,
  }) async {
    bool _success = false;

    final Object? _object = await readPath(path: oldPath);

    if (_object != null){

      final f_db.DatabaseReference? _ref = _getRefByPath(
        path: newPath,
      );

      await tryAndCatch(
          invoker: 'OfficialReal.clonePath',
          timeout: timeout,
          onError: (String error) => _onRealError(
            error: error,
            path: newPath,
            invoker: 'OfficialReal.clonePath',
          ),
          functions: () async {
            await _ref?.set(_object);
            _success = true;
          });
    }

    return _success;
  }
  // -----------------------------------------------------------------------------

}
