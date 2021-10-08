import 'package:rxdart/rxdart.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';
import 'validator.dart';
import '../modals/user_responses.dart';
import '../modals/error_response.dart';
import '../modals/success_responses.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';

class LoginBloc extends Object with Validator {
  final _club = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _rememberMe = BehaviorSubject<bool>();
  final _emailForgot = BehaviorSubject<String>();

  Stream<String> get club => _club.stream;
  Stream<String> get email => _email.stream; //.transform(loginEmail);
  Stream<String> get password => _password.stream.transform(loginPassword);
  Stream<bool> get rememberMe => _rememberMe.stream;
  Stream<String> get emailForgot => _emailForgot.stream.transform(loginEmail);
  Stream<bool> get submitValid =>
      Rx.combineLatest2(email, password, (e, p) => true);
  Stream<bool> get submitValidForgot =>
      Rx.combineLatest2(emailForgot, emailForgot, (e, p) => true);

  Function(String) get changeClub => _club.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(bool) get changeRememberMe => _rememberMe.sink.add;
  Function(String) get changeEmailForgot => _emailForgot.sink.add;

  String clubValue() {
    return _club.value;
  }

  bool rememberMeValue() {
    return _rememberMe.value;
  }

  saveRememberMe() {
    DataStore().saveRememberMeEmail(_email.value ?? '');
  }

  setLoginId() async {
    // print('setting remember me');
    changeEmail(await DataStore().getRememberMeMail() ?? '');
    // _email.value = await DataStore().getRememberMeMail() ?? '';
  }

  Future<dynamic> submitLogin() async {
    if ((_email.value == null) || (_email.value == '')) {
      ErrorResponseModel er = ErrorResponseModel(message: 'Enter Email');
      return er;
    }
    final apiProvider = ApiProvider();
    final packageInfo = await PackageInfo.fromPlatform();
    final response =
        await apiProvider.postData(Constants.END_POINT_LOGIN, body: {
      'club_id': _club.value,
      'email': _email.value,
      'password': _password.value,
      'social_token': '',
      'login_device': Platform.isIOS ? 'iOS' : 'android',
      'notification_token': await DataStore().getFcmToken(),
      'device_details':
          '${Platform.isIOS ? (await DeviceInfoPlugin().iosInfo).utsname.machine : (await DeviceInfoPlugin().androidInfo).model},version: ${packageInfo.version}, build: ${packageInfo.buildNumber}',
    });

    if (response['status']) {
      LoginResponseModal res = LoginResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> submitGoogleLogin(
      String email, String socialId, String displayName, String gender) async {
    final apiProvider = ApiProvider();
    final packageInfo = await PackageInfo.fromPlatform();
    final response =
        await apiProvider.postData(Constants.END_POINT_SOCIAL_LOGIN, body: {
      'club_id': _club.value,
      'email': email,
      'first_name': displayName,
      'last_name': '',
      'full_name': displayName,
      'gender': gender,
      'type': 'google',
      'social_token': '',
      "social_register_id": socialId,
      'login_device': Platform.isIOS ? 'iOS' : 'android',
      'notification_token': await DataStore().getFcmToken(),
      'device_details':
          '${Platform.isIOS ? (await DeviceInfoPlugin().iosInfo).utsname.machine : (await DeviceInfoPlugin().androidInfo).model},version: ${packageInfo.version}, build: ${packageInfo.buildNumber}',
    });

    if (response['status']) {
      LoginResponseModal res = LoginResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> submitForgot() async {
    final apiProvider = ApiProvider();
    final response =
        await apiProvider.postData(Constants.END_POINT_FORGOT_PASSWORD, body: {
      'club_id': _club.value,
      'email': _emailForgot.value,
    });

    if (response['status']) {
      SuccessResponseModel res = SuccessResponseModel.fromJSON(response);
      return res;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  dispose() {
    _club.close();
    _email.close();
    _password.close();
    _rememberMe.close();
    _emailForgot.close();
  }
}
