part of super_fire;

/// => TAMAM
@immutable
class StorageMetaModel {
  // -----------------------------------------------------------------------------
  const StorageMetaModel({
    required this.ownersIDs,
    this.width,
    this.height,
    this.name,
    this.sizeMB,
    this.data,
  });
  // -----------------------------------------------------------------------------
  final List<String> ownersIDs;
  final double? width;
  final double? height;
  final String? name;
  final double? sizeMB;
  final Map<String, String>? data;
  // -----------------------------------------------------------------------------

  /// CLONING

  // --------------------
  /// TESTED : WORKS PERFECT
  StorageMetaModel copyWith({
    List<String>? ownersIDs,
    double? width,
    double? height,
    String? name,
    double? sizeMB,
    Map<String, String>? data,
  }){
    return StorageMetaModel(
      ownersIDs: ownersIDs ?? this.ownersIDs,
      width: width ?? this.width,
      height: height ?? this.height,
      name: name ?? this.name,
      sizeMB: sizeMB ?? this.sizeMB,
      data: data ?? this.data,
    );
  }
  // -----------------------------------------------------------------------------

  /// CYPHERS

  // --------------------
  /// TESTED : WORKS PERFECT
  Map<String, dynamic> cipherToLDB(){
    return <String, dynamic>{
      'ownersIDs': ownersIDs,
      'width': width,
      'height': height,
      'name': name,
      'sizeMB': sizeMB,
      'data': data,
    };
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static StorageMetaModel? decipherFromLDB(Map<String, dynamic>? map){
    StorageMetaModel? _output;

    if (map != null){
      _output = StorageMetaModel(
        ownersIDs: Stringer.getStringsFromDynamics(map['ownersIDs']),
        width: map['width'],
        height: map['height'],
        name: map['name'],
        sizeMB: map['sizeMB'],
        data: _getDataMap(map['data']),
      );
    }

    return _output;
  }
  // --------------------
  /// TASK : TEST ME
  static Map<String, String>? _getDataMap(dynamic thing){
    Map<String, String>? _output;

    if (thing != null){
      _output = {};

      if (thing is Map){
        final List<dynamic> _keys = thing.keys.toList();
        for (final String key in _keys){

          if (thing[key] is String){
            _output[key] = thing[key];
          }

        }
      }

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static StorageMetaModel? _decipherMetaMap({
    required Map<String, String>? customMetadata,
  }){
    StorageMetaModel? _output;

    if (customMetadata != null){
      _output = StorageMetaModel(
        ownersIDs: MapperSS.getKeysHavingThisValue(
          map: customMetadata,
          value: 'cool',
        ),
        width: Numeric.transformStringToDouble(customMetadata['width']),
        height: Numeric.transformStringToDouble(customMetadata['height']),
        name: customMetadata['name'],
        sizeMB: Numeric.transformStringToDouble(customMetadata['sizeMB']),
        data: _getRemainingData(customMetadata),
      );

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, String>? _getRemainingData(Map<String, String>? metaMap){
    Map<String, String>? _map;

    if (metaMap != null){

      _map = {};

      final List<String> _keys = metaMap.keys.toList();

      if (Lister.checkCanLoop(_keys) == true){

        for (final String key in _keys){

          if (
              metaMap[key] != 'cool' &&
              key != 'width' &&
              key != 'height' &&
              key != 'name' &&
              key != 'sizeMB'
          ){
            _map[key] = metaMap[key]!;
          }

        }

      }

    }

    return _map;
  }
  // -----------------------------------------------------------------------------

  /// OFFICIAL CIPHERS

  // --------------------
  /// TESTED : WORKS PERFECT
  f_s.SettableMetadata toOfficialSettableMetadata({
    required Uint8List? bytes,
    Map<String, String>? extraData,
  }){

    /// ASSIGNING NULL TO KEY DELETES PAIR AUTOMATICALLY.
    Map<String, String>? _metaDataMap = <String, String>{
      'name': name ?? '',
      'sizeMB': '$sizeMB',
      'width': '$width',
      'height': '$height',
    };

    /// ADD OWNERS IDS
    if (Lister.checkCanLoop(ownersIDs) == true){
      for (final String ownerID in ownersIDs) {
        _metaDataMap[ownerID] = 'cool';
      }
    }

    _metaDataMap = _cleanNullPairs(
        map: _metaDataMap,
    )?.cast<String, String>();

    /// ADD META DATA MAP
    if (data != null) {
      _metaDataMap = MapperSS.combineStringStringMap(
        baseMap: _metaDataMap,
        replaceDuplicateKeys: true,
        insert: data,
      )?.cast<String, String>();
    }

    /// ADD EXTRA DATA MAP
    if (extraData != null) {
      _metaDataMap = MapperSS.combineStringStringMap(
        baseMap: _metaDataMap,
        replaceDuplicateKeys: true,
        insert: extraData,
      )?.cast<String, String>();
    }

    return f_s.SettableMetadata(
      customMetadata: _metaDataMap,
      // cacheControl: ,
      // contentDisposition: ,
      // contentEncoding: ,
      // contentLanguage: ,
      contentType: FireFileTyper.getContentType(bytes),
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
  static StorageMetaModel? decipherOfficialFullMetaData({
    required f_s.FullMetadata? fullMetadata,
  }){
    StorageMetaModel? _output;

    if (fullMetadata != null){

      _output = _decipherMetaMap(
          customMetadata: fullMetadata.customMetadata
      );

    }

    else {
      _output = StorageMetaModel.emptyModel();
    }

    return _output;
  }
  // --------------------

  /// NATIVE CYPHERS

  // --------------------
  /// TESTED : WORKS PERFECT
  f_d.SettableMetadata? toNativeSettableMetadata({
    required Uint8List bytes,
    Map<String, String>? extraData,
  }){

    /// ASSIGNING NULL TO KEY DELETES PAIR AUTOMATICALLY.
    Map<String, String>? _metaDataMap = <String, String>{
      'name': name ?? '',
      'sizeMB': '$sizeMB',
      'width': '$width',
      'height': '$height',
    };

    /// ADD OWNERS IDS
    if (Lister.checkCanLoop(ownersIDs) == true){
      for (final String ownerID in ownersIDs) {
        _metaDataMap[ownerID] = 'cool';
      }
    }

    _metaDataMap = _cleanNullPairs(
        map: _metaDataMap,
    )?.cast<String, String>();

    /// ADD META DATA MAP
    if (data != null) {
      _metaDataMap = MapperSS.combineStringStringMap(
        baseMap: _metaDataMap,
        replaceDuplicateKeys: true,
        insert: data,
      )?.cast<String, String>();
    }

    /// ADD EXTRA DATA MAP
    if (extraData != null) {
      _metaDataMap = MapperSS.combineStringStringMap(
        baseMap: _metaDataMap,
        replaceDuplicateKeys: true,
        insert: extraData,
      )?.cast<String, String>();
    }

    blog('meta data are : $_metaDataMap');

    return f_d.SettableMetadata(
      customMetadata: _metaDataMap,
      // cacheControl: ,
      // contentDisposition: ,
      // contentEncoding: ,
      // contentLanguage: ,
      contentType: FireFileTyper.getContentType(bytes),
    );

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static StorageMetaModel? decipherNativeFullMetaData({
    required f_d.FullMetadata? fullMetadata,
  }){
    StorageMetaModel? _output;

    if (fullMetadata != null){

      _output = _decipherMetaMap(
          customMetadata: fullMetadata.customMetadata
      );

    }

    else {
      _output = StorageMetaModel.emptyModel();
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<StorageMetaModel?> completeMeta({
    required Uint8List? bytes,
    required StorageMetaModel? meta,
    required String? path,
  }) async {
    StorageMetaModel? _output = meta;

    /// DIMENSIONS
    if (
    (meta?.height == null || meta?.width == null)
    &&
    bytes != null
    ){

      final ui.Image? _decodedImage = await Floaters.getUiImageFromUint8List(bytes);

      _output = _output?.copyWith(
        width: _decodedImage?.width.toDouble(),
        height: _decodedImage?.height.toDouble(),
      );

    }

    /// SIZE
    if (meta?.sizeMB == null){

      final double? _mega = Filers.calculateSize(bytes?.length, FileSizeUnit.megaByte);
      _output = _output?.copyWith(
        sizeMB: _mega,
      );
    }

    blog('meta?.name : ${meta?.name} : path : $path');

    /// NAME
    if (TextCheck.isEmpty(meta?.name?.trim()) == true && path != null){

      final String? _name = TextMod.removeTextBeforeLastSpecialCharacter(
          text: path,
          specialCharacter: '/',
      );

      blog ('_name should be : $_name');

      if (_name != null){
        _output = _output?.copyWith(
          name: _name,
        );
      }

    }

    StorageMetaModel.blogStorageMetaModel(_output);

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
  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogStorageMetaModel(StorageMetaModel? model){

    blog('blogStorageMetaModel ------------------------------------ >> START');

    if (model == null){
      blog('blogStorageMetaModel : model is null');
    }
    else {

    blog(
        'name : ${model.name} : '
        'height : ${model.height} : width : '
        '${model.width} : sizeMB : ${model.sizeMB}'
    );
    Stringer.blogStrings(strings: model.ownersIDs, invoker: 'model.ownersIDs');
    Mapper.blogMap(model.data, invoker: 'blogStorageMetaModel.data');

    }

    blog('blogStorageMetaModel ------------------------------------ >> END');
  }
  // -----------------------------------------------------------------------------

  /// CHECKERS

  // --------------------
  /// TESTED : WORKS PERFECT
  static bool checkMetaDatasAreIdentical({
    required StorageMetaModel? meta1,
    required StorageMetaModel? meta2,
  }){
    bool _output = false;

    if (meta1 == null && meta2 == null){
      _output = true;
    }

    else if (meta1 != null && meta2 != null){

      if (
          Lister.checkListsAreIdentical(list1: meta1.ownersIDs, list2: meta2.ownersIDs) == true
              &&
          meta1.width == meta2.width
              &&
          meta1.height == meta2.height
              &&
          meta1.sizeMB == meta2.sizeMB
              &&
          meta1.name == meta2.name
              &&
          Mapper.checkMapsAreIdentical(map1: meta1.data, map2: meta2.data) == true
      ){
        _output = true;
      }

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Size?> getFileWidthAndHeight({
    required File? file,
  }) async {

    if (file != null){

      final Uint8List? _uInt8List = await Floaters.getBytesFromFile(file);
        // blog('_uInt8List : $_uInt8List');
      final ui.Image? _decodedImage = await Floaters.getUiImageFromUint8List(_uInt8List);

      if (_decodedImage == null){
        return null;
      }
      else {
        return Size(
          _decodedImage.width.toDouble(),
          _decodedImage.height.toDouble(),
        );
      }

    }
    else {
      return null;
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, String?>? _cleanNullPairs({
    required Map<String, String?>? map,
  }){
    Map<String, String?>? _output;

    if (map != null){

      _output = {};
      final List<String> _keys = map.keys.toList();

      for (final String key in _keys){

        if (map[key] != null){

          _output = _insertPairInMap(
            map: _output,
            key: key,
            value: map[key],
          );

        }

        // else {
        //   blog('$key : value is null');
        // }

      }

      if (_output != null && _output.keys.isEmpty == true){
        _output = null;
      }

    }

    // else {
    //   blog('cleanNullPairs: map is null');
    // }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, String?>? _insertPairInMap({
    required Map<String, String?>? map,
    required String? key,
    required dynamic value,
    bool overrideExisting = true,
  }) {
    final Map<String, String?>? _result = <String, String?>{};

    if (map != null) {
      _result?.addAll(map);
    }

    if (key != null && _result != null) {
      /// PAIR IS NULL
      if (_result[key] == null) {
        _result[key] = value;
        // _result.putIfAbsent(key, () => value);
      }

      /// PAIR HAS VALUE
      else {
        if (overrideExisting == true) {
          _result[key] = value;
        }
      }
    }

    return _result;
  }
  // -----------------------------------------------------------------------------

  /// DUMMY

  // --------------------
  /// TESTED : WORKS PERFECT
  static StorageMetaModel emptyModel(){
    return const StorageMetaModel(
      ownersIDs: [],
      // name: null,
      // data: null,
      // width: null,
      // height: null,
      // sizeMB: null,
    );
  }
  // -----------------------------------------------------------------------------

  /// OVERRIDES

  // --------------------
   @override
   String toString(){

    final String _output =
        '''
        StorageMetaModel(
          ownersIDs : $ownersIDs,
          width : $width,
          height : $height,
          sizeMB : $sizeMB,
          name : $name,
          data : $data,
        )
        ''';

    return _output;
   }
  // --------------------
  @override
  bool operator == (Object other){

    if (identical(this, other)) {
      return true;
    }

    bool _areIdentical = false;
    if (other is StorageMetaModel){
      _areIdentical = checkMetaDatasAreIdentical(
        meta1: this,
        meta2: other,
      );
    }

    return _areIdentical;
  }
  // --------------------
  @override
  int get hashCode =>
      ownersIDs.hashCode^
      width.hashCode^
      height.hashCode^
      sizeMB.hashCode^
      name.hashCode^
      data.hashCode;
  // -----------------------------------------------------------------------------
}
