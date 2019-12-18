import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseManager {
  Future<DocumentSnapshot> createUser(String userId);
  Stream<DocumentSnapshot> getUserStrean(String userId);
  Future<DocumentSnapshot> getSingleUser(String userId);
  Future<DocumentSnapshot> getUserWhere(String field, dynamic val);
  Future<void> updateUser(String userId, Map<String, dynamic> data);
  Future<void> deleteUser(String userId);

  Future<void> createGroup(String firstUser, String secondUser);
  Stream<DocumentSnapshot> getGroupStream(String groupId);
  Future<DocumentSnapshot> getSingleGroup(String groupId);
  Stream<List<DocumentSnapshot>> groupsWithUserStream(String userId);
  Future<void> updateGroup(String groupId, Map<String, dynamic> data);
  Future<void> deleteGroup(String groupId);

}

class DB implements DatabaseManager {
  static final DB instance = DB();
  static final Firestore db = Firestore.instance;

  DocumentReference userDoc(String userId) =>
      db.collection(USERS).document(userId);
  DocumentReference groupDoc(String groupId) =>
      db.collection(GROUPS).document(groupId);
  DocumentReference assetTypeDoc(String groupId, String assetTypeId) =>
      groupDoc(groupId).collection(ASSET_TYPES).document(assetTypeId);
  DocumentReference asset(String groupId, String assetId) =>
      groupDoc(groupId).collection(ASSETS).document(assetId);

  Future<DocumentSnapshot> createUser(String userId) async {
    await userDoc(userId).setData({CREATED_AT: DateTime.now().millisecondsSinceEpoch, PASSWORD: getRandomSixCharacterString()});
    return userDoc(userId).get();
  }

  Stream<DocumentSnapshot> getUserStrean(String userId) {
    return userDoc(userId).snapshots();
  }

  Future<DocumentSnapshot> getSingleUser(String userId) {
    return userDoc(userId).get();
  }

  Future<DocumentSnapshot> getUserWhere(String field, dynamic val){
    return db.collection(USERS).where(field, isEqualTo: val).getDocuments().then((snapshots) => snapshots.documents.length > 0 ? snapshots.documents[0] : null);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) {
    return userDoc(userId).updateData(data);
  }

  Future<void> deleteUser(String userId) {
    return userDoc(userId).delete();
  }

  Future<void> createGroup(String firstUser, String secondUser) async {
    DocumentSnapshot newGroup = await db.collection(GROUPS).document().get();
    return groupDoc(newGroup.documentID).setData({USERS: [firstUser, secondUser]});
  }

  Stream<DocumentSnapshot> getGroupStream(String groupId) {
    return groupDoc(groupId).snapshots();
  }

  Future<DocumentSnapshot> getSingleGroup(String groupId) {
    return groupDoc(groupId).get();
  }

  Stream<List<DocumentSnapshot>> groupsWithUserStream(String userId){
    return db.collection(GROUPS).where(USERS, arrayContains: userId).snapshots().map((snapshot) => snapshot.documents);
  }

  Future<void> updateGroup(String groupId, Map<String, dynamic> data) {
    return groupDoc(groupId).updateData(data);
  }

  Future<void> deleteGroup(String groupId) {
    return groupDoc(groupId).delete();
  }

  // for generating passwords to request account access
  String getRandomSixCharacterString(){
    String randomChar (){
      const chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '2', '3', '4', '5', '6', '7', '8', '9'];
      int seed = Random().nextInt(chars.length);
      return chars[seed];
    }

    String password = '';
    for(int i=0;i<6;i++){
      password += randomChar();
    }

    return password;
  }
}


// db strings
const String NAME = 'Name';
const String USERS = 'Users';
const String OWNER = 'Owner';
const String GROUPS = 'Groups';
const String ASSET_TYPES = 'Asset Types';
const String ASSETS = 'Assets';
const String TYPE = 'Type';
const String CREATED_AT = 'Created At';
const String CONNECTION_REQUESTS = 'Connection Requests';
const String PASSWORD = 'Password';


