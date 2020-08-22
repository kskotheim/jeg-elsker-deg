import 'package:bloc/bloc.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/settings/settings_repo.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final SettingsRepository repo = SR();
  final String userId;
  final GroupBloc groupBloc;

  bool statsRetrieved = false;
  int postCt;
  int useCt;
  int daysVisited;

  StatsBloc({this.userId, this.groupBloc})
      : assert(userId != null, groupBloc != null),
        super(StatsLoading());

  void _getStats() async {
    repo.getPostCt(userId).listen(
      (event) {
        postCt = event;
        _checkAndPropagate();
      },
    );
    repo.getPostUseCt(userId).listen(
      (event) {
        useCt = event;
        _checkAndPropagate();
      },
    );
  }

  void _checkAndPropagate() {
    if (postCt != null && useCt != null) {
      statsRetrieved = true;
      add(StatsLoaded(Stats(
          posts: postCt,
          useCt: useCt,
          daysVisited: groupBloc.currentGroup.visitCount[userId],
          partnerDaysVisited: groupBloc.currentGroup.visitCount[groupBloc
              .currentGroup.users
              .where((element) => element.userId != userId)
              .first.userId])));
    }
  }

  @override
  Stream<StatsState> mapEventToState(event) async* {
    if (event is StatsOpened) {
      _getStats();
    }
    if (event is StatsLoaded) {
      yield StatsReady(event.stats);
    }
  }
}

class StatsEvent {}

class StatsOpened extends StatsEvent {}

class StatsLoaded extends StatsEvent {
  final Stats stats;
  StatsLoaded(this.stats) : assert(stats != null);
}

class StatsState {}

class StatsReady extends StatsState {
  final Stats stats;
  StatsReady(this.stats) : assert(stats != null);
}

class StatsLoading extends StatsState {}

class Stats {
  final int posts;
  final int useCt;
  final int daysVisited;
  final int partnerDaysVisited;

  Stats(
      {this.posts = 0,
      this.useCt = 0,
      this.daysVisited = 0,
      this.partnerDaysVisited = 0});
}
