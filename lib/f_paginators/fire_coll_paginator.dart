part of super_fire;

class FireCollPaginator extends StatefulWidget {
  /// --------------------------------------------------------------------------
  const FireCollPaginator({
    required this.paginationQuery,
    required this.builder,
    required this.paginationController,
    this.streamQuery,
    this.child,
    this.onDataChanged,
    super.key
  });
  /// --------------------------------------------------------------------------
  final FireQueryModel? paginationQuery;
  final FireQueryModel? streamQuery;
  final Widget? child;
  final PaginationController? paginationController;
  final ValueChanged<List<Map<String, dynamic>>>? onDataChanged;
  final Widget Function(
      BuildContext context,
      List<Map<String, dynamic>> maps,
      bool isLoading,
      Widget? child
      ) builder;
  /// --------------------------------------------------------------------------
  @override
  _FireCollPaginatorState createState() => _FireCollPaginatorState();
  /// --------------------------------------------------------------------------
}

class _FireCollPaginatorState extends State<FireCollPaginator> {
  // -----------------------------------------------------------------------------
  late PaginationController _paginatorController;
  StreamSubscription? _streamSub;
  final ValueNotifier<List<Map<String, dynamic>>> _streamOldMaps = ValueNotifier<List<Map<String, dynamic>>>([]);
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

    /// PAGINATOR CONTROLLER
    _initializePaginatorController();

    /// LISTEN TO SCROLL
    _initializeScrollListener();

  }
  // --------------------
  bool _isInit = true;
  @override
  void didChangeDependencies() {

    if (_isInit && mounted) {
      _isInit = false; // good

      asyncInSync(() async {

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
  void didUpdateWidget(covariant FireCollPaginator oldWidget) {

    asyncInSync(() async {

      final bool _paginationQueryChanged = FireQueryModel.checkQueriesAreIdentical(
        model1: oldWidget.paginationQuery,
        model2: widget.paginationQuery,
      ) == false;

      final bool _streamQueryChanged = FireQueryModel.checkQueriesAreIdentical(
        model1: oldWidget.streamQuery,
        model2: widget.streamQuery,
      ) == false;

      if (
          _paginationQueryChanged == true
          ||
          _streamQueryChanged == true
      ){

        _paginatorController.clear(
          mounted: mounted,
        );

        setNotifier(
            notifier: _paginatorController.canKeepReading,
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

    _streamOldMaps.dispose();
    _loading.dispose();

    /// STATE ARE HANDLED INTERNALLY
    if (widget.paginationController == null){
      _paginatorController.dispose();
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
      addExtraMapsAtEnd: widget.paginationController?.addExtraMapsAtEnd ?? true,
      idFieldName: widget.paginationQuery?.idFieldName ?? 'id',
      onDataChanged: widget.onDataChanged,
    );

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  void _initializeScrollListener(){

      createPaginationListener(
          controller: _paginatorController.scrollController,
          isPaginating: _paginatorController.isPaginating,
          canKeepReading: _paginatorController.canKeepReading,
          mounted: mounted,
          onPaginate: () async {
            await _readMore();
          }
      );

    }
  // --------------------
  /// TESTED : WORKS PERFECT
  void _initializeStreamListener(){

    if (widget.streamQuery != null){

      final Stream<List<Map<String, dynamic>>>? _stream = Fire.streamColl(
        queryModel: widget.streamQuery!,
      );

      _streamSub = FireCollStreamer.initializeStreamListener(
        stream: _stream,
        mounted: mounted,
        oldMaps: _streamOldMaps,
        onChanged: (List<Map<String, dynamic>> oldMaps, List<Map<String, dynamic>> newMaps){

          // final List<Map<String, dynamic>> _allMaps = [..._paginatorController.paginatorMaps.value];
          // blog(' === > streamMaps : ${streamMaps.length} maps');

          PaginationController.insertMapsToPaginator(
            mapsToAdd: newMaps,
            controller: _paginatorController.copyWith(
              /// to put stream maps in inverse direction
              addExtraMapsAtEnd: !_paginatorController.addExtraMapsAtEnd,
            ),
            mounted: mounted,
          );

        },
      );

    }

  }
  // -----------------------------------------------------------------------------

  /// READING

  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _readMore() async {

    blog('read more');

    await _triggerLoading(setTo: true);

    /// CAN KEEP READING
    if (_paginatorController.canKeepReading.value  == true){

      final List<Map<String, dynamic>>? _nextMaps = await Fire.readColl(
        queryModel: widget.paginationQuery,
        startAfter: _paginatorController.startAfter.value,
        addDocSnapshotToEachMap: true,
      );

      if (Mapper.checkCanLoopList(_nextMaps) == true){

        PaginationController.insertMapsToPaginator(
          mapsToAdd: _nextMaps,
          controller: _paginatorController,
          mounted: mounted,
        );

      }

      else {
        setNotifier(
            notifier: _paginatorController.canKeepReading,
            mounted: mounted,
            value: false
        );
      }

    }

    /// NO MORE MAPS TO READ
    else {
      blog('FireCollPaginator : _readMore : _canKeepReading : ${_paginatorController.canKeepReading.value} '
      'isPaginating : ${_paginatorController.isPaginating}'
          );
    }

    await _triggerLoading(setTo: false);

  }
  // -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
        valueListenable: _loading,
        child: widget.child,
        builder: (_, bool _isLoading, Widget? child){

          return ValueListenableBuilder(
              valueListenable: _paginatorController.paginatorMaps,
              builder: (_, List<Map<String, dynamic>> maps, Widget? xChild){

                // Mapper.blogMaps(maps, invoker: 'FireCollPaginator : builder');

                return widget.builder(context, maps, _isLoading, child);

              });

        }
    );

  }
  // -----------------------------------------------------------------------------
}
