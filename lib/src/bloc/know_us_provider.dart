import 'package:flutter/material.dart';
import 'know_us_bloc.dart';
export 'know_us_bloc.dart';

class KnowUsProvider extends InheritedWidget {
  final bloc = KnowUsBloc();

  KnowUsProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static KnowUsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KnowUsProvider>().bloc;
  }
}
