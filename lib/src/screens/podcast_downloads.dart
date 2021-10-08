import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:share/share.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../widgets/spacer.dart';
import '../bloc/general_provider.dart';
import 'navigation_drawer.dart';

class PodcastDownloadsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PodcastDownloadsScreenState();
  }
}

class _PodcastDownloadsScreenState extends State<PodcastDownloadsScreen> {
  final ClubColourModeModal colours = Setting().colours();
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  FileSystemEntity _playingFile;
  Duration totalDuration;

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
        'Podcast Downloads',
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
    // _content();
    return FutureBuilder(
      future: _content(),
      builder: (cntxt, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        if (snapshot.hasData) {
          return _fileList(snapshot.data);
        }
        return Container();
      },
    );
  }

  Future<List<FileSystemEntity>> _content() async {
    Directory dir = await _getDownloadDirectory();
    final intermediatePath = 'agape_podcast/';
    final dirPath = path.join(dir.path, intermediatePath);
    Directory dr = Directory(dirPath);
    List<FileSystemEntity> files = dr.listSync();
    // print(files);
    return files;
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Widget _fileList(List<FileSystemEntity> files) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (cntxt, index) {
        FileSystemEntity file = files[index];
        return _listItem(file);
      },
    );
  }

  Widget _listItem(FileSystemEntity file) {
    return Card(
      color: colours.bgColour(),
      child: Column(
        children: [
          ListTile(
            title: Text(
              file.path.split('/').last,
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 16,
                color: colours.bodyTextColour(),
              ),
            ),
            leading: _playButton(file),
            trailing: _dotButton(file),
          ),
          _slider(file),
          _totalTime(),
        ],
      ),
    );
  }

  void _play(String file) async {
    try {
      // print('MAKING PLAYER PLAY');
      await player.open(
        Audio.file(file),
        autoStart: true,
        showNotification: true,
        volume: 1.0,
      );
    } catch (t) {
      print('mp3 unreachable');
      print(t);
    }
  }

  Widget _playButton(FileSystemEntity file) {
    return StreamBuilder(
      stream: player.isPlaying,
      builder: (cntxt, AsyncSnapshot<bool> snapshot) {
        // print('Play snapshot');
        // print(snapshot.data);
        IconData iconData = Icons.play_arrow_rounded;
        bool isPlaying = snapshot.data;
        if (snapshot.hasData) {
          if (file == _playingFile) {
            iconData =
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded;
          }
        }
        return IconButton(
          icon: Icon(iconData, color: colours.headlineColour(), size: 40),
          splashColor: Colors.transparent,
          onPressed: () async {
            // print('Play pressed');
            // print(snapshot.data);
            if (snapshot.hasData) {
              if (isPlaying) {
                await player.stop();
                if (_playingFile != file) {
                  _playingFile = file;
                  _play(file.path);
                }
              } else {
                _playingFile = file;
                _play(file.path);
              }
            }
          },
        );
      },
    );
  }

  Widget _dotButton(FileSystemEntity file) {
    return IconButton(
      icon: Icon(Icons.more_vert, color: colours.headlineColour()),
      onPressed: () {
        _popup(file);
      },
    );
  }

  Widget _slider(FileSystemEntity file) {
    return StreamBuilder(
      stream: player.currentPosition,
      builder: (cntxt, snapshot) {
        if (file != _playingFile) {
          return Container();
        }
        double currentValue = 0.0;
        // print(snapshot.data);
        // print('total: $totalDuration');
        if ((snapshot.hasData) && (totalDuration != null)) {
          currentValue = snapshot.data.inSeconds / totalDuration.inSeconds;
        }
        // print('then current: $currentValue');
        if (currentValue.isNaN) {
          // print('current is nan');
          currentValue = 0.0;
        }
        // print('THE Current: $currentValue');
        return Slider(
          value: currentValue,
          min: 0.0,
          max: 1.0,
          activeColor: colours.headlineColour(),
          inactiveColor: Colors.grey[350],
          onChangeEnd: (double value) {
            // print('END Value: $value');
          },
          onChanged: (double value) {},
        );
      },
    );
  }

  Widget _totalTime() {
    //player.realtimePlayingInfos
    // return Text('10:20', style: style);
    // print('Total time');
    return StreamBuilder(
      stream: player.realtimePlayingInfos,
      builder: (cntxt, AsyncSnapshot<RealtimePlayingInfos> snapshot) {
        //String totalTime = '00:00';
        // print('Total time 2');
        if (snapshot.hasData) {
          Duration data = snapshot.data.duration;
          totalDuration = data;
          // print('Setting Total time: $data');
          // String hh = data.inHours.toString().padLeft(2, '0');
          // String mm = data.inMinutes.toString().padLeft(2, '0');
          // String ss = (data.inSeconds % 60).toString().padLeft(2, '0');
          // totalTime = '$hh:$mm:$ss';
        }
        //return Text(totalTime);
        return Container();
      },
    );
  }

  void _popup(FileSystemEntity file) {
    showDialog(
      context: context,
      builder: (BuildContext cntxt) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: colours.bgColour(),
          content: Container(
            height: 200,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                Space(verticle: 20),
                _optionDelete(file),
                Space(verticle: 15),
                _optionShare(file),
                Space(verticle: 20),
                _cancelButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _title() {
    return Text(
      'Options',
      style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colours.bodyTextColour()),
    );
  }

  Widget _optionDelete(FileSystemEntity file) {
    final IconData icon = Icons.delete_outline_rounded;
    return GestureDetector(
      child: Row(
        children: [
          Icon(icon, color: colours.headlineColour()),
          Space(horizontal: 5),
          Text(
            'Delete',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
      onTap: () async {
        await file.delete();
        _closePopup();
        setState(() {});
      },
    );
  }

  Widget _optionShare(FileSystemEntity file) {
    final IconData icon = Icons.share_rounded;
    return GestureDetector(
      child: Row(
        children: [
          Icon(icon, color: colours.headlineColour()),
          Space(horizontal: 5),
          Text(
            'Share',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
      onTap: () async {
        Share.shareFiles([file.path],
            text: file.path.split('/').last, subject: 'Partaker CCA Podcast');
        _closePopup();
      },
    );
  }

  Widget _cancelButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          _closePopup();
        },
        child: Text(
          'Cancel',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 18,
            color: colours.bgColour(),
          ),
        ),
      ),
    );
  }

  void _closePopup() {
    Navigator.pop(context);
  }
}
