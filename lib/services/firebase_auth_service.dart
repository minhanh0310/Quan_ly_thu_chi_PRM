import 'package:firebase_auth/firebase_auth.dart';

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
    await _auth.signOut();
  }
}
