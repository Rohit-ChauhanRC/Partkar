import 'package:flutter/material.dart';
import 'notification_bloc.dart';
export 'notification_bloc.dart';

class NotificationProvider extends InheritedWidget {
  final bloc = NotificationBloc();

  NotificationProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static NotificationBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NotificationProvider>()
        .bloc;
  }
}
