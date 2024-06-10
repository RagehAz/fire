part of super_fire;

class OfficialRealDocStreamer extends StatelessWidget {
  /// --------------------------------------------------------------------------
  const OfficialRealDocStreamer({
    required this.coll,
    required this.doc,
    required this.builder,
    super.key
  });
  /// --------------------------------------------------------------------------
  final String coll;
  final String doc;
  final Widget Function(bool loading, Map<String, dynamic>? map) builder;
  /// --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<f_db.DatabaseEvent>(
        stream: OfficialFirebase.getReal()?.ref('$coll/$doc').onValue,
        builder: (_, snapshot){

          final f_db.DatabaseEvent? _event = snapshot.data;
          final f_db.DataSnapshot? _snap = _event?.snapshot;
          final Map<String, dynamic>? _map = _OfficialFireMapper.getMapFromDataSnapshot(
            snapshot: _snap,
            addDocID: true,
          );

          return builder(snapshot.connectionState == ConnectionState.waiting, _map);

        }
    );

  }
/// --------------------------------------------------------------------------
}

class OfficialRealPathStreamer extends StatelessWidget {
  /// --------------------------------------------------------------------------
  const OfficialRealPathStreamer({
    required this.path,
    required this.builder,
    super.key
  });
  /// --------------------------------------------------------------------------
  final String path;
  final Widget Function(bool loading, Map<String, dynamic>? map) builder;
  /// --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<f_db.DatabaseEvent>(
        stream: OfficialFirebase.getReal()?.ref(path).onValue,
        builder: (_, snapshot){

          final f_db.DatabaseEvent? _event = snapshot.data;
          final f_db.DataSnapshot? _snap = _event?.snapshot;
          final Map<String, dynamic>? _map = _OfficialFireMapper.getMapFromDataSnapshot(
            snapshot: _snap,
            addDocID: true,
          );

          return builder(snapshot.connectionState == ConnectionState.waiting, _map);

        }
    );

  }
  /// --------------------------------------------------------------------------
}
