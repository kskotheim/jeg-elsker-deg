import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_love/src/components/group/nothings/browser/browser_repo.dart';
import 'package:my_love/src/components/group/nothings/nothing.dart';
import 'package:my_love/src/components/group/nothings/nothings_manager_bloc.dart';
import 'package:my_love/src/data/db.dart';

class NothingsBrowserBloc extends Bloc<BrowserEvent, BrowserState> {
  final NothingsManagerBloc nothingsManagerBloc;
  BrowserRepository repo;
  bool searchRecent = true;
  DocumentSnapshot lastItem;

  NothingsBrowserBloc({this.nothingsManagerBloc})
      : assert(nothingsManagerBloc != null),
        super(BrowserLoading()) {
    repo = BR(
        groupId: nothingsManagerBloc.groupId,
        toUserId: nothingsManagerBloc.partnerId);
    add(SearchRecentSelected());
  }

  @override
  Stream<BrowserState> mapEventToState(event) async* {
    List<DocumentSnapshot> nothingDocs;
    if (event is SearchRecentSelected) {
      searchRecent = true;
      nothingDocs = await repo.getMostRecentNothings();
      setLastItem(nothingDocs);
      yield NothingsRetrieved(listOfSnapsToNoths(nothingDocs));
    }
    if (event is SearchPopularSelected) {
      searchRecent = false;
      nothingDocs = await repo.getMostPopularNothings();
      setLastItem(nothingDocs);
      yield NothingsRetrieved(listOfSnapsToNoths(nothingDocs));
    }
    if (event is NextPageButtonPushed) {
      if (lastItem != null) {
        if (searchRecent) {
          nothingDocs = await repo.getMostRecentNothings(startAfter: lastItem);
        } else {
          nothingDocs = await repo.getMostPopularNothings(startAfter: lastItem);
        }
        setLastItem(nothingDocs);
        yield NothingsRetrieved(listOfSnapsToNoths(nothingDocs));
      }
    }
    if (event is NothingSelected) {
      repo.addNothingToNothingList(event.nothingId);
    }
  }

  void setLastItem(List<DocumentSnapshot> nothingDocs){
          print("length: ${nothingDocs.length}");

    if (nothingDocs.length < DB.NOTHINGS_PER_PAGE) {
      print('this was true');
          lastItem = null;
        } else {
          lastItem = nothingDocs[nothingDocs.length - 1];
          print("${lastItem.documentID}");
        }
  }

  dynamic extractLastItem(List list) {
    if (list.isNotEmpty) {
      return list.last;
    }
    return null;
  }

  List<Nothing> listOfSnapsToNoths(List<DocumentSnapshot> docs) =>
      docs.map((e) => Nothing.fromDocumentSnapshot(e)).toList();
}

class BrowserEvent {}

class SearchRecentSelected extends BrowserEvent {}

class SearchPopularSelected extends BrowserEvent {}

class NextPageButtonPushed extends BrowserEvent {}

class NothingSelected extends BrowserEvent {
  final String nothingId;
  NothingSelected(this.nothingId) : assert(nothingId != null);
}

class BrowserState {}

class BrowserLoading extends BrowserState {}

class NothingsRetrieved extends BrowserState {
  final List<Nothing> nothings;
  NothingsRetrieved(this.nothings) : assert(nothings != null);
}
