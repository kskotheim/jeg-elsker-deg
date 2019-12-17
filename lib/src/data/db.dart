import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseManager {
  Future<DocumentSnapshot> createUser(String userId);
  Stream<DocumentSnapshot> getUser(String userId);
  Future<DocumentSnapshot> getSingleUser(String userId);
  Future<void> updateUser(String userId, Map<String, dynamic> data);
  Future<void> deleteUser(String userId);

  Future<void> createGroup(String groupName, String userId);
  Stream<DocumentSnapshot> getGroup(String groupId);
  Future<DocumentSnapshot> getSingleGroup(String groupId);
  Stream<List<DocumentSnapshot>> groupsWithUserStream(String userId);
  Future<void> updateGroup(String groupId, Map<String, dynamic> data);
  Future<void> deleteGroup(String groupId);

  Future<void> createGroupConnectionRequest(String groupId, String userId, String username);
  Stream<List<DocumentSnapshot>> groupConnectionRequests(String groupId);
  Future<void> deleteGroupConnectionRequest(String groupId, String userId);

  Future<void> createAssetType(String groupId, String assetName);
  Future<List<DocumentSnapshot>> getAssetTypes(String groupId);
  Future<void> updateAssetType(
      String groupId, String assetTypeId, Map<String, dynamic> data);
  Future<void> deleteAssetType(String groupId, String asseTypeId);

  Future<DocumentSnapshot> createAsset(
      String groupId, String assetTypeId, String assetName);
  Future<List<DocumentSnapshot>> getAssetsOfType(
      String groupId, String assetTypeId);
  Future<List<DocumentSnapshot>> getAllAssets(String groupId);
  Future<void> updateAsset(
      String groupId, String assetId, Map<String, dynamic> data);
  Future<void> deleteAsset(String groupId, String assetId);
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
    await userDoc(userId).setData({CREATED_AT: DateTime.now().millisecondsSinceEpoch});
    return userDoc(userId).get();
  }

  Stream<DocumentSnapshot> getUser(String userId) {
    return userDoc(userId).snapshots();
  }

  Future<DocumentSnapshot> getSingleUser(String userId) {
    return userDoc(userId).get();
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) {
    return userDoc(userId).updateData(data);
  }

  Future<void> deleteUser(String userId) {
    return userDoc(userId).delete();
  }

  Future<void> createGroup(String groupName, String userId) async {
    DocumentSnapshot newGroup = await db.collection(GROUPS).document().get();
    return groupDoc(newGroup.documentID).setData({NAME: groupName, OWNER: userId, USERS: [userId], PASSWORD: getRandomSixCharacterString()});
  }

  Stream<DocumentSnapshot> getGroup(String groupId) {
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

  Future<void> createGroupConnectionRequest(String password, String userId, String username) async {
    QuerySnapshot snapshot = await db.collection(GROUPS).where(PASSWORD, isEqualTo: password).limit(1).getDocuments();
    if(snapshot.documents.length > 0){
      String id = snapshot.documents[0].documentID;
      return groupDoc(id).collection(CONNECTION_REQUESTS).document(userId).setData({NAME:username});
    } 
    else return null;
  }

  Stream<List<DocumentSnapshot>> groupConnectionRequests(String groupId){
    return groupDoc(groupId).collection(CONNECTION_REQUESTS).snapshots().map((snapshot) => snapshot.documents);
  }

  Future<void> deleteGroupConnectionRequest(String groupId, String userId){
    return groupDoc(groupId).collection(CONNECTION_REQUESTS).document(userId).delete();
  }

  Future<void> createAssetType(
      String groupId, String assetTypeName) async {
    DocumentSnapshot newAssetType =
        await groupDoc(groupId).collection(ASSET_TYPES).document().get();
    return assetTypeDoc(groupId, newAssetType.documentID)
        .setData({NAME: assetTypeName});
  }

  Future<List<DocumentSnapshot>> getAssetTypes(String groupId) async {
    QuerySnapshot query =
        await groupDoc(groupId).collection(ASSET_TYPES).getDocuments();
    return query.documents;
  }

  Future<void> updateAssetType(
      String groupId, String assetTypeId, Map<String, dynamic> data) {
    return assetTypeDoc(groupId, assetTypeId).updateData(data);
  }

  Future<void> deleteAssetType(String groupId, String assetTypeId) {
    return assetTypeDoc(groupId, assetTypeId).delete();
  }

  Future<DocumentSnapshot> createAsset(
      String groupId, String assetTypeId, String assetName) async {
    DocumentSnapshot newAsset =
        await groupDoc(groupId).collection(ASSETS).document().get();
    asset(groupId, newAsset.documentID)
        .setData({NAME: assetName, TYPE: assetTypeId});
    return asset(groupId, newAsset.documentID).get();
  }

  Future<List<DocumentSnapshot>> getAllAssets(String groupId) async {
    QuerySnapshot query =
        await groupDoc(groupId).collection(ASSETS).getDocuments();
    return query.documents;
  }

  Future<List<DocumentSnapshot>> getAssetsOfType(
      String groupId, String assetType) async {
    QuerySnapshot query = await groupDoc(groupId)
        .collection(ASSETS)
        .where(TYPE, isEqualTo: assetType)
        .getDocuments();
    return query.documents;
  }

  Future<void> updateAsset(
      String groupId, String assetId, Map<String, dynamic> data) {
    return asset(groupId, assetId).updateData(data);
  }

  Future<void> deleteAsset(String groupId, String assetId) {
    return asset(groupId, assetId).delete();
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


