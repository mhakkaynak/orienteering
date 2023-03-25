/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthManager {
  FirebaseAuthManager._init() {
    _auth = FirebaseAuth.instance;
  }

  static FirebaseAuthManager? _instance;

  late final FirebaseAuth _auth;

  Future<void> registerWithEmail(String email, String password) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user == null) {
        throw Exception('User registration failed.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user == null) throw Exception('Login failed.');
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      var googleSignIn = GoogleSignIn();
      var googleSignInAccount = await googleSignIn.signIn();
      var googleSignInAuth = await googleSignInAccount?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth?.accessToken,
          idToken: googleSignInAuth?.idToken);
      var user = await _auth.signInWithCredential(credential);
      if (user.user?.displayName == null) throw Exception('Login failed.');
      return user.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String? get uid => _auth.currentUser?.uid;

  bool get isItRegistered => _auth.currentUser != null;

  static FirebaseAuthManager get instance {
    _instance ??= FirebaseAuthManager._init();
    return _instance!;
  }
}
*/