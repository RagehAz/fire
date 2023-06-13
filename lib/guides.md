
---


### OFFICIAL GOOGLE AUTHING GUIDE

FOR WEB INTEGRATION

- add the following line to ./web/index.html

<meta name="google-signin-client_id" content="YOUR_GOOGLE_SIGN_IN_OAUTH_CLIENT_ID.apps.googleusercontent.com">


---

### Official facebook authing guide

/// FACEBOOK DEVELOPER DASHBOARD URL
https://developers.facebook.com/apps/?show_reminder=true

/// SETUP ON ANDROID

1 - open new app facebook developer account
2 - start doing Android
3 - skip download the facebook SDK
4 - assure u r using mavenCentral() under buildscript and allprojects in android/build.gradle
5 - put [ implementation 'com.facebook.android:facebook-android-sdk:latest.release' ] in
dependencies in  android/app/build.gradle,, ref : TalkToHumanity // USED_FOR_FACEBOOK_AUTH
6 - add package name com.example.example and com.example.example.MainActivity in fc dashboard
sequence
7 - get your key hashes and put in in dashboard sequence
  7a - download opensssl 64 from https://code.google.com/archive/p/openssl-for-windows/downloads
  7b - extract openssl in C:\Users\rageh\openssl
  7c - get android debugkey
    7c1 - cd android "from project terminal" to run below line
    7c2 - run this : D:\projects\bldrs\talktohumanity\android> .\gradlew signingreport
    7c3 - make sure that C:\Users\rageh\.android\debug.keystore is correct path for debugKeystore
  7d - run the below command in command prompt cmd
    7d1 - keytool -exportcert -alias androiddebugkey -keystore "C:\Users\rageh\.android\debug.keystore" | "C:\Users\rageh\openssl\bin\openssl" sha1 -binary | "C:\Users\rageh\openssl\bin\openssl" base64
    7d2 - enter keystore password : 'same as my windows pin'
  7e - add the generated key Hash to 'Release Key Hashes' in facebook dashboard sequence
8 - and set single sign on to "yes" in facebook dashboard sequence
9 - create strings.xml in .../android/app/src/main/res/values/strings.xml
  9a - see TalkToHumanity for reference.
  9b - get AppID from facebookDev-dashboard-Settings-Basic
  9c - get facebook_client_token from facebookDev-dashboard-Settings-Advanced-Security-Client Token

10 - modify android/app/src/main/AndroidManifest.xml
  10a - add xmlns:tools="http://schemas.android.com/tools" line 3,, see TalkToHumanity
  10b - assure there are <uses-permission android:name="android.permission.INTERNET" /> line
  10c - add this line under the "uses-permission" <uses-permission android:name="com.google.android.gms.permission.AD_ID" tools:node="remove"/>
  10d - copy the last 16 lines in TalkToHumanity as is
11 - add flutter_facebook_auth package in pubspec.yaml
12 - add facebook sign-in method in authentication in firebase
  12a - get App ID & App secret from facebookDev-dashboard-Settings-Basic

---

### Official Apple authing guide

/*

  CONFIGURATIONS

- IOS 13+
- add Apple as auth provider in firebase console
- add "Sign in with Apple" in xCode/Runner/Signing & Capabilities/+ Capability/Sign in with Apple
- make sure it is added under all - debug - release - profile

 */


### NATIVE FIRE REFERENCE VIDEO
  /// https://www.youtube.com/watch?v=Tw7L2NkhwPc&t=185s
