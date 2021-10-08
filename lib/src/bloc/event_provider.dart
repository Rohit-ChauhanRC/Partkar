import 'package:flutter/material.dart';
import 'event_bloc.dart';
export 'event_bloc.dart';

class EventProvider extends InheritedWidget {
  final bloc = EventBloc();

  EventProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static EventBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EventProvider>().bloc;
  }
}
