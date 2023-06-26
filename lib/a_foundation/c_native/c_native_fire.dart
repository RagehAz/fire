part of super_fire;

///
class _NativeFire {
  // -----------------------------------------------------------------------------

  const _NativeFire();

  // -----------------------------------------------------------------------------

  /// REFERENCE

  // --------------------
  /// TESTED : WORKS PERFECT
  static fd.CollectionReference? _getCollRef({
    required String coll,
    String? doc,
    String? subColl,
  }) {

    assert(
    (doc == null && subColl == null) || (doc != null && subColl != null),
    'doc & subColl should both be null or both have values'
    );

   if (doc == null || subColl == null){
      return _NativeFirebase.getFire()?.collection(coll);
    }
    else {
      /// return NativeFirebase.getFire().collection('$coll/$doc/$subColl');
      return _NativeFirebase.getFire()?.collection(coll)
          .document(doc)
          .collection(subColl);
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static fd.DocumentReference? _getDocRef({
    required String coll,
    String? doc,
    String? subColl,
    String? subDoc,
  }){

    final bool _isSubDoc = subColl != null && subDoc != null;

    /// IS DOC REF
    if (_isSubDoc == false){
      /// return NativeFirebase.getFire().document('$coll/$doc');
      return _getCollRef(coll: coll)?.document(doc!);
    }

    /// IS SUB DOC REF
    else {
      /// return NativeFirebase.getFire().document('$coll/$doc/$subColl/$subDoc');
      return _getCollRef(coll: coll)
          ?.document(doc!)
          .collection(subColl!)
          .document(subDoc!);
    }


  }
  // -----------------------------------------------------------------------------

  /// CREATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<String?> createDoc({
    required Map<String, dynamic>? input,
    required String coll,
    String? doc,
    String? subColl,
    String? subDoc,
  }) async {

    /// NOTE : creates firestore doc with auto generated ID then returns doc reference

    String? _docID;

    if (input != null){

      final bool _isCreatingSubDoc = subColl != null;

      fd.DocumentReference? _docRef;

      /// CREATING DOC
      if (_isCreatingSubDoc == false) {
        _docRef = _getDocRef(
          coll: coll,
          doc: doc ?? Numeric.createUniqueID().toString(),
        );
      }

      /// CREATING SUB DOC
      else {
        assert(doc != null, 'doc is null');
        _docRef = _getDocRef(
          coll: coll,
          doc: doc,
          subColl: subColl,
          subDoc: subDoc ?? Numeric.createUniqueID().toString(),
        );
      }

      final Map<String, dynamic> _map = Mapper.insertPairInMap(
        map: input,
        key: 'id',
        value: _docRef?.id,
        overrideExisting: true,
      );

      await _setData(
        invoker: 'NativeFire.createDoc',
        input: _map,
        ref: _docRef,
        onSuccess: (){
          _docID = _docRef?.id;
          },
      );

    }

    return _docID;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<String>> createDocs({
    required List<Map<String, dynamic>>? inputs,
    required String coll,
    String? doc,
    String? subColl,
    String? subDoc,
  }) async {
    final List<String> _output = <String>[];

    /// NOTE : THIS HAS TO BE DONE ONE BY ONE TO GENERATE DIFFERENT IDS

    if (Mapper.checkCanLoopList(inputs) == true) {
      for (final Map<String, dynamic> map in inputs!) {
        final String? _docID = await createDoc(
          input: map,
          coll: coll,
          doc: doc,
          subColl: subColl,
          subDoc: subDoc,
        );

        if (_docID != null) {
          _output.add(_docID);
        }
      }
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _setData({
    required fd.DocumentReference? ref,
    required Map<String, dynamic>? input,
    required String invoker,
    Function? onSuccess,
    Function(String? error)? onError,
  }) async {

    final Map<String, dynamic>? _upload = Mapper.cleanNullPairs(
      map: input,
    );

    if (_upload != null) {

      await tryAndCatch(
        invoker: invoker,
        onError: onError,
        functions: () async {

          await ref?.set(_upload);

          if (onSuccess != null) {
            onSuccess();
          }

          blog('$invoker.setData : CREATED ${_upload.keys.length} keys in : ${ref?.path}');

        },
      );

    }

  }
  // -----------------------------------------------------------------------------

  /// READ

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>?> readDoc({
    required String coll,
    required String doc,
    String? subColl,
    String? subDoc,
  }) async {
    Map<String, dynamic>? _output;

    await tryAndCatch(
        invoker: 'NativeFire.readDoc',
        functions: () async {

          final fd.DocumentReference? _docRef = _getDocRef(
            coll: coll,
            doc: doc,
            subColl: subColl,
            subDoc: subDoc,
          );

          final fd.Document? _document = await _docRef?.get();
          _output = _document?.map;

          _output = Mapper.insertPairInMap(
            map: _document?.map,
            key: 'id',
            value: _document?.id,
            overrideExisting: true,
          );

        });

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<Map<String, dynamic>>> readCollDocs({
    required String coll,
    required List<String>? ids,
    String? doc,
    String? subColl,
  }) async {
    final List<Map<String, dynamic>> _output = [];

    /// READING SUB DOCS
    if (Mapper.checkCanLoopList(ids) == true && subColl != null){

      await Future.wait(<Future>[

        ...List.generate(ids!.length, (index){

          return readDoc(
            coll: coll,
            doc: doc!,
            subColl: subColl,
            subDoc: ids[index],
          ).then((Map<String, dynamic>? map){

            if (map != null){
              _output.add(map);
            }

          });

        }),

      ]);

    }

    /// READING DOCS
    else {

      await Future.wait(<Future>[

        ...List.generate(ids!.length, (index){

          return readDoc(
            coll: coll,
            doc: ids[index],
          ).then((Map<String, dynamic>? map){

            if (map != null){
              _output.add(map);
            }

          });
        }),

      ]);

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<Map<String, dynamic>>> readColl({
    required FireQueryModel queryModel,
    dynamic startAfter,
  }) async {
    List<Map<String, dynamic>> _output = <Map<String, dynamic>>[];

    await tryAndCatch(
        invoker: 'NativeFire.readColl',
        functions: () async {

          final fd.QueryReference? query = _createCollQuery(
            collRef: _getCollRef(
              coll: queryModel.coll,
              doc: queryModel.doc,
              subColl: queryModel.subColl,
            ),
            orderBy: queryModel.orderBy,
            limit: queryModel.limit,
            startAfter: startAfter,
            finders: queryModel.finders,
          );

          final List<fd.Document>? _page = await query?.get();

          _output = _NativeFireMapper.getMapsFromNativePage(
            page: _page,
            addDocsIDs: true,
          );

        });

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<Map<String, dynamic>>> readAllColl({
    required String coll,
    String? doc,
    String? subColl,
  }) async {

    List<Map<String, dynamic>> _output = [];

    await tryAndCatch(
      invoker: 'NativeFire.readAllColl',
      functions: () async {

        final fd.CollectionReference? _collRef = _getCollRef(
          coll: coll,
          doc: doc,
          subColl: subColl,
        );

        if (_collRef != null) {

          final fd.Page<fd.Document>? _page = await _collRef.get(
              // pageSize: ,
              // nextPageToken: ,
              );

          _output = _NativeFireMapper.getMapsFromNativePage(
            page: _page,
            addDocsIDs: true,
          );

        }
      },

    );

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static fd.QueryReference? _createCollQuery({
    required fd.CollectionReference? collRef,
    QueryOrderBy? orderBy,
    int? limit,
    dynamic startAfter,
    List<FireFinder>? finders,
  }){
    fd.QueryReference? query;

    if (collRef != null){

      query = _NativeFirebase.getFire()?.collection(collRef.path).where(
          collRef.path,
          // isNull: false,
      );

      if (query != null) {

        /// ASSIGN SEARCH FINDERS
        if (Mapper.checkCanLoopList(finders) == true) {
          query = FireFinder.createNativeCompositeQueryByFinders(query: query, finders: finders);
        }

        /// ORDER BY A FIELD NAME
        if (orderBy != null) {
          query = query!.orderBy(orderBy.fieldName, descending: orderBy.descending);
        }

        /// LIMIT NUMBER OR RESULTS
        if (limit != null) {
          query = query!.limit(limit);
        }

        /// START AFTER A SPECIFIC SNAPSHOT
        if (startAfter != null) {
          assert(startAfter == null, 'Native Fire Implementation does not support startAfter');
          // query = query.startAfterDocument(startAfter);
        }


      }
    }

    return query;
  }
  // -----------------------------------------------------------------------------

  /// STREAMING

  // --------------------
  /// TASK : TEST ME
  static Stream<List<Map<String, dynamic>>>? streamColl({
    required FireQueryModel queryModel,
  }) {

    final fd.CollectionReference? _collRef = _getCollRef(
      coll: queryModel.coll,
      doc: queryModel.doc,
      subColl: queryModel.subColl,
    );

    return _collRef?.stream.map(_NativeFireMapper.mapDocs);
  }
  // --------------------
  /// TASK : TEST ME
  static Stream<Map<String, dynamic>?>? streamDoc({
    required String coll,
    required String doc,
    String? subColl,
    String? subDoc,
  }) {

    final fd.DocumentReference? _docRef = _getDocRef(
      coll: coll,
      doc: doc,
      subColl: subColl,
      subDoc: subDoc,
    );

    return _docRef?.stream.map(_NativeFireMapper.mapDoc);

  }
  // -----------------------------------------------------------------------------

  /// UPDATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> updateDoc({
    required Map<String, dynamic>? input,
    required String coll,
    required String doc,
    String? subColl,
    String? subDoc,
  }) async {

    await createDoc(
      coll: coll,
      doc: doc,
      subColl: subColl,
      subDoc: subDoc,
      input: input,
    );

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> updateDocField({
    required dynamic input,
    required String field,
    required String coll,
    required String doc,
    String? subColl,
    String? subDoc,
  }) async {

    // NOTES
    /// this updates a field if exists,
    /// if absent it creates a new field and inserts the value

    if (input != null){

      final fd.DocumentReference? _docRef = _getDocRef(
        coll: coll,
        doc: doc,
        subColl: subColl,
        subDoc: subDoc,
      );

      await _updateData(
        ref: _docRef,
        invoker: 'NativeFire.updateDocField',
        input: <String, dynamic>{field: input},
      );

    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _updateData({
    required fd.DocumentReference? ref,
    required Map<String, dynamic>? input,
    required String invoker,
    Function? onSuccess,
  }) async {

      final Map<String, dynamic>? _upload = Mapper.cleanNullPairs(
        map: input,
      );

      if (_upload != null){

        await tryAndCatch(
          invoker: invoker,
          functions: () async {

            // final SetOptions options = SetOptions(
            //   merge: true,
            //   mergeFields: <Object>[],
            // );

            await ref?.update(_upload);

            if (onSuccess != null){
              onSuccess();
            }

            blog('$invoker.updateData : UPDATED ${_upload.keys.length} keys in : ${ref?.path}');

          },
          // onError: (){},
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
    String? subColl,
    String? subDoc,
  }) async {
    await tryAndCatch(
        invoker: 'NativeFire.deleteDoc',
        functions: () async {

          final fd.DocumentReference? _docRef = _getDocRef(
            coll: coll,
            doc: doc,
            subColl: subColl,
            subDoc: subDoc,
          );

          await _docRef?.delete();

          blog('deleteDoc : deleted : $coll : $doc : $subColl : $subDoc');
        });
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteDocField({
    required String coll,
    required String doc,
    required String field,
    String? subColl,
    String? subDoc,
  }) async {

    final Map<String, dynamic>? _current = await readDoc(
      coll: coll,
      doc: doc,
      subColl: subColl,
      subDoc: subDoc,
    );

    if (_current != null){

      final Map<String, dynamic> _updated = Mapper.removePair(
          map: _current,
          fieldKey: field,
      );

      await updateDoc(
        coll: coll,
        doc: doc,
        subColl: subColl,
        subDoc: subDoc,
        input: _updated,
      );

    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteColl({
    required String coll,
    String? doc,
    String? subColl,
    Function(String? subDocID)? onDeleteDoc,
    int numberOfIterations = 1000,
    int numberOfReadsPerIteration = 5,
  }) async {

    /// PLAN : THIS SHOULD BE A CLOUD FUNCTION INSTEAD OF THIS BULLSHIT
    /// does the same deletion algorithm with [deleteAllCollectionDocs]

    for (int i = 0; i < numberOfIterations; i++){

        final List<Map<String, dynamic>> _maps = await readColl(
          queryModel: FireQueryModel(
            coll: coll,
            doc: doc,
            subColl: subColl,
            limit: numberOfReadsPerIteration,
          ),
        );

        if (_maps.isEmpty){
          break;
        }

        else {

          final List<String> _docIDs = Mapper.getMapsPrimaryKeysValues(
            maps: _maps,
            // primaryKey: 'id',
          );

          Stringer.blogStrings(strings: _docIDs, invoker: 'NativeFire.deleteColl : _docIDs ');

          await deleteDocs(
            coll: coll,
            doc: doc,
            subColl: subColl,
            docsIDs: _docIDs,
            onDeleteDoc: onDeleteDoc,
          );

        }

      }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteDocs({
    required String coll,
    required List<String> docsIDs,
    String? doc,
    String? subColl,
    Function(String? subDocID)? onDeleteDoc
  }) async {

    /// PLAN : THIS SHOULD BE A CLOUD FUNCTION INSTEAD OF THIS BULLSHIT

    if (Mapper.checkCanLoopList(docsIDs) == true){

      blog('deleteDocs : ids are : $docsIDs');

      final bool _isDeletingSubDocs = subColl != null && doc != null;

      for (final String docID in docsIDs){

        await Future.wait(<Future>[

          /// DELETING DOC
          if (_isDeletingSubDocs == false)
          deleteDoc(
            coll: coll,
            doc: docID,
          ),

          /// DELETING SUB DOC
          if (_isDeletingSubDocs == true)
          deleteDoc(
            coll: coll,
            doc: doc!,
            subColl: subColl,
            subDoc: docID,
          ),

          if (onDeleteDoc != null)
            onDeleteDoc(docID),

        ]);

      }

    }

  }
  // -----------------------------------------------------------------------------
}
