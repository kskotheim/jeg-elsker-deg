import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BoolBloc extends Bloc<bool, bool> {

  bool value = false;

  BoolBloc() : super(false);

  void enable() => add(true);
  void disable() => add(false);
  void toggle() => add(!value);

  @override
  Stream<bool> mapEventToState(bool event) async* {
    value = event;
    yield event;
  }

}


class BoolBlocManager<T extends BoolBloc> extends StatelessWidget {

  final Function(bool) childFct;

  BoolBlocManager({this.childFct});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, bool>(
      builder: (context, showList) => InkWell(
          child: childFct(showList),
          onTap: BlocProvider.of<T>(context).toggle),
    );
  }
}