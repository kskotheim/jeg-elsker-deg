import 'package:bloc/bloc.dart';
import 'package:my_love/src/components/group/group_repo.dart';

class NothingsManagerBloc extends Bloc<NothingsEvent, NothingsState>{
  final String groupId;
  final String userId;
  final String partnerId;
  GroupRepository repo;

  // List<SweetNothing> nothings;

  NothingsManagerBloc({this.userId, this.partnerId, this.groupId}){
    assert(userId != null);
    assert(partnerId != null);
    assert(groupId != null);

    repo = GR(groupId: groupId);

    repo.sweetNothings(partnerId).listen((nothings){
      add(RecievedNothings(nothings: nothings));
    });
  }

  @override
  NothingsState get initialState => NothingsLoading();

  @override
  Stream<NothingsState> mapEventToState(NothingsEvent event) async* {
    if(event is CreateNothing){
      repo.createSweetNothing(userId, partnerId, event.text);
    }
    if(event is RecievedNothings){
      yield NothingsUpdated(nothings: event.nothings);
    }
    if(event is DeleteNothing){
      repo.deleteNothing(partnerId, event.documentId);
    }

  }

}

class NothingsEvent{}

class CreateNothing extends NothingsEvent{
  final String text;
  CreateNothing({this.text}) : assert(text != null);
}

class RecievedNothings extends NothingsEvent {
  final List<SweetNothing> nothings;
  RecievedNothings({this.nothings});
}

class DeleteNothing extends NothingsEvent {
  final String documentId;
  DeleteNothing({this.documentId}) : assert(documentId != null);
}


class NothingsState{}

class NothingsLoading extends NothingsState{}

class NothingsUpdated extends NothingsState{
  final List<SweetNothing> nothings;
  NothingsUpdated({this.nothings});
}