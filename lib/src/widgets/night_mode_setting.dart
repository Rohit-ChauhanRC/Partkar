import 'package:agape/src/widgets/spacer.dart';
import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../resources/data_store.dart';
import '../bloc/settings_provider.dart';

class NightModeSettingWidget extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();
  final ColourModes mode;
  final Function onChange;

  NightModeSettingWidget({@required this.mode, @required this.onChange});

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    SettingsBloc settingsBloc = SettingsProvider.of(context);
    String status = '';
    if (mode == ColourModes.day) {
      status = 'Off';
    } else if (mode == ColourModes.night) {
      status = 'On';
    } else if (mode == ColourModes.auto) {
      status = 'Auto';
    }
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Night mode',
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 18,
                color: colours.bodyTextColour(),
              ),
            ),
            Text(
              status,
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 18,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        _popup(context, settingsBloc);
      },
    );
  }

  void _popup(BuildContext context, SettingsBloc settingsBloc) {
    showDialog(
      context: context,
      builder: (BuildContext cntxt) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 250,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                Space(verticle: 20),
                _optionOn(cntxt, settingsBloc),
                Space(verticle: 15),
                _optionOff(cntxt, settingsBloc),
                Space(verticle: 15),
                _optionAuto(cntxt, settingsBloc),
                Space(verticle: 20),
                _cancelButton(cntxt),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _title() {
    return Text(
      'Night Mode',
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _optionOn(BuildContext context, SettingsBloc settingsBloc) {
    final IconData icon = mode == ColourModes.night
        ? Icons.radio_button_checked
        : Icons.radio_button_unchecked;
    return GestureDetector(
      child: Row(
        children: [
          Icon(icon, color: Color(0xff093454)),
          Space(horizontal: 5),
          Text(
            'Always on',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
      onTap: () async {
        // print('Make Night mode on');
        await DataStore().saveSelectedColourMode(ColourModes.night);
        //settingsBloc.changeColourMode(ColourModes.night);
        onChange();
        _close(context);
      },
    );
  }

  Widget _optionOff(BuildContext context, SettingsBloc settingsBloc) {
    final IconData icon = mode == ColourModes.day
        ? Icons.radio_button_checked
        : Icons.radio_button_unchecked;
    return GestureDetector(
      child: Row(
        children: [
          Icon(icon, color: Color(0xff093454)),
          Space(horizontal: 5),
          Text(
            'Always off',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
      onTap: () async {
        // print('Make Night mode off');
        await DataStore().saveSelectedColourMode(ColourModes.day);
        //settingsBloc.changeColourMode(ColourModes.day);
        onChange();
        _close(context);
      },
    );
  }

  Widget _optionAuto(BuildContext context, SettingsBloc settingsBloc) {
    final IconData icon = mode == ColourModes.auto
        ? Icons.radio_button_checked
        : Icons.radio_button_unchecked;
    return GestureDetector(
      child: Row(
        children: [
          Icon(icon, color: Color(0xff093454)),
          Space(horizontal: 5),
          Text(
            'Auto',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
      onTap: () async {
        // print('Make Night mode auto');
        await DataStore().saveSelectedColourMode(ColourModes.auto);
        //settingsBloc.changeColourMode(ColourModes.auto);
        onChange();
        _close(context);
      },
    );
  }

  Widget _cancelButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          _close(context);
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

  void _close(BuildContext context) {
    Navigator.pop(context);
  }
}
