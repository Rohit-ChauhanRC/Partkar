import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'navigation_drawer.dart';
import 'home_tab.dart';
import 'bible_tab.dart';
import 'songs_tab.dart';
import 'podcasts_tab.dart';
import 'meetings_tab.dart';
import 'notification_bible_chapter.dart';
import 'song_details.dart';
import 'podcast_library.dart';
import 'event_detail.dart';
import 'webview.dart';
import '../bloc/home_provider.dart';
import '../bloc/bible_provider.dart';
import '../bloc/bible_reading_schedule_provider.dart';
import '../bloc/song_provider.dart';
import '../bloc/podcast_provider.dart';
import '../bloc/meeting_provider.dart';
// import '../bloc/settings_provider.dart';
import '../bloc/event_provider.dart';
import '../bloc/general_provider.dart';
import '../bloc/notification_provider.dart';
import '../widgets/spacer.dart';
import '../widgets/alert.dart';
import '../widgets/loader.dart';
import '../utilities/settings.dart';
import '../utilities/constants.dart';
import '../utilities/Helper.dart';
import '../resources/data_store.dart';
import '../modals/notification_responses.dart';
import '../modals/error_response.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  ClubColourModeModal colours = Setting().colours();

  TabController _homeTabController;

  void _handleTabChange() {
    // print('Tab changed to ${_homeTabController.previousIndex}');
    if (_homeTabController.indexIsChanging) {
      // if (!Helper.CHANGE_INDEX) {
      //   Helper.CHANGE_INDEX = true;
      //   return;
      // }
      // print('Home back checking');
      if (Helper.HOME_BACK_CLICKED) {
        Helper.HOME_BACK_CLICKED = false;
        return;
      }
      // print('Length checking');
      if (Helper.BACK_TRACK.length > 0) {
        // if ((Helper.BACK_TRACK.last != _homeTabController.previousIndex) &&
        //     (Helper.BACK_TRACK.last != _homeTabController.index)) {
        //   Helper.BACK_TRACK.add(_homeTabController.previousIndex);
        // }
        if (Helper.BACK_TRACK.last != _homeTabController.previousIndex) {
          Helper.BACK_TRACK.add(_homeTabController.previousIndex);
        }
      } else {
        Helper.BACK_TRACK.add(_homeTabController.previousIndex);
      }
      // Helper.CHANGE_INDEX = true;
      // print('New Trackback');
      // print(Helper.BACK_TRACK);
    }
  }

  @override
  void initState() {
    super.initState();
    _homeTabController = TabController(vsync: this, length: 5);
    Helper.TAB_CONTROLLER = _homeTabController;
    Helper.TAB_CONTROLLER.addListener(_handleTabChange);
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('The colours');
    // print(Setting().colours().toMap());
    print('Building home');
    return _body(context);
  }

  Widget _body(BuildContext context) {
    _helper();
    return FutureBuilder(
      future: DataStore().getSelectedColourMode(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          return _uiBuilder(context, snapshot.data);
        }
        return Container();
      },
    );
  }

  void _helper() {
    Future.delayed(Duration(seconds: 1), () async {
      // print('Sending handler build');
      // print(await DataStore().getTemp());
      Helper.HANDLE_NOTIFICATION();
    });
    Helper.HANDLE_NOTIFICATION = () {
      Map<String, dynamic> notifData = Helper.NOTIFICATION_INFO;
      // print(notifData);
      if (notifData == null) return;
      Helper.NOTIFICATION_INFO = null;
      PushNotificationModal notif =
          PushNotificationModal.fromJSON(jsonDecode(notifData['info']));
      // print('sending handle');
      _handleNotification(notif);
    };
  }

  // Widget _uiBuilder(BuildContext context, ColourModes mode) {
  //   SettingsBloc settingsBloc = SettingsProvider.of(context);
  //   GeneralBloc generalBloc = GeneralProvider.of(context);
  //   updateDeviceDetails(generalBloc);
  //   updateColourScheme(generalBloc);
  //   settingsBloc.changeColourMode(mode);
  //   //Check for update
  //   _checkVersion(generalBloc);
  //   return StreamBuilder(
  //     stream: settingsBloc.colourMode,
  //     builder: (cntxt, snapshot) {
  //       if (snapshot.hasData) {
  //         return _tabController(context, generalBloc);
  //       }
  //       return Container();
  //     },
  //   );
  // }

  Widget _uiBuilder(BuildContext context, ColourModes mode) {
    // SettingsBloc settingsBloc = SettingsProvider.of(context);
    GeneralBloc generalBloc = GeneralProvider.of(context);
    updateDeviceDetails(generalBloc);
    updateColourScheme(generalBloc);
    // settingsBloc.changeColourMode(mode);
    //Check for update
    _checkVersion(generalBloc);
    return _tabController(context, generalBloc);
    // return StreamBuilder(
    //   stream: settingsBloc.colourMode,
    //   builder: (cntxt, snapshot) {
    //     if (snapshot.hasData) {
    //       return _tabController(context, generalBloc);
    //     }
    //     return Container();
    //   },
    // );
  }

  _checkVersion(GeneralBloc generalBloc) async {
    String msg = await generalBloc.versionCheck();
    if (msg != null) {
      Future.delayed(Duration(seconds: 5), () {
        Alert.okCancel(context, 'Update', msg, okAction: () async {
          String url = 'http://onelink.to/rfgtut';
          if (await canLaunch(url)) {
            launch(url);
          }
        });
      });
    }
  }

  Widget _tabController(BuildContext context, GeneralBloc generalBloc) {
    // print('The colours');
    // print(Setting().colours().toMap());
    colours = Setting().colours();
    // Helper.NAVIGATION_BAR = _bottomBar(context, generalBloc);
    /*return DefaultTabController(
      length: 5,
      // initialIndex: 1,
      child: Scaffold(
        bottomNavigationBar: _bottomBar(context, generalBloc),
        endDrawer: GeneralProvider(child: NavigationDrawer()),
        body: _tabViewBuilder(generalBloc),
      ),
    );*/
    return Scaffold(
      bottomNavigationBar: _bottomBar(context, generalBloc),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      body: _tabViewBuilder(generalBloc),
    );
    // return WillPopScope(
    //   child: Scaffold(
    //     bottomNavigationBar: _bottomBar(context, generalBloc),
    //     endDrawer: GeneralProvider(child: NavigationDrawer()),
    //     body: _tabViewBuilder(generalBloc),
    //   ),
    //   onWillPop: () async {
    //     print('HOME BAck');
    //     Helper.HANDLE_BACK(context);
    //     return false;
    //   },
    // );
    // return CupertinoPageScaffold(
    //   child: CupertinoTabScaffold(
    //       tabBar: CupertinoTabBar(
    //         items: [
    //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    //           BottomNavigationBarItem(
    //               icon: Icon(Icons.settings), label: 'Settings')
    //         ],
    //       ),
    //       tabBuilder: (BuildContext context, index) {
    //         return _tabss(generalBloc, index);
    //       }),
    // );
  }

  Widget _tabViewBuilder(GeneralBloc generalBloc) {
    return TabBarView(
      // physics: NeverScrollableScrollPhysics(),
      controller: _homeTabController,
      children: <Widget>[
        HomeProvider(
          child: BibleReadingScheduleProvider(
            child: HomeTabScreen(
              generalBloc: generalBloc,
            ),
          ),
        ),
        BibleProvider(
          child: BibleTabScreen(
            generalBloc: generalBloc,
          ),
        ),
        SongProvider(
          child: SongsTabScreen(
            generalBloc: generalBloc,
          ),
        ),
        PodcastProvider(
          child: PodcastsTabScreen(
            generalBloc: generalBloc,
          ),
        ),
        MeetingProvider(
          child: MeetingsTabScreen(
            generalBloc: generalBloc,
          ),
        ),
      ],
    );
  }

  Widget _bottomBar(BuildContext context, GeneralBloc generalBloc) {
    return StreamBuilder(
      stream: generalBloc.displayTabbar,
      builder: (cntxt, snapshot) {
        bool hideTabbar = false;
        var data = snapshot.data;
        if ((data != null) && data) hideTabbar = true;
        return _tabbar(hideTabbar);
      },
    );
  }

  Widget _tabbar(bool hideTabbar) {
    var ww = AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: hideTabbar ? 0 : 68,
      color: Colors.transparent,
      child: Container(
        height: hideTabbar ? 0 : 67,
        color: colours.headlineColour(),
        padding: EdgeInsets.only(top: 0.7),
        child: Container(
          padding: EdgeInsets.only(bottom: 15),
          color: colours.bgColour(),
          child: TabBar(
            controller: _homeTabController,
            isScrollable: true,
            labelColor: colours.headlineColour(),
            unselectedLabelColor: colours.headlineColour().withOpacity(0.6),
            //indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            indicatorColor:
                hideTabbar ? Colors.transparent : colours.headlineColour(),
            tabs: _tabs(context),
          ),
        ),
      ),
    );
    return ww;
  }

  List<Widget> _tabs(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double tabWidth = width * 0.2;
    return [
      _tab('Home', 'assets/images/icon_home.png', tabWidth),
      _tab('Bible', 'assets/images/icon_Bible.png', tabWidth),
      _tab('Songs', 'assets/images/icon_songs.png', tabWidth),
      _tab('Podcasts', 'assets/images/icon_podcast.png', tabWidth),
      _tab('Meetings', 'assets/images/icon_meetings.png', tabWidth),
    ];
  }

  Widget _tab(String title, String iconResource, double width) {
    return Container(
      height: 50,
      width: width,
      padding: EdgeInsets.zero, //EdgeInsets.fromLTRB(8, 3, 8, 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        //color: Colors.blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Space(verticle: 2),
          Image.asset(
            iconResource,
            height: 25,
            width: 25,
            color: colours.headlineColour(),
          ),
          Space(verticle: 2),
          Text(
            title,
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /*void _handleNotification(PushNotificationModal notification) {
    // print(notification.type);
    // print(notification.notificationType);
    // print(notification.inAppType);
    if (notification.type == 'notification') {
      if (notification.notificationType == 'General') {
        if (notification.inAppType == 'bible_reading_schedule') {
          _processBibleReadingSchedule();
        } else if (notification.inAppType == 'bible_chapter') {
          _processBibleChapter(notification.bibleChapterId, 'Chapter');
        } else if (notification.inAppType == 'song') {
          _processSong(notification.songId.toString(), 'Song');
        } else if (notification.inAppType == 'podcast') {
          _processPodcast(notification.podcastLibraryId.toString(), 'Podcast');
        } else if (notification.inAppType == 'event') {
          _processEvent(notification.eventId.toString());
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WebViewScreen(
                      title: '', htmlData: notification.longDescription)));
        }
      } else if (notification.notificationType == 'Daily Bread') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => WebViewScreen(
                    title: '', htmlData: notification.longDescription)));
      } else if (notification.notificationType == 'Bible Reading Challenge') {
        _processBibleChapter(notification.bibleChapterId, 'Chapter');
      } else if (notification.notificationType == 'Info Page') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => WebViewScreen(
                    title: '', htmlData: notification.longDescription)));
      }
    } else if (notification.type == 'meeting') {
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => WebViewScreen(
                  title: '', htmlData: notification.longDescription)));
    }
  }*/

  void updateDeviceDetails(GeneralBloc generalBloc) async {
    if (!Helper.DEVICE_DETAILS_UPDATED) {
      await generalBloc.updateDeviceDetails();
      Helper.DEVICE_DETAILS_UPDATED = true;
    }
  }

  void updateColourScheme(GeneralBloc generalBloc) async {
    if (!Helper.COLOURS_UPDATED) {
      await generalBloc.updateColourScheme();
      Helper.COLOURS_UPDATED = true;
    }
  }

  void _handleNotification(PushNotificationModal notification) async {
    NotificationBloc bloc = NotificationProvider.of(context);
    // print('THISSSSS');
    // print(notification.type);
    // print(notification.id);
    // print(notification.type);
    // print(notification.inAppType);

    if (notification.type == 'notification') {
      if (notification.id == 0) {
        if (notification.inAppType == 'bible_reading_schedule') {
          // print('IT SHOULD WORK......');
          _processBibleReadingSchedule();
        } else if (notification.inAppType == 'bible_chapter') {
          _processBibleChapter(notification.bibleChapterId, 'Chapter');
        } else if (notification.inAppType == 'song') {
          _processSong(notification.songId.toString(), 'Song');
        } else if (notification.inAppType == 'podcast') {
          _processPodcast(notification.podcastLibraryId.toString(), 'Podcast');
        } else if (notification.inAppType == 'event') {
          _processEvent(notification.eventId.toString());
        }
        return;
      }
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
            _processBibleReadingSchedule();
          } else if (res.inAppType == 'bible_chapter') {
            _processBibleChapter(res.bibleChapterId, res.title);
          } else if (res.inAppType == 'song') {
            _processSong(res.songId.toString(), res.title);
          } else if (res.inAppType == 'podcast') {
            _processPodcast(res.podcastLibraryId.toString(), res.title);
          } else if (res.inAppType == 'event') {
            _processEvent(res.eventId.toString());
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                        title: res.title, htmlData: res.longDescription)));
          }
        } else if (res.notificationType == 'Daily Bread') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WebViewScreen(
                      title: res.title, htmlData: res.longDescription)));
        } else if (res.notificationType == 'Bible Reading Challenge') {
          _processBibleChapter(res.bibleChapterId, res.title);
        } else if (res.notificationType == 'Info Page') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WebViewScreen(
                      title: res.title, htmlData: res.longDescription)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WebViewScreen(
                      title: res.title, htmlData: res.longDescription)));
        }
      }
    }
  }

  void _processBibleReadingSchedule() async {
    // Navigator.of(context).pop();
    // Navigator.popUntil(context, (route) => route.isFirst);
    // // DefaultTabController.of(context).animateTo(1);
    await Future.delayed(Duration(microseconds: 1000), () {
      // Navigator.of(context).pop();
      Navigator.popUntil(context, (route) => route.isFirst);
      Helper.TAB_CONTROLLER.animateTo(1);
    });
  }

  void _processBibleChapter(int id, String title) {
    // print('Process bible chapter');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BibleProvider(
                child: NotificationBibleChapterScreen(
                    chapterId: id, title: title))));
  }

  void _processSong(String id, String title) {
    // print('Process song');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SongProvider(
                child: SongDetailScreen(
                    songId: id, title: title, songBloc: null))));
  }

  void _processPodcast(String id, String title) {
    // print('Process podcast');
    PodcastBloc bloc = PodcastProvider.of(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PodcastLibraryScreen(
                libraryId: id, libraryTitle: title, podcastBloc: bloc)));
  }

  void _processEvent(String id) {
    // print('Process events');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                EventProvider(child: EventDetailScreen(eventId: id))));
  }
}

///
