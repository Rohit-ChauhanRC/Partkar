import 'package:rxdart/rxdart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';
import 'validator.dart';
import '../resources/api_provider.dart';
// import '../resources/data_store.dart';
import '../modals/user_responses.dart';
import '../modals/error_response.dart';
import '../utilities/constants.dart';

class RegisterBloc extends Object with Validator {
  final _club = BehaviorSubject<String>();
  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _mobile = BehaviorSubject<String>();
  final _gender = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _school = BehaviorSubject<String>();
  final _schoolOthers = BehaviorSubject<String>();
  final _schoolYear = BehaviorSubject<String>();
  final _schoolYearOthers = BehaviorSubject<String>();
  final _tnc = BehaviorSubject<bool>();

  Stream<String> get club => _club.stream;
  Stream<String> get firstName => _firstName.stream;
  Stream<String> get lastName => _lastName.stream;
  Stream<String> get email => _email.stream;
  Stream<String> get mobile => _mobile.stream.transform(mobileValidation);
  Stream<String> get gender => _gender.stream;
  Stream<String> get password => _password.stream;
  Stream<String> get school => _school.stream;
  Stream<String> get schoolOthers => _schoolOthers.stream;
  Stream<String> get schoolYear => _schoolYear.stream;
  Stream<String> get schoolYearOthers => _schoolYearOthers.stream;
  Stream<bool> get tnc => _tnc.stream;
  Stream<bool> get submitValid =>
      Rx.combineLatest3(email, password, tnc, (e, p, t) => true);

  Function(String) get changeClub => _club.sink.add;
  Function(String) get changeFirstName => _firstName.sink.add;
  Function(String) get changeLastName => _lastName.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changeMobile => _mobile.sink.add;
  Function(String) get changeGender => _gender.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeSchool => _school.sink.add;
  Function(String) get changeSchoolOthers => _schoolOthers.sink.add;
  Function(String) get changeSchoolYear => _schoolYear.sink.add;
  Function(String) get changeSchoolYearOthers => _schoolYearOthers.sink.add;
  Function(bool) get changeTnc => _tnc.sink.add;

  String clubValue() {
    return _club.value;
  }

  String schoolValue() {
    return _school.value;
  }

  String schoolYearValue() {
    return _schoolYear.value;
  }

  Future<dynamic> submitRegister() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final body = {
      'club_id': _club.value,
      'email': _email.value,
      'first_name': _firstName.value,
      'last_name': _lastName.value,
      'mobile': _mobile.value,
      'gender': _gender.value ?? 'Male',
      'password': _password.value,
      'school': _school.value,
      'school_other': _schoolOthers.value ?? '',
      'year_in_school': _schoolYear.value,
      'year_in_school_other': _schoolYearOthers.value ?? '',
      'register_device': Platform.isIOS ? 'iOS' : 'android',
      'device_details':
          '${Platform.isIOS ? (await DeviceInfoPlugin().iosInfo).utsname.machine : (await DeviceInfoPlugin().androidInfo).model},version: ${packageInfo.version}, build: ${packageInfo.buildNumber}', //,'debug',
      // 'notification_token': await DataStore().getFcmToken(),
      'notification_token': await FirebaseMessaging.instance.getToken(),
    };
    // print(body);
    // print('Register Request');
    // print(body);
    final apiProvider = ApiProvider();
    final response =
        await apiProvider.postData(Constants.END_POINT_REGISTER, body: body);

    if (response['status']) {
      LoginResponseModal res = LoginResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
    // return null;
  }

  dispose() {
    _club.close();
    _firstName.close();
    _lastName.close();
    _email.close();
    _mobile.close();
    _gender.close();
    _password.close();
    _school.close();
    _schoolOthers.close();
    _schoolYear.close();
    _schoolYearOthers.close();
    _tnc.close();
  }
}
