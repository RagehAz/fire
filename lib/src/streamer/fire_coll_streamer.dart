part of fire;

class FireCollStreamer extends StatefulWidget {
  /// --------------------------------------------------------------------------
  const FireCollStreamer({
    @required this.queryModel,
    @required this.builder,
    this.onDataChange,
    this.loadingWidget,
    Key key
  }) : super(key: key);
  /// --------------------------------------------------------------------------
  final FireQueryModel queryModel;
  final Widget Function(BuildContext, List<Map<String, dynamic>>) builder;
  final Widget loadingWidget;
  final ValueChanged<List<Map<String, dynamic>>> onDataChange;
  // --------------------------------------------------------------------------
  /// TESTED : WORKS PERFECT
  static StreamSubscription onStreamDataChanged({
    @required Stream<QuerySnapshot<Object>> stream,
    @required ValueChanged<List<Map<String, dynamic>>> onChange,
    @required String invoker,
  }){

    final StreamSubscription _streamSubscription = stream.listen((QuerySnapshot<Object> snapshot) async {

      final List<Map<String, dynamic>> _newMaps = Mapper.getMapsFromQuerySnapshot(
        querySnapshot: snapshot,
        addDocsIDs: true,
        addDocSnapshotToEachMap: true,
      );

      onChange(_newMaps);

    },

      cancelOnError: false,

      onDone: (){
        blog('FireCollStreamer ($invoker) : onStreamDataChanged done');
      },

      onError: (Object error){
        blog('FireCollStreamer ($invoker) : onStreamDataChanged error : $error');
      },

    );

    return _streamSubscription;
  }
  /// --------------------------------------------------------------------------
  @override
  State<FireCollStreamer> createState() => _FireCollStreamerState();
  /// --------------------------------------------------------------------------
}

class _FireCollStreamerState extends State<FireCollStreamer> {
  // -----------------------------------------------------------------------------
  Stream<QuerySnapshot<Object>> _stream;
  StreamSubscription _sub;
  // -----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _stream = Fire.streamCollection(
      queryModel: widget.queryModel,
    );

    _sub =  _stream.listen((event) { });

    FireCollStreamer.onStreamDataChanged(
      stream: _stream,
      invoker: 'initState of FireCollStreamer',
      onChange: _onDataChanged,
    );

  }
  // --------------------
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
  // -----------------------------------------------------------------------------
  /// TESTED :
  void _onDataChanged(List<Map<String, dynamic>> newMaps){

    if (widget.onDataChange != null){
      if (mounted == true){
        widget.onDataChange(newMaps);
      }
    }

  }
  // -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: _stream,
      initialData: widget.queryModel.initialMaps ?? <Map<String, dynamic>>[],
      builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ?? widget.builder(ctx, <Map<String, dynamic>>[]);
        }

        else {

          final List<Map<String, dynamic>> _maps = Mapper.getMapsFromQuerySnapshot(
            querySnapshot: snapshot.data,
            addDocsIDs: true,
            addDocSnapshotToEachMap: true,
          );
          return widget.builder(ctx, _maps);

        }

      },
    );

  }
  // -----------------------------------------------------------------------------
}
