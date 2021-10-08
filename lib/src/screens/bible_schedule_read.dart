import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../modals/bible_responses.dart';
import '../modals/error_response.dart';
import '../bloc/bible_reading_schedule_provider.dart';
import '../bloc/general_provider.dart';
import '../widgets/alert.dart';
import '../widgets/spacer.dart';
import '../widgets/loader.dart';
import '../widgets/bible_verse_reading.dart';
import 'navigation_drawer.dart';

class BibleScheduleReadScreen extends StatefulWidget {
  final BibleReadingScheduleBloc bloc;
  //final BibleReadingScheduleModal schedule;
  final List<BibleReadingModal> readings;
  final String scheduleId;

  BibleScheduleReadScreen({
    @required this.bloc,
    @required this.readings,
    this.scheduleId,
  });

  @override
  State<BibleScheduleReadScreen> createState() {
    return _BibleScheduleReadScreenState(
      bloc: bloc,
      readings: readings,
    );
  }
}

class _BibleScheduleReadScreenState extends State<BibleScheduleReadScreen> {
  final ClubColourModeModal colours = Setting().colours();
  final BibleReadingScheduleBloc bloc;
  final String scheduleId;
  //final BibleReadingScheduleModal schedule;
  final List<BibleReadingModal> readings;
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  ScrollController _scrollController = ScrollController();

  int _currentIndex = 0;
  bool _auto = true;
  bool _refreshRequired = false;

  _BibleScheduleReadScreenState(
      {@required this.bloc, @required this.readings, this.scheduleId});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
        endDrawer: GeneralProvider(child: NavigationDrawer()),
        backgroundColor: colours.bgColour(),
      ),
      onWillPop: () async {
        Navigator.pop(context, _refreshRequired);
        return false;
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: _backButton(),
      title: Text(
        'Reading',
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
    if (_auto) {
      for (int i = 0; i < readings.length; i++) {
        _currentIndex = i;
        if (readings[i].isRead == false) {
          break;
        }
      }
      _auto = false;
    }

    if (_currentIndex == readings.length) {
      Future.delayed(Duration.zero, () {
        Navigator.pop(context, true);
      });
      // Navigator.pop(context, true);
      return Container();
    }

    return _readingView(context, readings[_currentIndex].id.toString(),
        readings[_currentIndex].portionName);
  }

  Widget _readingView(
      BuildContext context, String readingId, String portionName) {
    return FutureBuilder(
      future: bloc.fetchReading(readingId),
      builder: (chapterContext, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // if (snapshot.hasData) {
          final data = snapshot.data;
          //if (data is BibleReadingResponseModal) {
          if (data is Map<String, dynamic>) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: _chapterView(
                    context,
                    data['response'].data.readings,
                    portionName,
                    data['response'].data.medias,
                  ),
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

  List<Widget> _chapterView(
      BuildContext context,
      List<BibleChapterReadingModal> readings,
      String portionName,
      List<String> medias) {
    return [
      Space(verticle: 20),
      chapterHeading(portionName, colours),
      Space(verticle: 20),
      ...chapterReadings(readings, colours),
      Space(verticle: 20),
      ...readingMedias(player, medias),
      Space(verticle: 20),
      _previousNext(),
      Space(verticle: 50),
    ];
  }

  Widget _previousNext() {
    bool hidePrevious = false;
    bool hideNext = false;
    if (_currentIndex == 0) {
      hidePrevious = true;
    }
    // if ((selectedIndex + 1) == chapters.length) {
    //   hideNext = true;
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _previousButton(hidePrevious),
        _nextButton(hideNext),
      ],
    );
  }

  Widget _previousButton(bool hide) {
    if (hide) {
      return Container();
    }
    return ElevatedButton(
      child: Text(
        'Previous',
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          color: colours.bgColour(),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: colours.accentColour(),
      ),
      onPressed: () {
        player.stop();
        _currentIndex -= 1;
        setState(() {});
      },
    );
  }

  Widget _nextButton(bool hide) {
    if (hide) {
      return Container();
    }
    return ElevatedButton(
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
      onPressed: () async {
        player.stop();
        if (readings[_currentIndex].isRead == false) {
          Loader.showLoading(context);
          final res = await bloc.trackReading(
              readings[_currentIndex].id.toString(),
              scheduleId: scheduleId);
          if ((res != null) && (res is BibleReadingModal)) {
            readings.add(res);
          }
          Navigator.pop(context);
          readings[_currentIndex].isRead = true;
        }

        _currentIndex += 1;
        _scrollController.animateTo(_scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
        // _refreshRequired = true;
        try {
          Helper.RELOAD_HOME_TAB();
        } catch (e) {}
        setState(() {});
      },
    );
  }

  // void updateReadStatus(BuildContext context) async {
  //   Loader.showLoading(context);
  //   await bloc.trackReading(reading.id.toString());
  //   Navigator.pop(context);
  //   reload();
  // }
}
