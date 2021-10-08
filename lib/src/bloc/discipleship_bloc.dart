import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';
import '../modals/error_response.dart';
import '../modals/discipleship_responses.dart';

class DiscipleshipBloc {
  Future<dynamic> fetchLibraries() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider
        .getData(Constants.END_POINT_DISCIPLISHIP_LIBRARIES, headers: headers);
    print('Discipleship Response');
    print(response);
    if (response['status']) {
      print('converting data');
      DiscipleshipLibrariesResponseModal res =
          DiscipleshipLibrariesResponseModal.fromJSON(response);
      print('returning data');
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);
    print('returning null');
    return err;
  }

  Future<dynamic> fetchLibraryDetails(String id) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.getData(
        Constants.END_POINT_DISCIPLISHIP_LIBRARY(id),
        headers: headers);
    print('Discipleship library Response');
    print(response);
    if (response['status']) {
      DiscipleshipLibraryResponseModal res =
          DiscipleshipLibraryResponseModal.fromJSON(response);
      return res.data.discipleshipLibrary;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
