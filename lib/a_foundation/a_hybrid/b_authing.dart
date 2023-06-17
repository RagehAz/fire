part of super_fire;

/// => TAMAM
class Authing {
  // -----------------------------------------------------------------------------

  const Authing();

  // -----------------------------------------------------------------------------

  /// USER ID

  // --------------------
  /// TESTED : WORKS PERFECT
  static String getUserID() {

    if (FirebaseInitializer.isUsingOfficialPackages() == true) {
      return _OfficialAuthing.getUserID();
    }

    else {
      return _NativeAuthing.getUserID();
    }

  }
  // -----------------------------------------------------------------------------

  /// ANONYMOUS AUTH

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<AuthModel> anonymousSignin({
    Function(String error) onError,
  }) async {
    AuthModel _output;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialAuthing.anonymousSignIn(
        onError: onError,
      );
    }
    else {
      _output = await _NativeAuthing.anonymousSignin(
        onError: onError,
      );
    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// SIGN OUT

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> signOut({
    Function(String error) onError,
  }) async {
    bool _success;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _success = await _OfficialAuthing.signOut(
        onError: onError,
      );
    }

    else {
      _success = await _NativeAuthing.signOut(
        onError: onError,
      );
    }

    return _success;
  }
  // -----------------------------------------------------------------------------

  /// DELETE USER

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> deleteUser({
    @required String userID,
    Function(String error) onError,
  }) async {
    bool _success;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _success = await _OfficialAuthing.deleteUser(
        onError: onError,
      );
    }

    else {
      _success = await _NativeAuthing.deleteUser(
        onError: onError,
      );
    }

    return _success;
  }
    // -----------------------------------------------------------------------------

  /// SIGN IN METHOD

  // --------------------
  /// TESTED : WORKS PERFECT
  static bool userHasID() {

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      return _OfficialAuthing.userHasID();
    }

    else {
      return _NativeAuthing.userHasID();
    }

  }
  // --------------------
  /*
  /// TESTED : WORKS PERFECT
  static SignInMethod getCurrentSignInMethod(){

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      return _OfficialAuthing.getCurrentSignInMethod();
    }

    else {
      // COULD NOT GET THIS
      return _NativeAuthing.getCurrentSignInMethod();
    }

  }
   */
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<String> getAuthEmail() async {

      if (FirebaseInitializer.isUsingOfficialPackages() == true){
        return _OfficialAuthing.getAuthEmail();
      }

      else {
        return _NativeAuthing.getAuthEmail();
      }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static bool userIsSignedUp(SignInMethod method){

    if (
    method == null ||
    method == SignInMethod.anonymous
    ){
      return false;
    }
    else {
      return true;
    }

  }
  // -----------------------------------------------------------------------------
}

/// => TAMAM
class EmailAuthing {
  // -----------------------------------------------------------------------------

  const EmailAuthing();

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

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialEmailAuthing.signIn(
        email: email,
        password: password,
        onError: onError,
      );
    }

    else {
      _output = await _NativeEmailAuthing.signIn(
        email: email,
        password: password,
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

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialEmailAuthing.register(
        email: email,
        password: password,
        onError: onError,
      );
    }

    else {
      _output = await _NativeEmailAuthing.register(
        email: email,
        password: password,
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
    bool _output;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _output = await _OfficialEmailAuthing.checkPasswordIsCorrect(
        password: password,
        email: email,
      );
    }

    else {
      _output = await _NativeEmailAuthing.checkPasswordIsCorrect(
        password: password,
        email: email,
      );
    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// UPDATE EMAIL

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<bool> updateUserEmail({
    @required String newEmail,
  }) async {
    bool _success = false;

    if (FirebaseInitializer.isUsingOfficialPackages() == true){
      _success = await _OfficialEmailAuthing.updateUserEmail(
        newEmail: newEmail,
      );
    }

    else {
      _success = await _NativeEmailAuthing.updateUserEmail(
        newEmail: newEmail,
      );
    }

    return _success;
  }
  // -----------------------------------------------------------------------------
}
