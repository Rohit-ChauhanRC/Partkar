import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';
import '../modals/error_response.dart';
import '../modals/bible_responses.dart';
// import '../modals/success_responses.dart';

class BibleReadingScheduleBloc {
  Future<dynamic> fetch(String date) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final body = {'request_date': date};
    final apiProvider = ApiProvider();
    final response = await apiProvider.postData(
        Constants.END_POINT_BIBLE_READING_SCHEDULE,
        headers: headers,
        body: body);
    // print('BIBLE Reading Schedule Response');
    // print(response);
    if (response['status']) {
      try {
        BibleReadingTrackResponseModal ress =
            BibleReadingTrackResponseModal.fromJSON(response);

        return ress.data.readings;
      } catch (e) {}

      BibleReadingScheduleResponseModal res =
          BibleReadingScheduleResponseModal.fromJSON(response);
      if (res.data == null) {
        BibleReadingTrackResponseModal ress =
            BibleReadingTrackResponseModal.fromJSON(response);

        return ress.data.readings;
      }

      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> fetchReading(String id) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final body = {'reading_id': id};
    final apiProvider = ApiProvider();
    final response = await apiProvider.postData(
        Constants.END_POINT_BIBLE_READING,
        headers: headers,
        body: body);
    // print('BIBLE Reading Response');
    // print(response);
    if (response['status']) {
      BibleReadingResponseModal res =
          BibleReadingResponseModal.fromJSON(response);
      return {'id': id, 'response': res};
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> trackReading(String id, {String scheduleId}) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    Map<String, dynamic> body = {'reading_id': id};
    if (scheduleId != null) {
      body['schedule_id'] = scheduleId;
    }
    final apiProvider = ApiProvider();
    final response = await apiProvider.postData(
        Constants.END_POINT_BIBLE_READ_TRACKING,
        headers: headers,
        body: body);
    // print('BIBLE Reading track Response');
    // print(response);
    if (response['status']) {
      BibleNextReadingResponseModal res =
          BibleNextReadingResponseModal.fromJSON(response);
      return res.data.nextReadingInfo;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
