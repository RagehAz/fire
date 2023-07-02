part of super_fire;

class FirebaseInitializer {
  // -----------------------------------------------------------------------------

  /// NativeAuth SINGLETON

  // --------------------
  FirebaseInitializer.singleton();
  static final FirebaseInitializer _singleton = FirebaseInitializer.singleton();
  static FirebaseInitializer get instance => _singleton;
  // -----------------------------------------------------------------------------

  /// INITIALIZATION

  // --------------------
  /// use official firebase packages or Native dart implementation packages
  bool _usesOfficial = true;
  bool get usesOfficial => _usesOfficial;
  // --------------------
  /// TESTED : WORKS PERFECT
  static bool isUsingOfficialPackages() => FirebaseInitializer.instance.usesOfficial;
  // -----------------------------------------------------------------------------
  /// TESTED : WORKS PERFECT
  Future<void> _initialize({
    required bool? useOfficialPackages,
    required FirebaseOptions options,
    required SocialKeys socialKeys,
    required String? nativePersistentStoragePath,
    required String? appName,
  }) async {

    _usesOfficial = useOfficialPackages ?? (kIsWeb || DeviceChecker.deviceIsAndroid() || DeviceChecker.deviceIsIOS());

    /// OFFICIAL
    if (_usesOfficial == true){
      await _OfficialFirebase.initialize(
        appName: appName,
        options: options,
        socialKeys: socialKeys,
      );
    }

    /// NATIVE
    else {
      await _NativeFirebase.initialize(
        appName: appName,
        options: options,
        persistentStoragePath: nativePersistentStoragePath,
      );
    }

  }
  // --------------------
  /// TESTED : WORKS PERFECT
  static Future<void> initialize({
    required FirebaseOptions? options,
    required SocialKeys socialKeys,
    bool? useOfficialPackages,
    String? appName,
    String? nativePersistentStoragePath,
  }) async {

    await FirebaseInitializer.instance._initialize(
      options: options,
      socialKeys: socialKeys,
      useOfficialPackages: useOfficialPackages,
      nativePersistentStoragePath: nativePersistentStoragePath,
      appName: appName,
    );

  }
  // -----------------------------------------------------------------------------
}
