import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:share/share.dart';
import 'package:path/path.dart' as path;
import 'dart:math' as math;
import 'dart:convert';
import 'dart:io';
import '../bloc/audio_player_provider.dart';
import '../utilities/settings.dart';
import '../utilities/constants.dart';
import '../widgets/audio_play_speed_controller.dart';
import '../modals/podcast_responses.dart';
import '../widgets/alert.dart';
import '../resources/data_store.dart';
import '../screens/podcast_downloads.dart';
import 'spacer.dart';

//https://stackoverflow.com/questions/40992480/getting-a-soundcloud-api-client-id
//https://github.com/lotekbard/flutter-file-download-example/blob/master/lib/main.dart

class AudioPlayerWidget extends StatefulWidget {
  final AssetsAudioPlayer player;
  final PodcastModal podcast;
  final String titleImage;
  final String libraryName;

  AudioPlayerWidget({
    @required this.player,
    @required this.podcast,
    @required this.titleImage,
    @required this.libraryName,
  });

  @override
  State<StatefulWidget> createState() {
    return _AudioPlayerWidgetState(
      player: player,
      podcast: podcast,
      titleImage: titleImage,
      libraryName: libraryName,
    );
  }
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  ClubColourModeModal colours = Setting().colours();
  final AssetsAudioPlayer player; // = AssetsAudioPlayer();
  final PodcastModal podcast;
  final String titleImage;
  final String libraryName;
  final Dio _dio = Dio();
  Duration totalDuration;
  bool _downloading = false;
  bool _isDownloaded = false;

  _AudioPlayerWidgetState({
    @required this.player,
    @required this.podcast,
    @required this.titleImage,
    @required this.libraryName,
  });

  @override
  Widget build(BuildContext context) {
    AudioPlayerBloc audioPlayerBloc = AudioPlayeProvider.of(context);
    colours = Setting().colours();
    // _player();
    // return _body(context, audioPlayerBloc);
    return FutureBuilder(
      future: _content(),
      builder: (cntxt, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
        String filepath = '';
        if (snapshot.hasData) {
          List<FileSystemEntity> files = snapshot.data;
          for (FileSystemEntity file in files) {
            if (file.path.split('/').last ==
                '$libraryName - ${podcast.title}.${file.path.split('.').last}') {
              filepath = file.path;
              _isDownloaded = true;
            }
          }
        }
        _player(filepath);
        return _body(context, audioPlayerBloc);
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

  void _player(String filePath) async {
    try {
      // print('MAKING PLAYER PLAY');
      await player.open(
        filePath == '' ? Audio.network(podcast.mediaUrl) : Audio.file(filePath),
        autoStart: false,
        showNotification: true,
        volume: 1.0,
        // playSpeed: 1.3,
      );
    } catch (t) {
      //mp3 unreachable
      print('mp3 unreachable');
      print(t);
    }
  }

  Widget _body(BuildContext context, AudioPlayerBloc audioPlayerBloc) {
    //_player();
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Space(verticle: 2),
            _image(size),
            Space(verticle: 10),
            _title(size),
            //Space(verticle: 20),
            _bufferLoader(),
            _seekBar(size),
            Space(verticle: 0),
            _playerControls(size, audioPlayerBloc),
            Space(verticle: 20),
            _downloadSection(size, audioPlayerBloc),
            _downloadProgressBar(audioPlayerBloc),
            Space(verticle: 10),
            _downloadsButton(),
          ],
        ),
      ),
    );
  }

  Widget _image(Size size) {
    return Container(
      height: size.width * 0.32,
      width: size.width * 0.8,
      child: Image.network(titleImage, fit: BoxFit.cover),
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
      width: size.width * 0.7,
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

  Widget _bufferLoader() {
    return StreamBuilder(
      stream: player.isBuffering,
      builder: (cntxt, AsyncSnapshot<bool> snapshot) {
        if ((snapshot.hasData) && (snapshot.data)) {
          return Container(
            height: 30,
            width: 30,
            //padding: EdgeInsets.all(8),
            // child: Center(
            //     child: CircularProgressIndicator(
            //         valueColor: AlwaysStoppedAnimation<Color>(
            //             colours.bodyTextColour()))),
            child: CupertinoActivityIndicator(animating: true, radius: 15),
          );
        }
        return Container(height: 30);
      },
    );
  }

  Widget _seekBar(Size size) {
    TextStyle style = TextStyle(
      fontFamily: Constants.FONT_FAMILY_FUTURA,
      color: colours.headlineColour(),
      fontSize: 14,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          _currentTime(style),
          Expanded(child: _slider()),
          _totalTime(style),
        ],
      ),
    );
  }

  Widget _currentTime(TextStyle style) {
    return StreamBuilder(
      stream: player.currentPosition,
      builder: (cntxt, AsyncSnapshot<Duration> snapshot) {
        String currentTime = '00:00';
        if (snapshot.hasData) {
          Duration data = snapshot.data;
          String hh = data.inHours.toString().padLeft(2, '0');
          String mm = data.inMinutes.toString().padLeft(2, '0');
          String ss = (data.inSeconds % 60).toString().padLeft(2, '0');
          currentTime = '$hh:$mm:$ss';
        }
        return Text(currentTime, style: style);
      },
    );
  }

  Widget _slider() {
    return StreamBuilder(
      stream: player.currentPosition,
      builder: (cntxt, snapshot) {
        double currentValue = 0.0;
        if ((snapshot.hasData) && (totalDuration != null)) {
          currentValue = snapshot.data.inSeconds / totalDuration.inSeconds;
        }
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

  Widget _totalTime(TextStyle style) {
    //player.realtimePlayingInfos
    // return Text('10:20', style: style);
    return StreamBuilder(
      stream: player.realtimePlayingInfos,
      builder: (cntxt, AsyncSnapshot<RealtimePlayingInfos> snapshot) {
        String totalTime = '00:00';
        if (snapshot.hasData) {
          Duration data = snapshot.data.duration;
          totalDuration = data;
          String hh = data.inHours.toString().padLeft(2, '0');
          String mm = data.inMinutes.toString().padLeft(2, '0');
          String ss = (data.inSeconds % 60).toString().padLeft(2, '0');
          totalTime = '$hh:$mm:$ss';
        }
        return Text(totalTime, style: style);
      },
    );
  }

  Widget _playerControls(Size size, AudioPlayerBloc bloc) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      decoration: _decoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _playSpeed(context, bloc),
          _playControls(size),
          SizedBox(
            height: 40,
            width: 60,
            // child: IconButton(
            //   icon: Icon(Icons.more_vert, color: colours.headlineColour()),
            //   onPressed: () {},
            // ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      gradient: new LinearGradient(
        colors: [
          colours.gradientStartColour(),
          colours.gradientEndColour(),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
        //tileMode: TileMode.clamp,
      ),
    );
  }

  Widget _playSpeed(BuildContext context, AudioPlayerBloc bloc) {
    return AudioPlaySpeedControllerWidget(
        player: player, parentContext: context, bloc: bloc);
  }

  Widget _playControls(Size size) {
    return Container(
      padding: EdgeInsets.only(bottom: 12, top: 10),
      child: Row(
        children: [
          _replayButton(),
          Space(horizontal: 20),
          _playButton(),
          Space(horizontal: 20),
          _forwardButton(),
        ],
      ),
    );
  }

  Widget _playButton() {
    return StreamBuilder(
      stream: player.isPlaying,
      builder: (cntxt, snapshot) {
        // print('Play snapshot');
        // print(snapshot.data);
        IconData iconData = Icons.play_arrow_rounded;
        if (snapshot.hasData) {
          iconData = snapshot.data ? Icons.pause : Icons.play_arrow_rounded;
        }
        return IconButton(
          icon: Icon(iconData, color: colours.headlineColour(), size: 40),
          splashColor: Colors.transparent,
          //splashRadius: 0,
          onPressed: () async {
            bool playOnData =
                await DataStore().getMobileDataStatusForAudioPodcasts();
            var connectivityResult = await (Connectivity().checkConnectivity());
            // print(connectivityResult);
            if ((connectivityResult == ConnectivityResult.mobile) &&
                !playOnData) {
              Alert.defaultAlert(context, 'Warning',
                  'You chose not to play audio podcasts on mobile data');
              return;
            }
            // print('Play pressed');
            // print(snapshot.data);
            if (snapshot.hasData) {
              snapshot.data ? player.pause() : player.play();
            }
          },
        );
      },
    );
  }

  Widget _replayButton() {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.replay,
            size: 45,
            color: colours.headlineColour(),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              '15',
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 12,
                color: colours.headlineColour(),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        player.seekBy(Duration(seconds: -15));
      },
    );
  }

  Widget _forwardButton() {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Icon(
              Icons.replay,
              size: 45,
              color: colours.headlineColour(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              '15',
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 12,
                color: colours.headlineColour(),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        player.seekBy(Duration(seconds: 15));
      },
    );
  }

  Widget _downloadSection(Size size, AudioPlayerBloc audioPlayerBloc) {
    return Container(
      height: 120,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isDownloaded
              ? _roundButton('Downloaded', Icons.download_done_rounded, () {})
              : _roundButton('Download', Icons.download_rounded, () {
                  // print('Download pressed');
                  _downloadFile(podcast.mediaUrl, audioPlayerBloc);
                  _downloading = true;
                  audioPlayerBloc.changeProgressStatus(0);
                }),
          Space(horizontal: 40),
          _roundButton('Share', Icons.share_rounded, () {
            Share.share(
                '$libraryName - ${podcast.title}    ${podcast.mediaUrl}',
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

  Widget _downloadProgressBar(AudioPlayerBloc audioPlayerBloc) {
    return StreamBuilder(
      stream: audioPlayerBloc.progressStatus,
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          double progress = snapshot.data;
          if (progress > 0 || _downloading) {
            String downloadText = 'Downloading';
            if (progress >= 1) {
              downloadText = 'Download Complete';
            }
            return Column(
              children: [
                Text(
                  downloadText,
                  style: TextStyle(
                    color: colours.headlineColour(),
                    fontFamily: Constants.FONT_FAMILY_FUTURA,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                ),
                Space(verticle: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[400],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colours.headlineColour()),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _downloadsButton() {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => PodcastDownloadsScreen()));
        },
        child: Text(
          'Go to downloads',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: colours.bodyTextColour(),
          ),
        ),
      ),
    );
  }

  void _downloadFile(String fileUrl, AudioPlayerBloc audioPlayerBloc) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      // print('PErmisson');
      // final fileName = fileUrl.split('/').last;
      final ext = fileUrl.split('.').last;
      String fileName = '$libraryName - ${podcast.title}.$ext';
      final intermediatePath = 'agape_podcast/';
      final savePath = path.join(dir.path, intermediatePath + fileName);
      await _startDownload(savePath, fileUrl, audioPlayerBloc);
    } else {
      print('no PErmisson');
      // handle the scenario when user declines the permissions
    }
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

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;

    if (!permission.isGranted) {
      await Permission.storage.request();
      permission = await Permission.storage.status;
    }

    return permission == PermissionStatus.granted;
  }

  Future<void> _startDownload(
      String savePath, String fileUrl, AudioPlayerBloc audioPlayerBloc) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    // print('start download');
    try {
      final response = await _dio.download(fileUrl, savePath,
          onReceiveProgress: (int received, int total) {
        _onReceiveProgress(received, total, audioPlayerBloc);
      });
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
      print('Catch $ex');
    } finally {
      print('Finally');
      await _showNotification(result);
    }
  }

  void _onReceiveProgress(
      int received, int total, AudioPlayerBloc audioPlayerBloc) {
    // if (total != -1) {
    //   setState(() {
    //     _progress = (received / total * 100).toStringAsFixed(0) + "%";
    //   });
    // }
    double progress = received / total;
    print('progress: $progress');
    audioPlayerBloc.changeProgressStatus(progress);
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await FlutterLocalNotificationsPlugin().show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }
}

/**
 * //https://soundcloud.com/hitobias/dearest-lord-you--ve-called-us
 * //https://podcasts.agapecca.org/media/2021-03-09-5._Singing.mp3
//https://podcasts.agapecca.org/media/2021-03-09-Bible-reading-NT090-Luke-5-17_39.mp3
  void _player() async {
    try {
      await player.open(
        Audio.network(
            "https://podcasts.agapecca.org/media/2021-03-09-5._Singing.mp3"),
        autoStart: true,
      );
    } catch (t) {
      //mp3 unreachable
      print('mp3 unreachable');
      print(t);
    }
  }
 */
