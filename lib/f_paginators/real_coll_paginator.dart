// ignore_for_file: avoid_positional_boolean_parameters;
part of super_fire;

class RealCollPaginator extends StatefulWidget {
  /// --------------------------------------------------------------------------
  const RealCollPaginator({
    required this.builder,
    this.scrollController,
    this.realQueryModel,
    this.paginatorController,
    this.loadingWidget,
    this.child,
    super.key
  });
  /// --------------------------------------------------------------------------
  final ScrollController? scrollController;
  final RealQueryModel? realQueryModel;
  final PaginationController? paginatorController;
  final Widget? loadingWidget;
  final Widget? child;
  final Widget Function(
      BuildContext,
      List<Map<String, dynamic>>? maps,
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
  ScrollController? _controller;
  // --------------------
  final ValueNotifier<bool> _isPaginating = ValueNotifier(false);
  final ValueNotifier<bool> _canKeepReading = ValueNotifier(true);
  // --------------------
  PaginationController? _paginatorController;
  // -----------------------------------------------------------------------------
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

    // widget.realQueryModel.blogModel();

    /// SCROLLING
    _initializeScrollListeners();

    /// PAGINATOR CONTROLLER
    _initializePaginatorController();

    /// ON CHILD ADDED TO PATH
    // _initializeOnChildAddedListener();

  }
  // --------------------
  bool _isInit = true;
  @override
  void didChangeDependencies() {

    if (_isInit && mounted) {
      _isInit = false; // good

      _triggerLoading(setTo: true).then((_) async {

        await _readMore();

        await _triggerLoading(setTo: false);
      });

    }

    super.didChangeDependencies();
  }
  // --------------------
  @override
  void dispose() {
    _loading.dispose();
    _isPaginating.dispose();
    _canKeepReading.dispose();

    if (_sub != null){
      _sub!.cancel();
    }

    if (widget.paginatorController == null){
      _paginatorController?.dispose();
    }

    if (widget.scrollController == null){
      _controller?.dispose();
    }

    super.dispose();
  }
  // -----------------------------------------------------------------------------
  /// TESTED : WORKS PERFECT
  void _initializeScrollListeners(){
    _controller = widget.scrollController ?? ScrollController();
    Sliders.createPaginationListener(
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
    _paginatorController = widget.paginatorController ?? PaginationController.initialize(
      addExtraMapsAtEnd: false,
    );
    _paginatorController?.activateListeners(
      mounted: mounted,
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
  // --------------------
  ///
  Future<void> _readMore() async {

    setNotifier(
      notifier: _loading,
      mounted: mounted,
      value: true,
    );

    /// CAN KEEP READING
    if (_canKeepReading.value  == true){

      // if (_paginatorController?.startAfter?.value  == null){
      //   blog('should read more : ${_paginatorController.paginatorMaps.value.length} maps');
      // }
      // else {
      //   blog('x ---> should read more : ${_paginatorController.paginatorMaps.value.length} maps : '
      //       '${_paginatorController.startAfter.value['id']} : ${_paginatorController.startAfter.value['sentTime']}');
      // }

      final List<Map<String, dynamic>> _nextMaps = await Real.readPathMaps(
        startAfter: _paginatorController?.startAfter.value,
        realQueryModel: widget.realQueryModel,
        // addDocIDToEachMap: true,
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
            value: false,
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

    if (_paginatorController == null){
      return widget.loadingWidget ?? const SizedBox();
    }

    else {

      return ValueListenableBuilder(
          valueListenable: _paginatorController!.paginatorMaps,
          child: widget.child,
          builder: (_, List<Map<String, dynamic>>? maps, Widget? child){

            return widget.builder(context, maps, _loading.value, child);

          }
      );

    }

  }
// -----------------------------------------------------------------------------
}
