import 'package:rxdart/rxdart.dart';
import 'validator.dart';
import '../modals/error_response.dart';
import '../modals/success_responses.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';

class ChangePasswordBloc with Validator {
  final _oldPassword = BehaviorSubject<String>();
  final _newPassword = BehaviorSubject<String>();
  final _repPassword = BehaviorSubject<String>();

  Stream<String> get oldPassword => _oldPassword.stream.transform(checkEmpty);
  Stream<String> get newPassword => _newPassword.stream.transform(checkEmpty);
  Stream<String> get repPassword => _repPassword.stream.transform(checkEmpty);
  Stream<bool> get submitChange => Rx.combineLatest3(
      oldPassword, newPassword, repPassword, (o, n, r) => true);

  Function(String) get changeOldPassword => _oldPassword.sink.add;
  Function(String) get changeNewPassword => _newPassword.sink.add;
  Function(String) get changeRepPassword => _repPassword.sink.add;

  Future<dynamic> changePassword() async {
    if (_newPassword.value.length < 6) {
      String message = 'New Password Must Contain 6 characters';
      ErrorResponseModel err = ErrorResponseModel(message: message);

      return err;
    } else if (_newPassword.value != _repPassword.value) {
      String message = 'New password and repeat password must be same';
      ErrorResponseModel err = ErrorResponseModel(message: message);

      return err;
    }
    final body = {
      'current_password': _oldPassword.value,
      'new_password': _newPassword.value,
    };

    // print('Update Profile Request');
    // print(body);
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.postData(
        Constants.END_POINT_CHANGE_PASSWORD,
        headers: headers,
        body: body);

    // print('UPDATE PROFILE RESPONSE');
    // print(response);
    if (response['status']) {
      SuccessResponseModel res = SuccessResponseModel.fromJSON(response);
      //return res.data.user;
      return res.message;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  dispose() {
    _oldPassword.close();
    _newPassword.close();
    _repPassword.close();
  }
}
