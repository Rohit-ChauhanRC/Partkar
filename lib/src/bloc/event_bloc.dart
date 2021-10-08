import '../utilities/constants.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../modals/event_responses.dart';
import '../modals/error_response.dart';

class EventBloc {
  Future<dynamic> fetchEvents() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response =
        await apiProvider.getData(Constants.END_POINT_EVENTS, headers: headers);
    // print('EVENTS Response');
    // print(response);
    if (response['status']) {
      EventsResponseModal res = EventsResponseModal.fromJSON(response);
      return res.data.events;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> fetchEventDetail(String eventId, String mode) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final selectedClub = (await DataStore().getSelectedClub());
    final apiProvider = ApiProvider();
    final response = await apiProvider.getData(
        Constants.END_POINT_EVENT_DETAILS(
            eventId, selectedClub.id.toString(), mode),
        headers: headers);
    // print('EVENTS Response');
    // print(response);
    if (response['status']) {
      EventDetailResponseModal res =
          EventDetailResponseModal.fromJSON(response);
      return res.data.eventInfo;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
