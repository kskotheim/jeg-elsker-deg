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

  Future<void> createSweetNothing(String groupId, String fromUserId, String toUserId, String text);
  Stream<List<DocumentSnapshot>> sweetNothings(String groupId, String toUserId);
  Future<List<DocumentSnapshot>> getAllNothings(String groupId, String toUserId);
  Future<void> editSweetNothing(String groupId, String toUserId, String documentId, String newText);
  Future<void> deleteSweetNothing(String groupId, String toUserId, String documentId);

  Future<void> addWink(String groupId, String userId, int winkActiveUntil);
  Stream<int> winkStream(String groupId, String userId);

}

class DB implements DatabaseManager {
  static final DB instance = DB();
  static final Firestore db = Firestore.instance;

  DocumentReference userDoc(String userId) =>
      db.collection(USERS).document(userId);
  DocumentReference groupDoc(String groupId) =>
      db.collection(GROUPS).document(groupId);
  CollectionReference nothingsCollection(String groupId, String userId) => 
      groupDoc(groupId).collection(nothingsCollctiionName(userId));
  
  
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
    return  db.collection(GROUPS).document().setData({USERS: [firstUser, secondUser]});
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


  Future<void> createSweetNothing(String groupId, String fromUserId, String toUserId, String text) async {
    return nothingsCollection(groupId, toUserId).document().setData({TEXT:text, CREATED_AT: DateTime.now().millisecondsSinceEpoch});
  }
  Stream<List<DocumentSnapshot>> sweetNothings(String groupId, String toUserId){
    return nothingsCollection(groupId, toUserId).orderBy(CREATED_AT).snapshots().map((query) => query.documents);
  }
  Future<List<DocumentSnapshot>> getAllNothings(String groupId, String toUserId){
    return nothingsCollection(groupId, toUserId).orderBy(CREATED_AT).getDocuments().then((query) => query.documents);
  }
  Future<void> editSweetNothing(String groupId, String toUserId, String documentId, String newText) async {
    return nothingsCollection(groupId, toUserId).document(documentId).updateData({TEXT: newText});
  }
  Future<void> deleteSweetNothing(String groupId, String toUserId, String documentId)async{
    return nothingsCollection(groupId, toUserId).document(documentId).delete();
  }

  Future<void> addWink(String groupId, String userId, int winkActiveUntil){
    return groupDoc(groupId).collection(WINKS).document(userId).updateData({UNTIL: winkActiveUntil});
  }

  Stream<int> winkStream(String groupId, String userId){
    return groupDoc(groupId).collection(WINKS).document(userId).snapshots().map((document) => document.data[UNTIL]);
  }


}


// db strings
const String NAME = 'Name';
const String USERS = 'Users';
const String OWNER = 'Owner';
const String GROUPS = 'Groups';
const String CREATED_AT = 'Created At';
const String PASSWORD = 'Password';
const String FROM = 'From';
const String TO = 'To';
const String UNTIL = 'Until';
const String WINKS = 'Winks';
const String TEXT = 'Text';

String nothingsCollctiionName(String userId) => 'Nothings_$userId';


