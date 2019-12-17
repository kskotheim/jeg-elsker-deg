import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/components/auth/user.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/data/db.dart';

abstract class GroupRepository {
  Stream<Group> getGroup();

  Stream<List<User>> connectionRequests();
  Future<void> approveConnectionRequest(String userId);
  Future<void> disapproveConnectionRequest(String userId);
}

class GR implements GroupRepository {
  final String groupId;
  GR({this.groupId}) : assert(groupId != null);

  DatabaseManager db = DB.instance;

  Stream<Group> getGroup() {
    return db.getGroup(groupId).map((snapshot) => Group(
        groupId: snapshot.documentID,
        ownerId: snapshot.data[OWNER],
        password: snapshot.data[PASSWORD]));
  }

  Stream<List<User>> connectionRequests() {
    return db.groupConnectionRequests(groupId).map((documents){
      List<User> users = [];
      documents.forEach((document) async {
        String id = document.documentID;
        String name = document.data[NAME];
        users.add(User(userId: id, userName: name));
      });
      return users;
    });

  }

  Future<String> userName(String userId) {
    return db.getUser(userId).single.then((document) => document.data[NAME]);
  }
  
  Future<void> approveConnectionRequest(String userId) async {
    print('approving request');
    DocumentSnapshot group = await db.getSingleGroup(groupId);
    List<String> users = List<String>.from(group.data[USERS]);
    if(!users.contains(userId)){
      users.add(userId);
    }
    await db.updateGroup(groupId, {USERS: users});
    return db.deleteGroupConnectionRequest(groupId, userId);
  }
  Future<void> disapproveConnectionRequest(String userId){
    return db.deleteGroupConnectionRequest(groupId, userId);
  }
}
