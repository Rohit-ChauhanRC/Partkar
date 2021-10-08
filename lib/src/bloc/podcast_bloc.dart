// import 'package:rxdart/rxdart.dart';
import 'validator.dart';
import '../modals/error_response.dart';
import '../modals/podcast_responses.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';

class PodcastBloc extends Object with Validator {
  Future<dynamic> fetchLibraries() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider
        .getData(Constants.END_POINT_PODCASTS_LIBRARIES, headers: headers);
    // print('PODCASTS Response');
    // print(response);
    if (response['status']) {
      PodcastLibrariesResponseModal res =
          PodcastLibrariesResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> fetchLibraryDetails(String id) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider
        .getData(Constants.END_POINT_PODCAST_LIBRARY(id), headers: headers);
    // print('PODCASTS library Response');
    // print(response);
    if (response['status']) {
      PodacastLibraryResponseModal res =
          PodacastLibraryResponseModal.fromJSON(response);
      // print('Podcast library data');
      // print(res.data);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
