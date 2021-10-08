import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/spacer.dart';
import '../widgets/alert.dart';
import '../widgets/loader.dart';
import '../widgets/club_item.dart';
import '../bloc/login_provider.dart';
import '../modals/error_response.dart';
import '../modals/club_responses.dart';
import '../modals/success_responses.dart';
import '../utilities/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final ClubModal club;
  final String mediaUrl;

  ForgotPasswordScreen({@required this.club, @required this.mediaUrl});

  @override
  State<ForgotPasswordScreen> createState() {
    return _ForgotPasswordState(club: club, mediaUrl: mediaUrl);
  }
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  ClubModal club;
  String mediaUrl;

  _ForgotPasswordState({@required this.club, @required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _forgotForm(context),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        'Forgot Password',
        style: TextStyle(
          fontSize: 24,
          color: Color(0xff093454),
          fontFamily: Constants.FONT_FAMILY_TIMES,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 2,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  // Widget _uiBuilder(BuildContext context) {
  //   return FutureBuilder(
  //     future: _loginForm(context),
  //     builder: (cntxt, snapshot) {
  //       if (snapshot.hasData) {
  //         return snapshot.data;
  //       } else {
  //         return Container(
  //           child: CircularProgressIndicator(),
  //           alignment: Alignment.center,
  //         );
  //       }
  //     },
  //   );
  // }

  Widget _forgotForm(BuildContext context) {
    final loginBloc = LoginProvider.of(context);
    loginBloc.changeClub(club.id.toString());
    //Loader.showLoading(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Space(verticle: 50),
            ClubItemWidget(club: club, mediaUrl: mediaUrl),
            Space(verticle: 20),
            _emailField(loginBloc),
            Space(verticle: 60),
            _forgotButton(context, loginBloc),
          ],
        ),
      ),
    );
  }

  Widget _emailField(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.emailForgot,
      builder: (context, snapshot) {
        return TextField(
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'you@example.com',
            labelText: 'Enter Email',
            errorText: snapshot.error,
          ),
          onChanged: loginBloc.changeEmailForgot,
        );
      },
    );
  }

  Widget _forgotButton(BuildContext context, LoginBloc loginBloc) {
    return Container(
      width: double.infinity,
      child: StreamBuilder(
        stream: loginBloc.submitValidForgot,
        builder: (context, snapshot) {
          return ElevatedButton(
            child: Text(
              'Forgot Password',
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff093454),
              minimumSize: Size.fromHeight(40),
            ),
            onPressed: (snapshot.hasData)
                ? () {
                    FocusScope.of(context).unfocus();
                    _performForgot(context, loginBloc);
                  }
                : null,
          );
        },
      ),
    );
  }

  void _performForgot(BuildContext context, LoginBloc loginBloc) async {
    Loader.showLoading(context);
    final res = await loginBloc.submitForgot();
    Navigator.pop(context);
    if (res is ErrorResponseModel) {
      Alert.defaultAlert(context, 'Forgot Password', res.message);
    } else if (res is SuccessResponseModel) {
      Alert.defaultAlert(context, 'Forgot Password', res.message, okAction: () {
        Navigator.pop(context);
      });
    } else {
      Alert.defaultAlert(context, 'Error.', 'Try later.');
    }
  }
}
