import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/components/auth/user.dart';
import 'package:my_love/src/data/db.dart';
import 'package:my_love/src/data/strings.dart';

abstract class AccountRepository {
  Stream<User> currentUser();
  Future<User> getCurrentUser();

  Future<void> createGroup(String password);

  Stream<List<GroupInfo>> groupInfoStream();

}

class AR implements AccountRepository {
  final String userId;

  AR({this.userId}) : assert(userId != null);

  DatabaseManager db = DB.instance;

  Stream<User> currentUser(){
    return db.getUserStream(userId).map((document) => User(userId: document.documentID, password: document.data[PASSWORD]));
  }

  Future<User> getCurrentUser(){
    return db.getSingleUser(userId).then((document) => User(userId: document.documentID, password: document.data[PASSWORD]));
  }

  Future<void> createGroup(String password) async {
    DocumentSnapshot secondUser = await db.getUserWhere(PASSWORD, password);
    if(secondUser != null){
      await db.createGroup(userId, secondUser.documentID);
    }
  }

  Stream<List<GroupInfo>> groupInfoStream(){
    return db.groupsWithUserStream(userId).map((list) => list.map((snapshot) => GroupInfo(groupId: snapshot.documentID, firstUser: snapshot.data[USERS][0], secondUser: snapshot.data[USERS][1])).toList());
  }
}

class GroupInfo{
  final String groupId;
  final String firstUser;
  final String secondUser;

  GroupInfo({this.groupId, this.firstUser, this.secondUser});
}