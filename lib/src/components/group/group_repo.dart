import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/components/group/nothings/nothing.dart';
import 'package:my_love/src/data/db.dart';

abstract class GroupRepository {
  Stream<Group> getGroup();

  Future<void> addNewSweetNothing(String createdBy, String toUser, bool public, String text);
  Stream<List<String>> sweetNothingIds(String toUserId);
  Future<Nothing> getRandomSweetNothing(
      String toUserId, List<String> nothingsViewed, Function allNothingsViewed);
  Future<Nothing> getNothing(String nothingId, String toUserId);
  Future<void> deletePrivateNothing(String nothingId, String toUserId);
  Future<void> deletePublicNothing(String nothingId, String toUserId);

  Future<void> addWink(String userId);
  Stream<int> winkActiveUntilStream(String userId);
}

class GR implements GroupRepository {
  final String groupId;

  GR({this.groupId}) : assert(groupId != null);

  DatabaseManager db = DB.instance;

  Stream<Group> getGroup() {
    return db.getGroupStream(groupId).map((snapshot) {
      return Group.fromSnapshot(snapshot);
    });
  }

  Future<void> addNewSweetNothing(String createdBy, String toUser, bool public, String text) async {
    String nothingId = await db.createSweetNothing(createdBy, public, text);
    List<String> nothings = await db.getNothingList(groupId, toUser);
    nothings.add(nothingId);
    return db.updateNothingList(groupId, toUser, nothings);
  }

  Stream<List<String>> sweetNothingIds(String toUserId) {
    return db.nothingsListStream(groupId, toUserId);
  }

  Future<Nothing> getRandomSweetNothing(
      String toUserId, List<String> nothingsViewed, Function allNothingsViewed) async {
    List<String> nothings = await db.getNothingList(groupId, toUserId);

    if(nothings.length > 0){
      List<String> unseenNothings = nothings.where((id) => !nothingsViewed.contains(id)).toList();
      if(unseenNothings.length == 0){
        await allNothingsViewed();
        DocumentSnapshot snap = await db.getNothing(nothings[Random().nextInt(nothings.length)]);
        return Nothing.fromDocumentSnapshot(snap);
      } else {
        DocumentSnapshot snap = await db.getNothing(unseenNothings[Random().nextInt(unseenNothings.length)]);
        return Nothing.fromDocumentSnapshot(snap);
      }
    } else return Nothing.defaultNothing;
  }

  Future<Nothing> getNothing(String nothingId, String toUserId) {
    return db.getNothing(nothingId).then((snap) async {
      if(snap.exists){
        return Nothing.fromDocumentSnapshot(snap);
      } else {
        // nothing has been deleted
        List<String> nothingsList = await db.getNothingList(groupId, toUserId);
        if(nothingsList.remove(nothingId)){
          db.updateNothingList(groupId, toUserId, nothingsList);
        } else {
          print('error removing element $nothingId from list $groupId to user $toUserId');
        }
        return null;
      }
    });
  } 

  Future<void> deletePrivateNothing(String nothingId, String toUserId) async {
    List<String> nothingList = await db.getNothingList(groupId, toUserId);
    nothingList.remove(nothingId);
    await db.updateNothingList(groupId, toUserId, nothingList);
    return db.deleteNothing(nothingId);
  }

  Future<void> deletePublicNothing(String nothingId, String toUserId) async {
    List<String> nothingList = await db.getNothingList(groupId, toUserId);
    Nothing nothing = await db.getNothing(nothingId).then((value) => Nothing.fromDocumentSnapshot(value));
    nothingList.remove(nothingId);
    await db.updateNothingList(groupId, toUserId, nothingList);
    return db.updateNothing(nothingId, {USECT: nothing.useCt -1});
  }


  Future<void> addWink(String userId) {
    return db.addWink(groupId, userId,
        DateTime.now().millisecondsSinceEpoch + 12 * 60 * 60 * 1000);
  }

  Stream<int> winkActiveUntilStream(String userId) {
    return db.winkStream(groupId, userId);
  }
}
