import '../resources/data_store.dart';
import '../resources/api_provider.dart';
import '../utilities/constants.dart';
import '../modals/error_response.dart';
import '../modals/know_us_responses.dart';

class KnowUsBloc {
  Future<dynamic> fetchKnowUs(String mode) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final selectedClub = (await DataStore().getSelectedClub());
    final response = await apiProvider.getData(
        Constants.END_POINT_KNOW_US(selectedClub.id.toString(), mode),
        headers: headers);
    // print('Know us Response');
    // print(response);
    if (response['status']) {
      KnowUsResponseModal res = KnowUsResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> fetchSocialLinks() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.getData(Constants.END_POINT_SOCIAL_MEDIA,
        headers: headers);
    // print('Social Links Response');
    // print(response);
    if (response['status']) {
      SocialLinksResponseModal res =
          SocialLinksResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
