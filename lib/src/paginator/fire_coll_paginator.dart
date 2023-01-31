part of fire;

class FireCollPaginator extends StatefulWidget {
  /// --------------------------------------------------------------------------
  const FireCollPaginator({
    @required this.paginationQuery,
    @required this.builder,
    this.streamQuery,
    this.scrollController,
    this.loadingWidget,
    this.child,
    this.paginationController,
    this.onDataChanged,
    Key key
  }) : super(key: key);
  /// --------------------------------------------------------------------------
  final FireQueryModel paginationQuery;
  final FireQueryModel streamQuery;
  final Widget loadingWidget;
  final ScrollController scrollController;
  final Widget child;
  final PaginationController paginationController;
  final ValueChanged<List<Map<String, dynamic>>> onDataChanged;
  final Widget Function(
      BuildContext context,
      List<Map<String, dynamic>> maps,
      bool isLoading,
      Widget child
      ) builder;
  /// --------------------------------------------------------------------------
  @override
  _FireCollPaginatorState createState() => _FireCollPaginatorState();
  /// --------------------------------------------------------------------------
}

class _FireCollPaginatorState extends State<FireCollPaginator> {
  // -----------------------------------------------------------------------------
  ScrollController _controller;
  // --------------------
  final ValueNotifier<bool> _isPaginating = ValueNotifier(false);
  final ValueNotifier<bool> _canKeepReading = ValueNotifier(true);
  // --------------------
  PaginationController _paginatorController;
  StreamSubscription _streamSub;
  // -----------------------------------------------------------------------------
  /// --- LOADING
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  // --------------------
  Future<void>  _triggerLoading({@required bool setTo}) async {
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

    /// LISTEN TO SCROLL
    _initializeScrollListener();

    /// PAGINATOR CONTROLLER
    _initializePaginatorController();


  }
  // --------------------
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit && mounted) {

      _triggerLoading(setTo: true).then((_) async {

        /// INITIAL PAGINATION READ
        await _readMore();

        /// LISTEN TO STREAM CHANGES
        _initializeStreamListener();

          await _triggerLoading(setTo: false);
      });

      _isInit = false;
    }
    super.didChangeDependencies();
  }
  // --------------------
  @override
  void dispose() {
    _loading.dispose();
    _isPaginating.dispose();
    _canKeepReading.dispose();

    if (widget.paginationController == null){
      _paginatorController.dispose();
    }

    if (widget.scrollController == null){
      _controller.dispose();
    }

    if (_streamSub != null){
      _streamSub.cancel();
    }

    super.dispose();
  }
  // --------------------
  @override
  void didUpdateWidget(covariant FireCollPaginator oldWidget) {

    _triggerLoading(setTo: true).then((_) async {

      final bool _paginationQueryChanged = FireQueryModel.checkQueriesHaveNotChanged(
        model1: oldWidget.paginationQuery,
        model2: widget.paginationQuery,
      ) == false;

      final bool _streamQueryChanged = FireQueryModel.checkQueriesHaveNotChanged(
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
            notifier: _canKeepReading,
            mounted: mounted,
            value: true,
        );

        await _readMore();

      }

    });

    super.didUpdateWidget(oldWidget);
  }
  // -----------------------------------------------------------------------------

  /// INITIALIZATION

  // --------------------
  /// TESTED : WORKS PERFECT
  void _initializeScrollListener(){

      _controller = widget.scrollController ?? ScrollController();

      createPaginationListener(
          controller: _controller,
          isPaginating: _isPaginating,
          canKeepReading: _canKeepReading,
          mounted: mounted,
          onPaginate: () async {
            await _readMore();
          }
      );

    }
  // --------------------
  /// TESTED : WORKS PERFECT
  void _initializePaginatorController(){

    /// LISTEN TO PAGINATOR CONTROLLER NOTIFIERS (AddMap - replaceMap - deleteMap - onDataChanged)
    _paginatorController = widget.paginationController ?? PaginationController.initialize(
      addExtraMapsAtEnd: true,
      idFieldName: widget.paginationQuery.idFieldName,
      onDataChanged: widget.onDataChanged,
    );
    _paginatorController?.activateListeners(
      mounted: mounted,
    );

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  void _initializeStreamListener(){

    if (widget.streamQuery != null){

      final Stream<QuerySnapshot<Object>> _stream = Fire.streamCollection(
        queryModel: widget.streamQuery,
      );

      _streamSub = FireCollStreamer.onStreamDataChanged(
        stream: _stream,
        invoker: '_initializeStreamListener',
        onChange: (List<Map<String, dynamic>> streamMaps){

          // final List<Map<String, dynamic>> _allMaps = [..._paginatorController.paginatorMaps.value];
          // blog(' === > streamMaps : ${streamMaps.length} maps');

          PaginationController.insertMapsToPaginator(
            mapsToAdd: streamMaps,
            controller: _paginatorController,
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

    setNotifier(
      notifier: _loading,
      mounted: mounted,
      value: true,
    );

    /// CAN KEEP READING
    if (_canKeepReading.value  == true){

      final List<Map<String, dynamic>> _nextMaps = await Fire.superCollPaginator(
        queryModel: widget.paginationQuery,
        startAfter: _paginatorController.startAfter.value,
        addDocsIDs: true,
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
            notifier: _canKeepReading,
            mounted: mounted,
            value: false
        );
      }

    }

    /// NO MORE MAPS TO READ
    else {
      // blog('FireCollPaginator : _readMore : _canKeepReading : $_canKeepReading : NO MORE MAPS AFTER THIS ${_startAfter.toString()}');
    }

    setNotifier(
      notifier: _loading,
      mounted: mounted,
      value: false,
    );

  }
  // -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
        valueListenable: _loading,
        child: widget.child,
        builder: (_, bool _isLoading, Widget child){

          return ValueListenableBuilder(
              valueListenable: _paginatorController.paginatorMaps,
              builder: (_, List<Map<String, dynamic>> maps, Widget xChild){

                // Mapper.blogMaps(maps, invoker: 'FireCollPaginator : builder');

                return widget.builder(context, maps, _isLoading, child);

              });

        }
    );

  }
  // -----------------------------------------------------------------------------
}
