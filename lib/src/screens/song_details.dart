import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../modals/song_responses.dart';
import '../bloc/song_provider.dart';
import '../bloc/general_provider.dart';
import '../widgets/song_lyrics.dart';
import '../widgets/alert.dart';
import '../modals/error_response.dart';
import '../utilities/settings.dart';
import '../utilities/constants.dart';
import 'navigation_drawer.dart';

class SongDetailScreen extends StatefulWidget {
  final String songId;
  final String title;
  final SongBloc songBloc;
  final String songName;

  SongDetailScreen(
      {@required this.songId,
      @required this.title,
      @required this.songBloc,
      this.songName});

  @override
  State<StatefulWidget> createState() {
    return _SongDetailScreenState(
        songId: songId, title: title, songBloc: songBloc, songName: songName);
  }
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  final ClubColourModeModal colours = Setting().colours();
  final String songId;
  final String title;
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  final String songName;
  SongBloc songBloc;

  _SongDetailScreenState(
      {@required this.songId,
      @required this.title,
      @required this.songBloc,
      this.songName});

  Future<bool> _opPop() async {
    // print('Podcast Player POP');
    player.stop();
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (songBloc == null) {
      songBloc = SongProvider.of(context);
    }
    return WillPopScope(
      child: Scaffold(
        appBar: _appBar(),
        body: _viewBuilder(),
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

  Widget _viewBuilder() {
    return FutureBuilder(
      future: songBloc.fetchSongDetails(songId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // if (snapshot.hasData) {
          final data = snapshot.data;
          if (data is ErrorResponseModel) {
            Alert.defaultAlert(context, 'Error', data.message);
          } else if (data is SongDetailModal) {
            String name = songName ?? data.songName;
            return SongLyrics(
              songName: name,
              lyrics: data.songText
                  .replaceAll('---', '\u2014')
//				  .replaceAll("'T", '\u2019T')
//				  .replaceAll("'t", '\u2019t')
//				  .replaceAll(" '", ' \u2018')
//				  .replaceAll("\n'", "\n".'\u2018')
//				  .replaceAll("'", '\u2019')
//				  .replaceAll(' "', ' \u201c')
//				  .replaceAll("\n".'"', "\n".'\u201c')
//				  .replaceAll('" ', '\u201d ')
//				  .replaceAll('"'."\n", '\u201d'."\n")
//				  .replaceAll(',"', ',\u201d')
//				  .replaceAll('."', '.\u201d')
//				  .replaceAll('";', '\u201d;')
                  .replaceAll('_ ', '\u203F'), // This does not work!
              capo: data.capo,
              keyWithCapo: data.keyWithCapo,
              songKey: data.songKey,
              songMediaList: data.media,
              player: player,
            );
          }
          return Center(child: reloadButton());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget reloadButton() {
    return ElevatedButton(
      child: Text(
        'Reload',
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          color: colours.bgColour(),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: colours.accentColour(),
      ),
      onPressed: () async {
        setState(() {});
      },
    );
  }
}
