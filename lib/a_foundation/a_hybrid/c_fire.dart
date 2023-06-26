part of super_fire;

/// =>
class Fire {
  // -----------------------------------------------------------------------------

  const Fire();

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

    String? _id;

    /// OFFICIAL
    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      _id = await _OfficialFire.createDoc(
        input: input,
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    /// NATIVE
    else {
      _id = await _NativeFire.createDoc(
        input: input,
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    return _id;
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
    List<String> _output = [];

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      _output = await _OfficialFire.createDocs(
        inputs: inputs,
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    else {

      _output = await _NativeFire.createDocs(
        inputs: inputs,
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    return _output;
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

    /// OFFICIAL
    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      _output = await _OfficialFire.readDoc(
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    /// NATIVE
    else {
      _output = await _NativeFire.readDoc(
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<Map<String, dynamic>>> readCollDocs({
    required String coll,
    required List<String> ids,
    String? subColl,
    String? doc,
  }) async {
    List<Map<String, dynamic>> _output = [];

    /// OFFICIAL
    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      _output = await _OfficialFire.readCollDocs(
        coll: coll,
        ids: ids,
        subColl: subColl,
        doc: doc,
      );
    }

    /// NATIVE
    else {
      _output = await _NativeFire.readCollDocs(
        coll: coll,
        ids: ids,
        subColl: subColl,
        doc: doc,
      );
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<List<Map<String, dynamic>?>?> readColl({
    required FireQueryModel queryModel,
    cloud.QueryDocumentSnapshot<Object>? startAfter,
    bool addDocSnapshotToEachMap = false,
  }) async {

    List<Map<String, dynamic>> _output;

    /// OFFICIAL
    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      _output = await _OfficialFire.readColl(
        queryModel: queryModel,
        startAfter: startAfter,
        addDocSnapshotToEachMap: addDocSnapshotToEachMap,
      );
    }

    /// NATIVE
    else {
      _output = await _NativeFire.readColl(
        queryModel: queryModel,
        startAfter: startAfter,
      );
    }

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

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      _output = await _OfficialFire.readAllColl(
        coll: coll,
        doc: doc,
        subColl: subColl,
      );
    }

    else {
      _output = await _NativeFire.readAllColl(
        coll: coll,
        doc: doc,
        subColl: subColl,
      );
    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// STREAMING

  // --------------------
  /// TASK : TEST ME
  static Stream<List<Map<String, dynamic>>>? streamColl({
    required FireQueryModel queryModel,
  }) {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      return _OfficialFire.streamColl(queryModel: queryModel);
    }

    else {
      return _NativeFire.streamColl(queryModel: queryModel);
    }

  }
  // --------------------
  /// TASK : TEST ME
  static Stream<Map<String, dynamic>?>? streamDoc({
    required String coll,
    required String doc,
    String? subColl,
    String? subDoc,
  }) {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      return _OfficialFire.streamDoc(
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    else {
      return _NativeFire.streamDoc(
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }


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

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialFire.updateDoc(
        input: input,
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    else {
      await _NativeFire.updateDoc(
        input: input,
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

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

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialFire.updateDocField(
        input: input,
        field: field,
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    else {
      await _NativeFire.updateDocField(
        input: input,
        field: field,
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
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

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialFire.deleteDoc(
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

    else {
      await _NativeFire.deleteDoc(
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
      );
    }

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

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialFire.deleteDocField(
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
        field: field,
      );
    }

    else {
      await _NativeFire.deleteDocField(
        coll: coll,
        subColl: subColl,
        subDoc: subDoc,
        doc: doc,
        field: field,
      );
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteColl({
    required String coll,
    String? doc,
    String? subColl,
    Function(String? docID)? onDeleteDoc,
    int numberOfIterations = 1000,
    int numberOfReadsPerIteration = 5,
  }) async {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialFire.deleteColl(
        coll: coll,
        doc: doc,
        subColl: subColl,
        onDeleteDoc: onDeleteDoc,
        numberOfIterations: numberOfIterations,
        numberOfReadsPerIteration: numberOfReadsPerIteration,
      );
    }

    else {
      await _NativeFire.deleteColl(
        coll: coll,
        doc: doc,
        subColl: subColl,
        onDeleteDoc: onDeleteDoc,
        numberOfIterations: numberOfIterations,
        numberOfReadsPerIteration: numberOfReadsPerIteration,
      );
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

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialFire.deleteDocs(
        coll: coll,
        docsIDs: docsIDs,
        doc: doc,
        subColl: subColl,
        onDeleteDoc: onDeleteDoc,
      );
    }

    else {
      await _NativeFire.deleteDocs(
        coll: coll,
        docsIDs: docsIDs,
        doc: doc,
        subColl: subColl,
        onDeleteDoc: onDeleteDoc,
      );
    }

  }
  // -----------------------------------------------------------------------------
}
