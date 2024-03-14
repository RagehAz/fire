part of super_fire;

/// => TAMAM
@immutable
class StorageMetaModel {
  // -----------------------------------------------------------------------------

  const StorageMetaModel();

  // -----------------------------------------------------------------------------

  /// OFFICIAL CIPHERS

  // --------------------
  /// TESTED : WORKS PERFECT
  static f_s.SettableMetadata toOfficialSettableMetadata({
    required Uint8List? bytes,
    required MediaMetaModel? meta,
    Map<String, String>? extraData,
  }){

    /// ASSIGNING NULL TO KEY DELETES PAIR AUTOMATICALLY.
    Map<String, String>? _metaDataMap = <String, String>{
      'name': meta?.name ?? '',
      'sizeMB': '${meta?.sizeMB}',
      'width': '${meta?.width}',
      'height': '${meta?.height}',
      'uploadPath': meta?.uploadPath ?? '',
      'fileType': FileTyper.cipherType(meta?.fileType) ?? '',
    };

    /// ADD OWNERS IDS
    if (Lister.checkCanLoop(meta?.ownersIDs) == true){
      for (final String ownerID in meta!.ownersIDs) {
        _metaDataMap[ownerID] = 'cool';
      }
    }

    _metaDataMap = MapperSS.cleanNullPairs(
        map: _metaDataMap,
    );

    /// ADD META DATA MAP
    if (meta?.data != null) {
      _metaDataMap = MapperSS.combineStringStringMap(
        baseMap: _metaDataMap,
        replaceDuplicateKeys: true,
        insert: meta!.data,
      );
    }

    /// ADD EXTRA DATA MAP
    if (extraData != null) {
      _metaDataMap = MapperSS.combineStringStringMap(
        baseMap: _metaDataMap,
        replaceDuplicateKeys: true,
        insert: extraData,
      );
    }

    return f_s.SettableMetadata(
      customMetadata: _metaDataMap,
      // cacheControl: ,
      // contentDisposition: ,
      // contentEncoding: ,
      // contentLanguage: ,
      contentType: FileTyper.getContentType(
        bytes: bytes,
        forceType: meta?.fileType,
      ),
    );

  }
  // --------------------
  /// NEVER USED
  /*
  /// TESTED : WORKS PERFECT
  static StorageMetaModel decipherOfficialSettableMetaData({
    required f_s.SettableMetadata settableMetadata,
  }){
    StorageMetaModel _output;

    if (settableMetadata != null){

      _output = _decipherMetaMap(
          customMetadata: settableMetadata.customMetadata
      );

    }

    return _output;
  }
   */
  // --------------------
  /// TESTED : WORKS PERFECT
  static MediaMetaModel? decipherOfficialFullMetaData({
    required f_s.FullMetadata? fullMetadata,
  }){
    MediaMetaModel? _output;

    if (fullMetadata != null){

      _output = MediaMetaModel.decipherMetaMap(
          customMetadata: fullMetadata.customMetadata
      );

    }

    // else {
    //   _output = MediaMetaModel.emptyModel();
    // }

    return _output;
  }
  // --------------------

  /// NATIVE CYPHERS

  // --------------------
  /// TESTED : WORKS PERFECT
  static f_d.SettableMetadata? toNativeSettableMetadata({
    required Uint8List bytes,
    required MediaMetaModel? meta,
    Map<String, String>? extraData,
  }){

    /// ASSIGNING NULL TO KEY DELETES PAIR AUTOMATICALLY.
    Map<String, String>? _metaDataMap = <String, String>{
      'name': meta?.name ?? '',
      'sizeMB': '${meta?.sizeMB}',
      'width': '${meta?.width}',
      'height': '${meta?.height}',
      'uploadPath': meta?.uploadPath ?? '',
      'fileType': FileTyper.cipherType(meta?.fileType) ?? '',
    };

    /// ADD OWNERS IDS
    if (Lister.checkCanLoop(meta?.ownersIDs) == true){
      for (final String ownerID in meta!.ownersIDs) {
        _metaDataMap[ownerID] = 'cool';
      }
    }

    _metaDataMap = MapperSS.cleanNullPairs(
      map: _metaDataMap,
    );

    /// ADD META DATA MAP
    if (meta?.data != null) {
      _metaDataMap = MapperSS.combineStringStringMap(
        baseMap: _metaDataMap,
        replaceDuplicateKeys: true,
        insert: meta!.data,
      );
    }

    /// ADD EXTRA DATA MAP
    if (extraData != null) {
      _metaDataMap = MapperSS.combineStringStringMap(
        baseMap: _metaDataMap,
        replaceDuplicateKeys: true,
        insert: extraData,
      );
    }

    // blog('meta data are : $_metaDataMap');

    return f_d.SettableMetadata(
      customMetadata: _metaDataMap,
      // cacheControl: ,
      // contentDisposition: ,
      // contentEncoding: ,
      // contentLanguage: ,
      contentType: FileTyper.getContentType(
        bytes: bytes,
        forceType: meta?.fileType,
      ),
    );

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static MediaMetaModel? decipherNativeFullMetaData({
    required f_d.FullMetadata? fullMetadata,
  }){
    MediaMetaModel? _output;

    if (fullMetadata != null){

      _output = MediaMetaModel.decipherMetaMap(
          customMetadata: fullMetadata.customMetadata
      );

    }

    // else {
    //   _output = MediaMetaModel.emptyModel();
    // }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// BLOGGING

  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogOfficialSettableMetaData(f_s.SettableMetadata? metaData){
    blog('BLOGGING SETTABLE META DATA ------------------------------- START');
    if (metaData == null){
      blog('Meta data is null');
    }
    else {
      blog('cacheControl : ${metaData.cacheControl}');
      blog('contentDisposition : ${metaData.contentDisposition}');
      blog('contentEncoding : ${metaData.contentEncoding}');
      blog('contentLanguage : ${metaData.contentLanguage}');
      blog('contentType : ${metaData.contentType}');
      blog('customMetadata : ${metaData.customMetadata}');
    }
    blog('BLOGGING SETTABLE META DATA ------------------------------- END');
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogOfficialFullMetaData(f_s.FullMetadata? metaData){

    blog('BLOGGING FULL META DATA ------------------------------- START');
    if (metaData == null){
      blog('Meta data is null');
    }
    else {
      blog('name : ${metaData.name}');
      blog('bucket : ${metaData.bucket}');
      blog('cacheControl : ${metaData.cacheControl}');
      blog('contentDisposition : ${metaData.contentDisposition}');
      blog('contentEncoding : ${metaData.contentEncoding}');
      blog('contentLanguage : ${metaData.contentLanguage}');
      blog('contentType : ${metaData.contentType}');
      blog('customMetadata : ${metaData.customMetadata}'); // map
      blog('fullPath : ${metaData.fullPath}');
      blog('generation : ${metaData.generation}');
      blog('md5Hash : ${metaData.md5Hash}');
      blog('metadataGeneration : ${metaData.metadataGeneration}');
      blog('metageneration : ${metaData.metageneration}');
      blog('size : ${metaData.size}');
      blog('timeCreated : ${metaData.timeCreated}'); // date time
      blog('updated : ${metaData.updated}'); // date time
    }
    blog('BLOGGING FULL META DATA ------------------------------- END');

  }
  // -----------------------------------------------------------------------------
}
