import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../bloc/audio_player_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/podcast_responses.dart';
import '../widgets/audio_player.dart';
import '../widgets/youtube_player.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import 'navigation_drawer.dart';

class PodcastPlayerScreen extends StatefulWidget {
  final PodcastModal podcast;
  final String title;
  final String titleImage;

  PodcastPlayerScreen(
      {@required this.podcast,
      @required this.title,
      @required this.titleImage});

  @override
  State<StatefulWidget> createState() {
    return _PodcastPlayerScreenState(
        podcast: podcast, title: title, titleImage: titleImage);
  }
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  final ClubColourModeModal colours = Setting().colours();
  final PodcastModal podcast;
  final String title;
  final String titleImage;
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  _PodcastPlayerScreenState(
      {@required this.podcast,
      @required this.title,
      @required this.titleImage});

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
        body: _body(context),
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

  Widget _body(BuildContext context) {
    if (podcast.mediaUrl.contains('www.youtube.com')) {
      return YoutubePlayerWidget(
        podcast: podcast,
        titleImage: titleImage,
        libraryName: title,
      );
    }
    return AudioPlayeProvider(
        child: AudioPlayerWidget(
      player: player,
      podcast: podcast,
      titleImage: titleImage,
      libraryName: title,
    ));
  }
}
