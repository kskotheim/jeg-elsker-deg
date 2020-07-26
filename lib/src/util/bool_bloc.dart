import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoolBloc extends Bloc<bool, bool> {
  bool value = false;

  BoolBloc() : super(false);
  BoolBloc.value(bool initState) : super(initState);

  void enable() => add(true);
  void disable() => add(false);
  void toggle() => add(!value);

  @override
  Stream<bool> mapEventToState(bool event) async* {
    value = event;
    yield event;
  }
}

class BoolBlocToggler<T extends BoolBloc> extends StatelessWidget {
  final Function(bool) childFct;

  BoolBlocToggler({this.childFct});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, bool>(
      builder: (context, val) => InkWell(
        child: childFct(val),
        onTap: BlocProvider.of<T>(context).toggle,
      ),
    );
  }
}
