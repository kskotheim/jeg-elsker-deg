import 'package:my_love/src/components/auth/user.dart';

class Group {
  final String groupId;
  final List<User> users;

  Group({this.groupId, this.users = const []}) : assert(groupId != null);

}