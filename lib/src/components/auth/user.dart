import 'package:firebase_auth/firebase_auth.dart';


class User {
  final String userId;
  String password;

  User({this.userId, this.password}) : assert(userId != null);

  User.fromFirebaseUser(FirebaseUser user) : userId = user.uid;

}