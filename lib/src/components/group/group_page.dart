import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/components/group/group_bloc.dart';

class GroupPage extends StatelessWidget {
  final String groupId;
  GroupPage({this.groupId}) : assert(groupId != null);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupBloc>(
      create: (context) => GroupBloc(groupId: groupId),
      child: Center(
        child: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            if(state is GroupStateLoading) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Loading Group'),
                  CircularProgressIndicator(),
                ],
              );
            }
            if(state is ShowGroupInfo){
              Group group = state.group;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Group Page'),
                  
                ],
              );
            }
          }
        ),
      ),
    );
  }
}
