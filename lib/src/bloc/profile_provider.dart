import 'package:flutter/material.dart';
import 'profile_bloc.dart';
export 'profile_bloc.dart';

class ProfileProvider extends InheritedWidget {
  final bloc = ProfileBloc();

  ProfileProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static ProfileBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProfileProvider>().bloc;
  }
}
