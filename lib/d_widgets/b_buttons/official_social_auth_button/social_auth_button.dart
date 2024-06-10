part of super_fire;

class SocialAuthButton extends StatelessWidget {
  // --------------------------------------------------------------------------
  const SocialAuthButton({
    required this.signInMethod,
    required this.socialKeys,
    required this.onSuccess,
    required this.manualAuthing,
    this.onError,
    this.authAction = fui.AuthAction.signIn,
    /// WILL ALWAYS HAVE 5 PADDING FROM ALL SIDES FOR EACH BUTTON
    /// BUT THE CONTAINING BOX SIZE IS THIS :-
    this.size = standardSize,
    this.onAuthLoadingChanged,
    super.key
  });
  // --------------------------------------------------------------------------
  final SignInMethod signInMethod;
  final SocialKeys socialKeys;
  final Function(AuthModel? authModel) onSuccess;
  final Function(String? error)? onError;
  final Function(bool isLoading)? onAuthLoadingChanged;
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
        if (socialKeys.googleClientID != null){
          return GoogleProvider(
            clientId: socialKeys.googleClientID!,
            // redirectUri: ,
            // scopes: ,
            // iOSPreferPlist: ,
          );
        }
        else {
          return null;
        }

      case SignInMethod.facebook:
        if (socialKeys.facebookAppID != null){
          return FacebookProvider(
            clientId: socialKeys.facebookAppID!,
            // redirectUri: '',
          );
        }
        else {
          return null;
        }

      case SignInMethod.apple:
        return AppleProvider(
          // scopes: ,
        );

      case SignInMethod.anonymous:
        return null;

      case SignInMethod.password:
        return null;

    }
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  bool _listen (fui.AuthState oldState, fui.AuthState newState, fui.OAuthController ctrl){

    /// UN-INITIALIZED
    if (newState is fui.Uninitialized){
      blog('SocialAuthButton : is Uninitialized');
      onAuthLoadingChanged?.call(false);
    }

    /// SIGNING IN
    else if (newState is fui.SigningIn){
      blog('SocialAuthButton : is signing in');
      onAuthLoadingChanged?.call(true);
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
        onError?.call(failure.exception.toString());
        onAuthLoadingChanged?.call(false);
      }
    }

    /// SIGNED IN
    else if (newState is fui.SignedIn) {
        final fui.SignedIn signedIn = newState;
        final AuthModel? _authModel = AuthModel._getAuthModelFromOfficialFirebaseUser(
            user: signedIn.user,
        );
        onSuccess(_authModel);
        onAuthLoadingChanged?.call(false);
    }

    /// USER CREATED
    else if (newState is fui.UserCreated) {
      final fui.UserCreated userCreated = newState;
      final AuthModel? _authModel = AuthModel._getAuthModelFromOfficialUserCredential(
        cred: userCreated.credential,
      );
      onSuccess(_authModel);
      onAuthLoadingChanged?.call(false);
    }

    /// DIFFERENT SIGN IN METHOD FOUND
    // else if (newState is fui.DifferentSignInMethodsFound){
    //   if (onError != null){
    //     final fui.DifferentSignInMethodsFound  dif = newState;
    //     onError?.call('[DifferentSignInMethodsFound]: A different email is assigned for this account (${dif.email})');
    //     onAuthLoadingChanged?.call(false);
    //   }
    // }

    /// FETCHING PROVIDERS FOR EMAIL
    else if (newState is fui.FetchingProvidersForEmail){
      blog('SocialAuthButton : is FetchingProvidersForEmail');
    }

    /// MFA REQUIRED
    else if (newState is fui.MFARequired){
      blog('SocialAuthButton : is MFARequired');
    }

    else {
      onAuthLoadingChanged?.call(false);
    }

    // ignore: # avoid_returning_null
    return false;
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  String? _getIcon(SignInMethod? signInMethod){
    switch (signInMethod){
      case SignInMethod.apple: return Iconz.comApple;
      case SignInMethod.facebook: return Iconz.comFacebook;
      case SignInMethod.google: return Iconz.comGoogleLogo;
      case SignInMethod.password: return Iconz.comEmail;
      case SignInMethod.anonymous: return Iconz.users;
      default: return null;
    }
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  double _getIconSizeFactor(SignInMethod? signInMethod){
    switch (signInMethod){
      case SignInMethod.apple:      return 0.5;
      case SignInMethod.facebook:   return 1;
      case SignInMethod.google:     return 0.5;
      case SignInMethod.password:      return 0.5;
      case SignInMethod.anonymous:  return 0.5;
      default: return 1;
    }
  }
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _onManualAuth() async {

    onAuthLoadingChanged?.call(true);

    if (signInMethod == SignInMethod.google){
      await _googleManualAuthing();
    }

    else if (signInMethod == SignInMethod.facebook){
      await _facebookManualAuthing();
    }

    else if (signInMethod == SignInMethod.apple){
      await _appleManualAuthing();
    }

    onAuthLoadingChanged?.call(false);

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _googleManualAuthing() async {

    final AuthModel? _authModel = await OfficialGoogleAuthing.emailSignIn(
      onError: onError,
    );

    if (_authModel != null){
      onSuccess(_authModel);
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _facebookManualAuthing() async {

    final AuthModel? _authModel = await OfficialFacebookAuthing.signIn(
      onError: onError,
    );

    if (_authModel != null){
      onSuccess(_authModel);
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<void> _appleManualAuthing() async {

    final AuthModel? _authModel = await OfficialAppleAuthing.signInByApple(
        onError: onError,
      );

    if (_authModel != null){
      onSuccess(_authModel);
    }

  }
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    /// ANDROID
    if (manualAuthing == true){

      return AuthButtonBox(
        size: size,
        child: SuperBox(
          height: size,
          width: size, // - 10,
          bubble: false,
          corners: AuthButtonBox.corners,
          icon: _getIcon(signInMethod),
          iconSizeFactor: _getIconSizeFactor(signInMethod),
          color: Colorz.white255,
          onTap: _onManualAuth,
        ),
      );

    }

    /// IOS
    else {

      return AuthButtonBox(
        size: size,
        child: fui.AuthStateListener<fui.OAuthController>(
          listener: _listen,
          child: fui.OAuthProviderButton(
            provider: _getProvider(signInMethod),
            auth: OfficialFirebase.getAuth(),
            action: authAction,
            variant: fui.OAuthButtonVariant.icon,
          ),
        ),
      );

    }

  }
  // --------------------------------------------------------------------------
}
