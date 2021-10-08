import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'spacer.dart';
import 'song_audio_media_player.dart';
import 'song_youtube_media_player.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../bloc/audio_player_provider.dart';
import '../modals/song_responses.dart';
import '../resources/data_store.dart';

class SongLyrics extends StatefulWidget {
  final String songName;
  final String lyrics;
  final String capo;
  final String keyWithCapo;
  final String songKey;
  final List<SongMediaModal> songMediaList;
  final AssetsAudioPlayer player;

  SongLyrics({
    @required this.songName,
    @required this.lyrics,
    @required this.capo,
    @required this.keyWithCapo,
    @required this.songKey,
    @required this.songMediaList,
    @required this.player,
  });

  @override
  State<StatefulWidget> createState() {
    return _SongLyricsState(
      lyrics: lyrics,
      songName: songName,
      capo: capo,
      keyWithCapo: keyWithCapo,
      songKey: songKey,
      songMediaList: songMediaList,
      player: player,
    );
  }
}

class _SongLyricsState extends State<SongLyrics> {
  final ClubColourModeModal colours = Setting().colours();
  final String songName;
  final String lyrics;
  final String capo;
  final String keyWithCapo;
  final String songKey;
  final List<SongMediaModal> songMediaList;
  final AssetsAudioPlayer player;
  //bool displayChords = true;

  _SongLyricsState({
    @required this.songName,
    @required this.lyrics,
    @required this.capo,
    @required this.keyWithCapo,
    @required this.songKey,
    @required this.songMediaList,
    @required this.player,
  });

  @override
  Widget build(BuildContext context) {
    // return _uiBuilder();
    return FutureBuilder(
      future: DataStore().getSongToggleState(),
      builder: (_, snapshot) {
        bool status = false;
        if ((snapshot.hasData) && (snapshot.data != null)) {
          status = snapshot.data;
        }
        return _uiBuilder(status);
      },
    );
  }

  Widget _uiBuilder(bool displayChords) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(2, 0, 10, 0),
        margin: EdgeInsets.only(right: 0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Space(verticle: 20),
            _header(displayChords),
            //Space(verticle: 20),
            _capo(displayChords),
            Space(verticle: 10),
            ..._lyrics(displayChords),
            Space(verticle: 50),
            ..._medias(),
            Space(verticle: 50),
          ],
        ),
      ),
    );
  }

  Widget _header(bool displayChords) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              songName,
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_TIMES,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: colours.headlineColour(),
              ),
            ),
          ),
          _chordButton(displayChords),
        ],
      ),
    );
  }

  Widget _chordButton(bool displayChords) {
    double opacity = 1;
    if (!displayChords) opacity = 0.6;
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            'assets/images/icon_guitar_chords.png',
            height: 40,
            width: 40,
            color: colours.bodyTextColour().withOpacity(opacity),
          ),
        ),
        onTap: () {
          //displayChords = !displayChords;
          DataStore().saveSongTogleState(!displayChords);
          setState(() {});
        },
      ),
    );
  }

  Widget _capo(bool displayChords) {
    String text = '';
    if ((capo != null) && (capo != '') && (capo != '0')) {
      text = 'Capo $capo\u2013$keyWithCapo';
    } else {
      if (songKey != null) text = songKey;
    }
    if (!displayChords) text = '';
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 16,
            color: colours.headlineColour(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<Widget> _lyrics(bool displayChords) {
    final lines = lyrics.split('\\n');
    List<String> newLines = [];
    // print('Start parsing');
    int cachedindex = 0;
    for (int i = 0; i < lines.length; i++) {
      final newIndex = int.tryParse(lines[i]) ?? 0;
      if (cachedindex == 0) {
        newLines.add(lines[i]);
      } else {
        final lastIndex = newLines.length - 1;
        final lastData = '${newLines[lastIndex]} ${lines[i]}';
        newLines[lastIndex] = lastData;
      }
      cachedindex = newIndex;
    }
    // print('end parsing');
    return newLines
        .map((line) => _lyricsLine(_processedLyrics(line), displayChords))
        .toList();
  }

  LyricsLineModal _processedLyrics(String line) {
    return LyricsLineModal(lyrics: line, chords: '');
  }

  Widget _lyricsLine(LyricsLineModal line, bool displayChords) {
    //To check if starts with integer
    //print(line.lyrics.startsWith(new RegExp('[0-9]')));
    String lineNumber = '';
    if (line.lyrics.startsWith(new RegExp('[0-9]'))) {
      List<String> lineArr = line.lyrics.split(' ');
      lineNumber = '${lineArr[0]}.';
      lineArr.removeAt(0);
      line.lyrics = lineArr.join(' ');
    }

    bool haveChords = line.lyrics.contains('[');
    if (!displayChords) haveChords = false;
    Widget lineWidget =
        _line(haveChords, line.lyrics, lineNumber, displayChords);
    if (lineWidget == null) return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: lineWidget,
    );
  }

  Widget _line(
      bool haveChords, String line, String lineNumber, bool displayChords) {
    EdgeInsets padding = EdgeInsets.symmetric(vertical: 0);
    double lineSpacing = 1.2;
    if (haveChords) {
      padding = EdgeInsets.fromLTRB(0, 10, 0, 0);
      lineSpacing = 1.4;
    }
    Widget lineText = _lineText(line, lineSpacing, displayChords);
    if (lineText == null) return null;
    return Container(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _lineNumber(lineNumber, lineSpacing),
          Space(horizontal: 5),
          Expanded(child: lineText),
        ],
      ),
    );
  }

  Widget _lineNumber(String lineNumber, double lineSpacing) {
    return Container(
      width: 24,
      child: Text(
        lineNumber,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: 16,
          height: lineSpacing,
          color: colours.bodyTextColour(),
        ),
      ),
    );
  }

  Widget _lineText(String line, double lineSpacing, bool displayChords) {
    String chordCharacters = '';
    bool addChord = false;
    bool smallComment = line.startsWith('#');
    bool largeComment = line.startsWith('##');

    if (!displayChords) {
      if (line.startsWith('#!')) {
        line = '--22--22--';
      }
    }
    line = line
        .replaceAll('#! ', '')
        .replaceAll('# ', '')
        .replaceAll('#!', '')
        .replaceAll('#', '');
    // final List<String> arrChars =
    //     lineNew.replaceAll('# ', '').replaceAll('#', '').split('');
    final List<String> arrChars = line.split('');
    final List<TextSpan> spans = arrChars.map((c) {
      String spanCharacter = c;
      if (c == '[') {
        addChord = true;
      }
      if ((c == '[') || (c == ']')) {
        spanCharacter = '';
      } else {
        if (addChord) {
          chordCharacters += spanCharacter;
        }
      }
      if (c == ']') {
        addChord = false;
      }

      String chordCharacter;

      if ((chordCharacters.length > 0) && (!addChord)) {
        chordCharacter = chordCharacters;
      }

      if (addChord) spanCharacter = '';

      var textSpan = _characterSpan(spanCharacter, chordCharacter, lineSpacing,
          smallComment, largeComment, displayChords);

      if ((chordCharacters.length > 0) && (!addChord)) chordCharacters = '';

      return textSpan;
    }).toList();
    if (line == '--22--22--') {
      return null;
    }
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        text: '',
        children: spans,
      ),
    );
  }

  TextSpan _characterSpan(String text, String chord, double lineSpacing,
      bool smallComment, bool largeComment, bool displayChords) {
    double fontSize = 16;
    FontWeight fontWeight = FontWeight.normal;
    FontStyle fontStyle = FontStyle.normal;
    if (smallComment) {
      fontSize = 15;
      fontStyle = FontStyle.italic;
    }
    if (largeComment) {
      fontSize = 16;
      fontStyle = FontStyle.italic;
      fontWeight = FontWeight.bold;
    }
    return TextSpan(
      text: text,
      children: [
        _chord(chord, lineSpacing, displayChords),
      ],
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: fontSize,
        height: lineSpacing,
        letterSpacing: 0.2,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        color: colours.bodyTextColour(),
      ),
    );
  }

  WidgetSpan _chord(String chord, double lineSpacing, bool displayChords) {
    return displayChords
        ? WidgetSpan(
            child: Container(
              child: CustomPaint(
                size: Size(0, 0),
                painter: TheChord(
                  text: chord,
                  lineSpacing: lineSpacing,
                  colour: colours.headlineColour(),
                ),
              ),
            ),
          )
        : WidgetSpan(child: Container(width: 0));
  }

  List<Widget> _medias() {
    List<Widget> medias = [];
    if (songMediaList != null) {
      // for (SongMediaModal media in songMediaList) {
      // SongAudioMediaPlayer audioMediaPlayer =
      //     SongAudioMediaPlayer(mediaUrl: media.mediaUrl);

      // medias.add(audioMediaPlayer);
      // }
      for (int i = 0; i < songMediaList.length; i++) {
        String mediaUrl = songMediaList[i].mediaUrl;
        if (mediaUrl.endsWith('.mp3')) {
          SongAudioMediaPlayer audioMediaPlayer = SongAudioMediaPlayer(
            player: player,
            index: i,
            mediaUrl: mediaUrl,
            playPressed: () {},
            title: songMediaList[i].title,
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
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//Lyric Line Modal

class LyricsLineModal {
  String lyrics;
  String chords;

  LyricsLineModal({@required this.chords, @required this.lyrics});
}

//
// The Chord

class TheChord extends CustomPainter {
  final String text;
  final double lineSpacing;
  final Color colour;

  TheChord(
      {@required this.text, @required this.lineSpacing, @required this.colour});

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      fontFamily: Constants.FONT_FAMILY_FUTURA,
      fontSize: 14,
      height: lineSpacing,
      fontWeight: FontWeight.w700,
      color: colour,
    );
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      //maxWidth: 40, //size.width,
    );
    final offset = Offset(0, -37);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
