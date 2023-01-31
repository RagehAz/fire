part of fire;

/// => TAMAM
class Fire{
  // -----------------------------------------------------------------------------

  const Fire();

  // -----------------------------------------------------------------------------

  /// PATHS GETTERS

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> initializeFirestore({
    @required ValueNotifier<String> fireError,
    @required bool mounted,
  }) async {

    await tryAndCatch(
        functions: () async {

          // final FirebaseApp _firebaseApp =
          await Firebase.initializeApp();

          // blog('_firebaseApp.name : ${_firebaseApp.name}');
          // blog('_firebaseApp.isAutomaticDataCollectionEnabled : ${_firebaseApp.isAutomaticDataCollectionEnabled}');
          // blog('_firebaseApp.options :-');

          // Mapper.blogMap(_firebaseApp.options.asMap);

        },
        onError: (String error) {

          setNotifier(notifier: fireError, mounted: mounted, value: error);

        });

  }
  // -----------------------------------------------------------------------------

  /// PATHS GETTERS

  // --------------------
  /// TESTED : NOT USED
  /*
String pathOfDoc({
  @required String collName,
  @required String docName,
}) {
  return '$collName/$docName';
}
  // --------------------
String pathOfSubColl({
  @required String collName,
  @required String docName,
  @required String subCollName,
}) {
  return '$collName/$docName/$subCollName';
}
  // --------------------
String pathOfSubDoc({
  @required String collName,
  @required String docName,
  @required String subCollName,
  @required String subDocName,
}) {
  return '$collName/$docName/$subCollName/$subDocName';
}

 */
  // -----------------------------------------------------------------------------

  /// REFERENCES

  // --------------------
  /// TESTED : WORKS PERFECT
  static CollectionReference<Object> getSuperCollRef({
    @required String aCollName,
    String bDocName,
    String cSubCollName,
  }) {

    assert(
    (bDocName == null && cSubCollName == null) || (bDocName != null && cSubCollName != null),
    'bDocName & cSubCollName should both be null or both have values'
    );

    final FirebaseFirestore _fireInstance = FirebaseFirestore.instance;

    CollectionReference<Object> _ref = _fireInstance.collection(aCollName);

    if (bDocName != null && cSubCollName != null){
      _ref = _fireInstance
          .collection(aCollName)
          .doc(bDocName)
          .collection(cSubCollName);
    }

    return _ref;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static CollectionReference<Object> getCollectionRef(String collName) {
    return FirebaseFirestore.instance.collection(collName);
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static DocumentReference<Object> getDocRef({
    @required String collName,
    @required String docName,
  }) {

    /// or this syntax
    /// final DocumentReference<Object> _doc =
    /// FirebaseFirestore.instance
    ///     .collection(collName)
    ///     .doc(docName)

    return getCollectionRef(collName).doc(docName);
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static CollectionReference<Object> getSubCollectionRef({
    @required String collName,
    @required String docName,
    @required String subCollName,
  }) {

    /// or this syntax
    /// final CollectionReference<Object> _subCollection =
    /// FirebaseFirestore.instance
    ///     .collection(collName)
    ///     .doc(docName)
    ///     .collection(subCollName);

    return FirebaseFirestore.instance.collection('$collName/$docName/$subCollName');
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static DocumentReference<Object> getSubDocRef({
    @required String collName,
    @required String docName,
    @required String subCollName,
    @required String subDocName,
  }) {

    final CollectionReference<Object> _subCollection = FirebaseFirestore
        .instance
        .collection('$collName/$docName/$subCollName');

    /// or this syntax
    /// final DocumentReference<Object> _subDocRef =
    /// FirebaseFirestore.instance
    ///     .collection(collName)
    ///     .doc(docName)
    ///     .collection(subCollName)
    ///     .doc(subDocName);

    return _subCollection.doc(subDocName);
  }
  // -----------------------------------------------------------------------------

  /// QUERIES

  // --------------------
  /// TESTED : WORKS PERFECT
  static Query<Map<String, dynamic>> _superQuery({
    @required CollectionReference<Object> collRef,
    QueryOrderBy orderBy,
    int limit,
    QueryDocumentSnapshot<Object> startAfter,
    List<FireFinder> finders,
  }){

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(collRef.path);

    /// ASSIGN SEARCH FINDERS
    if (Mapper.checkCanLoopList(finders) == true){
      query = FireFinder.createCompositeQueryByFinders(
          query: query,
          finders: finders
      );
    }
    /// ORDER BY A FIELD NAME
    if (orderBy != null){
      query = query.orderBy(orderBy.fieldName, descending: orderBy.descending);
    }
    /// LIMIT NUMBER OR RESULTS
    if (limit != null){
      query = query.limit(limit);
    }
    /// START AFTER A SPECIFIC SNAPSHOT
    if (startAfter != null){
      query = query.startAfterDocument(startAfter);
    }

    return query;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<QuerySnapshot<Object>> _superCollectionQuery({
    @required CollectionReference<Object> collRef,
    QueryOrderBy orderBy,
    int limit,
    QueryDocumentSnapshot<Object> startAfter,
    List<FireFinder> finders,
  }) async {

    final Query<Map<String, dynamic>> query = _superQuery(
      collRef: collRef,
      orderBy: orderBy,
      limit: limit,
      startAfter: startAfter,
      finders: finders,
    );

    final QuerySnapshot<Object> _collectionSnapshot = await query.get();

    return _collectionSnapshot;
  }
  // -----------------------------------------------------------------------------

  /// BASICS

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _setData({
    @required DocumentReference<Object> ref,
    @required Map<String, dynamic> input,
    @required String invoker,
    Function onSuccess,
  }) async {

      final Map<String, dynamic> _upload = Mapper.cleanNullPairs(
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

              await ref.set(_upload);

              if (onSuccess != null){
                onSuccess();
              }

              blog('$invoker.setData : CREATED ${_upload.keys.length} keys in : ${ref.path}');

            },
        // onError: (){},
        );

      }

    }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _updateData({
    @required DocumentReference<Object> ref,
    @required Map<String, dynamic> input,
    @required String invoker,
    Function onSuccess,
  }) async {

      final Map<String, dynamic> _upload = Mapper.cleanNullPairs(
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

            await ref.update(_upload);

            if (onSuccess != null){
              onSuccess();
            }

            blog('$invoker.updateData : UPDATED ${_upload.keys.length} keys in : ${ref.path}');

          },
          // onError: (){},
        );




      }

    }
  // -----------------------------------------------------------------------------

  /// CREATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<DocumentReference<Object>> createDoc({
    @required String collName,
    @required Map<String, dynamic> input,
    ValueChanged<DocumentReference> onFinish,
    bool addDocID = false,
  }) async {

    /// NOTE : creates firestore doc with auto generated ID then returns doc reference

    DocumentReference<Object> _output;

    if (input != null){

      final CollectionReference<Object> _bzCollectionRef = getCollectionRef(collName);
      final DocumentReference<Object> _docRef = _bzCollectionRef.doc();

      if (addDocID == true) {
        Mapper.insertPairInMap(
          map: input,
          key: 'id',
          value: _docRef.id,
        );
      }

      await _setData(
          input: input,
          ref: _docRef,
          invoker: 'createDoc',
          onSuccess: (){
            _output = _docRef;
          }
      );

    }

    if (onFinish != null){
      onFinish(_output);
    }
    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<DocumentReference<Object>> createNamedDoc({
    @required String collName,
    @required String docName,
    @required Map<String, dynamic> input,
  }) async {
    DocumentReference<Object> _output;

    if (input != null){

      final DocumentReference<Object> _docRef = getDocRef(
        collName: collName,
        docName: docName,
      );

      await _setData(
          input: input,
          ref: _docRef,
          invoker: 'createNamedDoc',
          onSuccess: (){
            _output = _docRef;
          }
      );

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<DocumentReference<Object>> createSubDoc({
    @required String collName,
    @required String docName,
    @required String subCollName,
    @required Map<String, dynamic> input,
    ValueChanged<DocumentReference> onFinish,
  }) async {

    /// NOTE : creates firestore sub doc with auto ID
    /// creates a new sub doc and new sub collection if didn't exists
    /// and uses the same directory if existed to add a new doc
    /// updates the sub doc if existed
    /// and creates random name for sub doc if sub doc name is null

    final DocumentReference<Object> _subDocRef = await createNamedSubDoc(
      collName: collName,
      docName: docName,
      subCollName: subCollName,
      subDocName: null, /// to make it generate auto ID
      input: input,
    );

    if (onFinish != null){
      onFinish(_subDocRef);
    }

    return _subDocRef;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<DocumentReference<Object>> createNamedSubDoc({
    @required String collName,
    @required String docName,
    @required String subCollName,
    @required String subDocName,
    @required Map<String, dynamic> input,
  }) async {

    /// creates a new sub doc and new sub collection if didn't exists
    /// and uses the same directory if existed to add a new doc
    /// updates the sub doc if existed
    /// and creates random name for sub doc if sub doc name is null

    DocumentReference<Object> _output;

    if (input != null){

      final DocumentReference<Object> _ref = getSubDocRef(
        collName: collName,
        docName: docName,
        subCollName: subCollName,
        subDocName: subDocName,
      );

      await _setData(
          input: input,
          ref: _ref,
          invoker: 'createNamedSubDoc',
          onSuccess: (){
            _output = _ref;
          }
      );

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// READ

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<Map<String, dynamic>>> superCollPaginator({
    @required FireQueryModel queryModel,
    @required QueryDocumentSnapshot<Object> startAfter,
    bool addDocSnapshotToEachMap = false,
    bool addDocsIDs = false,
  }) async {

    List<Map<String, dynamic>> _maps = <Map<String,dynamic>>[];

    await tryAndCatch(
        invoker: 'superCollPaginator',
        functions: () async {

          final QuerySnapshot<Object> _collectionSnapshot = await _superCollectionQuery(
            collRef: queryModel.collRef,
            orderBy: queryModel.orderBy,
            limit: queryModel.limit,
            startAfter: startAfter,
            finders: queryModel.finders,
          );

          final List<QueryDocumentSnapshot<Object>> _queryDocumentSnapshots = _collectionSnapshot.docs;

          _maps = Mapper.getMapsFromQueryDocumentSnapshotsList(
              queryDocumentSnapshots: _queryDocumentSnapshots,
              addDocsIDs: addDocsIDs,
              addDocSnapshotToEachMap: addDocSnapshotToEachMap
          );

        });

    return _maps;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<Map<String, dynamic>>> readCollectionDocs({
    @required String collName,
    QueryOrderBy orderBy,
    int limit,
    QueryDocumentSnapshot<Object> startAfter,
    bool addDocSnapshotToEachMap = false,
    bool addDocsIDs = false,
    List<FireFinder> finders,
  }) async {

    List<Map<String, dynamic>> _maps = <Map<String,dynamic>>[];

    await tryAndCatch(
        invoker: 'readCollectionDocs',
        functions: () async {

          final CollectionReference<Object> _collRef = getCollectionRef(collName);

          final QuerySnapshot<Object> _collectionSnapshot = await _superCollectionQuery(
            collRef: _collRef,
            orderBy: orderBy,
            limit: limit,
            startAfter: startAfter,
            finders: finders,
          );

          final List<QueryDocumentSnapshot<Object>> _queryDocumentSnapshots = _collectionSnapshot.docs;

          _maps = Mapper.getMapsFromQueryDocumentSnapshotsList(
              queryDocumentSnapshots: _queryDocumentSnapshots,
              addDocsIDs: addDocsIDs,
              addDocSnapshotToEachMap: addDocSnapshotToEachMap
          );

        });

    return _maps;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<dynamic> _getMapByDocRef({
    @required DocumentReference<Object> docRef,
    @required bool addDocID,
    @required bool addDocSnapshot,
  }) async {
    dynamic _map;

    // await FirebaseFirestore.instance.disableNetwork();
    // await FirebaseFirestore.instance.enableNetwork();

    final DocumentSnapshot<Object> snapshot = await docRef.get();

    if (snapshot.exists == true) {
      _map = Mapper.getMapFromDocumentSnapshot(
        docSnapshot: snapshot,
        addDocSnapshot: addDocSnapshot,
        addDocID: addDocID,
      );
    }

    return _map;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, dynamic>> readDoc({
    @required String collName,
    @required String docName,
    bool addDocID = false,
    bool addDocSnapshot = false,
  }) async {


    Map<String, dynamic> _map; //QueryDocumentSnapshot

    final dynamic _result = await tryCatchAndReturnBool(
      invoker: 'readDoc',
      functions: () async {

        final DocumentReference<Object> _docRef = getDocRef(
          collName: collName,
          docName: docName,
        );
        // blog('readDoc() : _docRef : $_docRef');

        _map = await _getMapByDocRef(
          docRef: _docRef,
          addDocID: addDocID,
          addDocSnapshot: addDocSnapshot,
        );
        // blog('readDoc() : _map : $_map');
      },
    );

    // final String _found = _map == null ? 'NOT FOUND' : 'FOUND';
    // blog('readDoc() : reading doc : firestore/$collName/$docName : $_found');

    return _result.runtimeType == String ? null : _map;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<Map<String, dynamic>>> readSubCollectionDocs({
    @required String collName,
    @required String docName,
    @required String subCollName,
    int limit,
    QueryOrderBy orderBy,
    QueryDocumentSnapshot<Object> startAfter,
    bool addDocsIDs = false,
    bool addDocSnapshotToEachMap = false,
    List<FireFinder> finders,
  }) async {

    List<Map<String, dynamic>> _maps = <Map<String, dynamic>>[];

    await tryAndCatch(
        invoker: 'readSubCollectionDocs',
        functions: () async {

          final CollectionReference<Object> _subCollectionRef = getSubCollectionRef(
            collName: collName,
            docName: docName,
            subCollName: subCollName,
          );

          final QuerySnapshot<Object> _collectionSnapshot = await _superCollectionQuery(
            collRef: _subCollectionRef,
            orderBy: orderBy,
            limit: limit,
            startAfter: startAfter,
            finders: finders,
          );

          final List<QueryDocumentSnapshot<Object>> _queryDocumentSnapshots = _collectionSnapshot.docs;

          _maps =Mapper.getMapsFromQueryDocumentSnapshotsList(
              queryDocumentSnapshots: _queryDocumentSnapshots,
              addDocsIDs: addDocsIDs,
              addDocSnapshotToEachMap: addDocSnapshotToEachMap
          );

        }
    );

    return _maps;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<dynamic> readSubDoc({
    @required String collName,
    @required String docName,
    @required String subCollName,
    @required String subDocName,
    bool addDocSnapshot = false,
    bool addDocID = false,
  }) async {

    dynamic _map;

    await tryAndCatch(
        invoker: 'readSubDoc',
        functions: () async {

          final DocumentReference<Object> _subDocRef = getSubDocRef(
            collName: collName,
            docName: docName,
            subCollName: subCollName,
            subDocName: subDocName,
          );

          _map = await _getMapByDocRef(
            docRef: _subDocRef,
            addDocID: addDocID,
            addDocSnapshot: addDocSnapshot,
          );

        });

    return _map;
  }
  // -----------------------------------------------------------------------------

  /// STREAMING

  // --------------------
  /// TESTED : WORKS PERFECT
  static Stream<QuerySnapshot<Object>> streamCollection({
    @required FireQueryModel queryModel,
    QueryDocumentSnapshot<Object> startAfter,
  }) {

    final Query<Map<String, dynamic>> _query = _superQuery(
      collRef: queryModel.collRef,
      orderBy: queryModel.orderBy,
      startAfter: startAfter,
      limit: queryModel.limit,
      finders: queryModel.finders,
    );

    return _query.snapshots();
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Stream<QuerySnapshot<Object>> streamSubCollection({
    @required String collName,
    @required String docName,
    @required String subCollName,
    QueryOrderBy orderBy,
    QueryDocumentSnapshot<Object> startAfter,
    int limit,
    List<FireFinder> finders,
  }) {

    final CollectionReference<Object> _collRef = getSubCollectionRef(
      collName: collName,
      docName: docName,
      subCollName: subCollName,
    );

    final Query<Map<String, dynamic>> _query = _superQuery(
      collRef: _collRef,
      orderBy: orderBy,
      startAfter: startAfter,
      limit: limit,
      finders: finders,
    );

    return _query.snapshots();
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Stream<DocumentSnapshot<Object>> streamDoc({
    @required String collName,
    @required String docName,
  }) {

    final DocumentReference<Object> _docRef = getDocRef(
      collName: collName,
      docName: docName,
    );

    return _docRef.snapshots();
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Stream<DocumentSnapshot<Object>> streamSubDoc({
    @required String collName,
    @required String docName,
    @required String subCollName,
    @required String subDocName,
  }) {

    final DocumentReference<Object> _docRef = getSubDocRef(
      collName: collName,
      docName: docName,
      subCollName: subCollName,
      subDocName: subDocName,
    );

    return _docRef.snapshots();
  }
  // --------------------

  /// UPDATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> updateDoc({
    @required String collName,
    @required String docName,
    @required Map<String, dynamic> input,
  }) async {

    // NOTES
    /// this creates a new doc that overrides existing doc,, same as createNamedDoc method
    /// or another syntax
    /// --------------------
    /// await tryAndCatch(
    ///     context: context,
    ///     functions: () async {
    ///
    ///       DocumentReference<Object> _docRef = getDocRef(collName, docName);
    ///       await _docRef.set(input);
    ///
    ///     }
    /// );
    /// --------------------
    ///

    await createNamedDoc(
      collName: collName,
      docName: docName,
      input: input,
    );


  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> updateDocField({
    @required String collName,
    @required String docName,
    @required String field,
    @required dynamic input,
  }) async {

    if (input != null){

      final DocumentReference<Object> _ref = getDocRef(
        collName: collName,
        docName: docName,
      );

      await _updateData(
        ref: _ref,
        invoker: 'updateDocField',
        input: <String, dynamic>{field: input},
      );

    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> updateSubDoc({
    @required String collName,
    @required String docName,
    @required String subCollName,
    @required String subDocName,
    @required Map<String, dynamic> input,
  }) async {

    await createNamedSubDoc(
      collName: collName,
      docName: docName,
      subCollName: subCollName,
      subDocName: subDocName,
      input: input,
    );

  }
  // --------------------
  ///
  static Future<void> updateSubDocField({
    @required BuildContext context,
    @required String collName,
    @required String docName,
    @required String subCollName,
    @required String subDocName,
    @required String field,
    @required dynamic input
  }) async {

    // NOTES
    /// this updates a field if exists,
    /// if absent it creates a new field and inserts the value

    if (input != null){

      final DocumentReference<Object> _subDoc = getSubDocRef(
        collName: collName,
        docName: docName,
        subCollName: subCollName,
        subDocName: subDocName,
      );

      await _updateData(
        ref: _subDoc,
        invoker: 'updateSubDocField',
        input: <String, dynamic>{field: input},
      );

    }

  }
  // -----------------------------------------------------------------------------

  /// DELETE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteDoc({
    @required String collName,
    @required String docName,
  }) async {

    await tryAndCatch(
        invoker: 'deleteDoc',
        functions: () async {

          final DocumentReference<Object> _doc = getDocRef(
            collName: collName,
            docName: docName,
          );

          await _doc.delete();

          blog('deleteDoc : deleted : $collName : $docName');
        });
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteSubDoc({
    @required String collName,
    @required String docName,
    @required String subCollName,
    @required String subDocName,
  }) async {

    await tryAndCatch(
        invoker: 'deleteSubDoc',
        functions: () async {

          final DocumentReference<Object> _subDoc = getSubDocRef(
            collName: collName,
            docName: docName,
            subCollName: subCollName,
            subDocName: subDocName,
          );

          await _subDoc.delete();

          blog('deleteSubDoc : deleted : $collName : $docName : $subCollName : $subDocName');
        }
    );
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteCollDocsByIterations({
    @required BuildContext context,
    @required String collName,
    @required int numberOfIterations, // was 1000
    @required int numberOfReadsPerIteration, // was 5
  }) async {

      for (int i = 0; i < numberOfIterations; i++){

        final List<Map<String, dynamic>> _maps = await readCollectionDocs(
          collName: collName,
          limit: numberOfReadsPerIteration,
          addDocsIDs: true,
        );

        if (_maps.isEmpty){
          break;
        }

        else {

          final List<String> _docIDs = Mapper.getMapsPrimaryKeysValues(
            maps: _maps,
            // primaryKey: 'id',
          );

          blog('docs IDs : $_docIDs');

          await _deleteCollectionDocsByIDs(
            collName: collName,
            docsIDs: _docIDs,
          );

        }

      }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _deleteCollectionDocsByIDs({
    @required collName,
    @required List<String> docsIDs,
  }) async {

    /// PLAN : THIS SHOULD BE A CLOUD FUNCTION INSTEAD OF THIS BULLSHIT


    if (Mapper.checkCanLoopList(docsIDs) == true){

      for (final String id in docsIDs){

        await deleteDoc(
          collName: collName,
          docName: id,
        );

      }

    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteSubCollection({
    @required BuildContext context,
    @required String collName,
    @required String docName,
    @required String subCollName,
    @required Function onDeleteSubDoc,
    @required int numberOfIterations, // was 1000
    @required int numberOfReadsPerIteration, // was 5
  }) async {

    /// PLAN : THIS SHOULD BE A CLOUD FUNCTION INSTEAD OF THIS BULLSHIT
    /// does the same deletion algorithm with [deleteAllCollectionDocs]

    for (int i = 0; i < numberOfIterations; i++){

        final List<Map<String, dynamic>> _maps = await readSubCollectionDocs(
          collName: collName,
          docName: docName,
          subCollName: subCollName,
          limit: numberOfReadsPerIteration,
          addDocsIDs: true,
        );

        if (_maps.isEmpty){
          break;
        }

        else {

          final List<String> _docIDs = Mapper.getMapsPrimaryKeysValues(
            maps: _maps,
            // primaryKey: 'id',
          );

          blog('docs IDs : $_docIDs');

          await _deleteSubCollectionDocsBySubDocsIDs(
            collName: collName,
            docName: docName,
            subCollName: subCollName,
            subDocsIDs: _docIDs,
            onDeleteSubDoc: onDeleteSubDoc,
          );

        }

      }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> _deleteSubCollectionDocsBySubDocsIDs({
    @required collName,
    @required docName,
    @required subCollName,
    @required List<String> subDocsIDs,
    @required Function onDeleteSubDoc,
  }) async {

    /// PLAN : THIS SHOULD BE A CLOUD FUNCTION INSTEAD OF THIS BULLSHIT

    if (Mapper.checkCanLoopList(subDocsIDs) == true){

      for (final String subDocID in subDocsIDs){

        await Future.wait(<Future>[

          deleteSubDoc(
            collName: collName,
            docName: docName,
            subCollName: subCollName,
            subDocName: subDocID,
          ),


          if (onDeleteSubDoc != null)
            onDeleteSubDoc(subDocID),

        ]);

      }

    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteDocField({
    @required String collName,
    @required String docName,
    @required String field,
  }) async {

    final DocumentReference<Object> _docRef = getDocRef(
      collName: collName,
      docName: docName,
    );

    final Map<String, Object> updates = <String, Object>{};

    updates.addAll(<String, dynamic>{
      field: FieldValue.delete(),
    });

    await _updateData(
      ref: _docRef,
      invoker: 'deleteDocField',
      input: updates,
    );

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteSubDocField({
    @required String collName,
    @required String docName,
    @required String field,
    @required String subCollName,
    @required String subDocName,
  }) async {

    final DocumentReference<Object> _docRef = getSubDocRef(
      collName: collName,
      docName: docName,
      subCollName: subCollName,
      subDocName: subDocName,
    );

    // Remove field from the document
    final Map<String, Object> updates = <String, Object>{};

    updates.addAll(<String, dynamic>{
      field: FieldValue.delete(),
    });

    await _updateData(
      ref: _docRef,
      invoker: 'deleteSubDocField',
      input: updates,
    );

  }
  // -----------------------------------------------------------------------------
}
