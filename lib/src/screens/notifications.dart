import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/notification_provider.dart';
import '../bloc/podcast_provider.dart';
import '../bloc/general_provider.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../widgets/notification_list.dart';
import '../modals/notification_responses.dart';
import '../modals/error_response.dart';
import 'navigation_drawer.dart';

class NotificationsScreen extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: _backButton(context),
      title: Text(
        'Notifications',
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      iconTheme: IconThemeData(color: colours.bgColour()),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _backButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: colours.bgColour(),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _body(BuildContext context) {
    NotificationBloc notificationBloc = NotificationProvider.of(context);
    return FutureBuilder(
      future: notificationBloc.fetchNotifications(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data is ErrorResponseModel) {
            return Center(child: Text(data.message));
          } else if (data is NotificationsModal) {
            return PodcastProvider(
                child: NotificationList(
              notifications: data.notifications,
              onHideNotification: () {},
            ));
          } else {
            return Center(child: Text('Error, Try again later.'));
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        }
      },
    );
  }
}
