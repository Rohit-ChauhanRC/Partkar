import 'package:rxdart/rxdart.dart';
import '../modals/user_responses.dart';
import '../modals/error_response.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';

class ProfileBloc {
  final _iconPath = BehaviorSubject<String>();
  final _clubId = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _mobile = BehaviorSubject<String>();
  final _gender = BehaviorSubject<String>();
  final _school = BehaviorSubject<String>();
  final _schoolOthers = BehaviorSubject<String>();
  final _schoolYear = BehaviorSubject<String>();
  final _schoolYearOthers = BehaviorSubject<String>();
  final _makeUpdates = BehaviorSubject<bool>();

  Stream<String> get iconPath => _iconPath.stream;
  Stream<String> get clubId => _clubId.stream;
  Stream<String> get email => _email.stream;
  Stream<String> get firstName => _firstName.stream;
  Stream<String> get lastName => _lastName.stream;
  Stream<String> get mobile => _mobile.stream;
  Stream<String> get gender => _gender.stream;
  Stream<String> get school => _school.stream;
  Stream<String> get schoolOthers => _schoolOthers.stream;
  Stream<String> get schoolYear => _schoolYear.stream;
  Stream<String> get schoolYearOthers => _schoolYearOthers.stream;
  Stream<bool> get makeUpdates => _makeUpdates.stream;

  Function(String) get changeIconPath => _iconPath.sink.add;
  Function(String) get changeClubId => _clubId.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changeFirstName => _firstName.sink.add;
  Function(String) get changeLastName => _lastName.sink.add;
  Function(String) get changeMobile => _mobile.sink.add;
  Function(String) get changeGender => _gender.sink.add;
  Function(String) get changeSchool => _school.sink.add;
  Function(String) get changeSchoolOthers => _schoolOthers.sink.add;
  Function(String) get changeSchoolYear => _schoolYear.sink.add;
  Function(String) get changeSchoolYearOthers => _schoolYearOthers.sink.add;
  Function(bool) get changeMakeUpdates => _makeUpdates.sink.add;

  String schoolValue() {
    return _school.value;
  }

  String schoolYearValue() {
    return _schoolYear.value;
  }

  void setData(UserModal user) {
    changeClubId(user.clubId.toString());
    changeEmail(user.email);
    changeFirstName(user.firstName);
    changeLastName(user.lastName);
    changeMobile(user.mobile);
    changeGender(user.gender);
    changeSchool(user.school);
    changeSchoolOthers(user.schoolOther);
    changeSchoolYear(user.yearInSchool);
    changeSchoolYearOthers(user.yearInSchoolOther);
  }

  Future<dynamic> fetchProfile() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.getData(Constants.END_POINT_PROFILE,
        headers: headers);
    // print('PROFILE Response');
    // print(response);
    if (response['status']) {
      ProfileResponseModal res = ProfileResponseModal.fromJSON(response);
      return res.data.user;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> updateProfile() async {
    final body = {
      'first_name': _firstName.value,
      'last_name': _lastName.value,
      'mobile': _mobile.value,
      'gender': _gender.value ?? 'Male',
      'school': _school.value,
      'school_other': _schoolOthers.value ?? '',
      'year_in_school': _schoolYear.value,
      'year_in_school_other': _schoolYearOthers.value ?? '',
    };

    // print('Update Profile Request');
    // print(body);
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.updateProfile(
      Constants.END_POINT_PROFILE_UPDATE,
      headers: headers,
      body: body,
      imagePath: _iconPath.value,
    );

    // print('UPDATE PROFILE RESPONSE');
    // print(response);
    if (response['status']) {
      ProfileResponseModal res = ProfileResponseModal.fromJSON(response);
      //return res.data.user;
      return res.message;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
    // return null;
  }

  dispose() {
    _iconPath.close();
    _clubId.close();
    _email.close();
    _firstName.close();
    _lastName.close();
    _mobile.close();
    _gender.close();
    _school.close();
    _schoolOthers.close();
    _schoolYear.close();
    _schoolYearOthers.close();
    _makeUpdates.close();
  }
}
