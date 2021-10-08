import 'package:flutter/material.dart';
import 'club_bloc.dart';
export 'club_bloc.dart';

class ClubProvider extends InheritedWidget {
  final bloc = ClubBloc();

  ClubProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static ClubBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClubProvider>().bloc;
  }
}
