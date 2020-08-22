import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/components/auth/user.dart';
import 'package:my_love/src/data/strings.dart';

class Group {
  final String groupId;
  final List<User> users;
  final Map<String, int> visitCount;

  Group({this.groupId, this.users = const [], this.visitCount = const {}})
      : assert(groupId != null);

  Group.fromSnapshot(DocumentSnapshot snapshot)
      : groupId = snapshot.documentID,
        users = [
          User(userId: snapshot.data[USERS][0]),
          User(userId: snapshot.data[USERS][1])
        ],
        visitCount = {
          snapshot.data[USERS][0]:
              snapshot.data[visitStr(snapshot.data[USERS][0])] ?? 0,
          snapshot.data[USERS][1]:
              snapshot.data[visitStr(snapshot.data[USERS][1])] ?? 0,
        }{
        }
}
