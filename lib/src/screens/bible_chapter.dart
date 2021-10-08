import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../bloc/bible_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/bible_responses.dart';
import '../widgets/spacer.dart';
import '../widgets/alert.dart';
import '../widgets/bible_verse_reading.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import 'navigation_drawer.dart';

class BibleChapterScreen extends StatefulWidget {
  final List<BookChapterModal> chapters;
  final int selectedIndex;

  BibleChapterScreen({@required this.chapters, @required this.selectedIndex});

  @override
  State<BibleChapterScreen> createState() {
    return _BibleChapterState(chapters: chapters, selectedIndex: selectedIndex);
  }
}

class _BibleChapterState extends State<BibleChapterScreen> {
  final ClubColourModeModal colours = Setting().colours();
  final List<BookChapterModal> chapters;
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  int selectedIndex;

  _BibleChapterState({@required this.chapters, @required this.selectedIndex});

  Future<bool> _opPop() async {
    // print('Podcast Player POP');
    player.stop();
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: _appBar(),
        body: _uiBuilder(context),
        endDrawer: GeneralProvider(child: NavigationDrawer()),
        backgroundColor: colours.bgColour(),
      ),
      onWillPop: _opPop,
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: _backButton(),
      title: Text(
        chapters[selectedIndex].name,
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

  Widget _uiBuilder(BuildContext context) {
    final BibleBloc bibleBloc = BibleProvider.of(context);
    return FutureBuilder(
      future: bibleBloc.fetchChapterDetails(chapters[selectedIndex].id),
      builder: (chapterContext, snapshot) {
        //if (snapshot.hasData) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data;
          if (data.status) {
            return _chapterDetails(data.data.chapterReadings, data.data.medias);
          }
          return Alert.defaultAlert(
              context, 'Error', 'Error while loading data.');
        } else {
          return Container(
            child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(colours.bodyTextColour())),
            alignment: Alignment.center,
          );
        }
      },
    );
  }

  Widget _chapterDetails(
      List<BibleChapterReadingModal> readings, List<String> medias) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Space(verticle: 20),
            chapterHeading(chapters[selectedIndex].name, colours),
            Space(verticle: 20),
            ...chapterReadings(readings, colours),
            Space(verticle: 20),
            ...readingMedias(player, medias),
            Space(verticle: 20),
            _previousNext(),
          ],
        ),
      ),
    );
  }

  Widget _previousNext() {
    bool hidePrevious = false;
    bool hideNext = false;
    if (selectedIndex == 0) {
      hidePrevious = true;
    }
    if ((selectedIndex + 1) == chapters.length) {
      hideNext = true;
    }
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
        selectedIndex -= 1;
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
      onPressed: () {
        player.stop();
        selectedIndex += 1;
        setState(() {});
      },
    );
  }
}
