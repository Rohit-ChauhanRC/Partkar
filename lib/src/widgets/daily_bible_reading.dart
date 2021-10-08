import 'package:flutter/material.dart';
import '../bloc/bible_reading_schedule_provider.dart';
import '../modals/home_responses.dart';
import '../modals/bible_responses.dart';
import '../utilities/settings.dart';
import '../utilities/constants.dart';
import 'spacer.dart';
import 'bible_verse_reading.dart';
import '../screens/bible_schedule_read.dart';

class DailyBibleReadingWidget extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();
  final HomeReadingsModal homeReadings;
  final Function reloadData;

  DailyBibleReadingWidget(
      {@required this.homeReadings, @required this.reloadData});

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    bool completed = true;
    for (BibleReadingModal r in homeReadings.todayReadings) {
      if (r.isRead == false) {
        completed = false;
        break;
      }
    }
    if (completed) {
      return Container();
    }
    List<BibleChapterReadingModal> givenReadings = homeReadings.readingDetail;
    List<BibleChapterReadingModal> readings = [];
    if (givenReadings.length > 1) {
      readings.add(givenReadings[0]);
      readings.add(givenReadings[1]);
    } else if (givenReadings.length == 1) {
      readings.add(givenReadings[0]);
    }
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Daily Bible Reading'),
          Space(verticle: 15),
          _description(homeReadings.todayReadings),
          Space(verticle: 7),
          ...chapterReadings(readings, colours),
          _continueButton(context, homeReadings.todayReadings),
        ],
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      gradient: new LinearGradient(
        colors: [
          colours.gradientStartColour(),
          colours.gradientEndColour(),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
        //tileMode: TileMode.clamp,
      ),
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_TIMES,
        color: colours.headlineColour(),
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    );
  }

  Widget _description(List<BibleReadingModal> readings) {
    String descr = '';
    for (BibleReadingModal reading in readings) {
      if (descr == '') {
        descr = descr + "Today's reading: " + reading.portionShortName;
      } else {
        descr = descr + '; ${reading.portionName}';
      }
    }
    return Text(
      descr.replaceAll('-', '\u2013'),
      // overflow: TextOverflow.ellipsis,
      // softWrap: false,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 16,
        color: colours.headlineColour(),
      ),
    );
  }

  Widget _continueButton(
      BuildContext context, List<BibleReadingModal> readings) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          final BibleReadingScheduleBloc bloc =
              BibleReadingScheduleProvider.of(context);
          bool reload = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      BibleScheduleReadScreen(bloc: bloc, readings: readings)));
          // print('Get back');
          // print(reload);
          if ((reload != null) && reload) {
            reloadData();
            // Navigator.pop(context);
          }
        },
        child: Container(
          height: 26,
          width: 150,
          padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: colours.accentColour(),
          ),
          child: Center(
            child: Text(
              'Continue Reading',
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                color: colours.bgColour(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
