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
    required this.mounted,
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
  final bool mounted;
  // -----------------------------------------------------------------------------

  /// CLONING

  // --------------------
  /// TESTED : WORKS PERFECT
  PaginationController copyWith({
    ValueNotifier<List<Map<String, dynamic>>>? paginatorMaps,
    ValueNotifier<Map<String, dynamic>?>? replaceMap,
    ValueNotifier<Map<String, dynamic>?>? addMap,
    ValueNotifier<Map<String, dynamic>?>? deleteMap,
    ValueNotifier<dynamic>? startAfter,
    bool? addExtraMapsAtEnd,
    String? idFieldName,
    ValueChanged<List<Map<String, dynamic>>>? onDataChanged,
    ScrollController? scrollController,
    ValueNotifier<bool>? isPaginating,
    ValueNotifier<bool>? canKeepReading,
    bool? mounted,
  }) {
    return PaginationController(
      paginatorMaps: paginatorMaps ?? this.paginatorMaps,
      replaceMap: replaceMap ?? this.replaceMap,
      addMap: addMap ?? this.addMap,
      deleteMap: deleteMap ?? this.deleteMap,
      startAfter: startAfter ?? this.startAfter,
      addExtraMapsAtEnd: addExtraMapsAtEnd ?? this.addExtraMapsAtEnd,
      idFieldName: idFieldName ?? this.idFieldName,
      onDataChanged: onDataChanged ?? this.onDataChanged,
      scrollController: scrollController ?? this.scrollController,
      isPaginating: isPaginating ?? this.isPaginating,
      canKeepReading: canKeepReading ?? this.canKeepReading,
      mounted: mounted ?? this.mounted,
    );
  }
  // -----------------------------------------------------------------------------

  /// INITIALIZATION

  // --------------------
  /// TESTED : WORKS PERFECT
  static PaginationController initialize({
    required bool addExtraMapsAtEnd,
    required bool mounted,
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
      mounted: mounted,
      isPaginating: ValueNotifier(false),
    );

    _controller.activateListeners();

    return _controller;

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  void clear(){
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
    _removePaginatorMapsListener();
    _removeAddMapListener();
    _removeReplaceMapListener();
    _removeDeleteMapListener();
    paginatorMaps.dispose();
    replaceMap.dispose();
    addMap.dispose();
    deleteMap.dispose();
    startAfter.dispose();
    // blog('disposing scrollController');
    scrollController.dispose();
    canKeepReading.dispose();
    isPaginating.dispose();
  }
  // -----------------------------------------------------------------------------

  /// LISTENING

  // --------------------
  /// TESTED : WORKS PERFECT
  void activateListeners(){

    _listenToPaginatorMapsChanges();

    _listenToAddMap();

    _listenToReplaceMap();

    _listenToDeleteMap();

  }
  // --------------------

  /// MAP CHANGES LISTENER

  // ---------
  /// TESTED : WORKS PERFECT
  void _listenToPaginatorMapsChanges(){

    if (onDataChanged != null){
      /// REMOVED
      paginatorMaps.addListener(_paginatorMapsListener);
    }

  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _removePaginatorMapsListener(){
    if (onDataChanged != null){
      paginatorMaps.removeListener(_paginatorMapsListener);
    }
  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _paginatorMapsListener() {
    // if (paginatorMaps.value != null){
    onDataChanged!(paginatorMaps.value);
    // }
  }
  // --------------------------------

  /// ADD MAP LISTENER

  // ---------
  /// TESTED : WORKS PERFECT
  void _listenToAddMap(){
    // if (addMap != null){
      /// REMOVED
      addMap.addListener(_addMapListener);
    // }
  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _removeAddMapListener(){
    // if (addMap != null){
      addMap.removeListener(_addMapListener);
    // }
  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _addMapListener() {
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

        if (addExtraMapsAtEnd == true){
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

  }
  // ---------
  /// TESTED : WORKS PERFECT
  void addMapToPaginator({
    required Map<String, dynamic> map,
    required bool mounted,
  }){

    setNotifier(
        notifier: addMap,
        mounted: mounted,
        value: map,
    );

  }
  // --------------------------------

  /// REPLACE MAP

  // ---------
  /// TESTED : WORKS PERFECT
  void _listenToReplaceMap(){
    /// REMOVED
    replaceMap.addListener(_replaceMapListener);
  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _removeReplaceMapListener(){
    replaceMap.removeListener(_replaceMapListener);
  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _replaceMapListener() {

    _replaceExistingMap(
      mounted: mounted,
      controller: this,
    );

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
  void _listenToDeleteMap(){
    /// REMOVED
    deleteMap.addListener(_deleteMapListener);
  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _removeDeleteMapListener(){
    deleteMap.removeListener(_deleteMapListener);
  }
  // ---------
  /// TESTED : WORKS PERFECT
  void _deleteMapListener() {
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
    String idFieldName = 'id',
  }){

    if (Lister.checkCanLoop(ids) == true){

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

    if (Lister.checkCanLoop(paginatorMaps) == true){

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

    if (Lister.checkCanLoop(mapsToAdd) == true && controller != null){

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

  /// LISTENING

  // --------------------
  /// TESTED : WORKS PERFECT
  static double getVerticalPaginationTileHeight({
    required BuildContext context,
    required int numberOfTilesOnScreen,
    required double totalPaddings,
  }){
    final double _screenHeight = Scale.screenHeight(context);
    return (_screenHeight - totalPaddings) / numberOfTilesOnScreen;
  }
  // -----------------------------------------------------------------------------
}
