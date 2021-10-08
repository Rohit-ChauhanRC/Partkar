import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../utilities/settings.dart';
import '../utilities/constants.dart';
import 'spacer.dart';

class SongYoutubeMediaPlayer extends StatefulWidget {
  final int index;
  final String url;
  final String title;

  SongYoutubeMediaPlayer(
      {@required this.index, @required this.url, this.title});

  @override
  State<StatefulWidget> createState() {
    return _SongYoutubeMediaPlayerState(index: index, url: url, title: title);
  }
}

class _SongYoutubeMediaPlayerState extends State<SongYoutubeMediaPlayer> {
  ClubColourModeModal colours = Setting().colours();
  final int index;
  final String url;
  final String title;

  _SongYoutubeMediaPlayerState(
      {@required this.index, @required this.url, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _body(),
    );
  }

  Widget _body() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Space(verticle: 10),
            _title(size),
            Space(verticle: 20),
            _player(),
            Space(verticle: 30),
          ],
        ),
      ),
    );
  }

  Widget _title(Size size) {
    return Container(
      width: size.width * 0.95,
      child: Text(
        title ?? 'Song Recording ${index + 1}',
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          color: colours.bodyTextColour(),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _player() {
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: false,
        // hideControls: true,
      ),
    );

    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressColors: ProgressBarColors(
        playedColor: colours.headlineColour(),
        handleColor: colours.headlineColour(),
      ),
      progressIndicatorColor: colours.headlineColour(),
      onReady: () {
        // controller.addListener(listener);
      },
    );
  }
}
