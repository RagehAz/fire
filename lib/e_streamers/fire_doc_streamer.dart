part of super_fire;

class FireDocStreamer extends StatefulWidget {
  // --------------------------------------------------------------------------
  const FireDocStreamer({
    required this.collName,
    required this.docName,
    required this.builder,
    this.onChanged,
    this.initialMap,
    super.key
  });
  // --------------------
  final String collName;
  final String docName;
  final Widget Function(bool loading, Map<String, dynamic>? map) builder;
  final Function(Map<String, dynamic>? oldMap, Map<String, dynamic>? newMap)? onChanged;
  final Map<String, dynamic>? initialMap;
  // --------------------------------------------------------------------------
  /// TESTED : WORKS PERFECT
  static StreamSubscription? initializeStreamListener({
    required Stream<Map<String, dynamic>?>? stream,
    required ValueNotifier<Map<String, dynamic>?> oldMap,
    required bool mounted,
    required Function(Map<String, dynamic>? oldMap, Map<String, dynamic>? newMap)? onChanged,
  }) {

    final StreamSubscription? _sub =
    stream?.listen(

          /// LISTENER
          (Map<String, dynamic>? newMap) => _streamListener(
            mounted: mounted,
            newMap: newMap,
            oldMap: oldMap,
            onChanged: onChanged,
          ),

          /// CANCEL
          cancelOnError: false,

          /// ON DONE
          onDone: (){
            // blog('FireDocStreamer : onStreamDataChanged : done');
          },

          /// ON ERROR
          onError: (Object error){
            // blog('FireDocStreamer : onStreamDataChanged : error : $error');
          },

    );


    return _sub;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static void _streamListener({
    required Map<String, dynamic>? newMap,
    required ValueNotifier<Map<String, dynamic>?> oldMap,
    required Function(Map<String, dynamic>? oldMap, Map<String, dynamic>? newMap)? onChanged,
    required bool mounted,
  }) {

    // blog('xxx - onStreamDataChanged - snapshot : $snapshot');

    final bool _mapsAreTheSame = Mapper.checkMapsAreIdentical(
      map1: oldMap.value,
      map2: newMap,
    );

    // blog('FireDocStreamer - onStreamDataChanged - _oldMap == _newMap : $_mapsAreTheSame');

    if (_mapsAreTheSame == false){
      if (mounted == true){
        onChanged?.call(oldMap.value, newMap);
        setNotifier(notifier: oldMap, mounted: mounted, value: newMap);
      }
    }

  }
  // --------------------------------------------------------------------------
  @override
  _FireDocStreamerState createState() => _FireDocStreamerState();
  // --------------------------------------------------------------------------
}

class _FireDocStreamerState extends State<FireDocStreamer> {
  // -----------------------------------------------------------------------------
  late Stream<Map<String, dynamic>?>? _stream;
  final ValueNotifier<Map<String, dynamic>?> _oldMap = ValueNotifier<Map<String, dynamic>?>(null);
  StreamSubscription? _sub;
  // -----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _stream = Fire.streamDoc(
      coll: widget.collName,
      doc: widget.docName,
    );

    _sub = FireDocStreamer.initializeStreamListener(
      stream: _stream,
      oldMap: _oldMap,
      mounted: mounted,
      onChanged: widget.onChanged,
    );

  }
  // --------------------
  @override
  void dispose() {
      _oldMap.dispose();
      _sub?.cancel();
      super.dispose();
  }
  // -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      key: const ValueKey<String>('FireDocStreamer'),
      stream: _stream,
      initialData: widget.initialMap,
      builder: (BuildContext ctx, AsyncSnapshot<dynamic>? snapshot) {

        return widget.builder(snapshot?.connectionState == ConnectionState.waiting, snapshot?.data);

      },
    );

  }
// -----------------------------------------------------------------------------
}
