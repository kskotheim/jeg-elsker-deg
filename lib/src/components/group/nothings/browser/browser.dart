import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/group/nothings/browser/browser_bloc.dart';
import 'package:my_love/src/components/group/nothings/nothings_manager_bloc.dart';
import 'package:my_love/src/components/settings/settings_page.dart';

class NothingBrowser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrowserBloc>(
      create: (context) => BrowserBloc(
          nothingsManagerBloc: BlocProvider.of<NothingsManagerBloc>(context)),
      child: NothingsListPage(),
    );
  }
}

class NothingsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserBloc, BrowserState>(
      builder: (context, browserState) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () =>
                        BlocProvider.of<NothingsManagerBloc>(context)
                            .add(CancelButtonPushed()),
                  ),
                  FlatButton(
                    child: Container(
                      child: Text('Recent'),
                      decoration:
                          BlocProvider.of<BrowserBloc>(context).searchRecent
                              ? borderDecoration(context)
                              : null,
                    ),
                    onPressed: () => BlocProvider.of<BrowserBloc>(context)
                        .add(SearchRecentSelected()),
                  ),
                  FlatButton(
                    child: Container(
                      child: Text('Popular'),
                      decoration:
                          !BlocProvider.of<BrowserBloc>(context).searchRecent
                              ? borderDecoration(context)
                              : null,
                    ),
                    onPressed: () => BlocProvider.of<BrowserBloc>(context)
                        .add(SearchPopularSelected()),
                  )
                ],
              ),
              NothingsList(browserState),
            ],
          ),
        );
      },
    );
  }
}

class NothingsList extends StatelessWidget {
  final BrowserState browserState;

  NothingsList(this.browserState);

  @override
  Widget build(BuildContext context) {
    if (browserState is NothingsRetrieved) {
      NothingsRetrieved data = browserState;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListView(
            shrinkWrap: true,
            children: data.nothings
                .map(
                  (nothing) => ListTile(
                    title: Text(nothing.text),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Created: ${parseDate(nothing.createdAt)}'),
                        Text('Uses: ${nothing.useCt}'),
                      ],
                    ),
                    onTap: () => BlocProvider.of<BrowserBloc>(context).add(
                      NothingSelected(nothing.documentId),
                    ),
                  ),
                )
                .toList(),
          ),
          BlocProvider.of<BrowserBloc>(context).lastItem != null
              ? FlatButton(
                  child: Text('Next'),
                  onPressed: () => BlocProvider.of<BrowserBloc>(context).add(
                    NextPageButtonPushed(),
                  ),
                )
              : Container(),
        ],
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  String parseDate(int date) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(date);
    String dateString = '';
    switch (time.weekday) {
      case 1:
        dateString = 'Mon';
        break;
      case 2:
        dateString = 'Tue';
        break;
      case 3:
        dateString = 'Wed';
        break;
      case 4:
        dateString = 'Thu';
        break;
      case 5:
        dateString = 'Fri';
        break;
      case 6:
        dateString = 'Sat';
        break;
      case 7:
        dateString = 'Sun';
        break;
    }
    String monthString;
    switch (time.month) {
      case 1:
        monthString = 'Jan';
        break;
      case 2:
        monthString = 'Feb';
        break;
      case 3:
        monthString = 'Mar';
        break;
      case 4:
        monthString = 'Apr';
        break;
      case 5:
        monthString = 'May';
        break;
      case 6:
        monthString = 'Jun';
        break;
      case 7:
        monthString = 'Jul';
        break;
      case 8:
        monthString = 'Aug';
        break;
      case 9:
        monthString = 'Sep';
        break;
      case 10:
        monthString = 'Oct';
        break;
      case 11:
        monthString = 'Nov';
        break;
      case 12:
        monthString = 'Dec';
        break;
    }
    return "${dateString} ${monthString} ${time.day} '${time.year % 100}";
  }
}
