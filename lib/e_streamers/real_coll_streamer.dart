part of super_fire;

class RealCollStreamer extends StatelessWidget {
  /// --------------------------------------------------------------------------
  const RealCollStreamer({
    required this.coll,
    required this.builder,
    this.loadingWidget,
    this.noValueWidget,
    this.limit = 10,
   super.key
  });
  /// --------------------------------------------------------------------------
  final String coll;
  final Widget? loadingWidget;
  final Widget? noValueWidget;
  final Widget Function(BuildContext, List<Map<String, dynamic>> maps) builder;
  final int limit;
  /// --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<f_db.DatabaseEvent>(
        stream: f_db.FirebaseDatabase.instance.ref(coll).limitToFirst(limit).onValue,
        builder: (_, snapshot){

          /// LOADING
          if (snapshot.connectionState == ConnectionState.waiting){
            return loadingWidget ?? const SizedBox();
          }

          /// NO DATA
          else if (snapshot.hasData == false){
            return noValueWidget ?? const SizedBox();
          }

          /// RECEIVED DATA
          else {

            final List<f_db.DataSnapshot>? _snapshots = snapshot.data?.snapshot.children.toList();

            final List<Map<String, dynamic>>? _maps = _OfficialFireMapper.getMapsFromDataSnapshots(
              snapshots: _snapshots,
              addDocsIDs: true,
            );

            /// NO DATA
            if (Mapper.checkCanLoopList(_maps) == false){
              return noValueWidget ?? const SizedBox();
            }

            /// DATA IS GOOD
            else {
              return builder(context, _maps!);
            }

          }

        }
    );

  }
/// --------------------------------------------------------------------------
}
