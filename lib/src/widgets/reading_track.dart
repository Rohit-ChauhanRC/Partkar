import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../modals/bible_responses.dart';
import '../modals/error_response.dart';
import '../bloc/bible_reading_schedule_provider.dart';
import '../bloc/general_provider.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../utilities/constants.dart';
import 'alert.dart';
import 'spacer.dart';
import 'loader.dart';
import 'bible_verse_reading.dart';

class ReadingTrackWidget extends StatefulWidget {
  final BibleReadingScheduleBloc bloc;
  final BibleReadingModal reading;
  final Function reload;
  final GeneralBloc generalBloc;
  final AssetsAudioPlayer player;

  ReadingTrackWidget({
    @required this.bloc,
    @required this.reading,
    @required this.reload,
    @required this.generalBloc,
    @required this.player,
  });

  @override
  State<StatefulWidget> createState() {
    return _ReadingTrackWidgetState(
      bloc: bloc,
      reading: reading,
      reload: reload,
      generalBloc: generalBloc,
      player: player,
    );
  }
}

class _ReadingTrackWidgetState extends State<ReadingTrackWidget> {
  final ClubColourModeModal colours = Setting().colours();
  final BibleReadingScheduleBloc bloc;
  final BibleReadingModal reading;
  final Function reload;
  final GeneralBloc generalBloc;
  final AssetsAudioPlayer player;
  ScrollController scrollController = ScrollController();

  _ReadingTrackWidgetState({
    @required this.bloc,
    @required this.reading,
    @required this.reload,
    @required this.generalBloc,
    @required this.player,
  });

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (Helper.showTabbar) {
          Helper.showTabbar = false;
          generalBloc.changeDisplayTabbar(false);
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!Helper.showTabbar) {
          Helper.showTabbar = true;
          generalBloc.changeDisplayTabbar(true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _readingView(context);
  }

  Widget _readingView(BuildContext context) {
    return FutureBuilder(
      future: bloc.fetchReading(reading.id.toString()),
      builder: (chapterContext, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          //if (data is BibleReadingResponseModal) {
          if (data is Map<String, dynamic>) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: _chapterView(
                      context,
                      data['response'].data.readings,
                      data['response'].data.medias),
                ), //_renderChapters(),
              ),
            );
          } else if (data is ErrorResponseModel) {
            Alert.defaultAlert(context, 'Error', data.message);
            return Text('');
          }
        }

        return Center(
            child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
      },
    );
  }

  List<Widget> _chapterView(BuildContext context,
      List<BibleChapterReadingModal> readings, List<String> medias) {
    return [
      Space(verticle: 20),
      chapterHeading(reading.portionName, colours),
      Space(verticle: 20),
      ...chapterReadings(readings, colours),
      Space(verticle: 20),
      ...readingMedias(player, medias),
      Space(verticle: 20),
      _markButton(context),
      Space(verticle: 50),
    ];
  }

  Widget _markButton(BuildContext context) {
    return /* GestureDetector(
      child:*/
        Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Icon(Icons.radio_button_unchecked, color: colours.headlineColour()),
        // Space(horizontal: 5),
        // Text(
        //   'Mark as read',
        //   style: TextStyle(
        //     color: colours.headlineColour(),
        //     fontFamily: Constants.FONT_FAMILY_FUTURA,
        //     fontSize: 18,
        //   ),
        // ),
        ElevatedButton(
          onPressed: () {
            // print('Mark read on ${reading.id}');
            updateReadStatus(context);
          },
          child: Text(
            'Next',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              color: colours.bgColour(),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: colours.accentColour(),
          ),
        )
      ],
      // ),
      // onTap: () {
      //   print('Mark read on ${reading.id}');
      //   updateReadStatus(context);
      // },
    );
  }

  void updateReadStatus(BuildContext context) async {
    Loader.showLoading(context);
    await bloc.trackReading(reading.id.toString());
    Navigator.pop(context);
    reload();
  }
}
