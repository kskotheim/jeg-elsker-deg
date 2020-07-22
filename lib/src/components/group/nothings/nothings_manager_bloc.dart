import 'package:bloc/bloc.dart';
import 'package:my_love/src/components/group/group_repo.dart';
import 'package:my_love/src/components/group/nothings/nothing.dart';

class NothingsManagerBloc extends Bloc<NothingsEvent, NothingsState>{
  final String groupId;
  final String userId;
  final String partnerId;
  GroupRepository repo;
  List<Nothing> nothings = [];
  bool editNothingsList = false;

  // List<SweetNothing> nothings;

  NothingsManagerBloc({this.userId, this.partnerId, this.groupId}) : super(NothingsLoading()){
    assert(userId != null);
    assert(partnerId != null);
    assert(groupId != null);

    repo = GR(groupId: groupId);

    repo.sweetNothingIds(partnerId).listen((nothingIds) async {

      nothings = await Future.wait<Nothing>(nothingIds.map((nothingId) async {
        try{
         return nothings.where((element) => element.documentId == nothingId).single;
        } catch (e){
          return repo.getNothing(nothingId, partnerId);
        }
      }));
      
      // elements will be null if the database entry has been deleted
      if(nothings.length > 0){
        nothings.removeWhere((element) => element == null);
      }

      add(RecievedNothings(nothings: nothings));
    });
  }

  @override
  Stream<NothingsState> mapEventToState(NothingsEvent event) async* {
    if(event is CreateNothing){
      repo.addNewSweetNothing(userId, partnerId, true, event.text);
    }
    if(event is RecievedNothings){
      yield NothingsUpdated(nothings: event.nothings);
    }
    if(event is DeleteNothing){
      // repo.deleteNothing(event.documentId);
    }

  }

}

class NothingsEvent{}

class CreateNothing extends NothingsEvent{
  final String text;
  CreateNothing({this.text}) : assert(text != null);
}

class RecievedNothings extends NothingsEvent {
  final List<Nothing> nothings;
  RecievedNothings({this.nothings});
}

class DeleteNothing extends NothingsEvent {
  final String documentId;
  DeleteNothing({this.documentId}) : assert(documentId != null);
}


class NothingsState{}

class NothingsLoading extends NothingsState{}

class NothingsUpdated extends NothingsState{
  final List<Nothing> nothings;
  NothingsUpdated({this.nothings});
}

