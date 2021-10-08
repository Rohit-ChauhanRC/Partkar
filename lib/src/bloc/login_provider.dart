import 'package:flutter/material.dart';
import 'login_bloc.dart';
export 'login_bloc.dart';

class LoginProvider extends InheritedWidget {
  final bloc = LoginBloc();

  LoginProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoginProvider>().bloc;
  }
}
