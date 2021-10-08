import 'package:flutter/material.dart';
import 'bible_bloc.dart';
export 'bible_bloc.dart';

class BibleProvider extends InheritedWidget {
  final bloc = BibleBloc();

  BibleProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static BibleBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BibleProvider>().bloc;
  }
}
