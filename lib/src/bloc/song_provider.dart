import 'package:flutter/material.dart';
import 'song_bloc.dart';
export 'song_bloc.dart';

class SongProvider extends InheritedWidget {
  final bloc = SongBloc();

  SongProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static SongBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SongProvider>().bloc;
  }
}
