import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:math' as math;
import 'spacer.dart';
import 'audio_play_speed_controller.dart';
import '../bloc/audio_player_provider.dart';
import '../utilities/settings.dart';
import '../utilities/constants.dart';

class SongAudioMediaPlayer extends StatefulWidget {
  final AssetsAudioPlayer player;
  final int index;
  final String mediaUrl;
  final String title;
  final Function playPressed;

  SongAudioMediaPlayer({
    @required this.player,
    @required this.index,
    @required this.mediaUrl,
    @required this.playPressed,
    this.title,
  });

  @override
  State<StatefulWidget> createState() {
    return _SongAudioMediaPlayerState(
      player: player,
      index: index,
      mediaUrl: mediaUrl,
      playPressed: playPressed,
      title: title,
    );
  }
}

class _SongAudioMediaPlayerState extends State<SongAudioMediaPlayer> {
  ClubColourModeModal colours = Setting().colours();
  final AssetsAudioPlayer player;
  final int index;
  final String mediaUrl;
  final Function playPressed;
  final String title;
  Duration totalDuration;

  _SongAudioMediaPlayerState({
    @required this.player,
    @required this.index,
    @required this.mediaUrl,
    @required this.playPressed,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    _player();
    return _body();
  }

  Widget _body() {
    AudioPlayerBloc audioPlayerBloc = AudioPlayeProvider.of(context);
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
            //Space(verticle: 20),
            _bufferLoader(),
            _seekBar(size),
            Space(verticle: 0),
            _playerControls(size, audioPlayerBloc),
            Space(verticle: 50),
          ],
        ),
      ),
    );
  }

  void _player() async {
    try {
      // print('MAKING PLAYER PLAY');
      await player.open(
        Audio.network(mediaUrl),
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

  Widget _title(Size size) {
    return Container(
      width: size.width * 0.7,
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

  Widget _bufferLoader() {
    return StreamBuilder(
      stream: player.isBuffering,
      builder: (cntxt, AsyncSnapshot<bool> snapshot) {
        if ((snapshot.hasData) && (snapshot.data)) {
          return Container(
            height: 30,
            width: 30,
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
            // bool playOnData =
            //     await DataStore().getMobileDataStatusForAudioPodcasts();
            // var connectivityResult = await (Connectivity().checkConnectivity());
            // print(connectivityResult);
            // if ((connectivityResult == ConnectivityResult.mobile) &&
            //     !playOnData) {
            //   Alert.defaultAlert(context, 'Warning',
            //       'You chose not to play audio podcasts on mobile data');
            //   return;
            // }
            await player.stop();
            // print('Play pressed');
            playPressed();
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
}
