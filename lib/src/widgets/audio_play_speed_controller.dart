import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../bloc/audio_player_provider.dart';
import '../utilities/settings.dart';
import '../utilities/constants.dart';
import 'spacer.dart';

class AudioPlaySpeedControllerWidget extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();
  final AssetsAudioPlayer player;
  final AudioPlayerBloc bloc;
  final BuildContext parentContext;

  AudioPlaySpeedControllerWidget(
      {@required this.player,
      @required this.parentContext,
      @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    return StreamBuilder(
      stream: player.playSpeed,
      builder: (cntxt, snapshot) {
        double speed = 0;
        if (snapshot.hasData) {
          // print('play speed');
          // print(snapshot.data);
          speed = snapshot.data;
        }
        return _viewBuilder(context, speed);
      },
    );
  }

  Widget _viewBuilder(BuildContext context, double speed) {
    bloc.changePlaySpeed(speed);
    return SizedBox(
      height: 40,
      width: 60,
      child: TextButton(
        onPressed: () {
          _popup(context);
        },
        child: Text(
          '${double.parse(speed.toStringAsFixed(1))} X',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            color: colours.headlineColour(),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _popup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext cntxt) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 230,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _title(),
                Space(verticle: 15),
                _speedText(),
                Space(verticle: 2),
                _speedSlider(),
                Space(verticle: 20),
                _confirmations(context),
                // _optionOn(cntxt, settingsBloc),
                // Space(verticle: 15),
                // _optionOff(cntxt, settingsBloc),
                // Space(verticle: 20),
                // _cancelButton(cntxt),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Playback Speed',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colours.headlineColour(),
          ),
        ),
        TextButton(
            onPressed: () {
              bloc.changePlaySpeed(1);
            },
            child: Text(
              'RESET',
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: colours.headlineColour(),
              ),
            ))
      ],
    );
  }

  Widget _speedText() {
    return StreamBuilder(
      stream: bloc.playSpeed,
      builder: (cntxt, snapshot) {
        double value = 1;
        if (snapshot.hasData) {
          value = snapshot.data;
        }
        return Text(
          '${double.parse(value.toStringAsFixed(1))} X',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontStyle: FontStyle.italic,
            fontSize: 18,
            color: colours.bodyTextColour(),
          ),
        );
      },
    );
  }

  Widget _speedSlider() {
    return StreamBuilder(
      stream: bloc.playSpeed,
      builder: (cntxt, snapshot) {
        double value = 1;
        if (snapshot.hasData) {
          value = snapshot.data;
        }
        return Slider(
          value: value,
          min: 0.5,
          max: 2.0,
          // divisions: 15,
          // label: 'tgis',
          activeColor: colours.headlineColour(),
          //inactiveColor: Colors.grey[350],
          onChangeStart: (double value) {
            // print('Start Value: $value');
          },
          onChangeEnd: (double value) {
            // print('END Value: $value');
          },
          onChanged: (double value) {
            //print('change Value: $value');
            bloc.changePlaySpeed(value);
          },
        );
      },
    );
  }

  Widget _confirmations(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            print('Set speed: ${bloc.getPlaySpeedValue()}');
            player.setPlaySpeed(bloc.getPlaySpeedValue());
            Navigator.pop(context);
          },
          child: Text(
            'OK',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: colours.headlineColour(),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'CANCEL',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: colours.headlineColour(),
            ),
          ),
        )
      ],
    );
  }
}
