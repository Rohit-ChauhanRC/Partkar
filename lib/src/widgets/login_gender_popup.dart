import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import 'spacer.dart';

class LoginGenderPopup extends StatelessWidget {
  final Function(String) onTap;

  LoginGenderPopup({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    // Future.delayed(Duration(milliseconds: 10), () {
    //   _popup(context);
    // });
    return _alert(context);
  }

  Widget _alert(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Select Gender',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 10),
      titlePadding: EdgeInsets.only(top: 15),
      backgroundColor: Colors.white,
      //actions: [_cancelButton(context)],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Space(verticle: 15),
          _optionMale(context),
          Space(verticle: 15),
          _optionFemale(context),
          Space(verticle: 20),
        ],
      ),
    );
  }

  Widget _optionMale(BuildContext context) {
    final IconData icon = Icons.male_rounded;
    return GestureDetector(
      child: Row(
        children: [
          Icon(icon, color: Color(0xff093454)),
          Space(horizontal: 5),
          Text(
            'Male',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
      onTap: () async {
        onTap('Male');
        _close(context);
      },
    );
  }

  Widget _optionFemale(BuildContext context) {
    final IconData icon = Icons.female_rounded;
    return GestureDetector(
      child: Row(
        children: [
          Icon(icon, color: Color(0xff093454)),
          Space(horizontal: 5),
          Text(
            'Female',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
      onTap: () async {
        onTap('Female');
        _close(context);
      },
    );
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
  }
}
