part of super_fire;

class _OfficialFirebase {
  // -----------------------------------------------------------------------------

  /// OfficialFirebase SINGLETON

  // --------------------
  _OfficialFirebase.singleton();
  static final _OfficialFirebase _singleton = _OfficialFirebase.singleton();
  static _OfficialFirebase get instance => _singleton;
  // -----------------------------------------------------------------------------

  /// INITIALIZATION

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> initialize({
    @required FirebaseOptions options,
    @required SocialKeys socialKeys,
    String appName,
  }) async {

    if (DeviceChecker.deviceIsWindows() == false) {
      await tryAndCatch(
        functions: () async {

          /// IOS - ANDROID - WEB : NO WINDOWS SUPPORT
          await _OfficialFirebase.instance._initializeApp(
            options: options,
            appName: appName,
          );

          _initializeSocialAuthing(
            socialKeys: socialKeys,
          );

        },
      );
    }

  }
  // -----------------------------------------------------------------------------

  /// APP

  // --------------------
  /// FIREBASE APP SINGLETON
  FirebaseApp _app;
  FirebaseApp get app => _app;
  /// NOT USED
  // static FirebaseApp getApp() => _OfficialFirebase.instance.app;
  // --------------------
  Future<FirebaseApp> _initializeApp({
    @required FirebaseOptions options,
    @required String appName,
  }) async {

    final FirebaseApp app = await Firebase.initializeApp(
      options: options,
      name: appName,
    );

    _app = app;

    return app;
  }
  // -----------------------------------------------------------------------------

  /// AUTH

  // --------------------
  /// FIREBASE AUTH INSTANCE SINGLETON
  f_a.FirebaseAuth _auth;
  f_a.FirebaseAuth get auth => _auth ??= f_a.FirebaseAuth.instance;
  static f_a.FirebaseAuth getAuth() => _OfficialFirebase.instance.auth;
  // --------------------
  /// TESTED : WORKS PERFECT
  static void _initializeSocialAuthing({
    @required SocialKeys socialKeys,
  }) {

    if (socialKeys != null) {
      fui.FirebaseUIAuth.configureProviders([
        if (socialKeys.supportEmail == true)
          fui.EmailAuthProvider(),
        if (socialKeys.googleClientID != null)
          GoogleProvider(
            clientId: socialKeys.googleClientID,
            // redirectUri: ,
            // scopes: ,
            // iOSPreferPlist: ,
          ),
        if (socialKeys.facebookAppID != null)
          FacebookProvider(
            clientId: socialKeys.facebookAppID,
            // redirectUri: '',
          ),
        if (socialKeys.supportApple == true)
          AppleProvider(

            // scopes: ,
          ),
      ]);
    }

  }
  // -----------------------------------------------------------------------------

  /// FIRE

  // --------------------
  /// FIREBASE FIRESTORE INSTANCE SINGLETON
  cloud.FirebaseFirestore _fire;
  cloud.FirebaseFirestore get fire => _fire ??= cloud.FirebaseFirestore.instance;
  static cloud.FirebaseFirestore getFire() => _OfficialFirebase.instance.fire;
  // -----------------------------------------------------------------------------

  /// REAL

  // --------------------
  /// FIREBASE REALTIME DATABASE INSTANCE SINGLETON
  f_db.FirebaseDatabase _real;
  f_db.FirebaseDatabase get real => _real ??= f_db.FirebaseDatabase.instance;
  static f_db.FirebaseDatabase getReal() => _OfficialFirebase.instance.real;
  // --------------------

  /// STORAGE

  // --------------------
  /// FIREBASE STORAGE INSTANCE SINGLETON
  f_s.FirebaseStorage _storage;
  f_s.FirebaseStorage get storage => _storage ??= f_s.FirebaseStorage.instance;
  static f_s.FirebaseStorage getStorage() => _OfficialFirebase.instance.storage;
  // -----------------------------------------------------------------------------
}
