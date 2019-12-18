import 'package:firebase_auth/firebase_auth.dart';


class User {
  final String userId;
  String password;
  String userName;

  User({this.userId, this.password,this.userName}) : assert(userId != null);

  User.fromFirebaseUser(FirebaseUser user) : userId = user.uid;

}