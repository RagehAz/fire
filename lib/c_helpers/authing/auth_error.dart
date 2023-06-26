part of super_fire;

class AuthError {
  // -----------------------------------------------------------------------------

  const AuthError();

  // -----------------------------------------------------------------------------
  static const Map<String, dynamic> _authErrors = {
    // There is no user record corresponding to this identifier. The user may have been deleted.',
    '[firebase_auth/user-not-found]': 'E-mail is not found',
    // A network error (such as timeout, interrupted connection or unreachable host) has occurred.',
    '[firebase_auth/network-request-failed]': 'No internet connection',
    // The email address is badly formatted.',
    '[firebase_auth/invalid-email]': 'E-mail is wrong',
    // The password is invalid or the user does not have a password.'
    '[firebase_auth/wrong-password]': 'Password is wrong',
    // We have blocked all requests from this device due to unusual activity. Try again later.',
    '[firebase_auth/too-many-requests]': 'Too many failed attempts, please try again later',
    // Google sign in failed
    'PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10: , null, null)' : 'Could not sign in by google',
    // The email address is already in use by another account.',
    '[firebase_auth/email-already-in-use]': 'This email is already registered',
    // The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.
    '[cloud_firestore/unavailable]': 'Network is unresponsive',
    //
    '[firebase_auth/account-exists-with-different-credential]': 'This email is already used by different Sign-In method',
    //

  };
  // -----------------------------------------------------------------------------
  static const Map<String, dynamic> allGoogleErrors = {
    'wrong-password': 'The password is invalid or the user does not have a password.',
    'claims-too-large': 'The claims payload provided to setCustomUserClaims() exceeds the maximum allowed size of 1000 bytes.',
    'email-already-exists': 'The provided email is already in use by an existing user. Each user must have a unique email.',
    'id-token-expired': 'The provided Firebase ID token is expired.',
    'id-token-revoked': 'The Firebase ID token has been revoked.',
    'insufficient-permission': 'The credential used to initialize the Admin SDK has insufficient permission to access the requested Authentication resource. Refer to Set up a Firebase project for documentation on how to generate a credential with appropriate permissions and use it to authenticate the Admin SDKs.',
    'invalid-claims': 'The custom claim attributes provided to setCustomUserClaims() are invalid.',
    'invalid-creation-time': 'The creation time must be a valid UTC date string.',
    'invalid-disabled-field': 'The provided value for the disabled user property is invalid. It must be a boolean.',
    'invalid-display-name': 'The provided value for the displayName user property is invalid. It must be a non-empty string.',
    'invalid-email-verified': 'The provided value for the emailVerified user property is invalid. It must be a boolean.',
    'invalid-hash-algorithm': 'The hash algorithm must match one of the strings in the list of supported algorithms.',
    'invalid-hash-block-size': 'The hash block size must be a valid number.',
    'invalid-hash-derived-key-length': 'The hash derived key length must be a valid number.',
    'invalid-hash-key': 'The hash key must a valid byte buffer.',
    'invalid-hash-memory-cost': 'The hash memory cost must be a valid number.',
    'invalid-hash-parallelization': 'The hash parallelization must be a valid number.',
    'invalid-hash-rounds': 'The hash rounds must be a valid number.',
    'invalid-hash-salt-separator': 'The hashing algorithm salt separator field must be a valid byte buffer.',
    'invalid-id-token': 'The provided ID token is not a valid Firebase ID token.',
    'invalid-last-sign-in-time': 'The last sign-in time must be a valid UTC date string.',
    'invalid-page-token': 'The provided next page token in listUsers() is invalid. It must be a valid non-empty string.',
    'invalid-password': 'The provided value for the password user property is invalid. It must be a string with at least six characters.',
    'invalid-password-hash': 'The password hash must be a valid byte buffer.',
    'invalid-password-salt': 'The password salt must be a valid byte buffer',
    'invalid-photo-url': 'The provided value for the photoURL user property is invalid. It must be a string URL.',
    'invalid-provider-data': 'The providerData must be a valid array of UserInfo objects.',
    'invalid-oauth-responsetype': 'Only exactly one OAuth responseType should be set to true.',
    'invalid-session-cookie-duration': 'The session cookie duration must be a valid number in milliseconds between 5 minutes and 2 weeks.',
    'invalid-uid': 'The provided uid must be a non-empty string with at most 128 characters.',
    'invalid-user-import': 'The user record to import is invalid.',
    'maximum-user-count-exceeded': 'The maximum allowed number of users to import has been exceeded.',
    'missing-hash-algorithm': 'Importing users with password hashes requires that the hashing algorithm and its parameters be provided.',
    'missing-uid': 'A uid identifier is required for the current operation.',
    'missing-oauth-client-secret': 'The OAuth configuration client secret is required to enable OIDC code flow.',
    'phone-number-already-exists': 'The provided phoneNumber is already in use by an existing user. Each user must have a unique phoneNumber.',
    'project-not-found': 'No Firebase project was found for the credential used to initialize the Admin SDKs. Refer to Set up a Firebase project for documentation on how to generate a credential for your project and use it to authenticate the Admin SDKs.',
    'reserved-claims': 'One or more custom user claims provided to setCustomUserClaims() are reserved. For example, OIDC specific claims such as (sub, iat, iss, exp, aud, auth_time, etc) should not be used as keys for custom claims.',
    'session-cookie-expired': 'The provided Firebase session cookie is expired.',
    'session-cookie-revoked': 'The Firebase session cookie has been revoked.',
    'uid-already-exists': 'The provided uid is already in use by an existing user. Each user must have a unique uid.',
    'admin-restricted-operation': 'This operation is restricted to administrators only.',
    'app-not-authorized': "This app, identified by the domain where it's hosted, is not authorized to use Firebase Authentication with the provided API key. Review your key configuration in the Google API console.",
    'app-not-installed': 'The requested mobile application corresponding to the identifier (Android package name or iOS bundle ID) provided is not installed on this device.',
    'captcha-check-failed': 'The reCAPTCHA response token provided is either invalid, expired, already used or the domain associated with it does not match the list of whitelisted domains.',
    'code-expired': 'The SMS code has expired. Please re-send the verification code to try again.',
    'cordova-not-ready': 'Cordova framework is not ready.',
    'cors-unsupported': 'This browser is not supported.',
    'credential-already-in-use': 'This credential is already associated with a different user account.',
    'custom-token-mismatch': 'The custom token corresponds to a different audience.',
    'requires-recent-login': 'This operation is sensitive and requires recent authentication. Log in again before retrying this request.',
    'dependent-sdk-initialized-before-auth': 'Another Firebase SDK was initialized and is trying to use Auth before Auth is initialized. Please be sure to call `initializeAuth` or `getAuth` before starting any other Firebase SDK.',
    'dynamic-link-not-activated': 'Please activate Dynamic Links in the Firebase Console and agree to the terms and conditions.',
    'email-change-needs-verification': 'Multi-factor users must always have a verified email.',
    'email-already-in-use': 'The email address is already in use by another account.',
    'emulator-config-failed': "Auth instance has already been used to make a network call. Auth can no longer be configured to use the emulator. Try calling 'connectAuthEmulator()' sooner.",
    'expired-action-code': 'The action code has expired.',
    'cancelled-popup-request': 'This operation has been cancelled due to another conflicting popup being opened.',
    'internal-error': 'An internal AuthError has occurred.',
    'invalid-app-credential': 'The phone verification request contains an invalid application verifier. The reCAPTCHA token response is either invalid or expired.',
    'invalid-app-id': 'The mobile app identifier is not registed for the current project.',
    'invalid-user-token': "This user's credential isn't valid for this project. This can happen if the user's token has been tampered with, or if the user isn't for the project associated with this API key.",
    'invalid-auth-event': 'An internal AuthError has occurred.',
    'invalid-verification-code': 'The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure to use the verification code provided by the user.',
    'invalid-continue-uri': 'The continue URL provided in the request is invalid.',
    'invalid-cordova-configuration': 'The following Cordova plugins must be installed to enable OAuth sign-in: cordova-plugin-buildinfo, cordova-universal-links-plugin, cordova-plugin-browsertab, cordova-plugin-inappbrowser and cordova-plugin-customurlscheme.',
    'invalid-custom-token': 'The custom token format is incorrect. Please check the documentation.',
    'invalid-dynamic-link-domain': 'The provided dynamic link domain is not configured or authorized for the current project.',
    'invalid-email': 'The email address is badly formatted.',
    'invalid-emulator-scheme': 'Emulator URL must start with a valid scheme (http:// or https://).',
    'invalid-api-key': 'Your API key is invalid, please check you have copied it correctly.',
    'invalid-cert-hash': 'The SHA-1 certificate hash provided is invalid.',
    'invalid-credential': 'The supplied auth credential is malformed or has expired.',
    'invalid-message-payload': 'The email template corresponding to this action contains invalid characters in its message. Please fix by going to the Auth email templates section in the Firebase Console.',
    'invalid-multi-factor-session': 'The request does not contain a valid proof of first factor successful sign-in.',
    'invalid-oauth-provider': 'EmailAuthProvider is not supported for this operation. This operation only supports OAuth providers.',
    'invalid-oauth-client-id': 'The OAuth client ID provided is either invalid or does not match the specified API key.',
    'unauthorized-domain': 'This domain is not authorized for OAuth operations for your Firebase project. Edit the list of authorized domains from the Firebase console.',
    'invalid-action-code': 'The action code is invalid. This can happen if the code is malformed, expired, or has already been used.',
    'invalid-persistence-type': 'The specified persistence type is invalid. It can only be local, session or none.',
    'invalid-phone-number': 'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code].',
    'invalid-provider-id': 'The specified provider ID is invalid.',
    'invalid-recipient-email': 'The email corresponding to this action failed to send as the provided recipient email address is invalid.',
    'invalid-sender': 'The email template corresponding to this action contains an invalid sender email or name. Please fix by going to the Auth email templates section in the Firebase Console.',
    'invalid-verification-id': 'The verification ID used to create the phone auth credential is invalid.',
    'invalid-tenant-id': "The Auth instance's tenant ID is invalid.",
    'missing-android-pkg-name': 'An Android Package Name must be provided if the Android App is required to be installed.',
    'auth-domain-config-required': 'Be sure to include authDomain when calling firebase.initializeApp(), by following the instructions in the Firebase console.',
    'missing-app-credential': 'The phone verification request is missing an application verifier assertion. A reCAPTCHA response token needs to be provided.',
    'missing-verification-code': 'The phone auth credential was created with an empty SMS verification code.',
    'missing-continue-uri': 'A continue URL must be provided in the request.',
    'missing-iframe-start': 'An internal AuthError has occurred.',
    'missing-ios-bundle-id': 'An iOS Bundle ID must be provided if an App Store ID is provided.',
    'missing-or-invalid-nonce': 'The request does not contain a valid nonce. This can occur if the SHA-256 hash of the provided raw nonce does not match the hashed nonce in the ID token payload.',
    'missing-multi-factor-info': 'No second factor identifier is provided.',
    'missing-multi-factor-session': 'The request is missing proof of first factor successful sign-in.',
    'missing-phone-number': 'To send verification codes, provide a phone number for the recipient.',
    'missing-verification-id': 'The phone auth credential was created with an empty verification ID.',
    'app-deleted': 'This instance of FirebaseApp has been deleted.',
    'multi-factor-info-not-found': 'The user does not have a second factor matching the identifier provided.',
    'multi-factor-auth-required': 'Proof of ownership of a second factor is required to complete sign-in.',
    'account-exists-with-different-credential': 'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.',
    'network-request-failed': 'A network AuthError (such as timeout, interrupted connection or unreachable host) has occurred.',
    'no-auth-event': 'An internal AuthError has occurred.',
    'no-such-provider': 'User was not linked to an account with the given provider.',
    'null-user': 'A null user object was provided as the argument for an operation which requires a non-null user object.',
    'operation-not-allowed': 'The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.',
    'operation-not-supported-in-this-environment': "This operation is not supported in the environment this application is running on. 'location.protocol' must be http, https or chrome-extension and web storage must be enabled.",
    'popup-blocked': 'Unable to establish a connection with the popup. It may have been blocked by the browser.',
    'popup-closed-by-user': 'The popup has been closed by the user before finalizing the operation.',
    'provider-already-linked': 'User can only be linked to one identity for the given provider.',
    'quota-exceeded': "The project's quota for this operation has been exceeded.",
    'redirect-cancelled-by-user': 'The redirect operation has been cancelled by the user before finalizing.',
    'redirect-operation-pending': 'A redirect sign-in operation is already pending.',
    'rejected-credential': 'The request contains malformed or mismatching credentials.',
    'second-factor-already-in-use': 'The second factor is already enrolled on this account.',
    'maximum-second-factor-count-exceeded': 'The maximum allowed number of second factors on a user has been exceeded.',
    'tenant-id-mismatch': "The provided tenant ID does not match the Auth instance's tenant ID",
    'timeout': 'The operation has timed out.',
    'user-token-expired': "The user's credential is no longer valid. The user must sign in again.",
    'too-many-requests': 'We have blocked all requests from this device due to unusual activity. Try again later.',
    'unauthorized-continue-uri': 'The domain of the continue URL is not whitelisted.  Please whitelist the domain in the Firebase console.',
    'unsupported-first-factor': 'Enrolling a second factor or signing in with a multi-factor account requires sign-in with a supported first factor.',
    'unsupported-persistence-type': 'The current environment does not support the specified persistence type.',
    'unsupported-tenant-operation': 'This operation is not supported in a multi-tenant context.',
    'unverified-email': 'The operation requires a verified email.',
    'user-cancelled': 'The user did not grant your application the permissions it requested.',
    'user-not-found': 'There is no user record corresponding to this identifier. The user may have been deleted.',
    'user-disabled': 'The user account has been disabled by an administrator.',
    'user-mismatch': 'The supplied credentials do not correspond to the previously signed in user.',
    'weak-password': 'The password must be 6 characters long or more.',
    'web-storage-unsupported': 'This browser is not supported or 3rd party cookies and data may be disabled.',
    'already-initialized': 'initializeAuth() has already been called with different options.'
        ' To avoid this error, call initializeAuth() with the same options as when it was originally called, or call getAuth() to return the already initialized instance.',
    'cancelled': 'The operation was cancelled (typically by the caller).',
    'unknown': 'Unknown error or an error from a different error domain.',
    'invalid-argument': "Client specified an invalid argument. Note that this differs from 'failed-precondition'. 'invalid-argument' indicates arguments that are problematic regardless of the state of the system (e.g. an invalid field name).",
    'deadline-exceeded': 'Deadline expired before operation could complete. For operations that change the state of the system, this error may be returned even if the operation has completed successfully. For example, a successful response from a server could have been delayed long enough for the deadline to expire.',
    'not-found': 'Some requested document was not found.',
    'already-exists': 'Some document that we attempted to create already exists.',
    'permission-denied': 'The caller does not have permission to execute the specified operation.',
    'resource-exhausted': 'Some resource has been exhausted, perhaps a per-user quota, or perhaps the entire file system is out of space.',
    'failed-precondition': "Operation was rejected because the system is not in a state required for the operation's execution.",
    'aborted': 'The operation was aborted, typically due to a concurrency issue like transaction aborts, etc.',
    'out-of-range': 'Operation was attempted past the valid range.',
    'unimplemented': 'Operation is not implemented or not supported/enabled.',
    'internal': 'Internal errors. Means some invariants expected by underlying system has been broken. If you see one of these errors, something is very broken.',
    'unavailable': 'The service is currently unavailable. This is most likely a transient condition and may be corrected by retrying with a backoff.',
    'data-loss': 'Unrecoverable data loss or corruption.',
    'unauthenticated': 'The request does not have valid authentication credentials for the operation.'
};
  // -----------------------------------------------------------------------------
  ///
  static String? getErrorReply({
    required String? error,
  }) {
    String _output = 'Something went wrong !';

    if (error != null){

      for (final String key in _authErrors.keys.toList()){

        final bool _errorIsKnown = TextCheck.stringContainsSubString(
          string: error,
          subString: key,
        );

        if (_errorIsKnown == true){
          _output = _authErrors[key];
        }
        break;

      }

    }

    return _output;
  }
  // --------------------
  ///
  static String? getErrorKey({
    required String? error,
  }) {
    String? _output;

    if (error != null){

      for (final String key in _authErrors.keys.toList()){

        final bool _errorIsKnown = TextCheck.stringContainsSubString(
          string: error,
          subString: key,
        );

        if (_errorIsKnown == true){
          _output = key;
        }

        break;

      }

    }

    return _output;
  }
  // -----------------------------------------------------------------------------

  /// CHECKERS

  // --------------------
  ///
  static bool checkIsUserNotFound(String? error){
    bool _output = false;

    if (TextCheck.isEmpty(error) == false){

      _output = TextCheck.stringContainsSubString(
          string: error,
          subString: '[firebase_auth/user-not-found]',
        );

    }

    return _output;
  }
  // -----------------------------------------------------------------------------
}
