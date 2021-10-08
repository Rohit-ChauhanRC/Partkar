import '../utilities/constants.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../modals/home_responses.dart';
import '../modals/error_response.dart';

class HomeBloc {
  Future<dynamic> fetchData() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response =
        await apiProvider.getData(Constants.END_POINT_HOME, headers: headers);
    // print('EVENTS Response');
    // print(response);
    if (response['status']) {
      HomeDataResponseModal res = HomeDataResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
