import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/data/strings.dart';

abstract class DatabaseManager {
  Future<DocumentSnapshot> createUser(String userId);
  Stream<DocumentSnapshot> getUserStream(String userId);
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

  Future<String> createSweetNothing(String createdBy, bool public, String text);
  Future<DocumentSnapshot> getNothing(String nothingId);
  Future<List<DocumentSnapshot>> getNothingsOrderBy(String field);
  Future<List<DocumentSnapshot>> getNothingsOrderByStartAfter(
      String field, DocumentSnapshot startAfter);
  Future<void> updateNothing(String nothingId, Map<String, dynamic> data);
  Future<void> deleteNothing(String nothingId);

  Future<void> createNothingList(String groupId, String toUserId);
  Future<List<String>> getNothingList(String groupId, String toUserId);
  Stream<List<String>> nothingsListStream(String groupId, String toUserId);
  Future<void> updateNothingList(
      String groupId, String toUserId, List<String> nothingList);

  Future<void> createReport(String commentId, String userId);
  Future<List<DocumentSnapshot>> getReports();
  Future<void> deleteReport(String reportId);

  Stream<int> getPostCount(String userId);
  Stream<int> getPostUseCount(String userId);

  //TODO: add flowers, winks, poems
  Future<void> addWink(String groupId, String userId, int winkActiveUntil);
  Stream<int> winkStream(String groupId, String userId);
}

class DB implements DatabaseManager {
  static final DB instance = DB();
  static final Firestore db = Firestore.instance;
  static const int NOTHINGS_PER_PAGE = 5;

  DocumentReference userDoc(String userId) =>
      db.collection(USERS).document(userId);
  DocumentReference groupDoc(String groupId) =>
      db.collection(GROUPS).document(groupId);
  DocumentReference nothingDoc(String nothingId) =>
      db.collection(NOTHINGS).document(nothingId);

  // USER methods

  Future<DocumentSnapshot> createUser(String userId) async {
    await userDoc(userId).setData({
      CREATED_AT: DateTime.now().millisecondsSinceEpoch,
      PASSWORD: getRandomSixCharacterString()
    });
    return userDoc(userId).get();
  }

  Stream<DocumentSnapshot> getUserStream(String userId) {
    return userDoc(userId).snapshots();
  }

  Future<DocumentSnapshot> getSingleUser(String userId) {
    return userDoc(userId).get();
  }

  Future<DocumentSnapshot> getUserWhere(String field, dynamic val) {
    return db
        .collection(USERS)
        .where(field, isEqualTo: val)
        .getDocuments()
        .then((snapshots) =>
            snapshots.documents.length > 0 ? snapshots.documents[0] : null);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) {
    return userDoc(userId).updateData(data);
  }

  Future<void> deleteUser(String userId) {
    return userDoc(userId).delete();
  }

  // GROUP methods

  Future<void> createGroup(String firstUser, String secondUser) async {
    DocumentReference groupDoc = db.collection(GROUPS).document();

    return Future.wait(
      [
        groupDoc.setData({USERS: [firstUser, secondUser], visitStr(firstUser):0, visitStr(secondUser):0}),
        createNothingList(groupDoc.documentID, firstUser),
        createNothingList(groupDoc.documentID, secondUser),
        userDoc(firstUser).setData({CREATED_AT: DateTime.now()}),
        userDoc(secondUser).setData({CREATED_AT: DateTime.now()})
      ],
    );
  }

  Stream<DocumentSnapshot> getGroupStream(String groupId) {
    return groupDoc(groupId).snapshots();
  }

  Future<DocumentSnapshot> getSingleGroup(String groupId) {
    return groupDoc(groupId).get();
  }

  Stream<List<DocumentSnapshot>> groupsWithUserStream(String userId) {
    return db
        .collection(GROUPS)
        .where(USERS, arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.documents);
  }

  Future<void> updateGroup(String groupId, Map<String, dynamic> data) {
    return groupDoc(groupId).updateData(data);
  }

  Future<void> deleteGroup(String groupId) {
    return groupDoc(groupId).delete();
  }

  // NOTHING methods

  Future<String> createSweetNothing(
      String createdBy, bool public, String text) async {
    DocumentReference doc = db.collection(NOTHINGS).document();
    await doc.setData({
      TEXT: text,
      CREATED_AT: DateTime.now().millisecondsSinceEpoch,
      PUBLIC: public,
      CREATOR_ID: createdBy,
      USE_CT: 1
    });
    return doc.documentID;
  }

  Future<DocumentSnapshot> getNothing(String nothingId) {
    return nothingDoc(nothingId).get();
  }

  Future<List<DocumentSnapshot>> getNothingsOrderBy(String field) {
    return db
        .collection(NOTHINGS)
        .where(PUBLIC, isEqualTo: true)
        .orderBy(field, descending: true)
        .limit(NOTHINGS_PER_PAGE)
        .getDocuments()
        .then((query) => query.documents);
  }

  Future<List<DocumentSnapshot>> getNothingsOrderByStartAfter(
      String field, DocumentSnapshot startAfter) {
    return db
        .collection(NOTHINGS)
        .where(PUBLIC, isEqualTo: true)
        .orderBy(field, descending: true)
        .startAfterDocument(startAfter)
        .limit(NOTHINGS_PER_PAGE)
        .getDocuments()
        .then((query) => query.documents);
  }

  Future<void> updateNothing(String nothingId, Map<String, dynamic> data) {
    return nothingDoc(nothingId).updateData(data);
  }

  Future<void> deleteNothing(String nothingId) {
    return nothingDoc(nothingId).delete();
  }

  // NOTHING-LIST methods

  Future<void> createNothingList(String groupId, String toUserId) {
    return groupDoc(groupId)
        .collection(NOTHINGS)
        .document(nothingsCollctiionName(toUserId))
        .setData({NOTHINGS: []});
  }

  Future<List<String>> getNothingList(String groupId, String toUserId) {
    return groupDoc(groupId)
        .collection(NOTHINGS)
        .document(nothingsCollctiionName(toUserId))
        .get()
        .then((doc) {
          if(!doc.exists){
            return [];
          } else return List<String>.from(doc.data[NOTHINGS] ?? []);
        });
  }

  Stream<List<String>> nothingsListStream(String groupId, String toUserId) {
    return groupDoc(groupId)
        .collection(NOTHINGS)
        .document(nothingsCollctiionName(toUserId))
        .snapshots()
        .map((snapshot) => List<String>.from(snapshot.data[NOTHINGS]));
  }

  Future<void> updateNothingList(
      String groupId, String toUserId, List<String> nothingList) {
    return groupDoc(groupId)
        .collection(NOTHINGS)
        .document(nothingsCollctiionName(toUserId))
        .updateData({NOTHINGS: nothingList});
  }

  // POST-COUNT METHODS
  Stream<int> getPostCount(String userId) {
    return db.collection(NOTHINGS)
    .where(CREATOR_ID, isEqualTo: userId)
    .where(PUBLIC, isEqualTo: true).snapshots()
    .map((event) {
      return event.documents.length;
    });
  }

  Stream<int> getPostUseCount(String userId){
    return db.collection(NOTHINGS)
    .where(CREATOR_ID, isEqualTo: userId)
    .where(PUBLIC, isEqualTo: true)
    .where(USE_CT, isGreaterThan: 1).snapshots().map(
      (event) {
        if(event.documents.isEmpty){
          return 0;
        } else {
          return event.documents
          .map((e) => e.data[USE_CT]-1)
          .reduce((x, y) => x + y);
        }
      },
    );
  }

  // WINK methods

  Future<void> addWink(String groupId, String userId, int winkActiveUntil) {
    return groupDoc(groupId)
        .collection(WINKS)
        .document(userId)
        .updateData({UNTIL: winkActiveUntil});
  }

  Stream<int> winkStream(String groupId, String userId) {
    return groupDoc(groupId)
        .collection(WINKS)
        .document(userId)
        .snapshots()
        .map((document) => document.data[UNTIL]);
  }


  // Report Methods

  Future<void> createReport(String commentId, String userId){
    return db.collection(REPORTS).document().setData({COMMENT_ID: commentId, CREATOR_ID: userId});
  }
  Future<List<DocumentSnapshot>> getReports(){
    return db.collection(REPORTS).getDocuments().then((query) => query.documents);
  }
  Future<void> deleteReport(String reportId){
    return db.collection(REPORTS).document(reportId).delete();
  }

  // for generating passwords to request account access
  String getRandomSixCharacterString() {
    String randomChar() {
      const chars = [
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'm',
        'n',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9'
      ];
      int seed = Random().nextInt(chars.length);
      return chars[seed];
    }

    String password = '';
    for (int i = 0; i < 6; i++) {
      password += randomChar();
    }

    return password;
  }
}



String nothingsCollctiionName(String toUserId) => 'Nothings_For_$toUserId';
