part of super_fire;

abstract class OfficialModelling {
  // --------------------------------------------------------------------------

  /// GETTERS

  // --------------------
  /// TESTED : WORKS PERFECT
  static AuthModel? getAuthModelFromOfficialUserCredential({
    required f_a.UserCredential? cred,
    Map<String, dynamic>? addData,
  }){
    AuthModel? _output;

    if (cred != null){

      _output = AuthModel(
        id: cred.user?.uid,
        name: cred.user?.displayName,
        email: cred.user?.email,
        phone: cred.user?.phoneNumber,
        imageURL: _getUserImageURLFromOfficialUserCredential(cred),
        signInMethod: OfficialAuthing._getSignInMethodFromUser(user: cred.user),
        data: _createAuthModelDataMap(
          cred: cred,
          addData: addData,
        ),
      );

    }

    return _output;
  }
  // --------------------
  /// SOCIAL_AUTHING_DISASTER

  /// TESTED : WORKS PERFECT
  static AuthModel? getAuthModelFromOfficialFirebaseUser({
    required f_a.User? user,
  }){
    AuthModel? _output;

    if (user != null){

      _output = AuthModel(
        id: user.uid,
        name: user.displayName,
        email: user.email,
        phone: user.phoneNumber,
        imageURL: user.photoURL,
        signInMethod: OfficialAuthing._getSignInMethodFromUser(user: user),
        data: Mapper.cleanNullPairs(
          map: {
            'user.emailVerified': user.emailVerified,
            'user.isAnonymous': user.isAnonymous,
            'user.metadata': user.metadata.toString(),
            'user.providerData': cipherUserInfos(user.providerData),
            'user.refreshToken': user.refreshToken,
            'user.tenantId': user.tenantId,
          },
        ),
      );

    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, dynamic>? _createAuthModelDataMap({
    required f_a.UserCredential? cred,
    required Map<String, dynamic>? addData,
  }) {
    Map<String, dynamic> _map = {
      'credential.user.emailVerified': cred?.user?.emailVerified,
      'credential.user.isAnonymous': cred?.user?.isAnonymous,
      'credential.user.metadata': cred?.user?.metadata.toString(),
      'credential.user.photoURL': cred?.user?.photoURL,
      'credential.user.providerData': cipherUserInfos(cred?.user?.providerData),
      'credential.user.refreshToken': cred?.user?.refreshToken,
      'credential.user.tenantId': cred?.user?.tenantId,
      // 'credential.user.multiFactor': cred.user?.multiFactor?.toString(), // gets Instance of 'MultiFactor'
      'credential.credential.accessToken': cred?.credential?.accessToken,
      'credential.credential.providerId': cred?.credential?.providerId,
      'credential.credential.signInMethod': cred?.credential?.signInMethod,
      'credential.credential.token': cred?.credential?.token,
      'credential.additionalUserInfo.providerId': cred?.additionalUserInfo?.providerId,
      'credential.additionalUserInfo.isNewUser': cred?.additionalUserInfo?.isNewUser,
      'credential.additionalUserInfo.profile': Mapper.cleanNullPairs(map: cred?.additionalUserInfo?.profile),
      'credential.additionalUserInfo.username': cred?.additionalUserInfo?.username,
    };

    _map = Mapper.insertMapInMap(
      baseMap: _map,
      insert: addData,
      replaceDuplicateKeys: false,
    );

    return Mapper.cleanNullPairs(
      map: _map,
    );
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static AuthModel? getAuthModelFromAppleCred({
    required AuthorizationCredentialAppleID? cred,
  }) {
    AuthModel? _output;

    if (cred != null){

      _output = AuthModel(
        id: cred.userIdentifier,
        name: cred.givenName,
        email: cred.email,
        phone: null,
        imageURL: null,
        signInMethod: SignInMethod.apple,
        data: Mapper.cleanNullPairs(
          map: {
            'authorizationCredentialAppleID.authorizationCode': cred.authorizationCode,
            'authorizationCredentialAppleID.familyName': cred.familyName,
            'authorizationCredentialAppleID.identityToken': cred.identityToken,
            'authorizationCredentialAppleID.state': cred.state,
          },
        ),
      );
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static List<Map<String, String?>>? cipherUserInfos(List<f_a.UserInfo>? userInfos){

    List<Map<String, String?>>? _maps;

    if (Lister.checkCanLoop(userInfos) == true){

      _maps = <Map<String, String?>>[];

      for (final f_a.UserInfo info in userInfos!){
        final Map<String, String?>? _infoMap = cipherUserInfo(info);
        if (_infoMap != null){
          _maps.add(_infoMap);
        }
      }

    }

    return _maps;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, String?>? cipherUserInfo(f_a.UserInfo? userInfo){
    Map<String, String?>? _map;

    // blog('cipherUserInfo : blog : ${userInfo?.toString()}');

    if (userInfo != null){

      _map = {
        'displayName': userInfo.displayName,
        'email': userInfo.email,
        'uid' : userInfo.uid,
        'photoURL': userInfo.photoURL,
        'phoneNumber' :userInfo.phoneNumber,
        'providerId' : userInfo.providerId,
      };
    }

    return _map;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static List<f_a.UserInfo>? decipherUserInfos(dynamic maps){

    List<f_a.UserInfo>? _userInfos;

    if (Lister.checkCanLoop(maps) == true){

      _userInfos = <f_a.UserInfo>[];

      final List<Map<String, String?>>? _maps = AuthModel.fixTheImmutableMapsThing(maps);

      if (Lister.checkCanLoop(_maps) == true){

        for (final Map<String, String?>? _map in _maps!) {

          final f_a.UserInfo? _userInfo = decipherUserInfo(_map);

          if (_userInfo != null) {
            _userInfos.add(_userInfo);
          }

        }
      }

    }

    return _userInfos;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static f_a.UserInfo? decipherUserInfo(Map<String, String?>? map){
    f_a.UserInfo? _userInfo;

    if (map != null){
      _userInfo = f_a.UserInfo.fromJson(map);
    }

    return _userInfo;
  }
  // --------------------------------------------------------------------------

  /// USER IMAGE

  // --------------------
  /// TESTED : WORKS PERFECT
  static String? _getUserImageURLFromOfficialUserCredential(f_a.UserCredential? cred){
    String? _output;

    if (cred != null){

      final SignInMethod? signInMethod = OfficialAuthing.getCurrentSignInMethod();

      if (signInMethod == SignInMethod.google){
        _output = cred.user?.photoURL;
      }
      else if (signInMethod == SignInMethod.facebook){
        _output = OfficialFacebookAuthing.getUserFacebookImageURLFromUserCredential(cred);
      }
      else if (signInMethod == SignInMethod.apple){
        /// TASK : DO ME
      }
      else {
        _output = cred.user?.photoURL;
      }

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// OFFICIAL QUERY CREATOR

  // --------------------
  /// TESTED : WORKS PERFECT
  static cloud.Query<Map<String, dynamic>> createOfficialQueryByFinder({
    required cloud.Query<Map<String, dynamic>> query,
    required FireFinder finder,
  }){

    cloud.Query<Map<String, dynamic>> _output = query;

    /// IF EQUAL TO
    if (finder.comparison == FireComparison.equalTo) {
      _output = _output.where(finder.field, isEqualTo: finder.value);
    }

    /// IF GREATER THAN
    if (finder.comparison == FireComparison.greaterThan) {
      _output = _output.where(finder.field, isGreaterThan: finder.value);
    }

    /// IF GREATER THAN OR EQUAL
    if (finder.comparison == FireComparison.greaterOrEqualThan) {
      _output = _output.where(finder.field, isGreaterThanOrEqualTo: finder.value);
    }

    /// IF LESS THAN
    if (finder.comparison == FireComparison.lessThan) {
      _output = _output.where(finder.field, isLessThan: finder.value);
    }

    /// IF LESS THAN OR EQUAL
    if (finder.comparison == FireComparison.lessOrEqualThan) {
      _output = _output.where(finder.field, isLessThanOrEqualTo: finder.value);
    }

    /// IF IS NOT EQUAL TO
    if (finder.comparison == FireComparison.notEqualTo) {
      _output = _output.where(finder.field, isNotEqualTo: finder.value);
    }

    /// IF IS NULL
    if (finder.comparison == FireComparison.nullValue) {
      _output = _output.where(finder.field, isNull: finder.value);

    }

    /// IF whereIn
    if (finder.comparison == FireComparison.whereIn) {
      _output = _output.where(finder.field, whereIn: finder.value);
    }

    /// IF whereNotIn
    if (finder.comparison == FireComparison.whereNotIn) {
      _output = _output.where(finder.field, whereNotIn: finder.value);
    }

    /// IF array contains
    if (finder.comparison == FireComparison.arrayContains) {
      _output = _output.where(finder.field, arrayContains: finder.value);
    }

    /// IF array contains any
    if (finder.comparison == FireComparison.arrayContainsAny) {
      return _output.where(finder.field, arrayContainsAny: finder.value);
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static cloud.Query<Map<String, dynamic>> createOfficialCompositeQueryByFinders({
    required cloud.Query<Map<String, dynamic>> query,
    required List<FireFinder> finders,
  }){

    cloud.Query<Map<String, dynamic>> _output = query;

    if (Lister.checkCanLoop(finders) == true){

      for (final FireFinder finder in finders){
        _output = createOfficialQueryByFinder(
          query: _output,
          finder: finder,
        );
      }

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// QUERY CREATOR

  // --------------------
  /// TESTED : WORKS PERFECT
  static f_db.Query? createOfficialRealQuery({
    required RealQueryModel? queryModel,
    Map<String, dynamic>? lastMap,
    Map<String, dynamic>? endAt,
  }){
    f_db.Query? _query;

    if (queryModel != null){

      _query = OfficialReal._getRefByPath(path: queryModel.path);

      /// ORDER BY
      if (queryModel.orderType != null && _query != null){

        /// BY CHILD
        if (queryModel.orderType == RealOrderType.byChild){
          assert(queryModel.fieldNameToOrderBy != null, 'queryModel.fieldNameToOrderBy can not be null');
          // final String _lastNode = ChainPathConverter.getLastPathNode(queryModel.path);
          _query = _query.orderByChild(queryModel.fieldNameToOrderBy!);//queryModel.fieldNameToOrderBy);
        }

        /// BY KEY
        if (queryModel.orderType == RealOrderType.byKey){
          _query = _query.orderByKey();
        }

        /// BY VALUE
        if (queryModel.orderType == RealOrderType.byValue){
          _query = _query.orderByValue();
        }

        /// BY PRIORITY
        if (queryModel.orderType == RealOrderType.byPriority){
          _query = _query.orderByPriority();
        }

      }

      /// QUERY RANGE
      if (queryModel.queryRange != null && lastMap != null && _query != null){

        /// START AFTER
        if (queryModel.queryRange == QueryRange.startAfter){
          _query = _query.startAfter(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

        /// END AT
        if (queryModel.queryRange == QueryRange.endAt){
          _query = _query.endAt(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

        /// END BEFORE
        if (queryModel.queryRange == QueryRange.endBefore){
          _query = _query.endBefore(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

        /// EQUAL TO
        if (queryModel.queryRange == QueryRange.equalTo){
          _query = _query.equalTo(
            lastMap[queryModel.fieldNameToOrderBy],
            key: lastMap[queryModel.idFieldName],
          );
        }

      }


      /// LIMIT
      if (queryModel.limit != null && _query != null){

        /// GET MAPS FROM BEGINNING OF THE ORDERED LIST
        if (queryModel.readFromBeginningOfOrderedList == true){
          _query = _query.limitToFirst(queryModel.limit!);
        }

        /// GET MAPS FROM THE END OF THE ORDERED LIST
        else {
          _query = _query.limitToLast(queryModel.limit!);
        }

      }

    }

    return _query;
  }
  // -----------------------------------------------------------------------------

  /// OFFICIAL CIPHERS

  // --------------------
  /// TESTED : WORKS PERFECT
  static f_s.SettableMetadata toOfficialSettableMetadata({
    required AvModel? avModel,
    Map<String, String>? extraData,
  }){

    return f_s.SettableMetadata(
      customMetadata: AvCipher.toStringStringMap(
        avModel: avModel,
        lowerCaseKeys: false,
      ),
      // cacheControl: ,
      // contentDisposition: ,
      // contentEncoding: ,
      // contentLanguage: ,
      contentType: FileMiming.getMimeByType(avModel?.fileExt),
    );

  }
  // -----------------------------------------------------------------------------

  /// BLOGGING

  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogOfficialSettableMetaData(f_s.SettableMetadata? metaData){
    blog('BLOGGING SETTABLE META DATA ------------------------------- START');
    if (metaData == null){
      blog('Meta data is null');
    }
    else {
      blog('cacheControl : ${metaData.cacheControl}');
      blog('contentDisposition : ${metaData.contentDisposition}');
      blog('contentEncoding : ${metaData.contentEncoding}');
      blog('contentLanguage : ${metaData.contentLanguage}');
      blog('contentType : ${metaData.contentType}');
      blog('customMetadata : ${metaData.customMetadata}');
    }
    blog('BLOGGING SETTABLE META DATA ------------------------------- END');
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogOfficialFullMetaData(f_s.FullMetadata? metaData){

    blog('BLOGGING FULL META DATA ------------------------------- START');
    if (metaData == null){
      blog('Meta data is null');
    }
    else {
      blog('name : ${metaData.name}');
      blog('bucket : ${metaData.bucket}');
      blog('cacheControl : ${metaData.cacheControl}');
      blog('contentDisposition : ${metaData.contentDisposition}');
      blog('contentEncoding : ${metaData.contentEncoding}');
      blog('contentLanguage : ${metaData.contentLanguage}');
      blog('contentType : ${metaData.contentType}');
      blog('customMetadata : ${metaData.customMetadata}'); // map
      blog('fullPath : ${metaData.fullPath}');
      blog('generation : ${metaData.generation}');
      blog('md5Hash : ${metaData.md5Hash}');
      blog('metadataGeneration : ${metaData.metadataGeneration}');
      blog('metageneration : ${metaData.metageneration}');
      blog('size : ${metaData.size}');
      blog('timeCreated : ${metaData.timeCreated}'); // date time
      blog('updated : ${metaData.updated}'); // date time
    }
    blog('BLOGGING FULL META DATA ------------------------------- END');

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogRef(f_s.Reference? ref){
    blog('BLOGGING STORAGE IMAGE f_s.REFERENCE ------------------------------- START');
    // --------------------
    if (ref == null){
      blog('f_s.Reference is null');
    }
    else {
      blog('name : ${ref.name}');
      blog('fullPath : ${ref.fullPath}');
      blog('bucket : ${ref.bucket}');
      blog('hashCode : ${ref.hashCode}');
      blog('parent : ${ref.parent}');
      blog('root : ${ref.root}');
      blog('storage : ${ref.storage}');
    }

    blog('BLOGGING STORAGE IMAGE f_s.REFERENCE ------------------------------- END');
  }
  // -----------------------------------------------------------------------------
}
