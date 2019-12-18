import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/components/auth/user.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/data/db.dart';

abstract class GroupRepository {
  Stream<Group> getGroup();

}

class GR implements GroupRepository {
  final String groupId;
  GR({this.groupId}) : assert(groupId != null);

  DatabaseManager db = DB.instance;

  Stream<Group> getGroup() {
    return db.getGroupStream(groupId).map((snapshot) => Group(
        groupId: snapshot.documentID,
        ownerId: snapshot.data[OWNER],
        password: snapshot.data[PASSWORD]));
  }

}
