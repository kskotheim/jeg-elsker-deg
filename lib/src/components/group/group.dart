import 'package:my_love/src/components/auth/user.dart';

class Group {
  final String groupId;
  final String ownerId;
  final String password;
  final List<User> users;

  Group({this.groupId, this.ownerId, this.password, this.users = const []}) : assert(groupId != null, ownerId != null);

}