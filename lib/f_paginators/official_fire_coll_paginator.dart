part of super_fire;

class OfficialFireCollPaginator extends StatefulWidget {
  /// --------------------------------------------------------------------------
  const OfficialFireCollPaginator({
    required this.paginationQuery,
    required this.builder,
    required this.paginationController,
    this.streamQuery,
    this.child,
    this.onDataChanged,
    this.onError,
    this.reloadOnRebuild = false,
    super.key
  });
  /// --------------------------------------------------------------------------
  final FireQueryModel? paginationQuery;
  final FireQueryModel? streamQuery;
  final Widget? child;
  final PaginationController? paginationController;
  final ValueChanged<List<Map<String, dynamic>>>? onDataChanged;
  final Function(String error)? onError;
  final bool reloadOnRebuild;
  final Widget Function(
      List<Map<String, dynamic>> maps,
      bool isLoading,
      Widget? child
      ) builder;
  /// --------------------------------------------------------------------------
  @override
  _OfficialFireCollPaginatorState createState() => _OfficialFireCollPaginatorState();
  /// --------------------------------------------------------------------------
}

class _OfficialFireCollPaginatorState extends State<OfficialFireCollPaginator> {
  // -----------------------------------------------------------------------------
  PaginationController? _paginatorController;
  StreamSubscription? _streamSub;
  ValueNotifier<List<Map<String, dynamic>>>? _streamOldMaps;
  // -----------------------------------------------------------------------------
  /// --- LOADING
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  // --------------------
  Future<void>  _triggerLoading({required bool setTo}) async {
    setNotifier(
      notifier: _loading,
      mounted: mounted,
      value: setTo,
    );
  }
  // -----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _streamOldMaps = ValueNotifier<List<Map<String, dynamic>>>([]);

    /// PAGINATOR CONTROLLER
    _initializePaginatorController();



  }
  // --------------------
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    
    if (_isInit && mounted) {
      _isInit = false; // good

      asyncInSync(() async {

        /// THOSE REFRESH THE WIDGET WHEN ITS REBUILT AGAIN ANAD AGAIN
        _paginatorController?.clear(
          isMounted: mounted,
        );
        setNotifier(
          notifier: _paginatorController?.canKeepReading,
          mounted: mounted,
          value: true,
        );

        /// REMOVED
        _paginatorController?.scrollController.addListener(_scrollListener);

        /// INITIAL PAGINATION READ
        await _readMore();

        /// LISTEN TO STREAM CHANGES
        _initializeStreamListener();

      });

    }

    super.didChangeDependencies();
  }
  // --------------------
  @override
  void didUpdateWidget(covariant OfficialFireCollPaginator oldWidget) {
    
    asyncInSync(() async {

      final bool _paginationQueryChanged = FireQueryModel.checkQueriesAreIdentical(
        model1: oldWidget.paginationQuery,
        model2: widget.paginationQuery,
      ) == false;

      final bool _streamQueryChanged = FireQueryModel.checkQueriesAreIdentical(
        model1: oldWidget.streamQuery,
        model2: widget.streamQuery,
      ) == false;
      
      if (widget.reloadOnRebuild || _paginationQueryChanged == true || _streamQueryChanged == true){

        await Future.delayed(const Duration(milliseconds: 100));

        _paginatorController?.clear(
          isMounted: mounted,
        );

        _paginatorController?.canKeepReading.set(
          mounted: mounted,
          value: true,
        );
        
        await _readMore();

      }

    });

    super.didUpdateWidget(oldWidget);
  }
  // --------------------
  @override
  void dispose() {

    _paginatorController?.scrollController.removeListener(_scrollListener);

    _streamOldMaps?.dispose();
    _streamOldMaps = null;

    _loading.dispose();

    /// STATE ARE HANDLED INTERNALLY
    if (widget.paginationController == null){
      _paginatorController?.dispose();
      _paginatorController = null;
    }

    if (_streamSub != null){
      _streamSub?.cancel();
    }

    super.dispose();
  }
  // -----------------------------------------------------------------------------

  /// INITIALIZATION

  // --------------------
  /// TESTED : WORKS PERFECT
  void _initializePaginatorController(){

    /// LISTEN TO PAGINATOR CONTROLLER NOTIFIERS (AddMap - replaceMap - deleteMap - onDataChanged)
    _paginatorController = widget.paginationController ?? PaginationController.initialize(
      mounted: mounted,
      addExtraMapsAtEnd: widget.paginationController?.addExtraMapsAtEnd ?? true,
      idFieldName: widget.paginationQuery?.idFieldName ?? 'id',
      onDataChanged: widget.onDataChanged,
    );

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  void _initializeStreamListener(){

    if (widget.streamQuery != null){

      final Stream<List<Map<String, dynamic>>>? _stream = OfficialFire.streamColl(
        queryModel: widget.streamQuery!,
      );

      if (_streamOldMaps != null){
        _streamSub = OfficialFireCollStreamer.initializeStreamListener(
          stream: _stream,
          mounted: mounted,
          oldMaps: _streamOldMaps!,
          onChanged: (List<Map<String, dynamic>> oldMaps, List<Map<String, dynamic>> newMaps){

            // final List<Map<String, dynamic>> _allMaps = [..._paginatorController.paginatorMaps.value];
            // blog(' === > streamMaps : ${streamMaps.length} maps');

            if (_paginatorController != null){
              PaginationController.insertMapsToPaginator(
                mapsToAdd: newMaps,
                controller: _paginatorController!.copyWith(
                  /// to put stream maps in inverse direction
                  addExtraMapsAtEnd: !_paginatorController!.addExtraMapsAtEnd,
                ),
                mounted: mounted,
              );
            }

          },
        );
      }

    }

  }
  // -----------------------------------------------------------------------------

  /// LISTENERS

  // --------------------
  void _scrollListener(){

    if (_paginatorController != null){
      paginationListener(
        canKeepReading: _paginatorController!.canKeepReading,
        controller: _paginatorController!.scrollController,
        isPaginating: _paginatorController!.isPaginating,
        onPaginate: () async {
          await _readMore();
        },
        mounted: mounted,
      );
    }

  }
  // -----------------------------------------------------------------------------

  /// READING

  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _readMore() async {
    
    await _triggerLoading(setTo: true);

    await _readMoreOfficial();

    await _triggerLoading(setTo: false);

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _readMoreOfficial() async {
    
    /// CAN KEEP READING
    if (mounted == true && Booler.boolIsTrue(_paginatorController?.canKeepReading.value)  == true){

      final List<Map<String, dynamic>>? _nextMaps = await OfficialFire.readColl(
        queryModel: widget.paginationQuery,
        startAfter: _paginatorController?.startAfter.value,
        addDocSnapshotToEachMap: true,
        onError: widget.onError,
      );

      if (Lister.checkCanLoop(_nextMaps) == true){

        PaginationController.insertMapsToPaginator(
          mapsToAdd: _nextMaps,
          controller: _paginatorController,
          mounted: mounted,
        );

      }

      else {
        setNotifier(
            notifier: _paginatorController?.canKeepReading,
            mounted: mounted,
            value: false
        );
      }

    }

    /// NO MORE MAPS TO READ
    else {
      blog('FireCollPaginator : _readMore : _canKeepReading : ${_paginatorController?.canKeepReading.value} '
          'isPaginating : ${_paginatorController?.isPaginating}'
      );
    }


  }
  // -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    
    return MultiWires(
        wires: <Wire?>[
          _loading,
          _paginatorController?.paginatorMaps,
        ],
        child: widget.child,
        builder: (Widget? child){

          final bool _isLoading = _loading.value;
          final List<Map<String, dynamic>> maps = _paginatorController?.paginatorMaps.value ?? [];

          return widget.builder(maps, _isLoading, child);

        }
        );

  }
  // -----------------------------------------------------------------------------
}
