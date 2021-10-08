import 'package:flutter/material.dart';
import 'settings_bloc.dart';
export 'settings_bloc.dart';

class SettingsProvider extends InheritedWidget {
  final bloc = SettingsBloc();

  SettingsProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static SettingsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsProvider>().bloc;
  }
}
