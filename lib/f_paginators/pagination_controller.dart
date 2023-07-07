part of super_fire;

/// => TAMAM
class PaginationController {
  /// -----------------------------------------------------------------------------
  const PaginationController({
    required this.paginatorMaps,
    required this.replaceMap,
    required this.addMap,
    required this.deleteMap,
    required this.startAfter,
    required this.addExtraMapsAtEnd,
    required this.idFieldName,
    required this.onDataChanged,
    required this.scrollController,
    required this.isPaginating,
    required this.canKeepReading,
  });
  /// -----------------------------------------------------------------------------
  final ValueNotifier<List<Map<String, dynamic>>> paginatorMaps;
  final ValueNotifier<Map<String, dynamic>?> replaceMap;
  final ValueNotifier<Map<String, dynamic>?> addMap;
  final ValueNotifier<Map<String, dynamic>?> deleteMap;
  final ValueNotifier<dynamic> startAfter;
  final bool addExtraMapsAtEnd;
  final String idFieldName;
  final ValueChanged<List<Map<String, dynamic>>>? onDataChanged;
  final ScrollController scrollController;
  final ValueNotifier<bool> isPaginating;
  final ValueNotifier<bool> canKeepReading;
  // -----------------------------------------------------------------------------

  /// INITIALIZATION

  // --------------------
  /// TESTED : WORKS PERFECT
  static PaginationController initialize({
    required bool addExtraMapsAtEnd,
    ValueChanged<List<Map<String, dynamic>>>? onDataChanged,
    String idFieldName = 'id',
  }){

    final PaginationController _controller = PaginationController(
      paginatorMaps: ValueNotifier(<Map<String, dynamic>>[]),
      replaceMap: ValueNotifier<Map<String, dynamic>?>(null),
      addMap: ValueNotifier<Map<String, dynamic>?>(null),
      deleteMap: ValueNotifier<Map<String, dynamic>?>(null),
      startAfter: ValueNotifier<dynamic>(null),
      addExtraMapsAtEnd: addExtraMapsAtEnd,
      idFieldName: idFieldName,
      onDataChanged: onDataChanged,
      scrollController: ScrollController(),
      canKeepReading: ValueNotifier(true),
      isPaginating: ValueNotifier(false),
    );

    _controller.activateListeners(mounted: true);

    return _controller;

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  void clear({
  required bool mounted,
  }){
    setNotifier(mounted: mounted, notifier: paginatorMaps, value: <Map<String, dynamic>>[]);
    setNotifier(mounted: mounted, notifier: replaceMap, value: null);
    setNotifier(mounted: mounted, notifier: addMap, value: null);
    setNotifier(mounted: mounted, notifier: deleteMap, value: null);
    setNotifier(mounted: mounted, notifier: startAfter, value: null);
    setNotifier(mounted: mounted, notifier: isPaginating, value: false);
    setNotifier(mounted: mounted, notifier: canKeepReading, value: true);
  }
  // --------------------
  /*
  void removeListeners(){
    paginatorMaps.removeListener(() { });
    replaceMap.removeListener(() { });
    addMap.removeListener(() { });
    deleteMap.removeListener(() { });
    startAfter.removeListener(() { });
  }
   */
  // -----------------------------------------------------------------------------

  /// DISPOSING

  // --------------------
  /// TESTED : WORKS PERFECT
  void dispose(){
    paginatorMaps.dispose();
    replaceMap.dispose();
    addMap.dispose();
    deleteMap.dispose();
    startAfter.dispose();
    blog('disposing scrollController');
    scrollController.dispose();
    canKeepReading.dispose();
    isPaginating.dispose();
  }
  // -----------------------------------------------------------------------------

  /// LISTENING

  // --------------------
  /// TESTED : WORKS PERFECT
  void activateListeners({
    required bool mounted,
    // required ValueChanged<List<Map<String, dynamic>>> onDataChanged,
  }){

    _listenToPaginatorMapsChanges();

    _listenToAddMap(
      mounted: mounted,
      addAtEnd: addExtraMapsAtEnd,
    );

    _listenToReplaceMap(
      mounted: mounted,
    );

    _listenToDeleteMap(
      mounted: mounted,
    );

  }
  // --------------------

  /// MAP CHANGES LISTENER

  // ---------
  /// TESTED : WORKS PERFECT
  void _listenToPaginatorMapsChanges(){

    if (onDataChanged != null){
      paginatorMaps.addListener(() {
        // if (paginatorMaps.value != null){
          onDataChanged!(paginatorMaps.value);
        // }
      });
    }

  }
  // --------------------------------

  /// ADD MAP LISTENER

  // ---------
  /// TESTED : WORKS PERFECT
  void _listenToAddMap({
    required bool addAtEnd,
    required bool mounted,
  }){
    // if (addMap != null){
      addMap.addListener(() {

        blog('_listenToAddMap FIRING');

        _addMapToPaginatorMaps(
          addAtEnd: addAtEnd,
          mounted: mounted,
        );

      });
    // }
  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _addMapToPaginatorMaps({
    required bool addAtEnd,
    required bool mounted,
  }){

    List<Map<String, dynamic>> _combinedMaps = [...paginatorMaps.value];

    // blog('_addMapToPaginatorMaps STARTS WITH : ${paginatorMaps.value.length} maps');

    if (addMap.value != null){

      final bool _idExists = Mapper.checkMapsContainMapWithID(
        maps: _combinedMaps,
        map: addMap.value,
        idFieldName: idFieldName,
      );

      blog('_addMapToPaginatorMaps _idExists : $_idExists');

      /// SHOULD REPLACE
      if (_idExists == true){
        _combinedMaps = Mapper.replaceMapInMapsWithSameIDField(
          baseMaps: paginatorMaps.value,
          mapToReplace: addMap.value,
          idFieldName: idFieldName,
        )!;
      }

      /// SHOULD ADD
      else {

        if (addAtEnd == true){
          _combinedMaps = [...paginatorMaps.value, addMap.value!];
        }
        else {
          _combinedMaps = [addMap.value!, ...paginatorMaps.value,];
        }

      }

      setNotifier(
        notifier: paginatorMaps,
        mounted: mounted,
        value: _combinedMaps,
      );

      // setNotifier(
      //     notifier: addMap,
      //     mounted: mounted,
      //     value: null,
      // );

      _setStartAfter(
        startAfter: startAfter,
        paginatorMaps: _combinedMaps,
        mounted: mounted,
      );

    }

    // blog('_addMapToPaginatorMaps ENDS WITH : ${paginatorMaps.value.length} maps');
  }
  // --------------------------------

  /// REPLACE MAP

  // ---------
  /// TESTED : WORKS PERFECT
  void _listenToReplaceMap({
    required bool mounted,
  }){

      replaceMap.addListener(() {

        _replaceExistingMap(
          mounted: mounted,
          controller: this,
        );

      });

  }
  // ---------
  /// TESTED : WORKS PERFECT
  static void _replaceExistingMap({
    required bool mounted,
    required PaginationController controller,
  }){

    if (controller.replaceMap.value != null){

      final List<Map<String, dynamic>>? _updatedMaps = Mapper.replaceMapInMapsWithSameIDField(
        baseMaps: controller.paginatorMaps.value,
        mapToReplace: controller.replaceMap.value,
        idFieldName: controller.idFieldName,
      );

      setNotifier(
        notifier: controller.paginatorMaps,
        mounted: mounted,
        value: _updatedMaps,
      );

      setNotifier(
        notifier: controller.replaceMap,
        mounted: mounted,
        value: null,
      );

      _setStartAfter(
        startAfter: controller.startAfter,
        paginatorMaps: controller.paginatorMaps.value,
        mounted: mounted,
      );

    }

  }
  // ---------
  /// TESTED : WORKS PERFECT
  void replaceMapByID({
    required Map<String, dynamic> map,
    required bool mounted,
  }){

    setNotifier(
        notifier: replaceMap,
        mounted: mounted,
        value: map,
    );

  }
  // --------------------------------

  /// DELETE MAP

  // ---------
  /// TESTED : WORKS PERFECT
  void _listenToDeleteMap({
    required bool mounted,
  }){

      deleteMap.addListener(() {

        _deleteExistingMap(
          mounted: mounted,
        );

      });

  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _deleteExistingMap({
    required bool mounted,
  }){

    if (deleteMap.value != null){

      final List<Map<String, dynamic>> _updatedMaps = Mapper.removeMapFromMapsByIdField(
        baseMaps: paginatorMaps.value,
        mapIDToRemove: deleteMap.value![idFieldName],
        idFieldName: idFieldName,
      );

      setNotifier(
        notifier: paginatorMaps,
        mounted: mounted,
        value: _updatedMaps,
      );

      setNotifier(
        notifier: deleteMap,
        mounted: mounted,
        value: null,
      );

      _setStartAfter(
        startAfter: startAfter,
        paginatorMaps: paginatorMaps.value,
        mounted: mounted,
      );

    }


  }
  // ---------
  /// TESTED : WORKS PERFECT
  void deleteMapByID({
    required String? id,
    required bool mounted,
    String idFieldName = 'id',
  }){

    if (id != null){

      setNotifier(
          notifier: deleteMap,
          mounted: mounted,
          value: Mapper.getMapFromMapsByID(
            maps: paginatorMaps.value,
            id: id,
            idFieldName: idFieldName,
          ),
      );

    }

  }
  // ---------
  /// TESTED : WORKS PERFECT
  void removeMapsByIDs({
    required List<String> ids,
    required bool mounted,
    String idFieldName = 'id',
  }){

    if (Mapper.checkCanLoopList(ids) == true){

      if (paginatorMaps.value.isNotEmpty == true){

        List<Map<String, dynamic>> _maps = [];
        _maps = <Map<String, dynamic>>[...paginatorMaps.value];

       for (final String id in ids){
         _maps = Mapper.removeMapFromMapsByIdField(
           baseMaps: _maps,
           mapIDToRemove: id,
         );
       }

       setNotifier(
           notifier: paginatorMaps,
           mounted: mounted,
           value: _maps,
       );


      }

    }

  }
  // --------------------------------

  /// START AFTER

  // ---------
  /// TESTED : WORKS PERFECT
  static void _setStartAfter({
    required ValueNotifier<dynamic> startAfter,
    required List<Map<String, dynamic>>? paginatorMaps,
    required bool mounted,
  }){

    if (Mapper.checkCanLoopList(paginatorMaps) == true){

      setNotifier(
          notifier: startAfter,
          mounted: mounted,
          value: paginatorMaps?.last['docSnapshot'] ?? paginatorMaps?.last
      );

    }

    else {
      setNotifier(
          notifier: startAfter,
          mounted: mounted,
          value: null,
      );
    }

  }
  // --------------------------------

  /// INSERTION

  // ---------
  /// TESTED : WORKS PERFECT
  static void insertMapsToPaginator({
    required PaginationController? controller,
    required List<Map<String, dynamic>?>? mapsToAdd,
    required bool mounted,
  }){

    List<Map<String, dynamic>>? _combinedMaps = [...?controller?.paginatorMaps.value];

    if (Mapper.checkCanLoopList(mapsToAdd) == true && controller != null){

      for (final Map<String, dynamic>? mapToInsert in mapsToAdd!) {

        final bool _contains = Mapper.checkMapsContainMapWithID(
          maps: _combinedMaps,
          map: mapToInsert,
          idFieldName: controller.idFieldName,
        );

        /// SHOULD REPLACE EXISTING MAP
        if (_contains == true) {
          _combinedMaps = Mapper.replaceMapInMapsWithSameIDField(
            baseMaps: _combinedMaps,
            mapToReplace: mapToInsert,
            idFieldName: controller.idFieldName,
          );
        }

        /// SHOULD ADD NEW MAP
        else {
          if (controller.addExtraMapsAtEnd == true) {
            _combinedMaps = [...?_combinedMaps, mapToInsert!];
          } else {
            _combinedMaps = [mapToInsert!, ...?_combinedMaps];
          }
        }
      }

      _setPaginatorMaps(
        controller: controller,
        mounted: mounted,
        maps: _combinedMaps,
      );
    }


  }
  // ---------
  /// TESTED : WORKS PERFECT
  static void _setPaginatorMaps({
    required PaginationController controller,
    required List<Map<String, dynamic>>? maps,
    required bool mounted,
  }){

    setNotifier(
      notifier: controller.paginatorMaps,
      mounted: mounted,
      value: maps,
    );

    _setStartAfter(
      startAfter: controller.startAfter,
      paginatorMaps: maps,
      mounted: mounted,
    );

  }
  // -----------------------------------------------------------------------------
}
