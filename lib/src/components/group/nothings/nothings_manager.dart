import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/group/nothings/browser/browser.dart';
import 'package:my_love/src/components/group/nothings/nothing.dart';
import 'package:my_love/src/components/group/nothings/nothings_manager_bloc.dart';
import 'package:my_love/src/util/bool_bloc.dart';

class NothingsManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Group currentGroup = BlocProvider.of<GroupBloc>(context).currentGroup;
    String userId = BlocProvider.of<AccountBloc>(context).currentUser.userId;
    return MultiBlocProvider(
        providers: [
          BlocProvider<NothingsManagerBloc>(
            create: (context) => NothingsManagerBloc(
                groupId: currentGroup.groupId,
                userId: userId,
                partnerId: currentGroup.users
                    .where((user) => user.userId != userId)
                    .first
                    .userId),
          ),
          BlocProvider<ToggleEditNothingList>(
            create: (context) => ToggleEditNothingList(),
          ),
          BlocProvider<MakeNotePublic>(
            create: (context) => MakeNotePublic(),
          ),
        ],
        child: Center(
          child: NothingsManagerPage(),
        ));
  }
}

class NothingsManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NothingsManagerBloc, NothingsState>(
        builder: (context, nothingsState) {
      if (nothingsState is NothingsLoading ||
          nothingsState is NothingsUpdated) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NewNoteButton(),
                BrowseNotesButton(),
                nothingsState is NothingsUpdated
                    ? ToggleEditListButton()
                    : Container(
                        width: 30.0,
                      ),
              ],
            ),
            nothingsState is NothingsUpdated
                ? SweetNothingsList(
                    nothings: nothingsState.nothings,
                  )
                : CircularProgressIndicator(),
          ],
        );
      } else if (nothingsState is ShowNewNoteForm) {
        return NewNoteForm();
      } else if (nothingsState is ShowBrowseNoteScreen) {
        return NothingBrowser();
      }
    });
  }
}

class NewNoteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.add),
          Text('New Note'),
        ],
      ),
      onPressed: () => BlocProvider.of<NothingsManagerBloc>(context)
          .add(NewNoteButtonPushed()),
    );
  }
}

class BrowseNotesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.add),
          Text('Browse Notes'),
        ],
      ),
      onPressed: () => BlocProvider.of<NothingsManagerBloc>(context)
          .add(BrowseNotesButtonPushed()),
    );
  }
}

class ToggleEditListButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BoolBlocToggler<ToggleEditNothingList>(
      childFct: (val) => Icon(
        Icons.edit,
        color: val ? Colors.blue.shade200 : Colors.black87,
      ),
    );
  }
}

class SweetNothingsList extends StatelessWidget {
  final List<Nothing> nothings;
  SweetNothingsList({this.nothings}) : assert(nothings != null);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToggleEditNothingList, bool>(
        builder: (context, editNothingList) {
      return Container(
        height: MediaQuery.of(context).size.height * .4,
        width: MediaQuery.of(context).size.width * .75,
        child: ListView(
          children: nothings
              .map(
                (nothing) => ListTile(
                  title: Text(nothing.text),
                  trailing:
                      editNothingList ? DeleteNothingIconButton(nothing) : null,
                ),
              )
              .toList(),
        ),
      );
    });
  }
}

class DeleteNothingIconButton extends StatelessWidget {
  final Nothing nothing;
  DeleteNothingIconButton(this.nothing) : assert(nothing != null);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                title: Text('Delete this message?'),
                children: <Widget>[
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context, false),
                  )
                ],
              )).then((result) {
        if (result) {
          BlocProvider.of<NothingsManagerBloc>(context)
              .add(DeleteNothing(documentId: nothing.documentId));
        }
      }),
    );
  }
}

class NewNoteForm extends StatelessWidget {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('something to tell your love'),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () => BlocProvider.of<NothingsManagerBloc>(context)
                  .add(CancelButtonPushed()),
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
                BlocProvider.of<NothingsManagerBloc>(context).add(
                  CreateNothing(
                      text: textController.text,
                      public: BlocProvider.of<MakeNotePublic>(context).state),
                );
                textController.clear();
              },
            )
          ],
        ),
        BlocBuilder<MakeNotePublic, bool>(
          builder: (context, makeNotePublic) {
            return InkWell(
              onTap: BlocProvider.of<MakeNotePublic>(context).toggle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: makeNotePublic,
                    onChanged: (val) =>
                        BlocProvider.of<MakeNotePublic>(context).add(val),
                  ),
                  Text('Public'),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

class BrowseNotesForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// bool bloc for showing / hiding delete icons

class ToggleEditNothingList extends BoolBloc {}

// bool bloc for public checkbox button

class MakeNotePublic extends BoolBloc {}
