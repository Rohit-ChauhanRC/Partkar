import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/club_provider.dart';
import '../bloc/register_provider.dart';
import '../bloc/login_provider.dart';
import '../bloc/podcast_provider.dart';
import '../bloc/general_provider.dart';
import '../bloc/notification_provider.dart';
import '../modals/club_responses.dart';
import '../modals/error_response.dart';
import '../modals/user_responses.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/google_sign_in.dart';
import '../utilities/facebook_sign_in.dart';
import '../widgets/spacer.dart';
import '../widgets/alert.dart';
import '../widgets/loader.dart';
import '../widgets/club_item.dart';
import '../widgets/login_gender_popup.dart';
import 'home.dart';
import 'club_selector.dart';

class RegisterScreen extends StatefulWidget {
  final ClubModal club;
  final String mediaUrl;

  RegisterScreen({@required this.club, @required this.mediaUrl});

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState(club: club, mediaUrl: mediaUrl);
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> genders = ['Male', 'Female'];
  ClubModal club;
  String mediaUrl;
  bool tncAccepted = false;

  _RegisterScreenState({@required this.club, @required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _uiBuilder(context),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        'Register',
        style: TextStyle(
          fontSize: 24,
          color: Color(0xff093454),
          fontFamily: Constants.FONT_FAMILY_TIMES,
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: BackButton(color: Color(0xff093454)),
      backgroundColor: Colors.white,
      elevation: 2,
      //leading: Container(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _uiBuilder(BuildContext context) {
    final clubBloc = ClubProvider.of(context);
    final RegisterBloc registerBloc = RegisterProvider.of(context);
    final LoginBloc loginBloc = LoginProvider.of(context);
    registerBloc.changeClub(club.id.toString());
    return StreamBuilder(
      stream: registerBloc.club,
      builder: (clubContext, clubSnapshot) {
        String clubId = clubSnapshot.data;
        //clubSnapshot.hasData ? clubSnapshot.data : clubs[0].id.toString();
        return FutureBuilder(
          future: clubBloc.fetchClubInfo(clubId),
          builder:
              (clubInfoContext, AsyncSnapshot<ClubDataModal> clubInfoSnapshot) {
            // print('Club info has data ${clubInfoSnapshot.hasData}');
            if (clubInfoSnapshot.hasData) {
              return _registerForm(
                  context,
                  registerBloc,
                  loginBloc,
                  clubInfoSnapshot.data.schools,
                  clubInfoSnapshot.data.yearSchools,
                  clubInfoSnapshot.data.tnc,
                  clubInfoSnapshot.data.privacyPolicy);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  Widget _registerForm(
      BuildContext context,
      RegisterBloc registerBloc,
      LoginBloc loginBloc,
      List<ClubSchoolModal> schools,
      List<ClubSchoolYearModal> years,
      String tnc,
      String privacyPolicy) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Space(verticle: 30),
            _loginButton(context),
            Space(verticle: 10),
            _changeClubButton(context),
            Space(verticle: 15),
            // _socialLogin(loginBloc),
            // Space(verticle: 15),
            ClubItemWidget(club: club, mediaUrl: mediaUrl),
            _firstName(registerBloc),
            Space(verticle: 10),
            _lastName(registerBloc),
            Space(verticle: 10),
            _email(registerBloc),
            Space(verticle: 10),
            _password(registerBloc),
            Space(verticle: 10),
            _mobile(registerBloc),
            Space(verticle: 20),
            Text('Gender',
                style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA)),
            _gender(context, registerBloc),
            Space(verticle: 20),
            Text('School',
                style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA)),
            _schoolsDropDownBuilder(context, registerBloc, schools),
            _schoolOthers(registerBloc),
            Space(verticle: 20),
            Text('I am a...',
                style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA)),
            _schoolYearsDropDownBuilder(context, registerBloc, years),
            _schoolYearOthers(registerBloc),
            Space(verticle: 30),
            _appTnc(tnc, privacyPolicy),
            Space(verticle: 50),
            _registerButton(context, registerBloc),
            Space(verticle: 40),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already registered?  ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'Log in here',
            style: TextStyle(
                color: Color(0xff093454),
                fontSize: 18,
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontWeight: FontWeight.w200,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context, true);
              },
          ),
        ],
      ),
    );
  }

  Widget _changeClubButton(BuildContext context) {
    return GestureDetector(
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Change Club',
          //textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            color: Colors.grey[600],
          ),
        ),
      ),
      onTap: () async {
        bool reload = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (cntxt) => ClubProvider(child: ClubSelectorScreen())));

        if ((reload != null) && reload) {
          club = await DataStore().getSelectedClub();
          mediaUrl = await DataStore().getClubMediaUrl();
          setState(() {});
        }
      },
    );
  }

  Widget _socialLogin(LoginBloc loginBloc) {
    return _googleLoginButton(loginBloc);
    // _googleLoginButton(loginBloc);
    // return _facebookLoginButton(loginBloc);
  }

  Widget _googleLoginButton(LoginBloc loginBloc) {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        icon: Image.asset('assets/images/google_login.png'),
        iconSize: 70,
        onPressed: () async {
          User user = await PartakerGoogleSignIn.signIn();
          showDialog(
            context: context,
            builder: (BuildContext dialogueContext) {
              return LoginGenderPopup(onTap: (String gender) {
                // print(gender);
                performGoogleSignIn(context, loginBloc, user.email, user.uid,
                    user.displayName, gender);
              });
            },
          );
        },
      ),
    );
  }

  Widget _facebookLoginButton(LoginBloc loginBloc) {
    return TextButton(
      child: Text('F_LOGIN'),
      onPressed: () async {
        await PartakerFacebookSignIn.signIn();
      },
    );
  }

  Widget _firstName(RegisterBloc registerBloc) {
    return StreamBuilder(
      stream: registerBloc.firstName,
      builder: (context, snapshot) {
        final controller = TextEditingController();
        controller.text = snapshot.data;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Enter Your First Name',
            labelText: 'First Name',
            errorText: snapshot.error,
          ),
          onChanged: registerBloc.changeFirstName,
        );
      },
    );
  }

  Widget _lastName(RegisterBloc registerBloc) {
    return StreamBuilder(
      stream: registerBloc.lastName,
      builder: (context, snapshot) {
        final controller = TextEditingController();
        controller.text = snapshot.data;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Enter Your Last Name',
            labelText: 'Last Name',
            errorText: snapshot.error,
          ),
          onChanged: registerBloc.changeLastName,
        );
      },
    );
  }

  Widget _email(RegisterBloc registerBloc) {
    return StreamBuilder(
      stream: registerBloc.email,
      builder: (context, snapshot) {
        return TextField(
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Enter Email',
            labelText: 'Email',
            errorText: snapshot.error,
          ),
          onChanged: registerBloc.changeEmail,
        );
      },
    );
  }

  Widget _mobile(RegisterBloc registerBloc) {
    return StreamBuilder(
      stream: registerBloc.mobile,
      builder: (context, snapshot) {
        // final controller = TextEditingController();
        // controller.text = snapshot.data;
        // controller.selection = TextSelection.fromPosition(
        //     TextPosition(offset: controller.text.length));
        return TextField(
          // controller: controller,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          autocorrect: false,
          enableSuggestions: false,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Enter Mobile Number',
            labelText: 'Mobile Number',
            errorText: snapshot.error,
          ),
          onChanged: registerBloc.changeMobile,
        );
      },
    );
  }

  Widget _gender(BuildContext context, RegisterBloc registerBloc) {
    return StreamBuilder(
      stream: registerBloc.gender,
      builder: (cntxt, snapshot) {
        return DropdownButton<String>(
          isExpanded: true,
          style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA, color: Colors.black),
          value: (snapshot.data == null) ? genders[0] : snapshot.data,
          items: genders.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: registerBloc.changeGender,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }

  Widget _password(RegisterBloc registerBloc) {
    return StreamBuilder(
      stream: registerBloc.password,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Enter Password',
            labelText: 'Password',
            errorText: snapshot.error,
          ),
          onChanged: registerBloc.changePassword,
        );
      },
    );
  }

  Widget _schoolsDropDownBuilder(BuildContext context,
      RegisterBloc registerBloc, List<ClubSchoolModal> schools) {
    return StreamBuilder(
      stream: registerBloc.school,
      builder: (schoolContext, snapshot) {
        return DropdownButton<String>(
          isExpanded: true,
          style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA, color: Colors.black),
          value: registerBloc.schoolValue(),
          items: schools.map((ClubSchoolModal club) {
            return new DropdownMenuItem<String>(
              value: club.title,
              child: new Text(club.title),
            );
          }).toList(),
          onChanged: (value) {
            String val = (value.toLowerCase() == 'other') ? '' : null;
            // print('school dropdown');
            // print(val);
            registerBloc.changeSchoolOthers((value == 'Other') ? '' : null);
            registerBloc.changeSchool(value);
          },
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }

  Widget _schoolOthers(RegisterBloc registerBloc) {
    return StreamBuilder(
      stream: registerBloc.schoolOthers,
      builder: (context, snapshot) {
        // print('Other');
        // print(snapshot.data);
        if (snapshot.hasData) {
          final controller = TextEditingController();
          controller.text = snapshot.data;
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
          return TextField(
            controller: controller,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
            decoration: InputDecoration(
              hintText: 'Enter School Name',
              labelText: 'School/Others',
              errorText: snapshot.error,
            ),
            onChanged: registerBloc.changeSchoolOthers,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _schoolYearsDropDownBuilder(BuildContext context,
      RegisterBloc registerBloc, List<ClubSchoolYearModal> years) {
    return StreamBuilder(
      stream: registerBloc.schoolYear,
      builder: (schoolContext, snapshot) {
        return DropdownButton<String>(
          isExpanded: true,
          style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA, color: Colors.black),
          value: registerBloc.schoolYearValue(),
          items: years.map((ClubSchoolYearModal year) {
            return new DropdownMenuItem<String>(
              value: year.title,
              child: new Text(year.title),
            );
          }).toList(),
          onChanged: (value) {
            registerBloc.changeSchoolYearOthers((value == 'Other') ? '' : null);
            registerBloc.changeSchoolYear(value);
          },
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }

  Widget _schoolYearOthers(RegisterBloc registerBloc) {
    return StreamBuilder(
      stream: registerBloc.schoolYearOthers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final controller = TextEditingController();
          controller.text = snapshot.data;
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
          return TextField(
            controller: controller,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
            decoration: InputDecoration(
              hintText: 'Fill in your current year in school or status',
              labelText: 'Year in school/Status',
              errorText: snapshot.error,
            ),
            onChanged: registerBloc.changeSchoolYearOthers,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _appTnc(String tnc, String privacyPolicy) {
    return StreamBuilder(
      builder: (cntxt, snapshot) {
        IconData icon = Icons.check_box_outline_blank_rounded;
        if (tncAccepted) {
          icon = Icons.check_box_rounded;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                tncAccepted = !tncAccepted;
                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Icon(icon),
              ),
            ),
            Space(horizontal: 10),
            Expanded(child: _tncText(tnc, privacyPolicy)),
          ],
        );
      },
    );
  }

  Widget _tncText(String tnc, String privacyPolicy) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'I have read and accepted ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
          text: 'terms & conditions',
          style: TextStyle(
            color: Color(0xff093454),
            fontSize: 18,
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontWeight: FontWeight.w200,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              // String url = 'https://www.partaker.net/app-terms-conditions/';
              // if (await canLaunch(url)) {
              //   launch(url);
              // }
              _popup(context, 'Terms & Conditions', tnc ?? 'No Data Found');
            },
        ),
        TextSpan(
          text: ' and ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextSpan(
          text: 'privacy policy.',
          style: TextStyle(
            color: Color(0xff093454),
            fontSize: 18,
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontWeight: FontWeight.w200,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              // String url = 'https://www.partaker.net/app-privacy-policy/';
              // if (await canLaunch(url)) {
              //   launch(url);
              // }
              _popup(
                  context, 'Privacy Policy', privacyPolicy ?? 'No Data Found.');
            },
        ),
      ]),
    );
  }

  Widget _registerButton(BuildContext context, RegisterBloc registerBloc) {
    return Container(
      width: double.infinity,
      child: StreamBuilder(
        stream: registerBloc.submitValid,
        builder: (submitContext, snapshot) {
          return ElevatedButton(
            child: Text(
              'Register',
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
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (!tncAccepted) {
                Alert.defaultAlert(context, 'Terms & Conditions',
                    'You must read and accept terms & conditions and privacy policy in order to register in the app.');
              } else {
                _performRegister(context, registerBloc);
              }
            },
          );
        },
      ),
    );
  }

  void performGoogleSignIn(BuildContext context, LoginBloc loginBloc,
      String email, String socialId, String displayName, String gender) async {
    Loader.showLoading(context);
    final res =
        await loginBloc.submitGoogleLogin(email, socialId, displayName, gender);
    Navigator.pop(context);
    if (res is ErrorResponseModel) {
      Alert.defaultAlert(context, 'Login', res.message);
    } else if (res is LoginModal) {
      if (res.user != null) {
        if (loginBloc.rememberMeValue()) {
          loginBloc.saveRememberMe();
        } else {
          DataStore().removeRememberMeMail();
        }
        await DataStore().saveLoginToken(res.token);
        await DataStore().saveUser(res.user);
        await DataStore().saveLoginClub(res.clubinfo);
        await DataStore().saveLoginClubColours(res.colorModes);
        await Setting().loadColourMode();
        await Setting().loadColours();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (cntxt) => PodcastProvider(
                    child: GeneralProvider(
                        child: NotificationProvider(child: HomeScreen())))));
      } else {
        Alert.defaultAlert(context, 'Login Error', 'Try to update your app.');
      }
    } else {
      Alert.defaultAlert(context, 'Login Error.', 'Try later.');
    }
  }

  void _performRegister(BuildContext context, RegisterBloc registerBloc) async {
    Loader.showLoading(context);
    final res = await registerBloc.submitRegister();
    Navigator.pop(context);
    if (res is ErrorResponseModel) {
      Alert.defaultAlert(context, 'Register', res.message);
    } else if (res is LoginModal) {
      if (res.user != null) {
        await DataStore().saveLoginToken(res.token);
        await DataStore().saveUser(res.user);
        await DataStore().saveLoginClub(res.clubinfo);
        await DataStore().saveLoginClubColours(res.colorModes);
        await Setting().loadColourMode();
        await Setting().loadColours();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (cntxt) => PodcastProvider(
                    child: GeneralProvider(
                        child: NotificationProvider(child: HomeScreen())))));
      } else {
        Alert.defaultAlert(
            context, 'Register Error', 'Try to update your app.');
      }
    } else {
      Alert.defaultAlert(context, 'Register Error.', 'Try later.');
    }
  }

  void _popup(BuildContext context, String title, String data) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext cntxt) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          content: Container(
            height: size.height * 0.8,
            width: size.width,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            margin: EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(title),
                Space(verticle: 20),
                _description(data),
                Space(verticle: 20),
                _cancelButton(cntxt),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xff093454),
      ),
    );
  }

  Widget _description(String description) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          '${description.replaceAll('\\n', '\n').replaceAll('\\r', '\r')}',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
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
          'OK',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
  }
}
