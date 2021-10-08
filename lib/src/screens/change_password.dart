import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/change_password_provider.dart';
import '../modals/error_response.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../widgets/spacer.dart';
import '../widgets/loader.dart';
import '../widgets/alert.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: _backButton(context),
      title: Text(
        'Change Password',
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _backButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: colours.bgColour(),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _body(BuildContext context) {
    return _changePasswordForm(context);
  }

  Widget _changePasswordForm(BuildContext context) {
    final ChangePasswordBloc passwordBloc = ChangePasswordProvider.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Space(verticle: 40),
            _oldPassword(passwordBloc),
            Space(verticle: 20),
            _newPassword(passwordBloc),
            Space(verticle: 20),
            _repPassword(passwordBloc),
            Space(verticle: 50),
            _changeButton(passwordBloc),
            Space(verticle: 50),
          ],
        ),
      ),
    );
  }

  Widget _oldPassword(ChangePasswordBloc passwordBloc) {
    return StreamBuilder(
      stream: passwordBloc.oldPassword,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Current Password',
            labelText: 'Current Password',
            errorText: snapshot.error,
          ),
          onChanged: passwordBloc.changeOldPassword,
        );
      },
    );
  }

  Widget _newPassword(ChangePasswordBloc passwordBloc) {
    return StreamBuilder(
      stream: passwordBloc.newPassword,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'New Password',
            labelText: 'New Password',
            errorText: snapshot.error,
          ),
          onChanged: passwordBloc.changeNewPassword,
        );
      },
    );
  }

  Widget _repPassword(ChangePasswordBloc passwordBloc) {
    return StreamBuilder(
      stream: passwordBloc.repPassword,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Repeat Password',
            labelText: 'Repeat Password',
            errorText: snapshot.error,
          ),
          onChanged: passwordBloc.changeRepPassword,
        );
      },
    );
  }

  Widget _changeButton(ChangePasswordBloc passwordBloc) {
    return Container(
      width: double.infinity,
      child: StreamBuilder(
        stream: passwordBloc.submitChange,
        builder: (context, snapshot) {
          return ElevatedButton(
            child: Text(
              'Change Password',
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff0a3454),
              minimumSize: Size.fromHeight(40),
            ),
            onPressed: (snapshot.hasData)
                ? () {
                    FocusScope.of(context).unfocus();
                    _performChange(context, passwordBloc);
                  }
                : null,
          );
        },
      ),
    );
  }

  void _performChange(
      BuildContext context, ChangePasswordBloc passwordBloc) async {
    Loader.showLoading(context);
    final res = await passwordBloc.changePassword();
    Navigator.pop(context);
    if (res is ErrorResponseModel) {
      Alert.defaultAlert(context, 'Login', res.message);
    } else if (res is String) {
      Alert.defaultAlert(context, 'Success', res, okAction: () {
        Navigator.pop(context);
      });
    } else {
      Alert.defaultAlert(context, 'Error.', 'Try later.');
    }
  }
}
