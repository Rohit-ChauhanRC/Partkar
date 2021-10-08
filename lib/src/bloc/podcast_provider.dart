import 'package:flutter/material.dart';
import 'podcast_bloc.dart';
export 'podcast_bloc.dart';

class PodcastProvider extends InheritedWidget {
  final bloc = PodcastBloc();

  PodcastProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static PodcastBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PodcastProvider>().bloc;
  }
}
