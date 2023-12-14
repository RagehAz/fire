part of super_fire;
/// => TAMAM
@immutable
class AuthModel {
  // --------------------------------------------------------------------------
  const AuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.imageURL,
    required this.signInMethod,
    required this.data,
  });
  // --------------------------------------------------------------------------
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? imageURL;
  final SignInMethod? signInMethod;
  final Map<String, dynamic>? data;
  // --------------------------------------------------------------------------

  /// CLONING

  // --------------------
  /// TESTED : WORKS PERFECT
  AuthModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? imageURL,
    SignInMethod? signInMethod,
    Map<String, dynamic>? data,
  }){
    return AuthModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        imageURL: imageURL ?? this.imageURL,
        signInMethod: signInMethod ?? this.signInMethod,
        data: data ?? this.data,
    );
  }
  // --------------------------------------------------------------------------

  /// CYPHER

  // --------------------
  /// TESTED : WORKS PERFECT
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imageURL': imageURL,
      'signInMethod': cipherSignInMethod(signInMethod),
      'data': data,
    };
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static AuthModel? decipher({
    required Map<String, dynamic>? map
  }){
    AuthModel? _output;

    if (map != null){

      _output = AuthModel(
          id: map['id'],
          name: map['name'],
          email: map['email'],
          phone: map['phone'],
          imageURL: map['imageURL'],
          signInMethod: decipherSignInMethod(map['signInMethod']),
          data: map['data'],
      );

    }

    return _output;
  }
  // --------------------------------------------------------------------------

  /// GETTERS

  // --------------------
  /// TESTED : WORKS PERFECT
  static AuthModel? _getAuthModelFromOfficialUserCredential({
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
        signInMethod: _OfficialAuthing._getSignInMethodFromUser(user: cred.user),
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
  static AuthModel? _getAuthModelFromOfficialFirebaseUser({
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
        signInMethod: _OfficialAuthing._getSignInMethodFromUser(user: user),
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
  ///
  static AuthModel? getAuthModelFromFiredartUser({
    required fd_u.User? user,
    required SignInMethod? signInMethod,
  }){
    AuthModel? _output;

    if (user != null){

      _output = AuthModel(
        id: user.id,
        name: user.displayName,
        email: user.email,
        phone: null,
        imageURL: user.photoUrl,
        signInMethod: signInMethod,
        data: null,
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
    // -----------------------------------------------------------------------------

  /// SIGN IN METHOD

  // --------------------
  /// TESTED : WORKS PERFECT
  static String? cipherSignInMethod(SignInMethod? method){
    switch (method){

      case SignInMethod.google: return 'google.com';
      case SignInMethod.facebook: return 'facebook.com';
      case SignInMethod.anonymous: return 'anonymous';
      case SignInMethod.apple: return 'apple.com';
      case SignInMethod.password: return 'password';
      // case SignInMethod.phone: return 'phone'; break;
      default: return null;
    }
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static SignInMethod? decipherSignInMethod(String? providerID){

    switch (providerID){

      case 'google.com': return SignInMethod.google;
      case 'facebook.com': return SignInMethod.facebook;
      case 'anonymous': return SignInMethod.anonymous;
      case 'apple.com': return SignInMethod.apple;
      case 'password': return SignInMethod.password;
      // case 'phone': return SignInMethod.phone;
      default: return Authing.getUserID() == null ? null : SignInMethod.anonymous;
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static const List<SignInMethod> signInMethodsList = [
    SignInMethod.anonymous,
    SignInMethod.password,
    SignInMethod.google,
    SignInMethod.facebook,
    SignInMethod.apple,
  ];
  // --------------------
  /// TESTED : WORKS PERFECT
  static String? getSignInMethodIcon({
    required SignInMethod? signInMethod,
  }){

    switch (signInMethod){

      case SignInMethod.anonymous:  return Iconz.anonymousUser;
      case SignInMethod.password:   return Iconz.comEmail;
      case SignInMethod.google:     return Iconz.comGoogleLogo;
      case SignInMethod.facebook:   return Iconz.comFacebook;
      case SignInMethod.apple:      return Iconz.comApple;
      default: return null;

    }

  }
  // -----------------------------------------------------------------------------

  /// CYPHER USER INFO

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

      final List<Map<String, String?>>? _maps = _fixTheImmutableMapsThing(maps);

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
  // --------------------
  /// TESTED : WORKS PERFECT
  static List<Map<String, String?>>? _fixTheImmutableMapsThing(dynamic maps){

    // blog('1 _fixTheImmutableMapsThing : maps type is : ${maps.runtimeType}');
    final List<dynamic> _list = maps;
    // blog('2 _fixTheImmutableMapsThing : _list type is : ${_list.runtimeType}');

    final List<Map<String, String?>> _output = <Map<String, String?>>[];

    if (Lister.checkCanLoop(_list) == true){
      for (final dynamic object in _list){

        final Map<String, String?>? _stringStringMap = MapperSS.getStringStringMapFromImmutableMapStringObject(object);

        // blog('5 _fixTheImmutableMapsThing : _stringStringMap type is : ${_stringStringMap.runtimeType}');

        if (_stringStringMap != null){
          _output.add(_stringStringMap);
        }

      }

    }

    return _output;
  }
  // --------------------------------------------------------------------------

  /// USER IMAGE

  // --------------------
  /// TESTED : WORKS PERFECT
  static String? _getUserImageURLFromOfficialUserCredential(f_a.UserCredential? cred){
    String? _output;

    if (cred != null){

      final SignInMethod? signInMethod = _OfficialAuthing.getCurrentSignInMethod();

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
  // --------------------------------------------------------------------------

  /// BLOGGING

  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogAuthModel({
    required AuthModel? authModel,
    String invoker = 'AuthModel',
  }){

    if (authModel == null){
      blog('blogAuthModel : $invoker : model is null');
    }

    else {
      blog('blogAuthModel : $invoker : ---------------> START');
      blog('id : ${authModel.id}');
      blog('name : ${authModel.name}');
      blog('email : ${authModel.email}');
      blog('imageURL : ${authModel.imageURL}');
      blog('signInMethod : ${authModel.signInMethod}');
      Mapper.blogMap(authModel.data);
      blog('blogAuthModel: ---------------> END');
    }

  }
  // -----------------------------------------------------------------------------

  /// EQUALITY

  // --------------------
  /// TESTED : WORKS PERFECT
  static bool checkAuthModelsAreIdentical({
    required AuthModel? auth1,
    required AuthModel? auth2,
  }){
    bool _identical = false;

    if (auth1 == null && auth2 == null){
      _identical = true;
    }

    else if (auth1 != null && auth2 != null){

      if (
      auth1.id == auth2.id &&
      auth1.name == auth2.name &&
      auth1.email == auth2.email &&
      auth1.phone == auth2.phone &&
      auth1.imageURL == auth2.imageURL &&
      auth1.signInMethod == auth2.signInMethod &&
      Mapper.checkMapsAreIdentical(map1: auth1.data, map2: auth2.data)
      ){
        _identical = true;
      }

    }

    return _identical;
  }
  // -----------------------------------------------------------------------------

  /// OVERRIDES

  // --------------------
  /// TESTED : WORKS PERFECT
   @override
   String toString(){
    return
    '''
    
    AuthModel(
        id: $id, 
        name: $name,
        email: $email, 
        phone: $phone,
        imageURL: $imageURL,
        signInMethod: $signInMethod,
        data: $data
    )
     ''';

   }
  // --------------------
  @override
  bool operator == (Object other){

    if (identical(this, other)) {
      return true;
    }

    bool _areIdentical = false;
    if (other is AuthModel){
      _areIdentical = checkAuthModelsAreIdentical(
        auth1: this,
        auth2: other,
      );
    }

    return _areIdentical;
  }
  // --------------------
  @override
  int get hashCode =>
      id.hashCode^
      name.hashCode^
      email.hashCode^
      phone.hashCode^
      imageURL.hashCode^
      signInMethod.hashCode^
      data.hashCode;
  // -----------------------------------------------------------------------------
}
