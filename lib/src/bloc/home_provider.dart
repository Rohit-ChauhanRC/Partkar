import 'package:flutter/material.dart';
import 'home_bloc.dart';
export 'home_bloc.dart';

class HomeProvider extends InheritedWidget {
  final bloc = HomeBloc();

  HomeProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static HomeBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeProvider>().bloc;
  }
}
