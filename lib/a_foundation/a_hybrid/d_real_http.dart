part of super_fire;

/// REAL TIME DB METHODS
abstract class RealHttp{
  // -----------------------------------------------------------------------------

  const RealHttp();

  // -----------------------------------------------------------------------------

  /// REFERENCES

  // --------------------
  static Uri collectionLink(String collName){
    return Uri.parse('https://bldrsnet.firebaseio.com/$collName.json');
  }
  // --------------------
  static Uri docLink({
    @required String collName,
    @required String docName,
  }){
    return Uri.parse('https://bldrsnet.firebaseio.com/$collName/$docName.json');
  }
  // -----------------------------------------------------------------------------

  /// CREATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<String> createDoc({
    @required BuildContext context,
    @required String collName,
    @required Map<String, Object> input,
    Function(String error) onError,
  }) async {

    String _docID;

    await tryAndCatch(
        functions: () async {

          /// post map to realtime database
          final http.Response _response = await http.post(
            collectionLink(collName),
            body: json.encode(input),
          );

          blog('response is : $_response');

          /// --- get doc ID;
          _docID = json.decode(_response.body)['name'];

        },
        onError: (String error) => onError(error),

    );

    return _docID;
  }
  // -----------------------------------------------------------------------------
  /// TESTED : WORKS PERFECT
  static Future<void> createNamedDoc({
    @required BuildContext context,
    @required String collName,
    @required String docName,
    @required Map<String, Object> input,
  }) async {

    await updateDoc(
      context: context,
      collName: collName,
      docName: docName,
      input: input,
    );

  }
  // -----------------------------------------------------------------------------

  /// READ

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<Map<String, Object>> readDoc({
    @required BuildContext context,
    @required String collName,
    @required String docName,
    Function(String error) onError,
  }) async {

    Map<String, Object> _map;

    await tryAndCatch(
        functions: () async {

          /// READ data
          final http.Response response = await http.get(
              docLink(
                collName: collName,
                docName: docName,
              )
          );

          _map = json.decode(response.body);

        },
        onError: (String error) => onError(error),
    );

    return _map;
  }
  // -----------------------------------------------------------------------------

  /// UPDATE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> updateDoc({
    @required BuildContext context,
    @required String collName,
    @required String docName,
    @required Map<String, Object> input,
    Function(String error) onError,
  }) async {

    await tryAndCatch(
        functions: () async {

          /// post map to realtime database
          final http.Response _response = await http.patch(
            docLink(
              collName: collName,
              docName: docName,
            ),
            body: json.encode(input),
          );

          blog('response is : $_response');

          /// --- get things
          // dynamic things = json.decode(_response.body)['name'];

        },
        onError: (String error) => onError(error),

    );

  }
  // -----------------------------------------------------------------------------

  /// DELETE

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> deleteDoc({
    @required BuildContext context,
    @required String collName,
    @required String docName,
    Function(http.Response response) onError,
  }) async {

    final http.Response _response = await http.delete(docLink(collName: collName, docName: docName),);

    if(_response.statusCode >= 400){

      // can assign 'failed' value to a variable and return it from here
      // to be able to handle failed scenarios to see wether to keep or delete
      // the doc locally on providers or ldbs

      await onError(_response);

      // throw HttpException('Could not delete Business');
    }

  }
  // -----------------------------------------------------------------------------
}
