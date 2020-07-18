import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/components/auth/user.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/data/db.dart';

abstract class GroupRepository {
  Stream<Group> getGroup();

  Future<void> createSweetNothing(
      String fromUserId, String toUserId, String sweetNothing);
  Stream<List<SweetNothing>> sweetNothings(String toUserId);
  Future<SweetNothing> getRandomSweetNothing(String toUserId, List<String> nothingsViewed, allNothingsViewed);
  Future<void> deleteNothing(String toUserId, String documentId);

  Future<void> addWink(String userId);
  Stream<int> winkActiveUntilStream(String userId);
}

class GR implements GroupRepository {

  static const SweetNothing defaultNothing = SweetNothing(sweetNothing: 'You Are My Love');

  final String groupId;
  GR({this.groupId}) : assert(groupId != null);

  DatabaseManager db = DB.instance;

  Stream<Group> getGroup() {
    return db.getGroupStream(groupId).map((snapshot) => Group.fromSnapshot(snapshot));
  }

  Future<void> createSweetNothing(
      String fromUserId, String toUserId, String sweetNothing) {
    return db.createSweetNothing(groupId, fromUserId, toUserId, sweetNothing);
  }

  Stream<List<SweetNothing>> sweetNothings(String toUserId) {
    return db.sweetNothings(groupId, toUserId).map((documents) =>
        documents.map((document) => SweetNothing.fromDocumentSnapshot(document)).toList()
      );
  }

  Future<SweetNothing> getRandomSweetNothing(String toUserId, List<String> nothingsViewed, allNothingsViewed) async {
    List<DocumentSnapshot> nothings = await db.getAllNothings(groupId, toUserId);

    if(nothings.length > 0){
      List<DocumentSnapshot> unseenNothings = nothings.where((document) => !nothingsViewed.contains(document.data[CREATED_AT].toString())).toList();
      if(unseenNothings.length > 0){
        return SweetNothing.fromDocumentSnapshot( unseenNothings[Random().nextInt(unseenNothings.length)]);
      } else {
        await allNothingsViewed();
        return SweetNothing.fromDocumentSnapshot( nothings[Random().nextInt(nothings.length)]);
      }
    } else return defaultNothing;
  }

  Future<void> deleteNothing(String toUserId, String documentId){
    return db.deleteSweetNothing(groupId, toUserId, documentId);
  }


  Future<void> addWink(String userId){
    return db.addWink(groupId, userId, DateTime.now().millisecondsSinceEpoch + 12*60*60*1000);
  }
  Stream<int> winkActiveUntilStream(String userId){
    return db.winkStream(groupId, userId);
  }
}

class SweetNothing {
  final String sweetNothing;
  final int createdAt;
  final String documentId;

  const SweetNothing(
      {this.sweetNothing, this.createdAt, this.documentId});

  SweetNothing.fromDocumentSnapshot(DocumentSnapshot snap)
      : this.sweetNothing = snap.data[TEXT],
        this.createdAt = snap.data[CREATED_AT],
        this.documentId = snap.documentID;
}
