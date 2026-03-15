import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Quan_ly_thu_chi_PRM/services/remember_me_service.dart';

/// Thrown when a Google sign-in email already exists with a different provider.
/// The UI should prompt the user for their existing password, then call
/// [FirebaseAuthService.linkGoogleToExistingAccount].
class GoogleLinkingRequiredException implements Exception {
  final String email;
  final AuthCredential googleCredential;

  const GoogleLinkingRequiredException({
    required this.email,
    required this.googleCredential,
  });
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Sign in with email and password, with option to save credentials for "Remember me"
  Future<UserCredential> signInWithEmailPasswordAndRemember({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final credential = await signInWithEmailPassword(
      email: email,
      password: password,
    );

    if (rememberMe) {
      try {
        await RememberMeService().saveCredentials(
          email: email.trim(),
          password: password,
        );
      } catch (e) {
        print('Warning: Failed to save Remember me credentials: $e');
        // Don't throw - allow login to succeed even if credential saving fails
      }
    }

    return credential;
  }

  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (displayName != null && displayName.isNotEmpty) {
      await cred.user?.updateDisplayName(displayName);
      await cred.user?.reload();
    }

    return cred;
  }

  Future<void> sendEmailVerification() async {
    // handleCodeInApp: true + androidPackageName → Firebase generates an
    // App Link that Android will route directly into this app once the
    // SHA-256 fingerprint is registered in Firebase Console > Authentication
    // > Settings > Authorized domains (and App Check is configured).
    // Falls back to the polling mechanism until App Links are active.
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://quanlythuchiprm.firebaseapp.com',
      handleCodeInApp: true,
      androidPackageName: 'com.example.personal_finance_app',
      androidInstallApp: false,
    );
    await _auth.currentUser?.sendEmailVerification(actionCodeSettings);
  }

  Future<bool> reloadAndCheckVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> signOut() async {
    // Clear saved credentials when signing out
    await RememberMeService().clearCredentials();
    await _auth.signOut();
  }

  /// Updates the current user's display name
  Future<void> updateDisplayName(String displayName) async {
    await _auth.currentUser?.updateDisplayName(displayName);
    await _auth.currentUser?.reload();
  }

  /// Sends a password reset email to the specified email address
  Future<void> sendPasswordResetEmail({required String email}) async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://quanlythuchiprm.firebaseapp.com',
      handleCodeInApp: true,
      androidPackageName: 'com.example.personal_finance_app',
      androidInstallApp: false,
    );
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
      actionCodeSettings: actionCodeSettings,
    );
  }

  /// Verifies a password reset code
  Future<String> verifyPasswordResetCode(String code) async {
    return await _auth.verifyPasswordResetCode(code);
  }

  /// Confirms the password reset with the code and new password
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  /// Attempts silent sign-in with Google on native platforms.
  /// Returns null if silent sign-in is not possible (e.g., on web or no cached account).
  Future<(UserCredential, bool)?> signInSilentlyWithGoogle() async {
    // Web platform doesn't support silent sign-in the same way
    if (kIsWeb) return null;

    try {
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signInSilently();

      if (googleAccount == null) {
        // No cached account available
        return null;
      }

      final googleAuth = await googleAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final isNewUser = userCred.additionalUserInfo?.isNewUser ?? false;
      return (userCred, isNewUser);
    } catch (e) {
      // Silent sign-in failed, return null to fall back to manual sign-in
      return null;
    }
  }

  /// Signs in with Google.
  ///
  /// Returns a record of `(UserCredential, isNewUser)`.
  /// Throws [GoogleLinkingRequiredException] if the email already exists
  /// with a different provider (e.g., email/password).
  /// Throws [FirebaseAuthException] with code `cancelled` if the user
  /// dismisses the Google sign-in picker.
  Future<(UserCredential, bool)> signInWithGoogle() async {
    if (kIsWeb) {
      return _signInWithGoogleWeb();
    }
    return _signInWithGoogleNative();
  }

  Future<(UserCredential, bool)> _signInWithGoogleWeb() async {
    final provider = GoogleAuthProvider();
    try {
      final userCred = await _auth.signInWithPopup(provider);
      final isNewUser = userCred.additionalUserInfo?.isNewUser ?? false;
      return (userCred, isNewUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw GoogleLinkingRequiredException(
          email: e.email ?? '',
          googleCredential: e.credential!,
        );
      }
      rethrow;
    }
  }

  Future<(UserCredential, bool)> _signInWithGoogleNative() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();

    if (googleAccount == null) {
      throw FirebaseAuthException(
        code: 'cancelled',
        message: 'Google sign-in was cancelled',
      );
    }

    final googleAuth = await googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final userCred = await _auth.signInWithCredential(credential);
      final isNewUser = userCred.additionalUserInfo?.isNewUser ?? false;
      return (userCred, isNewUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw GoogleLinkingRequiredException(
          email: googleAccount.email,
          googleCredential: credential,
        );
      }
      rethrow;
    }
  }

  /// Signs in with email/password then links the provided Google credential,
  /// effectively merging the two accounts.
  ///
  /// Returns `(UserCredential, googlePhotoUrl)`. The photo URL is extracted
  /// from Google's provider data and, if available, also applied to the
  /// Firebase Auth profile so [currentUser.photoURL] is populated.
  /// The display name in both Firebase Auth and the database is left unchanged.
  Future<(UserCredential, String?)> linkGoogleToExistingAccount({
    required String email,
    required String password,
    required AuthCredential googleCredential,
  }) async {
    final userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save the original display name before linking — Firebase Auth may
    // overwrite it with the Google account's name after linkWithCredential.
    final originalDisplayName = userCred.user?.displayName;

    final linkedCred =
        await userCred.user!.linkWithCredential(googleCredential);

    // Extract Google's photo URL from the linked provider data.
    String? googlePhotoUrl;
    for (final provider in (linkedCred.user?.providerData ?? [])) {
      if (provider.providerId == 'google.com' && provider.photoURL != null) {
        googlePhotoUrl = provider.photoURL;
        break;
      }
    }

    // Update Firebase Auth photoURL with Google's photo.
    if (googlePhotoUrl != null) {
      await linkedCred.user?.updatePhotoURL(googlePhotoUrl);
    }

    // Restore the original display name — do NOT let Google's name overwrite
    // the name the user registered with manually.
    if (originalDisplayName != null && originalDisplayName.isNotEmpty) {
      await linkedCred.user?.updateDisplayName(originalDisplayName);
    }

    await linkedCred.user?.reload();

    return (userCred, googlePhotoUrl);
  }
}
