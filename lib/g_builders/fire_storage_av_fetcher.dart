part of super_fire;
/// => TAMAM
class FireStorageAvFetcher extends StatefulWidget {
  // --------------------------------------------------------------------------
  const FireStorageAvFetcher({
    required this.imagePath,
    required this.ldbDocName,
    required this.builder,
    required this.skipMetaData,
    super.key
  });
  // --------------------------------------------------------------------------
  final String imagePath;
  final String ldbDocName;
  final Function(bool isLoading, AvModel? picModel) builder;
  final bool skipMetaData;
  // --------------------------------------------------------------------------
  @override
  _FireStorageAvFetcherState createState() => _FireStorageAvFetcherState();
// --------------------------------------------------------------------------
}

class _FireStorageAvFetcherState extends State<FireStorageAvFetcher> {
  // -----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
  }
  // --------------------
  bool _isInit = true;
  @override
  void didChangeDependencies() {

    if (_isInit == true && mounted == true) {
      _isInit = false; // good

      asyncInSync(() async {

        await load();

      });

    }
    super.didChangeDependencies();
  }
  // --------------------
  @override
  void didUpdateWidget(FireStorageAvFetcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (
        oldWidget.imagePath != widget.imagePath ||
        oldWidget.ldbDocName != widget.ldbDocName ||
        oldWidget.skipMetaData != widget.skipMetaData
    ) {
      load();
    }
  }
  // --------------------
  @override
  void dispose() {
    super.dispose();
  }
  // -----------------------------------------------------------------------------
  bool _isLoading = true;
  AvModel? _avModel;
  // --------------------
  Future<void> load() async {

    if (mounted && _isLoading == false){
      setState(() {
        _isLoading = true;
      });
    }

    final AvModel? _av = await OfficialStorage.fetchAv(
      uploadPath: widget.imagePath,
      bobDocName: widget.ldbDocName,
      skipMeta: widget.skipMetaData,
    );

    if (mounted == true){
      setState(() {
        _avModel = _av;
        _isLoading = false;
      });
    }

  }
  // -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // --------------------
    return widget.builder(_isLoading, _avModel);
    // --------------------
  }
  // -----------------------------------------------------------------------------
}
