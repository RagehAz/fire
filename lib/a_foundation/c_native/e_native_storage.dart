part of super_fire;

/// => TAMAM
class _NativeStorage {
  // -----------------------------------------------------------------------------
  /// Note : use picName without file extension <---------------
  // -----------------------------------------------------------------------------

  const _NativeStorage();

  // -----------------------------------------------------------------------------

  /// f_d.REFERENCES

  // --------------------
  /// TESTED: WORKS PERFECT
  static f_d.Reference? _getRefByPath(String? path){

    if (ObjectCheck.objectIsPicPath(path) == true){

      final String? _storagePath = TextMod.removeNumberOfCharactersFromBeginningOfAString(
        string: path,
        numberOfCharacters: 'storage/'.length,
      );

      return _NativeFirebase.getStorage()?.ref(_storagePath);
    }

    else {
      return null;
    }

  }
  // --------------------
  /// DEPRECATED
  /*
  /// TESTED: WORKS PERFECT
  static f_d.Reference _getRefByNodes({
    required String coll,
    required String doc, // without extension
  }) {

    return _NativeFirebase.getStorage()
        .ref()
        .child(coll)
        .child(doc);

  }
   */
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<f_d.Reference?> _getRefByURL({
    required String? url,
  }) async {
    f_d.Reference? _ref;

    if (url != null){
      await tryAndCatch(
        invoker: 'NativeStorage._getRefByURL',
        functions: () async {
          _ref = _NativeFirebase.getStorage()?.refFromURL(url);
        },
        onError: StorageError.onException,
      );
    }


    return _ref;
  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<String?> _createURLByRef({
    required f_d.Reference? ref,
  }) async {
    String? _url;

    await tryAndCatch(
      invoker: 'NativeStorage._createURLByRef',
      functions: () async {
        _url = await ref?.getDownloadURL();
        },
      onError: StorageError.onException,
    );

    return _url;
  }
  // -----------------------------------------------------------------------------

  /// CREATE DOC

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<String?> uploadBytesAndGetURL({
    required Uint8List? bytes,
    required String path,
    required StorageMetaModel? storageMetaModel,
  }) async {

    assert(Mapper.checkCanLoopList(bytes) == true, 'uInt8List is empty or null');
    assert(storageMetaModel != null, 'metaData is null');
    assert(TextCheck.isEmpty(path) == false, 'path is empty or null');

    String? _url;

    await tryAndCatch(
      invoker: 'NativeStorage.createDocByUint8List',
      functions: () async {

        final f_d.Reference? _ref = _getRefByPath(path);

        if (_ref != null && bytes != null){
          final f_d.SettableMetadata? meta = storageMetaModel?.toNativeSettableMetadata(
            bytes: bytes,
            // extraData:
          );
          final f_d.UploadTask _uploadTask = _ref.putData(
            bytes,
            meta,/// NOTE : THIS DOES NOT WORK
          );
          await Future.wait(<Future>[
            _uploadTask.whenComplete(() async {
              _url = await _createURLByRef(ref: _ref);
              await _ref.updateMetadata(meta!);
            }),
            _uploadTask.onError((error, stackTrace) {
              blog('createDocByUint8List : 3 - failed to upload');
              blog('error : ${error.runtimeType} : $error');
              blog('stackTrace : ${stackTrace.runtimeType} : $stackTrace');
              return Future.error(error!);
            }),
          ]);
        }

      },
      onError: StorageError.onException,
    );

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

    /// NOTE : RETURNS URL
    String _fileURL;

    await tryAndCatch(
      invoker: 'NativeStorage.uploadFile',
      functions: () async {

        final Uint8List _bytes = await Floaters.getUint8ListFromFile(file);

        _fileURL = await uploadBytesAndGetURL(
          bytes: _bytes,
          path: '$coll/$doc',
          storageMetaModel: picMetaModel,
        );

      },
      onError: StorageError.onException,
    );

    return _fileURL;
  }
   */
  // -----------------------------------------------------------------------------

  /// CREATE URL

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<String?> createURLByPath({
    required String? path
  }) async {
    final f_d.Reference? _ref = _getRefByPath(path);
    final String? _url = await _createURLByRef(ref: _ref);
    return _url;
  }
  // -----------------------------------------------------------------------------

  /// READ DOC

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<Uint8List?> readBytesByPath({
    required String? path,
  }) async {
    Uint8List? _output;

    if (TextCheck.isEmpty(path) == false){

      await tryAndCatch(
        invoker: 'NativeStorage.readBytesByPath',
        functions: () async {
          final f_d.Reference? _ref = _getRefByPath(path);
          /// 10'485'760 default max size
          _output = await _ref?.getData();
        },
        onError: StorageError.onException,
      );

    }

    return _output;
  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<Uint8List?> readBytesByURL({
    required String? url
  }) async {
    Uint8List? _bytes;

    await tryAndCatch(
      invoker: 'NativeStorage.readBytesByURL',
      functions: () async {

        if (ObjectCheck.isAbsoluteURL(url) == true) {
          /// call http.get method and pass imageUrl into it to get response.
          final http.Response? _response = await Rest.get(
            rawLink: url!,
            // timeout: 60,
            invoker: 'NativeStorage.readBytesByURL',
          );

          if (_response != null && _response.statusCode == 200) {
            _bytes = _response.bodyBytes;
          }

        }

      },
      onError: StorageError.onException,
    );

    return _bytes;
  }
  // --------------------
  /// DEPRECATED : SHOULD USE readBytesByURL INSTEAD FOR WEB SUPPORT
  /*
  /// TESTED: WORKS PERFECT
  static Future<File> readFileByURL({
    required String url,
  }) async {
    File _file;

    await tryAndCatch(
      invoker: 'NativeStorage.readFileByURL',
      functions: () async {

        if (url != null) {
          final f_d.Reference _ref = await _getRefByURL(
            url: url,
          );

          if (_ref != null) {

            final Uint8List _uInts = await readBytesByURL(
              url: url,
            );

            _file = await Filers.getFileFromUint8List(
              uInt8List: _uInts,
              fileName: _ref.name,
            );

          }
        }

      },
      onError: StorageError.onException,
    );

    return _file;
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
    File _file;

    await tryAndCatch(
      invoker: 'NativeStorage.readFileByNodes',
      functions: () async {

        final f_d.Reference _ref = _getRefByNodes(
          coll: coll,
          doc: doc,
        );

        if (_ref != null) {
          final Uint8List _uInts = await _ref.getData();

          _file = await Filers.getFileFromUint8List(
              uInt8List: _uInts,
              fileName: _ref.name,
          );

        }
      },
      onError: StorageError.onException,
    );

    return _file;
  }
   */
  // -----------------------------------------------------------------------------

  /// READ META DATA

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<StorageMetaModel?> readMetaByPath({
    required String? path,
  }) async {
    StorageMetaModel? _output;

    if (TextCheck.isEmpty(path) == false){

      await tryAndCatch(
          invoker: 'NativeStorage.readBytesByPath',
          functions: () async {

            final f_d.Reference? _ref = _getRefByPath(path);

            if (_ref != null) {

              final f_d.FullMetadata _meta = await _ref.getMetadata();

              _output = StorageMetaModel.decipherNativeFullMetaData(
                fullMetadata: _meta,
              );

            }

          },
          onError: StorageError.onException,
      );
    }

    return _output;
  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<StorageMetaModel?> readMetaByURL({
    required String? url,
  }) async {
    StorageMetaModel? _output;

    if (ObjectCheck.isAbsoluteURL(url) == true){

      await tryAndCatch(
        invoker: 'NativeStorage.getMetaByURL',
        functions: () async {

          final f_d.Reference? _ref = await _getRefByURL(
            url: url,
          );

          if (_ref != null) {
            final f_d.FullMetadata _meta = await _ref.getMetadata();

            _output = StorageMetaModel.decipherNativeFullMetaData(
              fullMetadata: _meta,
            );
          }

        },
        onError: StorageError.onException,
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
    required StorageMetaModel? meta,
  }) async {

    /// ASSIGNING NULL TO KEY DELETES PAIR AUTOMATICALLY.

    if (ObjectCheck.isAbsoluteURL(url) == true && meta != null) {

      await tryAndCatch(
        invoker: 'NativeStorage.updatePicMetaData',
        onError: StorageError.onException,
        functions: () async {

          final f_d.Reference? _ref = await _getRefByURL(
            url: url,
          );

          if (_ref != null) {

            final Uint8List? _bytes = await readBytesByURL(
              url: url,
            );

            if (_bytes != null) {

              final f_d.SettableMetadata? _meta = meta.toNativeSettableMetadata(
                bytes: _bytes,
              );

              if (_meta != null) {
                await _ref.updateMetadata(_meta);
              }


            }

          }
        },
      );
    }

  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<void> updateMetaByPath({
    required String? path,
    required StorageMetaModel? meta,
  }) async {

    /// ASSIGNING NULL TO KEY DELETES PAIR AUTOMATICALLY.

    if (ObjectCheck.objectIsPicPath(path) == true && meta != null) {

      await tryAndCatch(
        invoker: 'NativeStorage.updatePicMetaData',
        onError: StorageError.onException,
        functions: () async {

          final f_d.Reference? _ref = _getRefByPath(path);

          if (_ref != null){

            final Uint8List? _bytes = await readBytesByPath(
              path: path,
            );

            if (_bytes != null){

              final f_d.SettableMetadata? _meta = meta.toNativeSettableMetadata(
                bytes: _bytes,
              );

              if (_meta != null){
                await _ref.updateMetadata(_meta);
              }

            }

          }

        },
      );
    }

  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<bool> move({
    required String oldPath,
    required String newPath,
    required String currentUserID,
  }) async {

    bool _output = false;

    final bool _canDelete = await _checkCanDeleteDocByPath(
      path: oldPath,
      userID: currentUserID,
    );

    blog('_NativeStorage.move : _canDelete : $_canDelete');

    blog('ObjectCheck.objectIsPicPath(oldPath) : ${ObjectCheck.objectIsPicPath(oldPath)}');
    blog('ObjectCheck.objectIsPicPath(newPath) : ${ObjectCheck.objectIsPicPath(newPath)}');

    if (
        _canDelete == true
        &&
        ObjectCheck.objectIsPicPath(oldPath) == true
        &&
        ObjectCheck.objectIsPicPath(newPath) == true
    ){

      /// READ OLD PIC
      final Uint8List? _bytes = await readBytesByPath(path: oldPath);

      blog('_NativeStorage.move : _bytes exist : ${_bytes != null}');

      if (_bytes != null) {
        /// READ OLD PIC META
        StorageMetaModel? _meta = await readMetaByPath(path: oldPath);
        _meta = await StorageMetaModel.completeMeta(
          bytes: _bytes,
          meta: _meta,
        );

        /// CREATE NEW PIC
        final String? _url = await uploadBytesAndGetURL(
          path: newPath,
          bytes: _bytes,
          storageMetaModel: _meta,
        );

        blog('_NativeStorage.move : _url : $_url');

        /// DELETE OLD PIC
        _output = await deleteDoc(
            path: oldPath,
            currentUserID: currentUserID,
        );
      }

    }

    return _output;
  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<void> rename({
    required String path,
    required String newName,
    required String currentUserID,
  }) async {

    final bool _canEdit = await _checkCanDeleteDocByPath(
      path: path,
      userID: currentUserID,
    );


    if (
        _canEdit == true
        &&
        ObjectCheck.objectIsPicPath(path) == true
        &&
        TextCheck.isEmpty(newName) == false
    ){

      /// READ OLD PIC
      final Uint8List? _bytes = await readBytesByPath(path: path);
      /// READ OLD PIC META
      StorageMetaModel? _meta = await readMetaByPath(path: path);
      _meta = _meta?.copyWith(
        name: newName,
      );

      final String? _pathWithoutOldName = TextMod.removeTextAfterLastSpecialCharacter(
          text: path,
          specialCharacter: '/',
      );

      /// CREATE NEW PIC
      await uploadBytesAndGetURL(
        path: '$_pathWithoutOldName/$newName',
        bytes: _bytes,
        storageMetaModel: _meta,
      );

      /// DELETE OLD PIC
      await deleteDoc(
          path: path,
          currentUserID: currentUserID
      );

    }

  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<void> completeMeta({
    required String path,
    required String currentUserID,
  }) async {

    final bool _canEdit = await _checkCanDeleteDocByPath(
      path: path,
      userID: currentUserID,
    );


    if (
        _canEdit == true
        &&
        ObjectCheck.objectIsPicPath(path) == true
    ){

      /// READ OLD PIC
      final Uint8List? _bytes = await readBytesByPath(path: path);
      /// READ OLD PIC META
      StorageMetaModel? _meta = await readMetaByPath(path: path);
      _meta = await StorageMetaModel.completeMeta(
        bytes: _bytes,
        meta: _meta,
      );

      /// CREATE URL
      final String? _url = await createURLByPath(
        path: path,
      );

      /// UPDATE META
      await updateMetaByURL(
          url: _url,
          meta: _meta
      );

    }


  }
  // -----------------------------------------------------------------------------

  /// DELETE

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<bool> deleteDoc({
    required String? path,
    required String? currentUserID,
  }) async {
    bool _output = false;

    if (TextCheck.isEmpty(path) == false){

      final bool _canDelete = await _checkCanDeleteDocByPath(
        path: path,
        userID: currentUserID,
      );

      if (_canDelete == true){

        await tryAndCatch(
          invoker: 'NativeStorage.deleteDoc',
          functions: () async {
            final f_d.Reference? _picRef = _getRefByPath(path);
            await _picRef?.delete();
            _output = true;
          },
          onError: StorageError.onException,
        );

      }

      else {
        blog('deletePic : CAN NOT DELETE STORAGE FILE');
      }

    }

    return _output;
  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<void> deleteDocs({
    required List<String>? paths,
    required String? currentUserID,
  }) async {

    if (Mapper.checkCanLoopList(paths) == true && currentUserID != null){

      await Future.wait(<Future>[

        ...List.generate(paths!.length, (index){

          return deleteDoc(
            path: paths[index],
            currentUserID: currentUserID,
          );

        }),

      ]);

    }

  }
  // -----------------------------------------------------------------------------

  /// CHECKERS

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> _checkCanDeleteDocByPath({
    required String? path,
    required String? userID,
  }) async {

    assert(path != null, 'path is null');

    bool _canDelete = false;

    if (path != null && userID != null){

      final StorageMetaModel? _meta = await readMetaByPath(
        path: path,
      );

      final List<String>? _ownersIDs = _meta?.ownersIDs;

      if (Mapper.checkCanLoopList(_ownersIDs) == true){

        _canDelete = Stringer.checkStringsContainString(
          strings: _ownersIDs,
          string: userID,
        );

      }

    }

    return _canDelete;
  }
  // -----------------------------------------------------------------------------

  /// BLOGGING

  // --------------------
  /// NOT USED
  /*
  /// TESTED : WORKS PERFECT
  static void blogRef(f_d.Reference ref){
    blog('BLOGGING STORAGE IMAGE f_d.REFERENCE ------------------------------- START');

    if (ref == null){
      blog('f_d.Reference is null');
    }
    else {
      blog('name : ${ref.name}');
      blog('fullPath : ${ref.fullPath}');
      blog('bucket : ${ref.bucket}');
      blog('hashCode : ${ref.hashCode}');
      blog('parent : ${ref.parent}');
      blog('root : ${ref.root}');
      blog('storage : ${ref.storage}');
    }

    blog('BLOGGING STORAGE IMAGE f_d.REFERENCE ------------------------------- END');
  }
   */
  // -----------------------------------------------------------------------------
}
