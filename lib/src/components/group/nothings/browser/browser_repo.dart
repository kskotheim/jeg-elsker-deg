import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/components/group/nothings/nothing.dart';
import 'package:my_love/src/data/db.dart';
import 'package:my_love/src/data/strings.dart';

abstract class BrowserRepository {
  Future<List<DocumentSnapshot>> getMostRecentNothings({DocumentSnapshot startAfter});
  Future<List<DocumentSnapshot>> getMostPopularNothings({DocumentSnapshot startAfter});

  Future<void> addNothingToNothingList(String nothingId);
  Future<void> createReport(String commentId, String userId);

}

class BR implements BrowserRepository{

  final String groupId;
  final String toUserId;

  BR({this.groupId, this.toUserId}) : assert(groupId != null, toUserId != null);

  DatabaseManager db = DB.instance;

  
  Future<List<DocumentSnapshot>> getMostRecentNothings({DocumentSnapshot startAfter}){
    if(startAfter == null){
      return db.getNothingsOrderBy(CREATED_AT);
    } else {
      return db.getNothingsOrderByStartAfter(CREATED_AT, startAfter);
    }
  }
  Future<List<DocumentSnapshot>> getMostPopularNothings({DocumentSnapshot startAfter}){
    if(startAfter == null){
      return db.getNothingsOrderBy(USE_CT);
    } else {
      return db.getNothingsOrderByStartAfter(USE_CT, startAfter);
    }
  }
  Future<void> addNothingToNothingList(String nothingId) async {
    List<String> nothingList = await db.getNothingList(groupId, toUserId);
    if(!nothingList.contains(nothingId)){
      Nothing nothing = await db.getNothing(nothingId).then((value) => Nothing.fromDocumentSnapshot(value));
      await db.updateNothing(nothingId, {USE_CT: nothing.useCt + 1});
      nothingList.add(nothingId);
      await db.updateNothingList(groupId, toUserId, nothingList);
    }
    return;
  }

  Future<void> createReport(String commentId, String userId){
    return db.createReport(commentId, userId);
  }
}