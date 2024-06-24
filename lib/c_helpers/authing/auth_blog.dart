part of super_fire;

/// => TAMAM
class AuthBlog {
  // -----------------------------------------------------------------------------

  const AuthBlog();

  // -----------------------------------------------------------------------------

  /// FIREBASE

  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogUserCredential({
    required f_a.UserCredential? cred,
  }){

    if (cred == null){
      blog('blogUserCredential : USER CREDENTIAL IS NULL');
    }

    else {
      blog('USER CREDENTIAL :----> ');
      blog('credential.user.displayName : ${cred.user?.displayName}');
      blog('credential.user.email : ${cred.user?.email}');
      blog('credential.user.emailVerified : ${cred.user?.emailVerified}');
      blog('credential.user.isAnonymous : ${cred.user?.isAnonymous}');
      blog('credential.user.metadata : ${cred.user?.metadata}');
      blog('credential.user.phoneNumber : ${cred.user?.phoneNumber}');
      blog('credential.user.photoURL : ${cred.user?.photoURL}');
      blog('credential.user.providerData : ${cred.user?.providerData}');
      blog('credential.user.refreshToken : ${cred.user?.refreshToken}');
      blog('credential.user.tenantId : ${cred.user?.tenantId}');
      blog('credential.user.uid : ${cred.user?.uid}');
      blog('credential.user.multiFactor : ${cred.user?.multiFactor}');
      blog('CREDENTIAL :-');
      blog('credential.credential.accessToken : ${cred.credential?.accessToken}');
      blog('credential.credential.providerId : ${cred.credential?.providerId}');
      blog('credential.credential.signInMethod : ${cred.credential?.signInMethod}');
      blog('credential.credential.token : ${cred.credential?.token}');
      blog('ADDITIONAL USER INFO :-');
      blog('credential.additionalUserInfo.providerId : ${cred.additionalUserInfo?.providerId}');
      blog('credential.additionalUserInfo.isNewUser : ${cred.additionalUserInfo?.isNewUser}');
      blog('credential.additionalUserInfo.profile : ${cred.additionalUserInfo?.profile}');
      blog('credential.additionalUserInfo.username : ${cred.additionalUserInfo?.username}');
      blog('blogUserCredential : USER CREDENTIAL BLOG END <-----');
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogOfficialFirebaseUser({
    required f_a.User? user,
  }){

    if (user == null){
      blog('blogUserCredential : FIRE BASE USER IS NULL');
    }

    else {
      blog('FIRE BASE USER :----> ');
      blog('credential.user.displayName : ${user.displayName}');
      blog('credential.user.email : ${user.email}');
      blog('credential.user.emailVerified : ${user.emailVerified}');
      blog('credential.user.isAnonymous : ${user.isAnonymous}');
      blog('credential.user.metadata : ${user.metadata}');
      blog('credential.user.phoneNumber : ${user.phoneNumber}');
      blog('credential.user.photoURL : ${user.photoURL}');
      blog('credential.user.providerData : ${user.providerData}');
      blog('credential.user.refreshToken : ${user.refreshToken}');
      blog('credential.user.tenantId : ${user.tenantId}');
      blog('credential.user.uid : ${user.uid}');
      blog('credential.user.multiFactor : ${user.multiFactor}');
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogCurrentOfficialFirebaseUser(){

    final f_a.User ?_user = OfficialAuthing.getUser();

    if (_user == null){
      blog('blogCurrentFirebaseUser : user is null');
    }
    else {
      blogOfficialFirebaseUser(user: _user);
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogAuthCred(f_a.AuthCredential? authCred){

    if (authCred == null){
      blog('blogAuthCred : AUTH CREDENTIAL IS NULL');
    }

    else {
      blog('AUTH CREDENTIAL :----> ');
      blog('authCred.signInMethod : ${authCred.signInMethod}');
      blog('authCred.providerId : ${authCred.providerId}');
      blog('authCred.accessToken : ${authCred.accessToken}');
      blog('authCred.token : ${authCred.token}');

    }

  }
  // -----------------------------------------------------------------------------

  /// APPLE

  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogAppleCred(AuthorizationCredentialAppleID? cred){

    if (cred == null){
      blog('blogAppleCred : AUTH CREDENTIAL IS NULL');
    }

    else {
      blog('APPLE CREDENTIAL :----> ');
      blog('credential.authorizationCode : ${cred.authorizationCode}');
      blog('credential.email : ${cred.email}');
      blog('credential.familyName : ${cred.familyName}');
      blog('credential.givenName : ${cred.givenName}');
      blog('credential.identityToken : ${cred.identityToken}');
      blog('credential.state : ${cred.state}');
      blog('credential.userIdentifier : ${cred.userIdentifier}');
    }

  }
  // -----------------------------------------------------------------------------

  /// FACEBOOK

  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogFacebookLoginResult({
    required LoginResult ?loginResult,
    String invoker = 'blogLoginResult',
  }){

    if (loginResult == null){
      blog('blogLoginResult : the Facebook login result is null');
    }
    else {
      blog('blogLoginResult : the Facebook login result is :- ');
      blog('loginResult.status.name : ${loginResult.status.name}');
      blog('loginResult.status.index : ${loginResult.status.index}');
      blog('loginResult.accessToken.expires : ${loginResult.accessToken?.expires}');
      blog('loginResult.accessToken.lastRefresh : ${loginResult.accessToken?.lastRefresh}');
      blog('loginResult.accessToken.userId : ${loginResult.accessToken?.userId}');
      blog('loginResult.accessToken.token : ${loginResult.accessToken?.token}');
      blog('loginResult.accessToken.applicationId : ${loginResult.accessToken?.applicationId}');
      blog('loginResult.accessToken.graphDomain : ${loginResult.accessToken?.graphDomain}');
      blog('loginResult.accessToken.declinedPermissions : ${loginResult.accessToken?.declinedPermissions}');
      blog('loginResult.accessToken.grantedPermissions : ${loginResult.accessToken?.grantedPermissions}');
      blog('loginResult.accessToken.isExpired : ${loginResult.accessToken?.isExpired}');
      blog('loginResult.message : ${loginResult.message}');
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogFacebookAuthCredential({
    required f_a.FacebookAuthCredential? facebookAuthCredential,
    String invoker = 'blogFacebookAuthCredential',
  }){

    if (facebookAuthCredential == null){
      blog('blogLoginResult : the Facebook login result is null');
    }
    else {
      blog('blogLoginResult : the Facebook login result is :-');
      blog('facebookAuthCredential.idToken : ${facebookAuthCredential.idToken}');
      blog('facebookAuthCredential.rawNonce : ${facebookAuthCredential.rawNonce}');
      blog('facebookAuthCredential.secret : ${facebookAuthCredential.secret}');
      blog('facebookAuthCredential.token : ${facebookAuthCredential.token}');
      blog('facebookAuthCredential.accessToken : ${facebookAuthCredential.accessToken}');
      blog('facebookAuthCredential.providerId : ${facebookAuthCredential.providerId}');
      blog('facebookAuthCredential.signInMethod : ${facebookAuthCredential.signInMethod}');

    }

  }
  // -----------------------------------------------------------------------------

  /// GOOGLE

  // --------------------
  /// TESTED : WORKS PERFECT
  static void blogGoogleSignInAuthentication({
    GoogleSignInAuthentication? auth,
  }){

    if (auth == null){
      blog('blogGoogleSignInAuthentication : GoogleSignInAuthentication is null');
    }
    else {
      blog('GoogleSignInAuthentication :----> ');
      blog('auth.accessToken : ${auth.accessToken}');
      blog('auth.idToken : ${auth.idToken}');
    }

  }
  // -----------------------------------------------------------------------------
}
