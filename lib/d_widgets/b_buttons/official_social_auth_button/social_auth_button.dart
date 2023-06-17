part of super_fire;

/*
DOCUMENTATION
https://github.com/firebase/flutterfire/blob/master/packages/firebase_ui_auth/doc/providers/oauth.md#custom-screens
 */

class SocialAuthButton extends StatelessWidget {
  // --------------------------------------------------------------------------
  const SocialAuthButton({
    @required this.signInMethod,
    @required this.socialKeys,
    @required this.onSuccess,
    @required this.manualAuthing,
    this.onError,
    this.authAction = fui.AuthAction.signIn,
    /// WILL ALWAYS HAVE 5 PADDING FROM ALL SIDES FOR EACH BUTTON
    /// BUT THE CONTAINING BOX SIZE IS THIS :-
    this.size = standardSize,
    this.onAuthLoadingChanged,
    Key key
  }) : super(key: key);
  // --------------------------------------------------------------------------
  final SignInMethod signInMethod;
  final SocialKeys socialKeys;
  final Function(AuthModel authModel) onSuccess;
  final Function(String error) onError;
  final Function(bool isLoading) onAuthLoadingChanged;
  final fui.AuthAction authAction;
  final double size;
  /// AUTO AUTHING uses
  /// fireUI.OAuthProviderButton()
  ///
  /// Manual Authing uses
  /// FacebookAuthing(); GoogleAuthing(); AppleAuthing(); classes
  ///
  /// what is failing :-
  /// web fails in manual authing
  /// android fails in auto authing
  ///
  /// WHATS PERFECTLY WORKING
  /// WEB => AUTO AUTHING
  /// IOS => AUTO AUTHING
  /// ANDROID => MANUAL AUTHING
  ///
  /// CONCLUSION
  /// so pass DeviceChecker.deviceIsAndroid() to manualAuthing parameter
  final bool manualAuthing;
  // --------------------------------------------------------------------------
  static const double standardSize = 50;
  // --------------------
  /// TESTED : WORKS PERFECT
  dynamic _getProvider(SignInMethod signInMethod) {
    switch (signInMethod) {

      case SignInMethod.google:
        return GoogleProvider(
          clientId: socialKeys.googleClientID,
          // redirectUri: ,
          // scopes: ,
          // iOSPreferPlist: ,
        );
        break;

      case SignInMethod.facebook:
        return FacebookProvider(
          clientId: socialKeys.facebookAppID,
          // redirectUri: '',
        );
        break;

      case SignInMethod.apple:
        return AppleProvider(
          // scopes: ,
        );
        break;

      case SignInMethod.anonymous:
        return null;
        break;

      case SignInMethod.password:
        return null;
        break;

    }
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  bool _listen (fui.AuthState oldState, fui.AuthState newState, fui.OAuthController ctrl){

    /// UN-INITIALIZED
    if (newState is fui.Uninitialized){
      blog('SocialAuthButton : is Uninitialized');
      onAuthLoadingChanged(false);
    }

    /// SIGNING IN
    else if (newState is fui.SigningIn){
      blog('SocialAuthButton : is signing in');
      onAuthLoadingChanged(true);
    }

    /// AUTH CRED RECEIVED
    else if (newState is fui.CredentialReceived){
      final fui.CredentialReceived cred = newState;
      blog('SocialAuthButton : is CredentialReceived');
      AuthBlog.blogAuthCred(cred.credential);
    }

    /// AUTH CRED LINKED
    else if (newState is fui.CredentialLinked){
        final fui.CredentialLinked cred = newState;
        AuthBlog.blogAuthCred(cred.credential);
    }

    /// AUTH FAILED
    else if (newState is fui.AuthFailed){
      if (onError != null){
        final fui.AuthFailed failure = newState;
        onError(failure.exception.toString());
        onAuthLoadingChanged(false);
      }
    }

    /// SIGNED IN
    else if (newState is fui.SignedIn) {
        final fui.SignedIn signedIn = newState;
        final AuthModel _authModel = AuthModel._getAuthModelFromOfficialFirebaseUser(
            user: signedIn.user,
        );
        onSuccess(_authModel);
        onAuthLoadingChanged(false);
    }

    /// USER CREATED
    else if (newState is fui.UserCreated) {
      final fui.UserCreated userCreated = newState;
      final AuthModel _authModel = AuthModel._getAuthModelFromOfficialUserCredential(
        cred: userCreated.credential,
      );
      onSuccess(_authModel);
      onAuthLoadingChanged(false);
    }

    /// DIFFERENT SIGN IN METHOD FOUND
    else if (newState is fui.DifferentSignInMethodsFound){
      if (onError != null){
        final fui.DifferentSignInMethodsFound  dif = newState;
        onError('[DifferentSignInMethodsFound]: A different email is assigned for this account (${dif.email})');
        onAuthLoadingChanged(false);
      }
    }

    /// FETCHING PROVIDERS FOR EMAIL
    else if (newState is fui.FetchingProvidersForEmail){
      blog('SocialAuthButton : is FetchingProvidersForEmail');
    }

    /// MFA REQUIRED
    else if (newState is fui.MFARequired){
      blog('SocialAuthButton : is MFARequired');
    }

    else {
      onAuthLoadingChanged(false);
    }

    // ignore: avoid_returning_null
    return null;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  String _getIcon(SignInMethod signInMethod){
    switch (signInMethod){
      case SignInMethod.apple: return Iconz.comApple; break;
      case SignInMethod.facebook: return Iconz.comFacebook; break;
      case SignInMethod.google: return Iconz.comGooglePlus; break;
      case SignInMethod.password: return Iconz.comEmail; break;
      case SignInMethod.anonymous: return Iconz.users; break;
      default: return null;
    }
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  double _getIconSizeFactor(SignInMethod signInMethod){
    switch (signInMethod){
      case SignInMethod.apple:      return 0.6; break;
      case SignInMethod.facebook:   return 1; break;
      case SignInMethod.google:     return 0.6; break;
      case SignInMethod.password:      return 0.6; break;
      case SignInMethod.anonymous:  return 0.6; break;
      default: return 1;
    }
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _onManualAuth() async {

    onAuthLoadingChanged(true);

    if (signInMethod == SignInMethod.google){
      await _googleManualAuthing();
    }

    else if (signInMethod == SignInMethod.facebook){
      await _facebookManualAuthing();
    }

    else if (signInMethod == SignInMethod.apple){
      await _appleManualAuthing();
    }

    onAuthLoadingChanged(false);

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _googleManualAuthing() async {

    final AuthModel _authModel = await OfficialGoogleAuthing.emailSignIn(
      onError: onError,
    );

    onSuccess(_authModel);

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _facebookManualAuthing() async {

    final AuthModel _authModel = await OfficialFacebookAuthing.signIn(
      onError: onError,
    );

    onSuccess(_authModel);

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _appleManualAuthing() async {

    final AuthModel _authModel = await OfficialAppleAuthing.signInByApple(
        onError: onError,
      );

    onSuccess(_authModel);
  }
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    /// NATIVE
    if (FirebaseInitializer.isUsingOfficialPackages() == false){
      return const SizedBox();
    }

    /// ANDROID
    else if (manualAuthing == true){

      return _AuthButtonBox(
        size: size,
        child: SuperBox(
          height: size - 10,
          width: size - 10,
          bubble: false,
          corners: _AuthButtonBox.corners,
          icon: _getIcon(signInMethod),
          iconSizeFactor: _getIconSizeFactor(signInMethod),
          color: Colorz.white255,
          onTap: _onManualAuth,
        ),
      );

    }

    /// IOS
    else {

      return _AuthButtonBox(
        size: size,
        child: fui.AuthStateListener<fui.OAuthController>(
          listener: _listen,
          child: fui.OAuthProviderButton(
            provider: _getProvider(signInMethod),
            auth: _OfficialFirebase.getAuth(),
            action: authAction,
            variant: fui.OAuthButtonVariant.icon,
          ),
        ),
      );

    }

  }
  // --------------------------------------------------------------------------
}
