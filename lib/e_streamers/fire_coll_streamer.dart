part of super_fire;

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
    @required Stream<List<Map<String, dynamic>>> stream,
    @required ValueChanged<List<Map<String, dynamic>>> onChange,
    @required String invoker,
  }){

    final StreamSubscription _streamSubscription = stream.listen(
      (List<Map<String, dynamic>> maps) async {
        onChange(maps);
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
  Stream<List<Map<String, dynamic>>> _stream;
  StreamSubscription _sub;
  // -----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _stream = Fire.streamColl(
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

          return widget.builder(ctx, snapshot.data);

        }

      },
    );

  }
  // -----------------------------------------------------------------------------
}
