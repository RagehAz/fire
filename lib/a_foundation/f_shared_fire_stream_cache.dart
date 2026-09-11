part of super_fire;

/// De-dupes identical Firestore doc/collection listeners so two callers
/// asking for the exact same query/doc don't each open their own native
/// Firestore listener. Purely internal to `OfficialFire.streamColl` /
/// `OfficialFire.streamDoc` -- no public API changes, every existing
/// caller (widgets, `OfficialFireCollPaginator`'s `streamQuery`, etc.)
/// keeps working unmodified.
///
/// Safe by construction:
/// - the real listener is opened lazily, only once the first caller with
///   a given signature actually subscribes;
/// - every new subscriber (including the very first) gets the latest
///   known value/error replayed, so nothing regresses vs. today's "every
///   listener gets its own instant snapshot" behavior;
/// - the underlying listener is torn down and the cache entry evicted the
///   moment the last subscriber for that signature detaches -- a
///   signature with zero active listeners costs exactly nothing, same as
///   today. The *next* subscriber after that always builds a fresh
///   listener from scratch, never reuses a torn-down one.
class _SharedFireStream<T> {
  // --------------------------------------------------------------------------
  _SharedFireStream({
    required this.sourceBuilder,
    required this.onIdle,
  });
  // --------------------
  final Stream<T>? Function() sourceBuilder;
  final VoidCallback onIdle;
  // --------------------
  StreamSubscription<T>? _sourceSub;
  final Set<MultiStreamController<T>> _controllers = <MultiStreamController<T>>{};
  T? _lastValue;
  bool _hasValue = false;
  Object? _lastError;
  StackTrace? _lastStackTrace;
  bool _hasError = false;
  bool _done = false;
  // -----------------------------------------------------------------------------

  /// STREAM

  // --------------------
  Stream<T> get stream => Stream<T>.multi(isBroadcast: true, (MultiStreamController<T> controller) {

    /// REPLAY LATEST KNOWN STATE TO THIS NEW LISTENER
    if (_hasValue == true){
      controller.add(_lastValue as T);
    }
    if (_hasError == true){
      controller.addError(_lastError!, _lastStackTrace);
    }
    if (_done == true){
      controller.close();
      return;
    }

    _controllers.add(controller);

    /// LAZILY OPEN THE ONE REAL LISTENER ON FIRST SUBSCRIBER
    if (_sourceSub == null){

      final Stream<T>? _source = sourceBuilder();

      _sourceSub = _source?.listen(
        (T value){
          _hasValue = true;
          _lastValue = value;
          for (final MultiStreamController<T> c in _controllers.toList()){
            c.add(value);
          }
        },
        onError: (Object error, StackTrace stack){
          _hasError = true;
          _lastError = error;
          _lastStackTrace = stack;
          for (final MultiStreamController<T> c in _controllers.toList()){
            c.addError(error, stack);
          }
        },
        onDone: (){
          _done = true;
          for (final MultiStreamController<T> c in _controllers.toList()){
            c.close();
          }
          _controllers.clear();
        },
        cancelOnError: false,
      );

    }

    controller.onCancel = () {
      _controllers.remove(controller);
      if (_controllers.isEmpty){
        _sourceSub?.cancel();
        _sourceSub = null;
        onIdle();
      }
    };

  });
  // -----------------------------------------------------------------------------
}

abstract class _SharedFireStreamCache {
  // --------------------------------------------------------------------------
  static final Map<String, _SharedFireStream<List<Map<String, dynamic>>>> _collCache =
      <String, _SharedFireStream<List<Map<String, dynamic>>>>{};
  static final Map<String, _SharedFireStream<Map<String, dynamic>?>> _docCache =
      <String, _SharedFireStream<Map<String, dynamic>?>>{};
  // -----------------------------------------------------------------------------

  /// COLLECTION

  // --------------------
  static Stream<List<Map<String, dynamic>>>? streamColl({
    required FireQueryModel queryModel,
    required Stream<List<Map<String, dynamic>>>? Function() sourceBuilder,
  }) {

    final String _key = _collKey(queryModel);

    final _SharedFireStream<List<Map<String, dynamic>>> _shared = _collCache.putIfAbsent(
      _key,
      () => _SharedFireStream<List<Map<String, dynamic>>>(
        sourceBuilder: sourceBuilder,
        onIdle: () => _collCache.remove(_key),
      ),
    );

    return _shared.stream;
  }
  // --------------------
  static String _collKey(FireQueryModel queryModel){

    final StringBuffer _buffer = StringBuffer()
      ..write('coll:${queryModel.coll}|')
      ..write('doc:${queryModel.doc}|')
      ..write('subColl:${queryModel.subColl}|')
      ..write('limit:${queryModel.limit}|')
      ..write('orderBy:${queryModel.orderBy?.fieldName}:${queryModel.orderBy?.descending}|')
      ..write('finders:[');

    if (Lister.checkCanLoop(queryModel.finders) == true){
      for (final FireFinder finder in queryModel.finders!){
        _buffer.write('${finder.field}~${finder.comparison}~${finder.value.runtimeType}:${finder.value};');
      }
    }

    _buffer.write(']');

    return _buffer.toString();
  }
  // -----------------------------------------------------------------------------

  /// DOC

  // --------------------
  static Stream<Map<String, dynamic>?>? streamDoc({
    required String coll,
    required String doc,
    required Stream<Map<String, dynamic>?>? Function() sourceBuilder,
    String? subColl,
    String? subDoc,
  }) {

    final String _key = 'coll:$coll|doc:$doc|subColl:$subColl|subDoc:$subDoc';

    final _SharedFireStream<Map<String, dynamic>?> _shared = _docCache.putIfAbsent(
      _key,
      () => _SharedFireStream<Map<String, dynamic>?>(
        sourceBuilder: sourceBuilder,
        onIdle: () => _docCache.remove(_key),
      ),
    );

    return _shared.stream;
  }
  // -----------------------------------------------------------------------------
}
