import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_love/src/data/db.dart';

abstract class Auth {
  Future<String> getCurrentUser();
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

class AuthRepository implements Auth {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseManager _db = DB.instance;

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user?.uid;
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    _db.createUser(result.user.uid);
    return result.user.uid;
  }

  Future<void> resetPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}