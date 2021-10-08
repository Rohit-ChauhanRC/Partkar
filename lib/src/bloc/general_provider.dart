import 'package:flutter/material.dart';
import 'general_bloc.dart';
export 'general_bloc.dart';

class GeneralProvider extends InheritedWidget {
  final bloc = GeneralBloc();

  GeneralProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static GeneralBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GeneralProvider>().bloc;
  }
}
