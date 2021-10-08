import 'package:agape/src/utilities/Helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import '../resources/data_store.dart';
import '../resources/api_provider.dart';
import '../utilities/constants.dart';
import '../utilities/google_sign_in.dart';
import '../modals/success_responses.dart';
import '../modals/error_response.dart';
import '../modals/club_responses.dart';

class GeneralBloc {
  // final _displayTabbar = BehaviorSubject<bool>();
  final _displayTabbar = PublishSubject<bool>();

  Stream<bool> get displayTabbar => _displayTabbar.stream;

  Function(bool) get changeDisplayTabbar => _displayTabbar.sink.add;

  Future<dynamic> logout() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.postData(Constants.END_POINT_LOGOUT,
        headers: headers);

    await PartakerGoogleSignIn.signOut();

    if (response['status']) {
      SuccessResponseModel res = SuccessResponseModel.fromJSON(response);
      return res;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> updateDeviceDetails() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final packageInfo = await PackageInfo.fromPlatform();
    final body = {
      'device_details':
          '${Platform.isIOS ? (await DeviceInfoPlugin().iosInfo).utsname.machine : (await DeviceInfoPlugin().androidInfo).model},version: ${packageInfo.version}, build: ${packageInfo.buildNumber}',
    };
    final response = await apiProvider.postData(
        Constants.END_POINT_UPDATE_DEVICE_DETAILS,
        headers: headers,
        body: body);

    if (response['status']) {
      SuccessResponseModel res = SuccessResponseModel.fromJSON(response);
      return res;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<String> versionCheck() async {
    if (Helper.VERSION_CHECKED) return null;
    Helper.VERSION_CHECKED = true;
    try {
      final apiProvider = ApiProvider();
      final Map<String, String> body = {
        'type': Platform.isIOS ? 'iOS' : 'android',
        'version': (await PackageInfo.fromPlatform()).version,
      };
      final response = await apiProvider
          .postData(Constants.END_POINT_VERSION_CHECK, body: body);
      // print('VERSION RESPONSE');
      // print(response);
      int stat = response['data']['version_info']['status'];
      if (stat != 0) {
        String store = Platform.isIOS ? 'App Store' : 'Play Store';
        return 'There is a new update available. Please update your app from the $store.';
      }
      return null;
    } catch (e) {
      // print('Version exception');
      // print(e);
    }

    return null;
  }

  Future<String> shareDetails() async {
    try {
      final apiProvider = ApiProvider();
      final headers = {'Authorization': await DataStore().getLoginToken()};
      final response = await apiProvider
          .getData(Constants.END_POINT_SHARE_DETAILS, headers: headers);
      // print('share RESPONSE');
      // print(response);
      var details = response['data']['share_detail'];
      if (details is String) {
        return details;
      }
      return null;
    } catch (e) {
      print('share exception');
      print(e);
    }

    return null;
  }

  Future<void> updateColourScheme() async {
    int clubId = (await DataStore().getLoginClub()).id;
    final body = {'club_id': clubId};
    final apiProvider = ApiProvider();
    final response =
        await apiProvider.postData(Constants.END_POINT_CLUB_INFO, body: body);
    ClubInfoResponseModal res = ClubInfoResponseModal.fromJSON(response);
    // print('>>>>>>>>>>   THIS    <<<<<<<<<<<');
    // print(res.data.colorModes);
    final colours = res.data.colorModes;
    if (colours != null) {
      DataStore().saveLoginClubColours(colours);
    }
  }

  void dispose() {
    _displayTabbar.close();
  }
}
