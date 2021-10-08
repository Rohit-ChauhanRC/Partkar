import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../bloc/bible_reading_schedule_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/error_response.dart';
import '../modals/bible_responses.dart';
import '../widgets/reading_schedule.dart';
import '../widgets/reading_track.dart';
import '../utilities/settings.dart';
import 'navigation_drawer.dart';

class BibleScheduleScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  BibleScheduleScreen({@required this.generalBloc});

  @override
  State<BibleScheduleScreen> createState() {
    return _BibleScheduleScreenState(generalBloc: generalBloc);
  }
}

class _BibleScheduleScreenState extends State<BibleScheduleScreen> {
  ClubColourModeModal colours = Setting().colours();
  final GeneralBloc generalBloc;
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  _BibleScheduleScreenState({@required this.generalBloc});

  @override
  Widget build(BuildContext context) {
    colours = Setting().colours();
    return Scaffold(
      body: _uiBuilder(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  Widget _uiBuilder(BuildContext context) {
    // print('Building Bible Schedule');
    final BibleReadingScheduleBloc bloc =
        BibleReadingScheduleProvider.of(context);
    // final givenFormat = DateFormat("yyyy-MM-dd");
    // DateTime date = DateTime.now();
    // final String formattedDate = givenFormat.format(date);

    // print('formatted date $formattedDate');
    return FutureBuilder(
      // future: bloc.fetch(formattedDate),
      future: bloc.fetch(''),
      builder: (settingContext, snapshot) {
        //if (!(snapshot.hasData)) {r
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        } else {
          final data = snapshot.data;
          if (data is ErrorResponseModel) {
            return Center(child: Text(data.message));
          } else if (data is List<BibleReadingScheduleModal>) {
            return ReadingScheduleWidget(
              bloc: bloc,
              scheduleList: data,
              reloadData: () {
                setState(() {});
              },
              generalBloc: generalBloc,
            ); //_listBuilder(bloc, context, data);
          } else if (data is BibleReadingModal) {
            return ReadingTrackWidget(
              bloc: bloc,
              reading: data,
              reload: () {
                setState(() {});
              },
              generalBloc: generalBloc,
              player: player,
            );
          } else {
            return Center(child: Text('Error, Try again later.'));
          }
        }
      },
    );
  }
}
