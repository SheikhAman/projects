import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get user => _auth.currentUser;

  static Future<bool> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user != null;
  }

  static Future<bool> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential.user != null;
  }

  static Future<void> logout() => _auth.signOut();

  // user er email verified ki na ta check korar method
  static bool emailVerified() => _auth.currentUser!.emailVerified;

  // email verification er jonno msg send korbe
  static Future<void> sendEmailVerification() =>
      _auth.currentUser!.sendEmailVerification();

  static Future<void> updateDisplayName(
    String name,
  ) =>
      _auth.currentUser!.updateDisplayName(name);

// email password er khetre user ke abar reauthenticate korte hobe
// image ta hoche downloadUrl,
  static Future<void> updateDisplayImage(String image) =>
      _auth.currentUser!.updatePhotoURL(image);

  static Future<void> updatePhoneNumber(
    String phone,
  ) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        _auth.currentUser!.updatePhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
