part of super_fire;

/// => TAMAM
class _NativeFireMapper {
  // -----------------------------------------------------------------------------

  const _NativeFireMapper();

  // -----------------------------------------------------------------------------
  /// TESTED : WORKS PERFECT
  static List<Map<String, dynamic>> getMapsFromNativePage({
    required List<fd.Document>? page,
    required bool addDocsIDs,
  }) {
    final List<Map<String, dynamic>> _output = [];

    if (page != null && page.isNotEmpty == true) {
      for (final fd.Document _doc in page) {
        final Map<String, dynamic>? _map = getMapFromNativeDoc(
          doc: _doc,
          addDocID: addDocsIDs,
        );

        if (_map != null){
          _output.add(_map);
        }
      }
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, dynamic>? getMapFromNativeDoc({
    required fd.Document? doc,
    required bool addDocID,
  }) {
    Map<String, dynamic>? _output;

    if (doc != null) {
      _output = doc.map;

      if (addDocID == true) {

        // blog('should insert id : ${doc.id} in this doc');

        _output = Mapper.insertPairInMap(
          map: _output,
          key: 'id',
          value: doc.id,
          overrideExisting: true,
        );
      }
    }

    // Mapper.blogMap(_output,invoker: 'getMapFromNativeDoc');

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static List<Map<String, dynamic>> mapDocs(List<fd.Document>? docs) {
    final List<Map<String, dynamic>> _maps = _NativeFireMapper.getMapsFromNativePage(
      page: docs,
      addDocsIDs: true,
    );
    return _maps;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, dynamic>? mapDoc(fd.Document? doc) {
    final Map<String, dynamic>? _map = _NativeFireMapper.getMapFromNativeDoc(
      doc: doc,
      addDocID: true,
    );
    return _map;
  }
  // -----------------------------------------------------------------------------

  /// DATA SNAPSHOT

  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, dynamic>? getMapFromDataSnapshot({
    required f_d.DataSnapshot? snapshot,
    required bool addDocID,
    Function? onExists,
    Function? onNull,
  }){
    Map<String, dynamic>? _output;

    if (snapshot != null && snapshot.value != null) {

      // blog('snapshot.value : ${snapshot.value} : type : ${snapshot.value.runtimeType}');

      if (snapshot.value.runtimeType.toString() == '_Map<String, dynamic>'){
        _output = Mapper.getMapFromIHLMOO(
          ihlmoo: snapshot.value,
        );
        // _output = Map<String, dynamic>.from(snapshot.value);
      }
      else if (snapshot.key != null) {
        _output = {
          snapshot.key! : snapshot.value,
        };

      }

      if (addDocID == true){
        _output = Mapper.insertPairInMap(
          map: _output,
          key: 'id',
          value: snapshot.key,
          overrideExisting: true,
        );
      }

      if (onExists != null){
        onExists();
      }
    }

    else {
      if (onNull != null){
        onNull();
      }
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static List<Map<String, dynamic>> getMapsFromDataSnapshot({
    required f_d.DataSnapshot? snapshot,
    // bool addDocID = true,
  }) {
    final List<Map<String, dynamic>> _output = [];

    if (snapshot != null && snapshot.value != null) {

      final dynamic _bigMap = snapshot.value;
      final List<String> _keys = _bigMap.keys.toList();

      // blog('snapshot.value : ${snapshot.value} : type : ${snapshot.value.runtimeType}');

      for (final String key in _keys) {

        /// CHILD IS MAP
        if (_bigMap[key] is Map<String, dynamic>) {
          /// ADD ONLY THE ID OF EACH MAP, BUT IF THE MAP CONTAINS
          /// SUB MAPS, ADDING THEIRS IDS IS IGNORED,
          final Map<String, dynamic> _map = Mapper.insertPairInMap(
            map: _bigMap[key],
            key: 'id',
            value: key,
            overrideExisting: true,
          );

          _output.add(_map);
        }

        /// CHILD IS NOT A MAP
        else {
          final Map<String, dynamic> _map = {
            key: _bigMap[key],
          };

          _output.add(_map);
        }

      }
    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// INCREMENTATION

  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, dynamic> incrementFields({
    required Map<String, dynamic>? baseMap,
    required Map<String, int>? incrementationMap,
    required bool isIncrementing,
  }){

    Map<String, dynamic> _output = Mapper.insertMapInMap(
        baseMap: {},
        insert: baseMap,
    );

    if (incrementationMap != null){

      final List<String> _keys = incrementationMap.keys.toList();
      final int _incrementer = isIncrementing == true ? 1 : -1;

      if(Lister.checkCanLoop(_keys) == true){

        for (final String _key in _keys){

          if (incrementationMap[_key] != null){

            final int _currentValue = _output[_key] ?? 0;
            final int _increment = incrementationMap[_key]! * _incrementer;
            final int _newValue = _currentValue + _increment;

              _output = Mapper.insertPairInMap(
                map: _output,
                key: _key,
                value: _newValue,
                overrideExisting: true,
              );

          }

        }

      }

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// BLOGGING

  // --------------------
  /// TESTED : WORKS PERFECT
  /*
  static void _blogEvent(f_d.Event event){
    blog('EVENT IS :----');
    blog('event.previousSiblingKey : ${event.previousSiblingKey}');
    blog('event.snapshot.key : ${event.snapshot.key}');
    blog('event.snapshot.value : ${event.snapshot.value}');
  }
  */
  // -----------------------------------------------------------------------------
}
