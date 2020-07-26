import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/group/nothings/browser/browser_bloc.dart';
import 'package:my_love/src/components/group/nothings/nothings_manager_bloc.dart';

class NothingBrowser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NothingsBrowserBloc>(
      create: (context) => NothingsBrowserBloc(
          nothingsManagerBloc: BlocProvider.of<NothingsManagerBloc>(context)),
      child: NothingsListPage(),
    );
  }
}

class NothingsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NothingsBrowserBloc browserBloc =
        BlocProvider.of<NothingsBrowserBloc>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () => BlocProvider.of<NothingsManagerBloc>(context)
                    .add(CancelButtonPushed()),
              ),
              FlatButton(
                child: Text('Recent'),
                onPressed: () => browserBloc.add(SearchRecentSelected()),
              ),
              FlatButton(
                child: Text('Popular'),
                onPressed: () => browserBloc.add(SearchPopularSelected()),
              )
            ],
          ),
          NothingsList(),
        ],
      ),
    );
  }
}

class NothingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NothingsBrowserBloc, BrowserState>(
      builder: (context, snapshot) {
        NothingsBrowserBloc browserBloc =
            BlocProvider.of<NothingsBrowserBloc>(context);
        if (snapshot is BrowserLoading) {
          return CircularProgressIndicator();
        }
        if (snapshot is NothingsRetrieved) {
          NothingsRetrieved data = snapshot;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListView(
                shrinkWrap: true,
                children: data.nothings
                    .map(
                      (nothing) => ListTile(
                        title: Text(nothing.text),
                        subtitle: Text('Uses: ${nothing.useCt}'),
                        onTap: () => browserBloc.add(
                          NothingSelected(nothing.documentId),
                        ),
                      ),
                    )
                    .toList(),
              ),
              browserBloc.lastItem != null
                  ? FlatButton(
                      child: Text('Next'),
                      onPressed: () => browserBloc.add(
                        NextPageButtonPushed(),
                      ),
                    )
                  : Text('last item: ${browserBloc.lastItem}'),
            ],
          );
        }
      },
    );
  }
}
