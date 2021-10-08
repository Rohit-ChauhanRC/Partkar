import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../modals/bible_responses.dart';
import '../bloc/audio_player_provider.dart';
import 'spacer.dart';
import 'song_audio_media_player.dart';
import 'song_youtube_media_player.dart';

Widget chapterHeading(String heading, ClubColourModeModal colours) {
  return Text(
    heading.replaceAll('-', '\u2013'),
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: Constants.FONT_FAMILY_TIMES,
      color: colours.bodyTextColour(),
    ),
  );
}

List<Widget> chapterReadings(
    List<BibleChapterReadingModal> readings, ClubColourModeModal colours) {
  List<Widget> readingWidgets = [];
  for (int i = 0; i < readings.length; i++) {
    readingWidgets.add(_chapterReading(readings[i], i, colours));
    readingWidgets.add(Space(verticle: 10));
  }
  return readingWidgets;
}

Widget _chapterReading(
    BibleChapterReadingModal reading, int index, ClubColourModeModal colours) {
  String ref = verseRef(reading.verseRef, index).replaceAll('-', '\u2013');
  // String text = verseText('${reading.text} [and this]', index);
  String text = verseText(reading.text, index);
  return Html(
    data: '<p><b>$ref</b> $text</p>',
    shrinkWrap: true,
    style: {
      'b': Style(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: FontSize(16),
        fontWeight: FontWeight.w400,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        color: colours.bodyTextColour(),
      ),
      'i': Style(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: FontSize(16),
        fontWeight: FontWeight.w600,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        fontStyle: FontStyle.italic,
        color: colours.bodyTextColour(),
      ),
      'p': Style(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: FontSize(16),
        fontWeight: FontWeight.w200,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        color: colours.bodyTextColour(),
      ),
      'a': Style(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: FontSize(16),
        fontWeight: FontWeight.w700,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        color: colours.headlineColour(),
      ),
      'html': Style(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        color: colours.bodyTextColour(),
      ),
      'body': Style(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        color: colours.bodyTextColour(),
      ),
      'div': Style(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        color: colours.bodyTextColour(),
      ),
    },
  );
}

String verseRef(String ref, int index) {
  if (index == 0) return ref;
  return ref.split(' ').last;
}

String verseText(String readingText, int index) {
  return readingText
      .replaceAll('[', '<i>')
      .replaceAll(']', '</i>')
      .replaceAll("'", '\u2019')
      .replaceAll('  ', ' ')
      .replaceAll(' "', ' \u201c')
      .replaceAll('" ', '\u201d ')
      .replaceAll(',"', ',\u201d')
      .replaceAll('."', '.\u201d')
      .replaceAll('";', '\u201d;')
      .replaceAll('--', '\u2014');
}

List<Widget> readingMedias(
    AssetsAudioPlayer player, List<String> songMediaList) {
  List<Widget> medias = [];
  if (songMediaList != null) {
    for (int i = 0; i < songMediaList.length; i++) {
      String mediaUrl = songMediaList[i];
      if (mediaUrl.endsWith('.mp3')) {
        SongAudioMediaPlayer audioMediaPlayer = SongAudioMediaPlayer(
          player: player,
          index: i,
          mediaUrl: mediaUrl,
          title: 'Audio Bible',
          playPressed: () {},
        );

        medias.add(AudioPlayeProvider(child: audioMediaPlayer));
      } else if (mediaUrl.contains('youtube.com')) {
        medias.add(SongYoutubeMediaPlayer(
          index: i,
          url: mediaUrl,
        ));
      }
    }
  }
  return medias;
}
