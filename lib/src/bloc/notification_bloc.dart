import 'package:flutter/material.dart';

import '../modals/error_response.dart';
import '../modals/notification_responses.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';

class NotificationBloc {
  Future<dynamic> fetchSettings() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider
        .getData(Constants.END_POINT_NOTIFICATION_SETTINGS, headers: headers);
    // print('Notification settings Response');
    // print(response);
    if (response['status']) {
      // print('got status');
      try {
        NotificationSettingsResponseModal res =
            NotificationSettingsResponseModal.fromJSON(response);
        // print('returning notif response');
        return res.data;
      } catch (e) {
        print('the exception');
        print(e);
      }
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> updateSettings(
      {@required String key,
      @required String group,
      @required int status}) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final body = {'group': group, 'key': key, 'status': status.toString()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.postData(
        Constants.END_POINT_NOTIFICATION_SETTINGS,
        headers: headers,
        body: body);
    // print('Notification update Response');
    // print(response);
    if (response['status']) {
      // print('got status');
      try {
        NotificationSettingsResponseModal res =
            NotificationSettingsResponseModal.fromJSON(response);
        // print('returning notif response');
        return res.data;
      } catch (e) {
        print('the exception');
        print(e);
      }
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> fetchNotifications() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider
        .getData(Constants.END_POINT_NOTIFICATIONS, headers: headers);
    // print('Notifications Response');
    // print(response);
    if (response['status']) {
      try {
        NotificationsResponseModal res =
            NotificationsResponseModal.fromJSON(response);
        return res.data;
      } catch (e) {
        print('the exception');
        print(e);
      }
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> fetchNotificationDetail(String id, String mode) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final selectedClub = (await DataStore().getSelectedClub());
    final apiProvider = ApiProvider();
    final response = await apiProvider.getData(
        Constants.END_POINT_NOTIFICATION_DETAIL(
            id, selectedClub.id.toString(), mode),
        headers: headers);
    // print('Notifications Response');
    // print(response);
    if (response['status']) {
      try {
        NotificationDetailResponseModal res =
            NotificationDetailResponseModal.fromJSON(response);
        return res.data.notificationDetail;
      } catch (e) {
        print('the exception');
        print(e);
      }
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }
}
