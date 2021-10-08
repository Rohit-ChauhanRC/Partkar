import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import '../utilities/settings.dart';
import '../utilities/constants.dart';
import '../modals/podcast_responses.dart';
import 'spacer.dart';

class YoutubePlayerWidget extends StatefulWidget {
  //final AssetsAudioPlayer player;
  final PodcastModal podcast;
  final String titleImage;
  final String libraryName;

  YoutubePlayerWidget(
      {@required this.podcast,
      @required this.titleImage,
      @required this.libraryName});

  @override
  State<StatefulWidget> createState() {
    return _YoutubePlayerWidgetWidgetState(
        podcast: podcast, titleImage: titleImage, libraryName: libraryName);
  }
}

class _YoutubePlayerWidgetWidgetState extends State<YoutubePlayerWidget> {
  ClubColourModeModal colours = Setting().colours();
  final PodcastModal podcast;
  final String titleImage;
  final String libraryName;
  Duration totalDuration;

  // YoutubePlayerController controller = YoutubePlayerController(
  //       initialVideoId: YoutubePlayer.convertUrlToId(podcast.mediaUrl));

  _YoutubePlayerWidgetWidgetState(
      {@required this.podcast,
      @required this.titleImage,
      @required this.libraryName});

  @override
  Widget build(BuildContext context) {
    colours = Setting().colours();
    return _body(context);
  }

  Widget _body(BuildContext context) {
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(podcast.mediaUrl),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: false,
        // hideControls: true,
      ),
    );

    Size size = MediaQuery.of(context).size;
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        // bottomActions: [ElevatedButton(onPressed: () {}, child: Text('play'))],
        showVideoProgressIndicator: true,
        progressColors: ProgressBarColors(
          playedColor: colours.headlineColour(),
          handleColor: colours.headlineColour(),
        ),
        progressIndicatorColor: colours.headlineColour(),
      ),
      builder: (cntxt, player) {
        return SingleChildScrollView(
          child: Column(
            children: [
              player,
              Space(verticle: 20),
              _title(size),
              Space(verticle: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     controller.play();

              //   },
              //   child: Text('play'),
              // ),
              _downloadSection(size),
            ],
          ),
        );
      },
    );
  }

  Widget _title(Size size) {
    String info = '';
    if (podcast.podcastDate != '') {
      info += _dateString(podcast.podcastDate);
    }
    if (podcast.speaker != '') {
      info += ' \u2022 ${podcast.speaker}';
    }
    if (podcast.length != '') {
      info += ' \u2022 ${podcast.length} min';
    }
    return Container(
      width: size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Space(verticle: 10),
          Text(
            podcast.title,
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              color: colours.bodyTextColour(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Space(verticle: 10),
          Text(
            // '${podcast.podcastDate} ● ${podcast.speaker} ● ${podcast.length} min',
            info,
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              color: colours.bodyTextColour(),
              fontSize: 14,
              //fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _dateString(String date) {
    // Input date Format
    final givenFormat = DateFormat("yyyy-MM-dd");
    DateTime givenDate = givenFormat.parse(date);
    final DateFormat newFormat = DateFormat('MMMM dd, yyyy');
    // Output Date Format
    final String formattedDate = newFormat.format(givenDate);
    return formattedDate;
  }

  Widget _downloadSection(Size size) {
    return Container(
      height: 120,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _roundButton('Share', Icons.share_rounded, () {
            Share.share(
                '$libraryName - ${podcast.title}     ${podcast.mediaUrl}',
                subject: 'Partaker CCA Podcast');
          })
        ],
      ),
    );
  }

  Widget _roundButton(String text, IconData icon, Function onPressed) {
    return Column(
      children: [
        TextButton(
          onPressed: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // color: colours.headlineColour().withOpacity(0.1),
                  color: colours.gradientEndColour(),
                ),
              ),
              Icon(icon, size: 30, color: colours.headlineColour()),
            ],
          ),
        ),
        Text(text),
      ],
    );
  }
}
