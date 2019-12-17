import 'package:my_love/src/components/account/group_list/group_info.dart';
import 'package:my_love/src/components/auth/user.dart';
import 'package:my_love/src/data/db.dart';

abstract class AccountRepository {
  Stream<User> currentUser();
  Future<void> renameUser(String userName);

  Future<void> createGroup(String groupName);
  Future<void> requestConnection(String password, String username);

  Stream<List<GroupInfo>> groupInfoStream();

  
}

class AR implements AccountRepository {
  final String userId;

  AR({this.userId}) : assert(userId != null);

  DatabaseManager db = DB.instance;

  Stream<User> currentUser(){
    return db.getUser(userId).map((document) => User(userId: document.documentID, userName: document.data[NAME]));
  }
  Future<void> renameUser(String username) async {
    return db.updateUser(userId, {NAME: username});
  }

  Future<void> createGroup(String groupName){
    return db.createGroup(groupName, userId);
  }
  Future<void> requestConnection(String password, String username){
    return db.createGroupConnectionRequest(password, userId, username);
  }


  Stream<List<GroupInfo>> groupInfoStream(){
    return db.groupsWithUserStream(userId).map((list) => list.map((snapshot) => GroupInfo(groupId: snapshot.documentID, groupName: snapshot.data[NAME])).toList());
  }
}