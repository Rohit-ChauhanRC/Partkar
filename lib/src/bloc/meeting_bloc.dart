// import 'package:rxdart/rxdart.dart';
import '../utilities/constants.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../modals/meeting_responses.dart';
import '../modals/error_response.dart';

class MeetingBloc {
  Future<dynamic> fetchMeetings() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.getData(Constants.END_POINT_MEETINGS,
        headers: headers);
    // print('MEETINGS Response');
    // print(response);
    if (response['status']) {
      MeetingsResponseModal res = MeetingsResponseModal.fromJSON(response);
      return res.data.meetings;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
