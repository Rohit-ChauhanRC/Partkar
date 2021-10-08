import '../modals/app_policy_responses.dart';
import '../modals/error_response.dart';
import '../resources/api_provider.dart';
import '../utilities/constants.dart';

class AppPolicyBloc {
  Future<dynamic> fetchpolicies() async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getData(Constants.END_POINT_APP_POLICY);
    // print('App Policies Response');
    // print(response);
    if (response['status']) {
      PoliciesResponseModal res = PoliciesResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
