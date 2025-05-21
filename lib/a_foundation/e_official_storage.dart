part of super_fire;

/// => TAMAM
abstract class OfficialStorage {
  // -----------------------------------------------------------------------------
  /// Note : use picName without file extension <---------------
  // -----------------------------------------------------------------------------

  /// CREATE DOC

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AvModel?> uploadAv({
    required AvModel? avModel,
  }) async {
    AvModel? _output;

    if (avModel != null && avModel.xFilePath != null){

      await tryAndCatch(
        invoker: 'OfficialStorage.uploadAv',
        functions: () async {

          final f_s.Reference? _ref = OfficialStoragePathing.getRefByPath(avModel.uploadPath);

          // blog('createDocByUint8List : 1 - got ref : $_ref');

          if (_ref != null) {

            final AvModel? _toUpload = await AvOps.completeAv(
              avModel: avModel,
              bytesIfExisted: null,
            );

            if (_toUpload != null){

              final f_s.UploadTask _uploadTask = _ref.putFile(
                File(_toUpload.xFilePath!),
                OfficialModelling.toOfficialSettableMetadata(
                  avModel: _toUpload,
                ),
              );

              await Future.wait(
                  <Future>[

                    /// ON COMPLETION
                    _uploadTask.whenComplete(() async {

                      final String? _url = await OfficialStoragePathing.createURLByRef(ref: _ref);
                      blog('receieved url ($_url)');

                      _output = await _toUpload.setOriginalURL(
                          originalURL: _url,
                      );

                    }),

                    /// ON ERROR
                    _uploadTask.onError((error, stackTrace) {
                      blog('createDocByUint8List : 3 - failed to upload');
                      blog('error : ${error.runtimeType} : $error');
                      blog('stackTrace : ${stackTrace.runtimeType} : $stackTrace');
                      return Future.error(error!);
                    }),

                  ]
              );

            }

          }
          },
        onError: StorageError.onException,
    );

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// READ DOC

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AvModel?> readAv({
    required String? uploadPath,
    required String bobDocName,
    required bool skipMeta,
  }) async {
    AvModel? _output;

    if (TextCheck.isEmpty(uploadPath) == false){

      await tryAndCatch(
        invoker: 'OfficialStorage.readAv',
        functions: () async {

          final f_s.Reference? _ref = OfficialStoragePathing.getRefByPath(uploadPath);
          // blog('got ref : $_ref');
          /// 10'485'760 default max size

          final Uint8List? _theBytes = await _ref?.getData();

          if (skipMeta == true){
            _output = await AvOps.createFromBytes(
              bytes: _theBytes,
              data: CreateSingleAVConstructor(
                bobDocName: bobDocName,
                uploadPath: uploadPath!,
                skipMeta: true,
              ),
            );
          }

          else {

            final f_s.FullMetadata? _fullMeta = await _ref?.getMetadata();

            final AvModel? _meta = AvCipher.fromStringStringMap(
              uploadPath: uploadPath,
              bobDocName: bobDocName,
              map: _fullMeta?.customMetadata,
            );

            _output = await AvOps.createFromBytes(
                bytes: _theBytes,
                data: CreateSingleAVConstructor(
                  uploadPath: uploadPath!,
                  bobDocName: bobDocName,
                  skipMeta: false,
                  originalURL: await OfficialStoragePathing.createURLByPath(path: uploadPath),
                  caption: _meta?.caption,
                  durationMs: _meta?.durationMs,
                  originalXFilePath: _meta?.originalXFilePath,
                  origin: _meta?.origin,
                  ownersIDs: _meta?.ownersIDs,
                  width: _meta?.width,
                  height: _meta?.height,
                  fileExt: _meta?.fileExt,
                ),
            );

          }

        },
        onError: StorageError.onException,
      );

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// READ META DATA

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AvModel?> readMetaByPath({
    required String? uploadPath,
    required String bobDocName,
  }) async {
    AvModel? _output;

    if (TextCheck.isEmpty(uploadPath) == false){

      await tryAndCatch(
          invoker: 'OfficialStorage.readBytesByPath',
          functions: () async {

            final f_s.Reference? _ref = OfficialStoragePathing.getRefByPath(uploadPath!);

            if (_ref != null) {

              final f_s.FullMetadata _meta = await _ref.getMetadata();

              _output = AvCipher.fromStringStringMap(
                uploadPath: uploadPath,
                bobDocName: bobDocName,
                map: _meta.customMetadata,
              );

              _output = await _output?.completeXFilePath();

            }

          },
          onError: StorageError.onException,
      );
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AvModel?> readMetaByURL({
    required String? url,
    required String bobDocName,
  }) async {
    AvModel? _output;

    if (ObjectCheck.isAbsoluteURL(url) == true){

      await tryAndCatch(
        invoker: 'OfficialStorage.readMetaByURL',
        functions: () async {

          final f_s.Reference? _ref = await OfficialStoragePathing.getRefByURL(
            url: url!,
          );

          if (_ref != null) {

            final f_s.FullMetadata _meta = await _ref.getMetadata();

            blog('_ref.fullPath(${_ref.fullPath})');

            _output = AvCipher.fromStringStringMap(
              uploadPath: 'storage/${_ref.fullPath}',
              bobDocName: bobDocName,
              map: _meta.customMetadata,
            );

            _output = await _output?.completeXFilePath();
            _output = await _output?.setOriginalURL(originalURL: url);

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
  /// TESTED : WORKS PERFECT
  static Future<bool> updateMeta({
    required AvModel? avModel
  }) async {
    bool _done = false;

    if (avModel != null) {

      await tryAndCatch(
        invoker: 'OfficialStorage.updateMeta',
        onError: StorageError.onException,
        functions: () async {

          final f_s.Reference? _ref = OfficialStoragePathing.getRefByPath(avModel.uploadPath);

          if (_ref != null){

            /// ASSIGNING NULL DELETES FIELD
            await _ref.updateMetadata(OfficialModelling.toOfficialSettableMetadata(
              avModel: avModel,
            ));

            _done = true;

          }

        },
      );
    }

    return _done;
  }
  // -----------------------------------------------------------------------------

  /// EDIT

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> move({
    required String? oldPath,
    required String? newPath,
    required String? currentUserID,
    required String bobDocName,
  }) async {

    bool _output = false;

    final bool _canDelete = await _checkCanDeleteDocByPath(
      path: oldPath,
      userID: currentUserID,
      bobDocName: bobDocName,
    );

    if (
        _canDelete == true
        &&
        ObjectCheck.objectIsFireStoragePicPath(oldPath) == true
        &&
        ObjectCheck.objectIsFireStoragePicPath(newPath) == true
        &&
        currentUserID != null
    ){

      /// READ OLD PIC
      final AvModel? _old = await readAv(
        uploadPath: oldPath,
        bobDocName: bobDocName,
        skipMeta: false,
      );

      AvModel? _new = await AvOps.cloneAv(
        avModel: _old,
        uploadPath: newPath!,
        bobDocName: bobDocName,
        ownersIDs: _old?.ownersIDs,
      );

      if (_new != null){

        _new = await uploadAv(avModel: _new);

        /// FAILED TO CREATE NEW
        if (_new == null){
          await AvOps.deleteSingle(docName: bobDocName, uploadPath: newPath);
        }

        /// SUCCESS TO CREATE NEW
        else {
          _output = await deleteAv(
            path: oldPath!,
            currentUserID: currentUserID,
            bobDocName: bobDocName,
          );
        }

      }

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> rename({
    required String? path,
    required String? newName,
    required String? currentUserID,
    required String bobDocName,
  }) async {

    final String? _newPath = FilePathing.replaceFileNameInPath(
      oldPath: path,
      fileName: FileNaming.getNameFromPath(path: newName, withExtension: false),
    );

    return move(
      oldPath: path,
      newPath: _newPath,
      currentUserID: currentUserID,
      bobDocName: bobDocName,
    );

  }
  // --------------------
  ///
  static Future<bool> completeMeta({
    required String? uploadPath,
    required String? currentUserID,
    required List<String>? addOwners,
    required String bobDocName,
  }) async {
    bool _done = false;

    final bool _canEdit = await _checkCanDeleteDocByPath(
      path: uploadPath,
      userID: currentUserID,
      bobDocName: bobDocName,
    );

    if (
        _canEdit == true
        &&
        ObjectCheck.objectIsFireStoragePicPath(uploadPath) == true
    ){

      AvModel? _avModel = await readAv(
        uploadPath: uploadPath,
        bobDocName: bobDocName,
        skipMeta: false,
      );

      if (Lister.checkCanLoop(addOwners) == true){
        _avModel = await _avModel?.setOwnersIDs(
            ownersIDs: [...?_avModel.ownersIDs, ...?addOwners],
        );
      }

      _avModel = await AvOps.completeAv(
        avModel: _avModel,
        bytesIfExisted: null,
      );

      _done = await updateMeta(avModel: _avModel);

    }

    return _done;
  }
  // -----------------------------------------------------------------------------

  /// DELETE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> deleteAv({
    required String path,
    required String bobDocName,
    required String currentUserID,
  }) async {
    bool _output = false;

    if (TextCheck.isEmpty(path) == false){

      final bool _canDelete = await _checkCanDeleteDocByPath(
        path: path,
        userID: currentUserID,
        bobDocName: bobDocName,
      );

      if (_canDelete == true){

        await tryAndCatch(
          invoker: 'OfficialStorage.deleteDoc',
          functions: () async {
            final f_s.Reference? _picRef = OfficialStoragePathing.getRefByPath(path);
            await _picRef?.delete();
            _output = await AvOps.deleteSingle(docName: bobDocName, uploadPath: path);
            // blog('deletePic : DELETED STORAGE FILE IN PATH: $path');
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
  /// TESTED : WORKS PERFECT
  static Future<void> deleteAvs({
    required List<String> paths,
    required String bobDocName,
    required String currentUserID,
  }) async {

    if (Lister.checkCanLoop(paths) == true){

      await Future.wait(<Future>[

        ...List.generate(paths.length, (index){

          return deleteAv(
            path: paths[index],
            bobDocName: bobDocName,
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
    required String bobDocName,
    required String? path,
    required String? userID,
  }) async {
    bool _canDelete = false;

    if (userID != null){

      final AvModel? _meta = await readMetaByPath(
        uploadPath: path,
        bobDocName: bobDocName,
      );

      _canDelete = Stringer.checkStringsContainString(
        strings: _meta?.ownersIDs,
        string: userID,
      );

    }

    return _canDelete;
  }
  // -----------------------------------------------------------------------------
}

/// => GREAT
abstract class OfficialStoragePathing {
  // -----------------------------------------------------------------------------

  /// f_s.REFERENCES

  // --------------------
  /// TESTED: WORKS PERFECT
  static f_s.Reference? getRefByPath(String? path){

    if (ObjectCheck.objectIsFireStoragePicPath(path) == true){

      final String? _storagePath = TextMod.removeNumberOfCharactersFromBeginningOfAString(
        string: path,
        numberOfCharacters: 'storage/'.length,
      );

      return OfficialFirebase.getStorage()?.ref(_storagePath);
    }

    else {
      return null;
    }

  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<f_s.Reference?> getRefByURL({
    required String url,
  }) async {
    f_s.Reference? _ref;

    await tryAndCatch(
      invoker: 'OfficialStorage._getRefByURL',
      functions: () async {
        _ref = OfficialFirebase.getStorage()?.refFromURL(url);
      },
      onError: StorageError.onException,
    );

    return _ref;
  }
  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<String?> createURLByRef({
    required f_s.Reference? ref,
  }) async {
    String? _url;

    await tryAndCatch(
      invoker: 'OfficialStorage._createURLByRef',
      functions: () async {
        _url = await ref?.getDownloadURL();
      },
      onError: StorageError.onException,
    );

    return _url;
  }
  // -----------------------------------------------------------------------------

  /// CREATE URL

  // --------------------
  /// TESTED: WORKS PERFECT
  static Future<String?> createURLByPath({
    required String? path
  }) async {
    final f_s.Reference? _ref = OfficialStoragePathing.getRefByPath(path);
    final String? _url = await OfficialStoragePathing.createURLByRef(ref: _ref);
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

  /// PATH BY URL

  // --------------------
/*

  // -----------------------------------------------------------------------------
    /// TESTED: WORKS PERFECT
  static Future<String> _getPathByURL(String url) async {
    String _path;

    if (ObjectCheck.isAbsoluteURL(url) == true){

      final f_s.Reference _ref = await _getRefByURL(url: url);
      _path = _ref.fullPath;

    }

    // blog('getPathByURL : _path : $_path');

    return _path;
  }
   */
  // --------------------------------------------------------------------------
}
