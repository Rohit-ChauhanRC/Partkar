import 'package:flutter/material.dart';
import 'meeting_bloc.dart';
export 'meeting_bloc.dart';

class MeetingProvider extends InheritedWidget {
  final bloc = MeetingBloc();

  MeetingProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static MeetingBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MeetingProvider>().bloc;
  }
}
