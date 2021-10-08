import 'package:flutter/material.dart';
import 'discipleship_bloc.dart';
export 'discipleship_bloc.dart';

class DiscipleshipProvider extends InheritedWidget {
  final bloc = DiscipleshipBloc();

  DiscipleshipProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static DiscipleshipBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DiscipleshipProvider>()
        .bloc;
  }
}
