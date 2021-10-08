import 'package:agape/src/resources/data_store.dart';
import 'package:agape/src/screens/notification_bible_chapter.dart';
import 'package:agape/src/screens/podcast_library.dart';
import 'package:agape/src/widgets/spacer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/notification_provider.dart';
import '../bloc/event_provider.dart';
import '../bloc/bible_provider.dart';
import '../bloc/song_provider.dart';
import '../bloc/podcast_provider.dart';
import '../modals/notification_responses.dart';
import '../modals/error_response.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../screens/event_detail.dart';
import '../screens/song_details.dart';
import '../screens/webview.dart';
import 'loader.dart';
import 'alert.dart';

class NotificationList extends StatefulWidget {
  final List<NotificationModal> notifications;
  final bool scorllable;
  final Function onHideNotification;
  final bool hide;

  NotificationList(
      {@required this.notifications,
      this.scorllable = true,
      @required this.onHideNotification,
      this.hide = false});

  @override
  State<StatefulWidget> createState() {
    return _NotificationListState(
        notifications: notifications,
        scorllable: scorllable,
        onHideNotification: onHideNotification,
        hide: hide);
  }
}

class _NotificationListState extends State<NotificationList> {
  ClubColourModeModal colours = Setting().colours();
  final Function onHideNotification;
  final bool hide;
  List<NotificationModal> notifications;
  final bool scorllable;

  _NotificationListState(
      {@required this.notifications,
      this.scorllable = true,
      this.onHideNotification,
      this.hide});

  @override
  Widget build(BuildContext context) {
    colours = Setting().colours();
    NotificationBloc bloc = NotificationProvider.of(context);
    return _notificationList(bloc);
    // return FutureBuilder(
    //   future: DataStore().hiddenNotificationIds(),
    //   builder: (_, snapshot) {
    //     if (hide) {
    //       if (snapshot.hasData) {
    //         final data = snapshot.data;
    //         if (data is List<String>) {
    //           for (String id in snapshot.data) {
    //             notifications
    //                 .removeWhere((element) => element.id.toString() == id);
    //           }
    //         }
    //       }
    //     }
    //     return _notificationList(bloc);
    //   },
    // );
  }

  Widget _notificationList(NotificationBloc bloc) {
    return ListView.builder(
      shrinkWrap: true,
      physics:
          scorllable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (cntxt, index) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: _itemDecoration(),
            child: _listItem(notifications[index]),
          ),
          onTap: () {
            _notificationSelected(context, notifications[index], bloc);
          },
        );
      },
    );
  }

  Widget _listItem(NotificationModal notification) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        _hideButton(notification.id),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _date(notification.notificationDateTime),
            Space(verticle: 8),
            _title(notification.title),
            _description(notification.shortDescription),
          ],
        ),
        _arrow(notification),
      ],
    );
  }

  BoxDecoration _itemDecoration() {
    return BoxDecoration(
      gradient: new LinearGradient(
        colors: [
          colours.gradientStartColour(),
          colours.gradientEndColour(),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
        //tileMode: TileMode.clamp,
      ),
    );
  }

  Widget _hideButton(int notifId) {
    return hide
        ? Container(
            alignment: Alignment.topRight,
            height: 26,
            width: 40,
            padding: EdgeInsets.only(right: 10),
            child: TextButton(
              child: Icon(
                Icons.cancel,
                color: colours.accentColour(),
              ),
              onPressed: () async {
                // print('Hide');
                await DataStore().hideNotification(notifId);
                onHideNotification();
              },
            ),
          )
        : Container();
  }

  Widget _arrow(NotificationModal notification) {
    return notification.type == 'notification'
        ? Positioned(
            bottom: 0,
            right: -5,
            child: Icon(
              Icons.chevron_right_rounded,
              color: colours.accentColour(),
              size: 25,
            ),
          )
        : Container();
  }

  Widget _date(String dateString) {
    final givenFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime givenDate = givenFormat.parse(dateString);
    final DateFormat newFormat = DateFormat('EEEE, MMMM d, yyyy h:mm a');
    final String formattedDate = newFormat.format(givenDate);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        formattedDate,
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: 16,
          color: colours.bodyTextColour(),
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colours.bodyTextColour(),
        ),
      ),
    );
  }

  Widget _description(String description) {
    return Html(
      data: description
          .replaceAll('&nbsp;', ' ')
          .replaceAll('<strong>', ' <strong>'),
      shrinkWrap: true,
      onLinkTap: (String url, cntxt, map, element) async {
        if (await canLaunch(url)) {
          launch(url);
        }
      },
      style: {
        'p': Style(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: FontSize(16),
          fontWeight: FontWeight.w200,
          padding: EdgeInsets.zero,
          color: colours.bodyTextColour(),
        ),
        'a': Style(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: FontSize(16),
          fontWeight: FontWeight.w700,
          padding: EdgeInsets.zero,
          color: colours.headlineColour(),
        ),
        'i': Style(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: FontSize(16),
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          padding: EdgeInsets.zero,
          color: colours.headlineColour(),
        ),
        'html': Style(
          padding: EdgeInsets.zero,
          color: colours.bodyTextColour(),
        ),
        'body': Style(
          padding: EdgeInsets.zero,
          color: colours.bodyTextColour(),
        ),
        'div': Style(
          padding: EdgeInsets.zero,
          color: colours.bodyTextColour(),
        ),
      },
    );
  }

  void _notificationSelected(BuildContext context,
      NotificationModal notification, NotificationBloc bloc) async {
    if (notification.type == 'notification') {
      Loader.showLoading(context);
      String mode = Setting().mode() == ColourModes.day ? 'day' : 'night';
      var res =
          await bloc.fetchNotificationDetail(notification.id.toString(), mode);
      Navigator.pop(context);
      if (res is ErrorResponseModel) {
        Alert.defaultAlert(context, 'Error', res.message);
      } else if (res is NotificationDetailModal) {
        // print('Got right');
        // print(res.notificationType);
        // print(res.inAppType);
        if (res.notificationType == 'General') {
          if (res.inAppType == 'bible_reading_schedule') {
            _proceBibleReadingSchedule(context);
          } else if (res.inAppType == 'bible_chapter') {
            _processBibleChapter(
                context, res.bibleChapterId, notification.title);
          } else if (res.inAppType == 'song') {
            _processSong(context, res.songId.toString(), notification.title);
          } else if (res.inAppType == 'podcast') {
            _processPodcast(
                context, res.podcastLibraryId.toString(), notification.title);
          } else if (res.inAppType == 'event') {
            _processEvent(context, res.eventId.toString());
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                        title: notification.title,
                        htmlData: res.longDescription)));
          }
        } else if (res.notificationType == 'Daily Bread') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WebViewScreen(
                      title: notification.title,
                      htmlData: res.longDescription)));
        } else if (res.notificationType == 'Bible Reading Challenge') {
          _processBibleChapter(context, res.bibleChapterId, notification.title);
        } else if (res.notificationType == 'Info Page') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WebViewScreen(
                      title: notification.title,
                      htmlData: res.longDescription)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WebViewScreen(
                      title: notification.title,
                      htmlData: res.longDescription)));
        }
      }
    }
  }

  void _proceBibleReadingSchedule(BuildContext context) async {
    Navigator.of(context).pop();
    Navigator.popUntil(context, (route) => route.isFirst);
    // DefaultTabController.of(context).animateTo(1);
    await Future.delayed(Duration(microseconds: 1000), () {
      Helper.TAB_CONTROLLER.animateTo(1);
    });
  }

  void _processBibleChapter(BuildContext context, int id, String title) {
    // print('Process bible chapter');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BibleProvider(
                child: NotificationBibleChapterScreen(
                    chapterId: id, title: title))));
  }

  void _processSong(BuildContext context, String id, String title) {
    // print('Process song');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SongProvider(
                child: SongDetailScreen(
                    songId: id, title: title, songBloc: null))));
  }

  void _processPodcast(BuildContext context, String id, String title) {
    // print('Process podcast');
    PodcastBloc bloc = PodcastProvider.of(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PodcastLibraryScreen(
                libraryId: id, libraryTitle: title, podcastBloc: bloc)));
  }

  void _processEvent(BuildContext context, String id) {
    // print('Process events');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                EventProvider(child: EventDetailScreen(eventId: id))));
  }
}
