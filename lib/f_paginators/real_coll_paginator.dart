// ignore_for_file: avoid_positional_boolean_parameters;
part of super_fire;

class RealCollPaginator extends StatefulWidget {
  /// --------------------------------------------------------------------------
  const RealCollPaginator({
    required this.builder,
    required this.paginationController,
    this.paginationQuery,
    this.child,
    this.onDataChanged,
    super.key
  });
  /// --------------------------------------------------------------------------
  final RealQueryModel? paginationQuery;
  final PaginationController? paginationController;
  final Widget? child;
  final ValueChanged<List<Map<String, dynamic>>>? onDataChanged;
  final Widget Function(
      BuildContext,
      List<Map<String, dynamic>> maps,
      bool isLoading,
      Widget? child
      ) builder;
  /// --------------------------------------------------------------------------
  @override
  _RealCollPaginatorState createState() => _RealCollPaginatorState();
  /// --------------------------------------------------------------------------
}

class _RealCollPaginatorState extends State<RealCollPaginator> {
  // -----------------------------------------------------------------------------
  late PaginationController _paginatorController;
  StreamSubscription? _sub;
  // -----------------------------------------------------------------------------
  /// --- LOADING
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  // --------------------
  Future<void> _triggerLoading({required bool setTo}) async {
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

    /// THOSE REFRESH THE WIDGET WHEN ITS REBUILT AGAIN ANAD AGAIN
    _paginatorController.clear();
    setNotifier(
      notifier: _paginatorController.canKeepReading,
      mounted: mounted,
      value: true,
    );
    
    /// REMOVED
    _paginatorController.scrollController.addListener(_scrollListener);

    /// ON CHILD ADDED TO PATH
    // _initializeOnChildAddedListener();

  }
  // --------------------
  bool _isInit = true;
  @override
  void didChangeDependencies() {

    if (_isInit && mounted) {
      _isInit = false; // good

      asyncInSync(() async {

        await _readMore();

      });

    }

    super.didChangeDependencies();
  }
  // --------------------
  @override
  void didUpdateWidget(covariant RealCollPaginator oldWidget) {

    asyncInSync(() async {

      final bool _paginationQueryChanged = RealQueryModel.checkQueriesAreIdentical(
        model1: oldWidget.paginationQuery,
        model2: widget.paginationQuery,
      ) == false;

      if (_paginationQueryChanged == true){

        _paginatorController.clear();

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
  // -----------------------------------------------------------------------------
  @override
  void dispose() {

    _paginatorController.scrollController.removeListener(_scrollListener);

    _loading.dispose();

    if (_sub != null){
      _sub!.cancel();
    }

    if (widget.paginationController == null){
      _paginatorController.dispose();
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
      addExtraMapsAtEnd: true,
      idFieldName: widget.paginationQuery?.idFieldName ?? 'id',
      onDataChanged: widget.onDataChanged,
    );

  }
  // --------------------
  /// streams the entire path at once
  /*
  void _initializeOnChildAddedListener(){

    _sub = RealStream.streamOnChildAddedToPath(
      path: widget.realQueryModel.path,
      onChildAdded: (dynamic map) async {

        // Mapper.blogMap(map, invoker: 'RealCollPaginator.Real.streamPath');

        if (_isInit == false){
          _paginatorController.addMap.value  = Mapper.getMapFromInternalHashLinkedMapObjectObject(
            internalHashLinkedMapObjectObject: map,
          );
        }

      },
    );

  }
   */
  // -----------------------------------------------------------------------------

  /// LISTENERS

  // --------------------
  void _scrollListener(){

    paginationListener(
      controller: _paginatorController.scrollController,
      isPaginating: _paginatorController.isPaginating,
      canKeepReading: _paginatorController.canKeepReading,
      mounted: mounted,
      onPaginate: () async {
        await _readMore();
      },
    );

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

      final List<Map<String, dynamic>> _nextMaps = await Real.readPathMaps(
        startAfter: _paginatorController.startAfter.value,
        realQueryModel: widget.paginationQuery,
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
            notifier: _paginatorController.canKeepReading,
            mounted: mounted,
            value: false,
        );
      }

    }

    /// NO MORE MAPS TO READ
    else {
      blog('FireCollPaginator : _readMore : _canKeepReading : ${_paginatorController.canKeepReading} :NO MORE MAPS AFTER THIS ');
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
