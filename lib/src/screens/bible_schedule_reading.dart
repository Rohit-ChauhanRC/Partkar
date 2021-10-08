import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../bloc/bible_reading_schedule_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/bible_responses.dart';
import '../modals/error_response.dart';
import '../widgets/spacer.dart';
import '../widgets/alert.dart';
import '../widgets/bible_verse_reading.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import 'navigation_drawer.dart';

class BibleScheduleReadingScreen extends StatefulWidget {
  final BibleReadingScheduleBloc bloc;
  final BibleReadingScheduleModal schedule;

  BibleScheduleReadingScreen({
    @required this.bloc,
    @required this.schedule,
  });

  @override
  _BibleScheduleReadingState createState() {
    return _BibleScheduleReadingState(
      bloc: bloc,
      schedule: schedule,
    );
  }
}

class _BibleScheduleReadingState extends State<BibleScheduleReadingScreen> {
  final ClubColourModeModal colours = Setting().colours();
  final BibleReadingScheduleBloc bloc;
  final BibleReadingScheduleModal schedule;
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  int currentIndex = 0;
  List<Map<String, List<BibleChapterReadingModal>>> allReadings = [];
  Map<String, List<String>> allMedias = {};

  _BibleScheduleReadingState({
    @required this.bloc,
    @required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: _backButton(),
      title: Text(
        'Readings',
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      iconTheme: IconThemeData(color: colours.bgColour()),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _backButton() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: colours.bgColour(),
      ),
      onPressed: () {
        player.stop();
        Navigator.pop(context);
      },
    );
  }

  Widget _body() {
    //bloc.fetchReading(schedule.readings[0].id.toString());
    // print('PORTION NAMES');
    // for (BibleReadingModal a in schedule.readings) {
    //   // print('${a.portionName}: ${a.isRead} - ${a.id} at $currentIndex');
    // }
    return FutureBuilder(
      future: bloc.fetchReading(schedule.readings[currentIndex].id.toString()),
      builder: (chapterContext, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          //if (data is BibleReadingResponseModal) {
          if (data is Map<String, dynamic>) {
            if (!(_containsReading(data['id']))) {
              allReadings.add({data['id']: data['response'].data.readings});
              allMedias[data['id']] = data['response'].data.medias;
            }

            return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: _renderChapters(),
                ));
          } else if (data is ErrorResponseModel) {
            Alert.defaultAlert(context, 'Error', data.message);
            return Text('');
          }
        }

        return Center(
            child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        // } else {
        //   return Text('else');
        // }
      },
    );
  }

  bool _containsReading(String id) {
    bool contains = false;
    for (Map<String, List<BibleChapterReadingModal>> reading in allReadings) {
      reading.forEach((key, value) {
        if ('$key' == '$id') {
          contains = true;
        }
      });
    }
    return contains;
  }

  bool _readStatus(String id) {
    for (BibleReadingModal reading in schedule.readings) {
      if (reading.id.toString() == id) {
        return reading.isRead;
      }
    }
    return false;
  }

  Widget _renderChapters() {
    List<Widget> readingWidgets = [];
    for (Map<String, List<BibleChapterReadingModal>> reading in allReadings) {
      reading.forEach((key, value) {
        readingWidgets.addAll(
            _chapterView(value, key, _readStatus(key), key, allMedias[key]));
      });
    }
    if (allReadings.length < schedule.readings.length) {
      if (schedule.readings[allReadings.length].isRead == true) {
        readingWidgets.add(Center(
            child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(colours.bodyTextColour()))));
        readingWidgets.add(Space(verticle: 30));
      }
    }
    Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //children: _chapterView(data['response'].data.readings, data['id'], false),
      children: readingWidgets,
    );
    checkForNext();
    return column;
  }

  List<Widget> _chapterView(List<BibleChapterReadingModal> readings,
      String title, bool isRead, String readingId, List<String> medias) {
    return [
      Space(verticle: 20),
      chapterHeading(_potionNameFromId(title), colours),
      Space(verticle: 20),
      ...chapterReadings(readings, colours),
      Space(verticle: 20),
      ...readingMedias(player, medias),
      Space(verticle: 20),
      _mark(isRead, readingId),
      Space(verticle: 10),
      Divider(height: 2, color: Colors.blue),
      Space(verticle: 50),
    ];
  }

  String _potionNameFromId(String id) {
    for (BibleReadingModal r in schedule.readings) {
      if (r.id.toString() == id) {
        return r.portionName;
      }
    }
    return '';
  }

  Widget _mark(bool isRead, String readingId) {
    if (isRead) {
      return Center(
          child: Icon(Icons.check_circle, color: colours.accentColour()));
    } else {
      return Center(child: _markButton(readingId, schedule.scheduleId));
    }
  }

  Widget _markButton(String readingId, scheduleId) {
    return /* GestureDetector(
      child: */
        Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Icon(Icons.radio_button_unchecked, color: colours.headlineColour()),
        // Space(horizontal: 5),
        // Text(
        //   'Mark as read',
        //   style: TextStyle(
        //     color: colours.bodyTextColour(),
        //     fontFamily: Constants.FONT_FAMILY_FUTURA,
        //     fontSize: 14,
        //   ),
        // ),
        ElevatedButton(
          onPressed: () {
            player.stop();
            updateReadStatus(readingId, scheduleId);
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
      //   // print('Mark read on $readingId');
      //   updateReadStatus(readingId);
      // },
    );
  }

  void updateReadStatus(String readingId, String scheduleId) {
    bloc.trackReading(readingId, scheduleId: scheduleId);
    if (schedule.readings.length == allReadings.length) {
      Navigator.pop(context);
      return;
    }
    // schedule.readings[currentIndex].isRead = true;
    // currentIndex += 1;
    setState(() {
      schedule.readings[currentIndex].isRead = true;
    });
    // schedule.readings[currentIndex].isRead = true;
    //currentIndex += 1;
    //checkForNext();
  }

  void checkForNext() {
    Future.delayed(Duration(seconds: 3), () {
      // print('Checking for next');
      if (schedule.readings.length > currentIndex + 1) {
        // print(
        //     'Checking for: ${schedule.readings[currentIndex + 1].portionName}');
        // print(
        //     'Read Status: ${schedule.readings[currentIndex + 1].isRead} at ${currentIndex + 1}');
        if (schedule.readings[currentIndex + 1].isRead) {
          setState(() {
            // print(
            //     'Making update for: ${schedule.readings[currentIndex + 1].portionName}');
            currentIndex += 1;
          });
        }
      }
    });
  }
}
