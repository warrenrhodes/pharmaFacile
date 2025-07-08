import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with PIN (for demonstration; use secure auth in production)
  Future<UserCredential?> signInWithPin(String pin) async {
    // Replace with your own logic for PIN-based auth
    // For demo, use email/password with PIN as password
    try {
      return await _auth.signInWithEmailAndPassword(
        email: 'demo@pharmafacile.com',
        password: pin,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Change PIN (for demonstration)
  Future<void> changePin(String oldPin, String newPin) async {
    // Replace with your own logic for changing PIN
    // For demo, re-authenticate and update password
    final user = _auth.currentUser;
    if (user != null) {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPin,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPin);
    }
  }
}
