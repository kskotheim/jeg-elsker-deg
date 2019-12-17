import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/account/group_list/group_info.dart';
import 'package:my_love/src/components/account/group_list/group_list_bloc.dart';

class GroupsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GroupListBloc(userId: BlocProvider.of<AccountBloc>(context).userId),
      child: Container(
        height: 300.0,
        child: BlocBuilder<GroupListBloc, GroupListState>(
          builder: (context, state) {
            if (state is GroupListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GroupList) {
              GroupList groupList = state;
              return ListView(
                  children: groupList.groupInfo
                      .map(
                        (GroupInfo groupInfo) => RaisedButton(
                          child: Text(groupInfo.groupName),
                          onPressed: () =>
                              BlocProvider.of<AccountBloc>(context).add(
                            GoToGroup(groupId: groupInfo.groupId),
                          ),
                        ),
                      )
                      .toList());
            }
          },
        ),
      ),
    );
  }
}
