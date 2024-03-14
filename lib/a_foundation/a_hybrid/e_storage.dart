part of super_fire;

/// => TAMAM
class Storage {
  // -----------------------------------------------------------------------------

  const Storage();

  // -----------------------------------------------------------------------------

  /// CREATE DOC

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<String?> uploadBytesAndGetURL({
    required Uint8List? bytes,
    required MediaMetaModel? storageMetaModel,
  }) async {

    String? _url;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _url = await _OfficialStorage.uploadBytesAndGetURL(
          bytes: bytes,
          meta: storageMetaModel
      );
    }

    else {

      _url = await _NativeStorage.uploadBytesAndGetURL(
          bytes: bytes,
          meta: storageMetaModel
      );

    }

    return _url;
  }
  // --------------------
  /// DEPRECATED : SHOULD USE uploadBytesAndGetURL INSTEAD FOR WEB SUPPORT
  /*
  /// TESTED: WORKS PERFECT
  static Future<String> uploadFileAndGetURL({
    required File file,
    required String coll,
    required String doc,
    required StorageMetaModel picMetaModel,
  }) async {
    String _url;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _url = await _OfficialStorage.uploadFileAndGetURL(
          file: file,
          coll: coll,
          doc: doc,
          picMetaModel: picMetaModel
      );
    }

    else {
      _url = await _NativeStorage.uploadFileAndGetURL(
          file: file,
          coll: coll,
          doc: doc,
          picMetaModel: picMetaModel
      );
    }

    return _url;
  }
   */
  // -----------------------------------------------------------------------------

  /// CREATE URL

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<String?> createURLByPath({
    required String? path,
  }) async {
    String? _url;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _url = await _OfficialStorage.createURLByPath(
        path: path,
      );
    }

    else {
      _url = await _NativeStorage.createURLByPath(
        path: path,
      );
    }

    return _url;
  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<String?> createURLByNodes({
    required String? coll,
    required String? doc, // without extension
  }) async {

    if (coll != null && doc != null){
      final String? _url = await createURLByPath(
          path: 'storage/$coll/$doc',
      );

      return _url;
    }

    else {
      return null;
    }

  }
  // -----------------------------------------------------------------------------

  /// READ DOC

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<Uint8List?> readBytesByPath({
    required String? path,
  }) async {
    Uint8List? _output;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialStorage.readBytesByPath(
          path: path,
      );
    }

    else {
      _output = await _NativeStorage.readBytesByPath(
          path: path,
      );
    }

    return _output;
  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<Uint8List?> readBytesByURL({
    required String? url,
  }) async {
    Uint8List? _output;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialStorage.readBytesByURL(
        url: url,
      );
    }

    else {
      _output = await _NativeStorage.readBytesByURL(
        url: url,
      );
    }

    return _output;
  }
  // --------------------
  /// DEPRECATED : SHOULD USE readBytesByURL INSTEAD FOR WEB SUPPORT
  /*
  /// TESTED: WORKS PERFECT
  static Future<File> readFileByURL({
    required String url,
  }) async {
    File _output;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialStorage.readFileByURL(
        url: url,
      );
    }

    else {
      _output = await _NativeStorage.readFileByURL(
        url: url,
      );
    }

    return _output;
  }
   */
  // --------------------
  /// DEPRECATED : SHOULD USE readBytesByPath INSTEAD FOR WEB SUPPORT
  /*
  /// TESTED: WORKS PERFECT
  static Future<File> readFileByNodes({
    required String coll,
    required String doc,
  }) async {
    File _output;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialStorage.readFileByNodes(
          coll: coll,
          doc: doc,
      );
    }

    else {
      _output = await _NativeStorage.readFileByNodes(
          coll: coll,
          doc: doc,
      );
    }

    return _output;
  }
   */
  // -----------------------------------------------------------------------------

  /// READ META DATA

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<MediaMetaModel?> readMetaByPath({
    required String? path,
  }) async {
    MediaMetaModel? _output;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialStorage.readMetaByPath(
          path: path,
      );
    }

    else {
      _output = await _NativeStorage.readMetaByPath(
          path: path,
      );
    }

    return _output;
  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<MediaMetaModel?> readMetaByURL({
    required String? url,
  }) async {
    MediaMetaModel? _output;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialStorage.readMetaByURL(
          url: url,
      );
    }

    else {
      _output = await _NativeStorage.readMetaByURL(
          url: url,
      );
    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// UPDATE META

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<void> updateMetaByURL({
    required String? url,
    required MediaMetaModel? meta,
  }) async {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialStorage.updateMetaByURL(
        url: url,
        meta: meta,
      );
    }

    else {
      await _NativeStorage.updateMetaByURL(
        url: url,
        meta: meta,
      );
    }

  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<void> updateMetaByPath({
    required String? path,
    required MediaMetaModel? meta,
  }) async {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialStorage.updateMetaByPath(
        path: path,
        meta: meta,
      );
    }

    else {
      await _NativeStorage.updateMetaByPath(
        path: path,
        meta: meta,
      );
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> move({
    required String? oldPath,
    required String? newPath,
    required String? currentUserID,
  }) async {
    bool _output;

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      _output = await _OfficialStorage.move(
        oldPath: oldPath,
        newPath: newPath,
        currentUserID: currentUserID
      );
    }

    else {
      _output = await _NativeStorage.move(
        oldPath: oldPath,
        newPath: newPath,
        currentUserID: currentUserID
      );
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> rename({
    required String? path,
    required String? newName,
    required String? currentUserID,
  }) async {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialStorage.rename(
        path: path,
        newName: newName,
        currentUserID: currentUserID
      );
    }

    else {
      await _NativeStorage.rename(
        path: path,
        newName: newName,
        currentUserID: currentUserID
      );
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> completeMeta({
    required String? path,
    required String? currentUserID,
    List<String>? addOwners,
  }) async {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialStorage.completeMeta(
        path: path,
        currentUserID: currentUserID,
        addOwners: addOwners,
      );
    }

    else {
      await _NativeStorage.completeMeta(
        path: path,
        currentUserID: currentUserID,
        addOwners: addOwners,
      );
    }

  }
  // -----------------------------------------------------------------------------

  /// DELETE

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<void> deleteDoc({
    required String path,
    required String currentUserID,
  }) async {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialStorage.deleteDoc(
        path: path,
        currentUserID: currentUserID,
      );
    }

    else {
      await _NativeStorage.deleteDoc(
        path: path,
        currentUserID: currentUserID,
      );
    }

  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<void> deleteDocs({
    required List<String> paths,
    required String currentUserID,
  }) async {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      await _OfficialStorage.deleteDocs(
        paths: paths,
        currentUserID: currentUserID,
      );
    }

    else {
      await _NativeStorage.deleteDocs(
        paths: paths,
        currentUserID: currentUserID,
      );
    }

  }
  // -----------------------------------------------------------------------------
}
