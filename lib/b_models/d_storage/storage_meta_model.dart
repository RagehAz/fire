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
    final Map<String, String>? _metaDataMap = MediaMetaModel.generateSettableMap(
        bytes: bytes,
        meta: meta
    );

    return f_s.SettableMetadata(
      customMetadata: _metaDataMap,
      // cacheControl: ,
      // contentDisposition: ,
      // contentEncoding: ,
      // contentLanguage: ,
      contentType: FileMiming.getMimeByType(meta?.fileExt),
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
