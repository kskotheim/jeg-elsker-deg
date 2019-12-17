
class GroupInfo {
  final String groupId;
  final String groupName;
  GroupInfo({this.groupName, this.groupId})
      : assert(groupId != null, groupName != null);
}
