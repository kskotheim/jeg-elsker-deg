import 'package:bloc/bloc.dart';
import 'package:my_love/src/components/auth/user.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/group/group_repo.dart';

class ConnectionRequestsBloc
    extends Bloc<ConnectionRequestEvent, ConnectionRequestState> {
  GroupRepository repo;
  final GroupBloc groupBloc;

  ConnectionRequestsBloc({this.groupBloc}) {
    repo = groupBloc.repo;
    repo.connectionRequests().listen(
        (requests) => add(ConnectionRequestsRetrieved(userDetails: requests)));
  }

  @override
  ConnectionRequestState get initialState => ConnectionRequestsLoading();

  @override
  Stream<ConnectionRequestState> mapEventToState(
      ConnectionRequestEvent event) async* {
    if (event is ConnectionRequestsRetrieved) {
      if (event.userDetails.length > 0) {
        yield ConnectionRequestsActive(userDetails: event.userDetails);
      } else {
        yield NoConnectionRequests();
      }
    }
    if(event is ApproveConnectionRequest){
      repo.approveConnectionRequest(event.userId);
    }
    if(event is DisapproveConnectionRequest){
      repo.disapproveConnectionRequest(event.userId);
    }
  }
}

class ConnectionRequestEvent {}

class ApproveConnectionRequest extends ConnectionRequestEvent {
  final String userId;
  ApproveConnectionRequest({this.userId}) : assert(userId != null);
}

class DisapproveConnectionRequest extends ConnectionRequestEvent {
  final String userId;
  DisapproveConnectionRequest({this.userId}) : assert(userId != null);
}

class ConnectionRequestsRetrieved extends ConnectionRequestEvent {
  final List<User> userDetails;
  ConnectionRequestsRetrieved({this.userDetails}) : assert(userDetails != null);

  @override
  String toString() {
    return 'Connection Requests Retrieved: $userDetails';
  }
}

class ConnectionRequestState {}

class ConnectionRequestsLoading extends ConnectionRequestState {}

class NoConnectionRequests extends ConnectionRequestState {}

class ConnectionRequestsActive extends ConnectionRequestState {
  final List<User> userDetails;
  ConnectionRequestsActive({this.userDetails}) : assert(userDetails != null);
}
