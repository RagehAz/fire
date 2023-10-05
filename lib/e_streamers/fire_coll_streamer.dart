part of super_fire;

class FireCollStreamer extends StatefulWidget {
  // --------------------------------------------------------------------------
  const FireCollStreamer({
    required this.queryModel,
    required this.builder,
    this.onChanged,
    super.key
  });
  // --------------------
  final FireQueryModel queryModel;
  final Widget Function(bool loading, List<Map<String, dynamic>> maps) builder;
  final Function(List<Map<String, dynamic>> oldMap, List<Map<String, dynamic>> newMap)? onChanged;
  // --------------------------------------------------------------------------
  /// TESTED : WORKS PERFECT
  static StreamSubscription? initializeStreamListener({
    required Stream<List<Map<String, dynamic>>>? stream,
    required bool mounted,
    required ValueNotifier<List<Map<String, dynamic>>> oldMaps,
    required Function(List<Map<String, dynamic>> oldMap, List<Map<String, dynamic>> newMap)? onChanged,
  }){

    final StreamSubscription? _sub =
    stream?.listen(

          /// LISTENER
          (List<Map<String, dynamic>> newMaps) => _streamListener(
            mounted: mounted,
            newMaps: newMaps,
            oldMaps: oldMaps,
            onChanged: onChanged,
          ),

          /// CANCEL
          cancelOnError: false,

          /// ON DONE
          onDone: (){
            blog('FireDocStreamer : onStreamDataChanged : done');
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
    required List<Map<String, dynamic>> newMaps,
    required ValueNotifier<List<Map<String, dynamic>>> oldMaps,
    required Function(List<Map<String, dynamic>> oldMap, List<Map<String, dynamic>> newMap)? onChanged,
    required bool mounted,
  }) {

    // Mapper.blogMaps(oldMaps.value,invoker: 'old');
    // Mapper.blogMaps(newMaps,invoker: 'new');

    final bool _mapsAreIdentical = Mapper.checkMapsListsAreIdentical(
      maps1: newMaps,
      maps2: oldMaps.value,
    );

    if (_mapsAreIdentical == false){
      if (mounted == true){
        onChanged?.call(oldMaps.value, newMaps);

        setNotifier(notifier: oldMaps, mounted: mounted, value: newMaps);
      }
    }

  }
  // --------------------------------------------------------------------------
  @override
  State<FireCollStreamer> createState() => _FireCollStreamerState();
  // --------------------------------------------------------------------------
}

class _FireCollStreamerState extends State<FireCollStreamer> {
  // -----------------------------------------------------------------------------
  late Stream<List<Map<String, dynamic>>>? _stream;
  final ValueNotifier<List<Map<String, dynamic>>> _oldMaps = ValueNotifier<List<Map<String, dynamic>>>([]);
  StreamSubscription? _sub;
  // -----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _stream = Fire.streamColl(
      queryModel: widget.queryModel,
    );

    _sub = FireCollStreamer.initializeStreamListener(
      stream: _stream,
      mounted: mounted,
      oldMaps: _oldMaps,
      onChanged: widget.onChanged,
    );

  }
  // --------------------
  @override
  void dispose() {
    _oldMaps.dispose();
    _sub?.cancel();
    super.dispose();
  }
  // -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      key: const ValueKey<String>('FireCollStreamer'),
      stream: _stream,
      initialData: widget.queryModel.initialMaps ?? <Map<String, dynamic>>[],
      builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {

        return widget.builder(snapshot.connectionState == ConnectionState.waiting, snapshot.data);

      },
    );

  }
  // -----------------------------------------------------------------------------
}
