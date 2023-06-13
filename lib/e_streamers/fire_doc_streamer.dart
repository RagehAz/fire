part of super_fire;

class FireDocStreamer extends StatefulWidget {
  /// --------------------------------------------------------------------------
  const FireDocStreamer({
    @required this.collName,
    @required this.docName,
    @required this.builder,
    this.onDataChanged,
    this.initialMap,
    this.loadingWidget,
    Key key
  }) : super(key: key);
  /// --------------------------------------------------------------------------
  final String collName;
  final String docName;
  final Widget Function(BuildContext, Map<String, dynamic>) builder;
  final Function(BuildContext, Map<String, dynamic>, Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialMap;
  final Widget loadingWidget;
  /// --------------------------------------------------------------------------
  static Future<void> onStreamDataChanged({
    @required Stream<Map<String, dynamic>> stream,
    @required Map<String, dynamic> oldMap,
    @required bool mounted,
    @required Function(Map<String, dynamic> oldMap, Map<String, dynamic> newMap) onChange,
  }) async {

    stream.listen((Map<String, dynamic> newMap) async {

      // blog('xxx - onStreamDataChanged - snapshot : $snapshot');

      final bool _mapsAreTheSame = Mapper.checkMapsAreIdentical(
        map1: oldMap,
        map2: newMap,
      );

      // blog('FireDocStreamer - onStreamDataChanged - _oldMap == _newMap : $_mapsAreTheSame');


      if (_mapsAreTheSame == false){
        if (mounted == true){
          onChange(oldMap, newMap);
        }
      }


    },

      cancelOnError: false,

      onDone: (){
        // blog('FireDocStreamer : onStreamDataChanged : done');
      },

      onError: (Object error){
        // blog('FireDocStreamer : onStreamDataChanged : error : $error');
      },

    );


  }
  /// --------------------------------------------------------------------------
  @override
  _FireDocStreamerState createState() => _FireDocStreamerState();
  /// --------------------------------------------------------------------------
}

class _FireDocStreamerState extends State<FireDocStreamer> {
  // -----------------------------------------------------------------------------
  Stream<Map<String, dynamic>> _stream;
  final ValueNotifier<Map<String, dynamic>> _oldMap = ValueNotifier<Map<String, dynamic>>(null);
  StreamSubscription _sub;
  // -----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _stream = Fire.streamDoc(
      coll: widget.collName,
      doc: widget.docName,
    );

    _sub = _stream.listen((event) { });

    FireDocStreamer.onStreamDataChanged(
      stream: _stream,
      oldMap: _oldMap.value,
      mounted: mounted,
      onChange: widget.onDataChanged == null ? null : _onChanged,
    );

  }
  // --------------------
  void _onChanged (Map<String, dynamic> oldMap, Map<String, dynamic> newMap){
    if (mounted == true){
      widget.onDataChanged(context, oldMap, newMap);
      setNotifier(notifier: _oldMap, mounted: mounted, value: oldMap);
    }
  }
  // --------------------
  @override
  void dispose() {
      blog('FireDocStreamer : DISPOSING THE FUCKING PAGE');
      _oldMap.dispose();
      _sub.cancel();
      super.dispose();
  }
  // -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      key: const ValueKey<String>('FireDocStreamer'),
      stream: _stream,
      initialData: widget.initialMap,
      builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ?? widget.builder(ctx, null);
        }

        else {

          return widget.builder(ctx, snapshot.data);

        }

      },
    );

  }
// -----------------------------------------------------------------------------
}
