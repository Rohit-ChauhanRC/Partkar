import 'package:flutter/material.dart';
import 'register_bloc.dart';
export 'register_bloc.dart';

class RegisterProvider extends InheritedWidget {
  final bloc = RegisterBloc();

  RegisterProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static RegisterBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RegisterProvider>().bloc;
  }
}
