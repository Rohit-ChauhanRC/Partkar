import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/spacer.dart';
import '../widgets/alert.dart';
import '../widgets/loader.dart';
import '../widgets/club_item.dart';
import '../widgets/login_gender_popup.dart';
import 'register.dart';
import 'club_selector.dart';
import 'home.dart';
import 'forgot_password.dart';
import '../bloc/club_provider.dart';
import '../bloc/login_provider.dart';
import '../bloc/register_provider.dart';
import '../bloc/podcast_provider.dart';
import '../bloc/general_provider.dart';
import '../bloc/notification_provider.dart';
import '../modals/error_response.dart';
import '../modals/user_responses.dart';
import '../modals/club_responses.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/google_sign_in.dart';
import '../utilities/facebook_sign_in.dart';

class LoginScreen extends StatefulWidget {
  final ClubModal club;
  final String mediaUrl;
  final bool goToRegister;

  LoginScreen(
      {@required this.club,
      @required this.mediaUrl,
      this.goToRegister = false});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState(
        club: club, mediaUrl: mediaUrl, goToRegister: goToRegister);
  }
}

class _LoginScreenState extends State<LoginScreen> {
  ClubModal club;
  String mediaUrl;
  bool goToRegister;
  final emailController = TextEditingController();

  _LoginScreenState(
      {@required this.club, @required this.mediaUrl, this.goToRegister});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _loginForm(context),
    );
  }

  AppBar _appbar() {
    checkRedirection();
    return AppBar(
      title: Text(
        'Log in',
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

  void checkRedirection() {
    if (goToRegister) {
      Future.delayed(Duration(milliseconds: 500), () async {
        bool reload = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (cntxt) => LoginProvider(
                    child: RegisterProvider(
                        child: ClubProvider(
                            child: RegisterScreen(
                                club: club, mediaUrl: mediaUrl))))));

        if ((reload != null) && reload) {
          club = await DataStore().getSelectedClub();
          mediaUrl = await DataStore().getClubMediaUrl();
          setState(() {});
        }
        goToRegister = false;
      });
    }
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

  Widget _loginForm(BuildContext context) {
    final loginBloc = LoginProvider.of(context);
    loginBloc.setLoginId();
    loginBloc.changeClub(club.id.toString());
    //Loader.showLoading(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Space(verticle: 40),
            _registerButton(context),
            Space(verticle: 40),
            _changeClubButton(context),
            ClubItemWidget(club: club, mediaUrl: mediaUrl),
            Space(verticle: 20),
            _emailField(loginBloc),
            Space(verticle: 5),
            _password(loginBloc),
            Space(verticle: 15),
            _forgotPasswordButton(context),
            Space(verticle: 40),
            _loginButton(context, loginBloc),
            Space(verticle: 10),
            // _socialLogin(loginBloc),
            // Space(verticle: 10),
            _rememberMe(context, loginBloc),
            Space(verticle: 60),
          ],
        ),
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

  Widget _emailField(LoginBloc loginBloc) {
    TextSelection cachedSelection;
    return StreamBuilder(
      stream: loginBloc.email,
      builder: (context, snapshot) {
        emailController.text = snapshot.data;

        if (cachedSelection == null) {
          emailController.selection = TextSelection.fromPosition(
              TextPosition(offset: emailController.text.length));
        } else {
          emailController.selection = cachedSelection;
        }

        return TextFormField(
          // initialValue: 'aasd',
          autocorrect: false,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'you@example.com',
            labelText: 'Enter Email',
            errorText: snapshot.error,
          ),
          // onChanged: loginBloc.changeEmail,
          onChanged: (text) {
            cachedSelection = emailController.selection;
            loginBloc.changeEmail(text);
          },
        );
      },
    );
  }

  Widget _password(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.password,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'password',
            labelText: 'Password',
            errorText: snapshot.error,
          ),
          onChanged: loginBloc.changePassword,
        );
      },
    );
  }

  Widget _forgotPasswordButton(BuildContext context) {
    return GestureDetector(
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Forgot Password',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            color: Colors.grey[600],
          ),
        ),
      ),
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (cntxt) => LoginProvider(
                    child:
                        ForgotPasswordScreen(club: club, mediaUrl: mediaUrl))));
      },
    );
  }

  Widget _loginButton(BuildContext context, LoginBloc loginBloc) {
    return Container(
      width: double.infinity,
      child: StreamBuilder(
        stream: loginBloc.submitValid,
        builder: (context, snapshot) {
          return ElevatedButton(
            child: Text(
              'Log in',
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
                    _performLogin(context, loginBloc);
                  }
                : null,
          );
        },
      ),
    );
  }

  Widget _socialLogin(LoginBloc loginBloc) {
    // return _googleLoginButton(loginBloc);
    // _googleLoginButton(loginBloc);
    return _facebookLoginButton(loginBloc); //social_token
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

  Widget _registerButton(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Not a member yet?  ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'Register Here',
            style: TextStyle(
                color: Color(0xff093454),
                fontSize: 18,
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontWeight: FontWeight.w200,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                bool reload = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (cntxt) => LoginProvider(
                            child: RegisterProvider(
                                child: ClubProvider(
                                    child: RegisterScreen(
                                        club: club, mediaUrl: mediaUrl))))));

                if ((reload != null) && reload) {
                  club = await DataStore().getSelectedClub();
                  mediaUrl = await DataStore().getClubMediaUrl();
                  setState(() {});
                }
              },
          ),
        ],
      ),
    );
  }

  Widget _rememberMe(BuildContext context, LoginBloc loginBloc) {
    // bool markSelected = false;
    // IconData icon =
    //     markSelected ? Icons.check_box : Icons.check_box_outline_blank;
    // loginBloc.changeRememberMe(true);

    return FutureBuilder(
      future: DataStore().getRememberMeMail(),
      builder: (cntxt, snapshot) {
        return _rememberMeButton(context, loginBloc, snapshot.data);
      },
    );
  }

  Widget _rememberMeButton(
      BuildContext context, LoginBloc loginBloc, String mail) {
    // bool markSelected = false;
    // IconData icon =
    //     markSelected ? Icons.check_box : Icons.check_box_outline_blank;
    loginBloc.changeRememberMe(true);

    return StreamBuilder(
      stream: loginBloc.rememberMe,
      builder: (cntxt, snapshot) {
        IconData icon = Icons.check_box_outline_blank;
        if (snapshot.hasData) {
          icon =
              snapshot.data ? Icons.check_box : Icons.check_box_outline_blank;
        }
        return GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Color(0xff0a3454)),
              Space(horizontal: 5),
              Text(
                'Remember Me',
                style: TextStyle(
                  fontFamily: Constants.FONT_FAMILY_FUTURA,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          onTap: () {
            loginBloc.changeRememberMe(!snapshot.data);
            // print('Change remember me to ${!snapshot.data}');
          },
        );
      },
    );
  }

  void _performLogin(BuildContext context, LoginBloc loginBloc) async {
    Loader.showLoading(context);
    final res = await loginBloc.submitLogin();
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
}
