import 'package:flutter/material.dart';
import 'app_policy_bloc.dart';
export 'app_policy_bloc.dart';

class AppPolicyProvider extends InheritedWidget {
  final bloc = AppPolicyBloc();

  AppPolicyProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static AppPolicyBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppPolicyProvider>().bloc;
  }
}
