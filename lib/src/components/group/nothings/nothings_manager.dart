import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/group/nothings/nothing.dart';
import 'package:my_love/src/components/group/nothings/nothings_manager_bloc.dart';
import 'package:my_love/src/util/bool_bloc.dart';

class NothingsManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Group currentGroup = BlocProvider.of<GroupBloc>(context).currentGroup;
    String userId = BlocProvider.of<AccountBloc>(context).currentUser.userId;
    return BlocProvider(
      create: (context) => NothingsManagerBloc(
          groupId: currentGroup.groupId,
          userId: userId,
          partnerId: currentGroup.users
              .where((user) => user.userId != userId)
              .first
              .userId),
      child: BlocProvider(
        create: (context) => ToggleEditNothingList(),
        child: BlocProvider(
          create: (context) => ShowNewNoteScreen(),
          child: Center(
            child: NothingsButtonAndList(),
          ),
        ),
      ),
    );
  }
}

class NothingsButtonAndList extends StatelessWidget {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowNewNoteScreen, bool>(
        builder: (context, showNewNoteScreen) {
      if (!showNewNoteScreen) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.add),
                        Text('New Note'),
                      ],
                    ),
                    onPressed:
                        BlocProvider.of<ShowNewNoteScreen>(context).toggle),
                BoolBlocManager<ToggleEditNothingList>(
                  childFct: (val) => InkWell(
                    child: Icon(
                      Icons.edit,
                      color: val ? Colors.blue.shade200 : Colors.black87,
                    ),
                  ),
                ),
              ],
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
                  onPressed:
                      BlocProvider.of<ShowNewNoteScreen>(context).toggle,
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
                    BlocProvider.of<NothingsManagerBloc>(context)
                        .add(CreateNothing(text: textController.text));
                    textController.clear();
                  },
                )
              ],
            ),
          ],
        );
      }
    });
  }
}

class SweetNothingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NothingsManagerBloc, NothingsState>(
      builder: (context, state) {
        if (state is NothingsLoading) {
          return CircularProgressIndicator();
        }
        if (state is NothingsUpdated) {
          List<Nothing> nothings = state.nothings;

          return Container(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width * .75,
            child: ListView(
              children: nothings
                  .map(
                    (nothing) => ListTile(
                      title: Text(nothing.text),
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
                            BlocProvider.of<NothingsManagerBloc>(context).add(
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

// bool bloc for showing / hiding delete icons

class ToggleEditNothingList extends BoolBloc {}

// bool bloc for showing new note screen

class ShowNewNoteScreen extends BoolBloc {}
