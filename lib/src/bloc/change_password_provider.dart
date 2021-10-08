import 'package:flutter/material.dart';
import 'change_password_bloc.dart';
export 'change_password_bloc.dart';

class ChangePasswordProvider extends InheritedWidget {
  final bloc = ChangePasswordBloc();

  ChangePasswordProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static ChangePasswordBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ChangePasswordProvider>()
        .bloc;
  }
}
