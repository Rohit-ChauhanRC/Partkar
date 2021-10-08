import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../bloc/bible_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/bible_responses.dart';
import '../widgets/spacer.dart';
import '../widgets/bible_verse_reading.dart';
import '../widgets/alert.dart';
import '../widgets/loader.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import 'navigation_drawer.dart';

class NotificationBibleChapterScreen extends StatefulWidget {
  final int chapterId;
  final String title;

  NotificationBibleChapterScreen(
      {@required this.chapterId, @required this.title});

  @override
  State<NotificationBibleChapterScreen> createState() {
    return _NotificationBibleChapterState(chapterId: chapterId, title: title);
  }
}

class _NotificationBibleChapterState
    extends State<NotificationBibleChapterScreen> {
  final ClubColourModeModal colours = Setting().colours();
  final int chapterId;
  final String title;
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  BibleChapterDetailModal chapter;

  _NotificationBibleChapterState(
      {@required this.chapterId, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _uiBuilder(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  Widget _appBar() {
    return AppBar(
      leading: _backButton(),
      title: Text(
        title,
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
    // print('Printing chapter');
    // print(chapter);
    //fetchChapterDetail();
    if (chapter == null) {
      return _uiBuilderAndFetch(context);
    } else {
      return _chapterDetails(chapter.chapterReadings, chapter.medias);
    }
  }

  void fetchChapterDetail() async {
    final BibleBloc bibleBloc = BibleProvider.of(context);
    Loader.showLoading(context);
    var res = await bibleBloc.fetchChapterDetails(chapterId);
    Navigator.pop(context);
    if (res.status) {
      chapter = res.data;
      //setState(() {});
    }
    Alert.defaultAlert(context, 'Error', 'Error while loading data.');
  }

  Widget _uiBuilderAndFetch(BuildContext context) {
    final BibleBloc bibleBloc = BibleProvider.of(context);
    return FutureBuilder(
      future: bibleBloc.fetchChapterDetails(chapterId),
      builder: (chapterContext, snapshot) {
        //if (snapshot.hasData) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data;
          if (data.status) {
            chapter = data.data;
            //setState(() {});
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
    final chapterName = chapter == null ? '' : chapter.chapter.name;
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Space(verticle: 20),
            chapterHeading(chapterName, colours),
            Space(verticle: 20),
            ...chapterReadings(readings, colours),
            Space(verticle: 20),
            ...readingMedias(player, medias),
            Space(verticle: 50),
          ],
        ),
      ),
    );
  }
}
