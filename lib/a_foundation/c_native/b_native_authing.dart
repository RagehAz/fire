part of super_fire;

/// => TAMAM
class _NativeAuthing{
  // -----------------------------------------------------------------------------

  const _NativeAuthing();

  // -----------------------------------------------------------------------------

  /// USER ID

  // --------------------
  /// TESTED : WORKS PERFECT
  static String? getUserID(){
    final fd.FirebaseAuth? _auth = _NativeFirebase.getAuthFire();
    if (_auth != null && _auth.isSignedIn == true){
      return _auth.userId;
    }
    else {
      return null;
    }
  }
  // -----------------------------------------------------------------------------

  /// ANONYMOUS AUTH

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel?> anonymousSignIn({
    Function(String? error)? onError,
  }) async {
    AuthModel? _output;

    await tryAndCatch(
      invoker: 'NativeAuthing.anonymousSignin',
      onError: onError,
      functions: () async {

        final fd_u.User? _user =  await _NativeFirebase.getAuthFire()?.signInAnonymously();

        _output = AuthModel.getAuthModelFromFiredartUser(
          user: _user,
          signInMethod: SignInMethod.anonymous,
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
    Function(String? error)? onError,
  }) async {

    final bool _success = await tryCatchAndReturnBool(
      invoker: 'NativeAuthing.signOut',
      onError: onError,
      functions: () async {

        /// FIREBASE SIGN OUT
        _NativeFirebase.getAuthFire()?.signOut();
        await _NativeFirebase.getAuthReal()?.signOut();

      },
    );

    return _success;
  }
  // -----------------------------------------------------------------------------

  /// DELETE USER

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> deleteUser({
    Function(String? error)? onError,
  }) async {

    final bool _success = await tryCatchAndReturnBool(
        invoker: 'NativeAuthing.deleteFirebaseUser',
        functions: () async {
          await _NativeFirebase.getAuthFire()?.deleteAccount.call();
        },
        onError: onError,
    );

    return _success;

  }
  // -----------------------------------------------------------------------------

  /// SIGN IN METHOD

  // --------------------
  /// TESTED : WORKS PERFECT
  static bool userHasID() {
    return getUserID() != null;
  }
  // --------------------
  /*
  /// TESTED : WORKS PERFECT
  static SignInMethod getCurrentSignInMethod(){

    if (userHasID() == true){
      /// CAN NOT GET IT HERE
      return await _getUser(). ??? ;
    }
    else {
      return null;
    }

  }
   */
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<String?> getAuthEmail() async {
     final fd_u.User? _user = await _getUser();
     return _user?.email;
  }
  // -----------------------------------------------------------------------------

  /// USER

  // -------------------
  /// TESTED : WORKS PERFECT
  static Future<fd_u.User?> _getUser() async {
    fd_u.User? _user;

    await tryAndCatch(
      invoker: 'NativeAuthing._getUser',
      functions: () async {
        _user = await _NativeFirebase.getAuthFire()?.getUser();
      },
    );

    return _user;
  }
  // -----------------------------------------------------------------------------
}

/// => TAMAM
class _NativeEmailAuthing {
  // -----------------------------------------------------------------------------

  const _NativeEmailAuthing();

  // -----------------------------------------------------------------------------

  /// SIGN IN

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel?> signIn({
    required String? email,
    required String? password,
    Function(String? error)? onError,
  }) async {
    AuthModel? _output;

    if (email != null && password != null) {
      await tryAndCatch(
        invoker: 'NativeAuth.signInByEmail',
        onError: onError,
        functions: () async {

          final fd_u.User? _user = await _NativeFirebase.getAuthFire()?.signIn(
              email,
              password,
          );

          final f_d.UserCredential? _realUserCred = await _NativeFirebase.getAuthReal()?.signInWithEmailAndPassword(
              email: email,
              password: password
          );

          blog('firedart user : ${_user?.id}  : fire_dart user : ${_realUserCred?.user?.uid}');

          _output = AuthModel.getAuthModelFromFiredartUser(
            user: _user,
            signInMethod: SignInMethod.password,
          );
        },
      );
    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// REGISTER

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel?> register({
    required String? email,
    required String? password,
    required bool autoSendVerificationEmail,
    Function(String? error)? onError,
  }) async {
    AuthModel? _output;

    if (
        TextCheck.isEmpty(email) == false
        &&
        TextCheck.isEmpty(password) == false
    ) {

      await tryAndCatch(
          invoker: 'NativeAuth.registerByEmail',
          functions: () async {

          final fd_u.User? _user = await _NativeFirebase.getAuthFire()?.signUp(
              email!,
              password!,
          );

          /// NOT TESTED
          if (autoSendVerificationEmail == true){
            await _NativeFirebase.getAuthFire()?.requestEmailVerification(
              langCode: 'en',
            );
          }

          _output = AuthModel.getAuthModelFromFiredartUser(
            user: _user,
            signInMethod: SignInMethod.password,
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
    required String? password,
    required String? email,
  }) async {

   final AuthModel? _authModel = await signIn(
      email: email,
      password: password,
    );

    return _authModel != null;
  }
  // -----------------------------------------------------------------------------

  /// UPDATE EMAIL

  // --------------------
  /// NOT SUPPORTED
  // static Future<bool> updateUserEmail({
  //   required String? newEmail,
  // }) async {
  //
  //   return false;
  // }
  // -----------------------------------------------------------------------------

  /// CHANGE PASSWORD

  // --------------------
  /// TASK : TEST ME
  static Future<bool> sendPasswordResetEmail({
    required String? email,
    required Function(String? error)? onError,
  }) async {
    bool _output = false;

    if (TextCheck.isEmpty(email) == false){

      await tryAndCatch(
        invoker: 'sendPasswordResetEmail',
        functions: () async {

          await _NativeFirebase.getAuthFire()!.resetPassword(email!);
          _output = true;
          },
        onError: onError,
      );

    }

    return _output;
  }
  // --------------------
  /// TASK : TEST ME
  static Future<bool> sendVerificationEmail({
    required String? email,
    required Function(String? error)? onError,
  }) async {
    bool _output = false;

    if (TextCheck.isEmpty(email) == false){

      await tryAndCatch(
        invoker: 'sendVerificationEmail',
        onError: onError,
        functions: () async {

          await _NativeFirebase.getAuthFire()?.requestEmailVerification();
          _output = true;
          },
      );

    }

    return _output;

  }
  // --------------------
}
