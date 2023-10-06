part of super_fire;

class RealCollStreamer extends StatelessWidget {
  /// --------------------------------------------------------------------------
  const RealCollStreamer({
    required this.coll,
    required this.builder,
    this.limit = 10,
   super.key
  });
  /// --------------------------------------------------------------------------
  final String coll;
  final Widget Function(bool loading, List<Map<String, dynamic>> maps) builder;
  final int limit;
  /// --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    if (FirebaseInitializer.isUsingOfficialPackages() == true){

      return StreamBuilder<f_db.DatabaseEvent>(
          stream: OfficialFirebase.getReal()?.ref(coll).limitToFirst(limit).onValue,
          builder: (_, snapshot){

            final List<f_db.DataSnapshot>? _snapshots = snapshot.data?.snapshot.children.toList();
            final List<Map<String, dynamic>> _maps = _OfficialFireMapper.getMapsFromDataSnapshots(
              snapshots: _snapshots,
              addDocsIDs: true,
            );

            return builder(snapshot.connectionState == ConnectionState.waiting, _maps);

          });

    }

    else {

      return StreamBuilder<f_d.Event>(
          stream: _NativeFirebase.getReal()?.reference().child(coll).limitToFirst(limit).onValue,
          builder: (_, snapshot){

            final f_d.Event? _event = snapshot.data;
            final f_d.DataSnapshot? _snap = _event?.snapshot;

            final List<Map<String, dynamic>> _maps = _NativeFireMapper.getMapsFromDataSnapshot(
              snapshot: _snap,
            );

            return builder(snapshot.connectionState == ConnectionState.waiting, _maps);

          });

    }


  }
/// --------------------------------------------------------------------------
}
