import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/group/connection_requests/connection_requests_bloc.dart';
import 'package:my_love/src/components/group/group_bloc.dart';

class ConnectionRequestsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ConnectionRequestsBloc(groupBloc: BlocProvider.of<GroupBloc>(context)),
      child: BlocBuilder<ConnectionRequestsBloc, ConnectionRequestState>(
        builder: (context, state) {
          if(state is ConnectionRequestsLoading){
            return CircularProgressIndicator();
          }
          if (state is NoConnectionRequests) {
            return Text('no connection requests');
          }
          if (state is ConnectionRequestsActive) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: state.userDetails.map((details) {
                return ListTile(
                  title: Text(details.userName),
                  leading: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () =>
                        BlocProvider.of<ConnectionRequestsBloc>(context).add(
                            ApproveConnectionRequest(userId: details.userId)),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () =>
                        BlocProvider.of<ConnectionRequestsBloc>(context).add(
                            DisapproveConnectionRequest(
                                userId: details.userId)),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
