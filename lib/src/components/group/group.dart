import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/components/auth/user.dart';
import 'package:my_love/src/data/db.dart';

class Group {
  final String groupId;
  final List<User> users;

  Group({this.groupId, this.users = const []}) : assert(groupId != null);

  Group.fromSnapshot(DocumentSnapshot snapshot)
      : groupId = snapshot.documentID,
        users = [
          User(userId: snapshot.data[USERS][0]),
          User(userId: snapshot.data[USERS][1])
        ];
}
