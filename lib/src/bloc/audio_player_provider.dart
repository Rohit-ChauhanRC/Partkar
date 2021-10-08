import 'package:flutter/material.dart';
import 'audio_player_bloc.dart';
export 'audio_player_bloc.dart';

class AudioPlayeProvider extends InheritedWidget {
  final bloc = AudioPlayerBloc();

  AudioPlayeProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static AudioPlayerBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AudioPlayeProvider>()
        .bloc;
  }
}
