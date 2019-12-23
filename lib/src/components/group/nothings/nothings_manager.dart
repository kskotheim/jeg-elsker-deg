import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/group/group_repo.dart';
import 'package:my_love/src/components/group/nothings/nothings_bloc.dart';

class NothingsManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Group currentGroup = BlocProvider.of<GroupBloc>(context).currentGroup;
    String userId = BlocProvider.of<AccountBloc>(context).currentUser.userId;
    return BlocProvider(
      create: (context) => NothingsBloc(
          groupId: currentGroup.groupId,
          userId: userId,
          partnerId: currentGroup.users
              .where((user) => user.userId != userId)
              .first
              .userId),
      child: Center(
        child: NothingsButtonAndList(),
      ),
    );
  }
}

class NothingsButtonAndList extends StatefulWidget {
  @override
  _NothingsButtonAndListState createState() => _NothingsButtonAndListState();
}

class _NothingsButtonAndListState extends State<NothingsButtonAndList> {
  bool showIcon = true;
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (showIcon) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() => showIcon = false),
          ),
          SweetNothingsList(),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('something to tell your love'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () => setState(() => showIcon = true),
              ),
              Container(
                width: 200.0,
                child: TextField(
                  controller: textController,
                  maxLength: 160,
                  maxLines: 6,
                  minLines: 1,
                ),
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  BlocProvider.of<NothingsBloc>(context)
                      .add(CreateNothing(text: textController.text));
                  textController.clear();
                  setState(() => showIcon = true);
                },
              )
            ],
          ),
        ],
      );
    }
  }
}

class SweetNothingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NothingsBloc, NothingsState>(
      builder: (context, state) {
        if (state is NothingsLoading) {
          return CircularProgressIndicator();
        }
        if (state is NothingsUpdated) {
          List<SweetNothing> nothings = state.nothings;

          return Container(
            height: MediaQuery.of(context).size.height * .4,
            child: ListView(
              children: nothings
                  .map(
                    (nothing) => ListTile(
                      title: Text(nothing.sweetNothing),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                                  title: Text('Delete this message?'),
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                    ),
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                    )
                                  ],
                                )).then((result) {
                          if (result) {
                            BlocProvider.of<NothingsBloc>(context).add(
                                DeleteNothing(documentId: nothing.documentId));
                          }
                        }),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }
      },
    );
  }
}
