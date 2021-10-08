import 'package:flutter/material.dart';
import 'bible_settings_bloc.dart';
export 'bible_settings_bloc.dart';

class BibleSettingsProvider extends InheritedWidget {
  final bloc = BibleSettingsBloc();

  BibleSettingsProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static BibleSettingsBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BibleSettingsProvider>()
        .bloc;
  }
}
