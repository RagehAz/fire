part of super_fire;

/// TAMAM
class _NativeFirebase {
  // -----------------------------------------------------------------------------

  /// NativeFirebase SINGLETON

  // --------------------
  _NativeFirebase.singleton();
  static final _NativeFirebase _singleton = _NativeFirebase.singleton();
  static _NativeFirebase get instance => _singleton;
  // -----------------------------------------------------------------------------

  /// INITIALIZATION

  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> initialize({
    required FirebaseOptions options,
    required String? appName,
    String? persistentStoragePath,
  }) async {

    assert(options.authDomain != null, 'options.authDomain is null');
    assert(options.databaseURL != null, 'options.databaseURL is null');
    assert(options.measurementId != null, 'options.measurementId is null');
    assert(options.storageBucket != null, 'options.storageBucket is null');

    /// AUTH FIRE
    final fd.FirebaseAuth _auth = await _NativeFirebase.instance._initializeAuthFire(
        apiKey: options.apiKey,
    );

    /// FIRE
    _NativeFirebase.instance._initializeFire(
      projectID: options.projectId,
      firebaseAuth: _auth,
    );

    /// APP
    final f_d.FirebaseApp _app = await _NativeFirebase.instance._initializeApp(
      options: options,
      persistentStoragePath: persistentStoragePath,
      appName: appName,
    );

    /// AUTH REAL
    _NativeFirebase.instance._initializeAuthReal(
        app: _app,
    );

    /// REAL
    _NativeFirebase.instance._initializeReal(
      databaseURL: options.databaseURL,
      app: _app,
    );

    /// STORAGE
    await _NativeFirebase.instance._initializeStorage(
      app: _app,
      persistentStoragePath: persistentStoragePath,
    );

  }
  // -----------------------------------------------------------------------------

  /// APP

  // --------------------
  /// FIREBASE APP SINGLETON
  f_d.FirebaseApp? _app;
  f_d.FirebaseApp? get app => _app;
  /// static f_d.FirebaseApp getApp() => _NativeFirebase.instance.app; // NOT USED
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<f_d.FirebaseApp> _initializeApp({
    required String? persistentStoragePath,
    required FirebaseOptions options,
    required String? appName,
  }) async {

    f_d.FirebaseDart.setup(storagePath: persistentStoragePath);

    final f_d.FirebaseApp app = await f_d.Firebase.initializeApp(
      name: appName,
      options: f_d.FirebaseOptions(
        appId: options.appId,
        apiKey: options.apiKey,
        projectId: options.projectId,
        messagingSenderId: options.messagingSenderId,
        authDomain: options.authDomain, //'my_project.firebaseapp.com'
        databaseURL: options.databaseURL,
        measurementId: options.measurementId,
        storageBucket: options.storageBucket,
        appGroupId: options.appGroupId,
        androidClientId: options.androidClientId,
        deepLinkURLScheme: options.deepLinkURLScheme,
        iosBundleId: options.iosBundleId,
        iosClientId: options.iosClientId,
        trackingId: options.trackingId,
      ),
    );

    _app = app;

    return app;
  }
  // -----------------------------------------------------------------------------

  /// AUTH A (FOR FIRE)

  // --------------------
  /// FIREBASE AUTH INSTANCE SINGLETON
  fd.FirebaseAuth? _authFire;
  fd.FirebaseAuth? get authFire => _authFire;
  static fd.FirebaseAuth? getAuthFire() => _NativeFirebase.instance.authFire;
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<fd.FirebaseAuth> _initializeAuthFire({
    required String apiKey,
    // required String projectID,
  }) async {

    final fd.FirebaseAuth firebaseAuth = fd.FirebaseAuth(
        apiKey,
        fd.VolatileStore(), // HiveStore
        );

    _authFire = firebaseAuth;

    blog('=> Native Firebase Auth has been initialized');

    return firebaseAuth;
  }
  // -----------------------------------------------------------------------------

  /// AUTH B (FOR REAL & STORAGE)

  // --------------------
  /// FIREBASE AUTH INSTANCE SINGLETON
  f_d.FirebaseAuth? _authReal;
  f_d.FirebaseAuth? get authReal => _authReal;
  static f_d.FirebaseAuth? getAuthReal() => _NativeFirebase.instance.authReal;
  // --------------------
  /// TESTED : WORKS PERFECT
  f_d.FirebaseAuth _initializeAuthReal({
    required f_d.FirebaseApp app,
  }) {
    final f_d.FirebaseAuth auth = f_d.FirebaseAuth.instanceFor(app: app);
    _authReal = auth;
    return auth;
}
  // -----------------------------------------------------------------------------

  /// FIRE

  // --------------------
  /// FIREBASE FIRESTORE INSTANCE SINGLETON
  fd.Firestore? _fire;
  fd.Firestore? get fire => _fire;
  static fd.Firestore? getFire() => _NativeFirebase.instance.fire;
  // --------------------
  /// TESTED : WORKS PERFECT
  fd.Firestore _initializeFire({
    required fd.FirebaseAuth? firebaseAuth,
    required String projectID,
  }) {
    fd.Firestore _store;


    if (firebaseAuth == null) {
      _store = fd.Firestore.initialize(
        projectID,
        // useApplicationDefaultAuth: false,
        // databaseId: ,
        // emulator: ,
      );
    }

    else {

      _store = fd.Firestore(
        projectID,
        authenticator: (Map<String, String> metadata, String uri) async {
          final String  idToken = await firebaseAuth.tokenProvider.idToken;
          metadata['authorization'] = 'Bearer $idToken';
          return;
        },
        // databaseId: ,
        // emulator: ,
      );

      /// FOR REFERENCE : THIS WAS OLD IMPLEMENTATION
      /*

     _store = fd.Firestore(
        projectID,
        auth: firebaseAuth,
        // databaseId: ,
        // emulator: ,
      );

   */

    }

    _fire = _store;
    blog('=> Native Firebase Firestore has been initialized');

    return _store;
  }
  // -----------------------------------------------------------------------------

  /// REAL

  // --------------------
  /// FIREBASE REALTIME DATABASE INSTANCE SINGLETON
  f_d.FirebaseDatabase? _real;
  f_d.FirebaseDatabase? get real => _real;
  static f_d.FirebaseDatabase? getReal() => _NativeFirebase.instance.real;
  // --------------------
  /// TESTED : WORKS PERFECT
  f_d.FirebaseDatabase _initializeReal({
    required f_d.FirebaseApp app,
    required String? databaseURL,
  }){

    final f_d.FirebaseDatabase _db = f_d.FirebaseDatabase(
      app: app,
      databaseURL: databaseURL,
    );

    _real = _db;

    return _db;
  }
  // -----------------------------------------------------------------------------

  /// STORAGE

  // --------------------
  /// FIREBASE STORAGE INSTANCE SINGLETON
  f_d.FirebaseStorage? _storage;
  f_d.FirebaseStorage? get storage => _storage;
  static f_d.FirebaseStorage? getStorage() => _NativeFirebase.instance.storage;
  // --------------------
  /// TESTED : WORKS PERFECT
  Future<f_d.FirebaseStorage> _initializeStorage({
    required f_d.FirebaseApp app,
    required String? persistentStoragePath,
  }) async {

    final f_d.FirebaseStorage storage = f_d.FirebaseStorage.instanceFor(
      app: app,
      // bucket: ,
    );

    _storage = storage;

    blog('=> Native Firebase Storage has been initialized');

    return storage;
  }
  // -----------------------------------------------------------------------------
}
