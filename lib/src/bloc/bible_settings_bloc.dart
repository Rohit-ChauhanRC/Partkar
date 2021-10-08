import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../modals/bible_responses.dart';
import '../modals/error_response.dart';
import '../utilities/constants.dart';

class BibleSettingsBloc {
  Future<dynamic> fetch() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider
        .getData(Constants.END_POINT_BIBLE_SETTINGS, headers: headers);
    // print('BIBLE Settings Response');
    // print(response);
    if (response['status']) {
      BibleSettingsResponseModal res =
          BibleSettingsResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> update(String setting) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final body = {'bible_settings': setting};
    final apiProvider = ApiProvider();
    final response = await apiProvider.postData(
        Constants.END_POINT_BIBLE_SETTINGS,
        headers: headers,
        body: body);
    // print('BIBLE Settings update Response');
    // print(response);
    if (response['status']) {
      return null;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
