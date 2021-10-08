import 'package:flutter/material.dart';
import 'bible_reading_schedule_bloc.dart';
export 'bible_reading_schedule_bloc.dart';

class BibleReadingScheduleProvider extends InheritedWidget {
  final bloc = BibleReadingScheduleBloc();

  BibleReadingScheduleProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => false;

  static BibleReadingScheduleBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BibleReadingScheduleProvider>()
        .bloc;
  }
}
