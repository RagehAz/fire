part of super_fire;

/// => TAMAM
class _OfficialAuthing {
  // -----------------------------------------------------------------------------

  const _OfficialAuthing();

  // -----------------------------------------------------------------------------

  /// USER ID

  // --------------------
  /// TESTED : WORKS PERFECT
  static String getUserID() {
    return _getUser()?.uid;
  }
  // -----------------------------------------------------------------------------

  /// ANONYMOUS AUTH

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel> anonymousSignIn({
    Function(String error) onError,
  }) async {
    AuthModel _output;

    await tryAndCatch(
      invoker: 'OfficialAuthing.anonymousSignin',
      onError: onError,
      functions: () async {

        final f_a.UserCredential _userCredential = await _OfficialFirebase
            .getAuth()
            .signInAnonymously();

        _output = AuthModel._getAuthModelFromOfficialUserCredential(
            cred: _userCredential,
        );

      },
    );

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// SIGN OUT

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> signOut({
    Function(String error) onError,
  }) async {

    final bool _success = await tryCatchAndReturnBool(
      invoker: 'OfficialAuthing.signOut',
      onError: onError,
      functions: () async {
        final SignInMethod signInMethod = getCurrentSignInMethod();

        /// GOOGLE SIGN OUT
        if (signInMethod == SignInMethod.google) {
          if (kIsWeb == false) {
            final GoogleSignIn _instance = OfficialGoogleAuthing.getGoogleSignInInstance();
            await _instance.disconnect();
            await _instance.signOut();
          }
        }

        /// FACEBOOK SIGN OUT
        else if (signInMethod == SignInMethod.facebook) {
          await OfficialFacebookAuthing.getFacebookAuthInstance().logOut();
        }

        /// FIREBASE SIGN OUT
        await _OfficialFirebase.getAuth().signOut();
      },
    );

    return _success;
  }
  // -----------------------------------------------------------------------------

  /// DELETE USER

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> deleteUser({
    Function(String error) onError,
  }) async {


    final bool _success = await tryCatchAndReturnBool(
        invoker: 'Official.deleteFirebaseUser',
        functions: () => _OfficialFirebase.getAuth().currentUser?.delete(),
        onError: onError,
    );

    return _success;

  }
  // -----------------------------------------------------------------------------

  /// SIGN IN METHOD

  // --------------------
  /// TESTED : WORKS PERFECT
  static bool userHasID() {
    return _getUser() != null;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static SignInMethod getCurrentSignInMethod(){
    return _getSignInMethodFromUser(user: _OfficialAuthing._getUser());
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static SignInMethod _getSignInMethodFromUser({
    @required f_a.User user,
  }){
    SignInMethod _output;

    if (user != null){

      final List<f_a.UserInfo> providerData = user.providerData;

      if (Mapper.checkCanLoopList(providerData) == true){
        final f_a.UserInfo _info = providerData.first;
        final String providerID = _info?.providerId;
        _output = AuthModel.decipherSignInMethod(providerID);
      }

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// USER

  // --------------------
  /// TESTED : WORKS PERFECT
  static f_a.User _getUser() {
    return _OfficialFirebase.getAuth()?.currentUser;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static String getAuthEmail(){
    return _getUser()?.email;
  }
  // -----------------------------------------------------------------------------
}

/// => TAMAM
class _OfficialEmailAuthing {
  // -----------------------------------------------------------------------------

  const _OfficialEmailAuthing();

  // -----------------------------------------------------------------------------

  /// SIGN IN

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel> signIn({
    @required String email,
    @required String password,
    Function(String error) onError,
  }) async {
    AuthModel _output;

    if (
        TextCheck.isEmpty(email) == false
        &&
        TextCheck.isEmpty(password) == false
    ) {
      await tryAndCatch(
        invoker: 'signInByEmail',
        functions: () async {

          final f_a.UserCredential _userCredential = await _OfficialFirebase.getAuth()
              .signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

          _output = AuthModel._getAuthModelFromOfficialUserCredential(
            cred: _userCredential,
          );

        },
        onError: onError,
      );
    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// REGISTER

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel> register({
    @required String email,
    @required String password,
    Function(String error) onError,
  }) async {
    AuthModel _output;

    if (
        TextCheck.isEmpty(email) == false
        &&
        TextCheck.isEmpty(password) == false
    ) {

      await tryAndCatch(
          invoker: 'registerByEmail',
          functions: () async {

            final f_a.UserCredential _userCredential = await _OfficialFirebase.getAuth().createUserWithEmailAndPassword(
              email: email.trim(),
              password: password,
            );

            _output = AuthModel._getAuthModelFromOfficialUserCredential(
                cred: _userCredential,
            );

          },
          onError: onError,
      );

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// CHECKERS

  // --------------------
    /// TESTED : WORKS PERFECT
  static Future<bool> checkPasswordIsCorrect({
    @required String password,
    @required String email,
  }) async {

    f_a.UserCredential _credential;

    final bool _credentialsAreGood = await tryCatchAndReturnBool(
        functions: () async {

          final f_a.AuthCredential _authCredential = f_a.EmailAuthProvider.credential(
            email: email,
            password: password,
          );

          _credential = await _OfficialFirebase.getAuth().currentUser?.reauthenticateWithCredential(_authCredential);

        }
    );

    if (_credentialsAreGood == true && _credential != null){
      return true;
    }
    else {
      return false;
    }

  }
  // -----------------------------------------------------------------------------

  /// UPDATE EMAIL

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> updateUserEmail({
    @required String newEmail,
  }) async {
    blog('updateUserEmail : START');

    bool _success = false;

    if (Authing.userIsSignedUp() == true) {

      final f_a.FirebaseAuth _auth = _OfficialFirebase.getAuth();
      final String _oldEmail = _auth?.currentUser?.email;

      blog('updateUserEmail : new : $newEmail : old : $_oldEmail');

      if (_oldEmail != newEmail) {
        _success = await tryCatchAndReturnBool(
          invoker: 'updateUserEmail',
          functions: () async {
            await _auth.currentUser.updateEmail(newEmail);
            blog('updateUserEmail : END');
          },
        );
      }

    }

    return _success;
  }
  // -----------------------------------------------------------------------------
}

/// => TAMAM
class OfficialGoogleAuthing {
  // --------------------
  OfficialGoogleAuthing.singleton();
  static final OfficialGoogleAuthing _singleton = OfficialGoogleAuthing.singleton();
  static OfficialGoogleAuthing get instance => _singleton;
  // -----------------------------------------------------------------------------

  /// GOOGLE SIGN IN SINGLETON

  // --------------------
  GoogleSignIn _googleSignIn;
  GoogleSignIn get googleSignIn => _googleSignIn ??= GoogleSignIn();
  static GoogleSignIn getGoogleSignInInstance() => OfficialGoogleAuthing.instance.googleSignIn;
  // -----------------------------------------------------------------------------

  /// GOOGLE AUTH PROVIDER SINGLETON

  // --------------------
  f_a.GoogleAuthProvider _googleAuthProvider;
  f_a.GoogleAuthProvider get googleAuthProvider => _googleAuthProvider ??=  f_a.GoogleAuthProvider();
  static f_a.GoogleAuthProvider getGoogleAuthProviderInstance() => OfficialGoogleAuthing.instance.googleAuthProvider;
  // -----------------------------------------------------------------------------

  /// SCOPED SIGN IN

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthClient> scopedSignIn({
    List<String> scopes,
    // String clientID,
  }) async {
    AuthClient client;

    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: scopes,
      // clientId: clientID,
      // forceCodeForRefreshToken: ,
      // hostedDomain: ,
      // serverClientId: ,
      // signInOption: ,
    );

    await tryAndCatch(
      invoker: 'googleSignIn',
        functions: () async {

          await _googleSignIn.signIn();

          client = await _googleSignIn.authenticatedClient();

        },
    );

    return client;
  }
  // -----------------------------------------------------------------------------

  /// EMAIL SIGN IN

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel> emailSignIn({
    Function(String error) onError,
  }) async {
    AuthModel _output;

    await getGoogleSignInInstance().signOut();

    if (kIsWeb == true) {
      _output = await _webGoogleAuth(onError: onError,);
    }

    else {
      _output = await _appGoogleAuth(onError: onError,);
    }

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel> _webGoogleAuth({
    Function(String error) onError,
  }) async {
    AuthModel _output;

    await tryAndCatch(
      invoker: 'webGoogleAuth',
        onError: onError,
        functions: () async {

        /// get [auth provider]
        final f_a.GoogleAuthProvider _googleAuthProvider = getGoogleAuthProviderInstance();

        final f_a.FirebaseAuth _firebaseAuth = _OfficialFirebase.getAuth();

        /// get [user credential] from [auth provider]
        final f_a.UserCredential _userCredential = await _firebaseAuth.signInWithPopup(_googleAuthProvider);

        _output = AuthModel._getAuthModelFromOfficialUserCredential(
          cred: _userCredential,
        );

      },
    );

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel> _appGoogleAuth({
    Function(String error) onError,
  }) async {
    AuthModel _output;

    await tryAndCatch(
      invoker: '_appGoogleAuth',
      onError: onError,
      functions: () async {

        /// get [google sign in account]
        final GoogleSignInAccount _googleSignInAccount = await getGoogleSignInInstance().signIn();

        if (_googleSignInAccount != null) {

              /// get [google sign in auth] from [google sign in account]
              final GoogleSignInAuthentication _googleSignInAuthentication = await
              _googleSignInAccount.authentication;

              /// get [auth credential] from [google sign in auth]
              final f_a.AuthCredential _authCredential = f_a.GoogleAuthProvider.credential(
                accessToken: _googleSignInAuthentication.accessToken,
                idToken: _googleSignInAuthentication.idToken,
              );

              final f_a.FirebaseAuth _firebaseAuth = _OfficialFirebase.getAuth();

              /// C - get [user credential] from [auth credential]
              final f_a.UserCredential _userCredential = await _firebaseAuth.signInWithCredential(_authCredential);

              _output = AuthModel._getAuthModelFromOfficialUserCredential(
                cred: _userCredential,
                addData: _createGoogleAuthDataMap(
                  googleSignInAuthentication: _googleSignInAuthentication,
                  authCredential: _authCredential,
                ),
              );

            }

      },
    );

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, dynamic> _createGoogleAuthDataMap({
    GoogleSignInAuthentication googleSignInAuthentication,
    f_a.AuthCredential authCredential,
  }){

    final Map<String, dynamic> _map = {
      'googleSignInAuthentication.accessToken': googleSignInAuthentication?.accessToken,
      'googleSignInAuthentication.idToken': googleSignInAuthentication?.idToken,
      'authCredential.signInMethod' : authCredential?.signInMethod,
      'authCredential.providerId' : authCredential?.providerId,
      'authCredential.accessToken' : authCredential?.accessToken,
      'authCredential.token' : authCredential?.token,
    };

    return Mapper.cleanNullPairs(map: _map);
  }
  // -----------------------------------------------------------------------------
}

/// => TAMAM
class OfficialFacebookAuthing {
  // --------------------
  OfficialFacebookAuthing.singleton();
  static final OfficialFacebookAuthing _singleton = OfficialFacebookAuthing.singleton();
  static OfficialFacebookAuthing get instance => _singleton;
  // -----------------------------------------------------------------------------

  /// AUDIO PLAYER SINGLETON

  // --------------------
  FacebookAuth _facebookAuth;
  FacebookAuth get facebookAuth => _facebookAuth ??= FacebookAuth.instance;
  static FacebookAuth getFacebookAuthInstance() => OfficialFacebookAuthing.instance.facebookAuth;
  // -----------------------------------------------------------------------------

  /// FACEBOOK AUTHENTICATION

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel> signIn({
    Function(String error) onError,
  }) async {
    AuthModel _output;

    await tryAndCatch(
      invoker: 'signInByFacebook',
      onError: onError,
      functions: () async {

        final LoginResult _loginResult = await  getFacebookAuthInstance().login(
          // loginBehavior: ,
          // permissions: ['email'],
        );

        if (_loginResult?.accessToken != null) {

          final f_a.FacebookAuthCredential _facebookAuthCredential =
          f_a.FacebookAuthProvider.credential(_loginResult.accessToken.token);

          final f_a.UserCredential _userCredential =
          await _OfficialFirebase.getAuth().signInWithCredential(_facebookAuthCredential);

          _output = AuthModel._getAuthModelFromOfficialUserCredential(
            cred: _userCredential,
            addData: _createFacebookAuthDataMap(
              facebookAuthCredential: _facebookAuthCredential,
              loginResult: _loginResult,
            ),
          );

        }

      },
    );

    return _output;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Map<String, dynamic> _createFacebookAuthDataMap({
    @required LoginResult loginResult,
    @required f_a.FacebookAuthCredential facebookAuthCredential,
  }) {
    final Map<String, dynamic> _map = {
      'loginResult.status.name': loginResult?.status?.name,
      'loginResult.status.index': loginResult?.status?.index,
      'loginResult.accessToken.expires':
          Timers.cipherTime(time: loginResult?.accessToken?.expires, toJSON: false),
      'loginResult.accessToken.lastRefresh':
          Timers.cipherTime(time: loginResult?.accessToken?.lastRefresh, toJSON: true),
      'loginResult.accessToken.userId': loginResult?.accessToken?.userId,
      'loginResult.accessToken.token': loginResult?.accessToken?.token,
      'loginResult.accessToken.applicationId': loginResult?.accessToken?.applicationId,
      'loginResult.accessToken.graphDomain': loginResult?.accessToken?.graphDomain,
      'loginResult.accessToken.declinedPermissions': loginResult?.accessToken?.declinedPermissions,
      'loginResult.accessToken.grantedPermissions': loginResult?.accessToken?.grantedPermissions,
      'loginResult.accessToken.isExpired': loginResult?.accessToken?.isExpired,
      'loginResult.message': loginResult?.message,
      'facebookAuthCredential.idToken': facebookAuthCredential?.idToken,
      'facebookAuthCredential.rawNonce': facebookAuthCredential?.rawNonce,
      'facebookAuthCredential.secret': facebookAuthCredential?.secret,
      'facebookAuthCredential.token': facebookAuthCredential?.token,
      'facebookAuthCredential.accessToken': facebookAuthCredential?.accessToken,
      'facebookAuthCredential.providerId': facebookAuthCredential?.providerId,
      'facebookAuthCredential.signInMethod': facebookAuthCredential?.signInMethod,
    };

    return Mapper.cleanNullPairs(map: _map);
  }
  // -----------------------------------------------------------------------------

  /// FACEBOOK USER DATA

  // --------------------
  /// TESTED : WORKS PERFECT
  static String getUserFacebookImageURLFromUserCredential(f_a.UserCredential cred){
    String _output;

    if (cred != null){

      if (cred.additionalUserInfo?.providerId == 'facebook.com'){
        final Map<String, dynamic> profileMap = cred.additionalUserInfo?.profile;
        if (profileMap != null){
          final picture = profileMap['picture'];
          if (picture != null){
            final data = picture['data'];
            if (data != null){
              _output = data['url'];
            }
          }
        }
      }


    }

    return _output;
  }
  // -----------------------------------------------------------------------------
}

/// => TAMAM
class OfficialAppleAuthing {
  // -----------------------------------------------------------------------------

  const OfficialAppleAuthing();

  // -----------------------------------------------------------------------------

  /// APPLE AUTHENTICATION

  // --------------------
  /// WORKS ON IOS DEVICE
  static Future<AuthModel> signInByApple({
    Function(String error) onError,
  }) async {
    AuthModel _output;

    await tryAndCatch(
      invoker: 'signInByApple',
      onError: onError,
      functions: () async {

        final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
          scopes: <AppleIDAuthorizationScopes>[
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          // state: ,
          // nonce: ,
          // webAuthenticationOptions: ,
        );

        // AuthBlog.blogAppleCred(credential);

        _output = AuthModel.getAuthModelFromAppleCred(
          cred: credential,
        );

      },
    );

    return _output;
  }
  // -----------------------------------------------------------------------------
}
