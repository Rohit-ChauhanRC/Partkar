import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../utilities/settings.dart';
import '../utilities/constants.dart';
import '../utilities/Helper.dart';
import '../bloc/home_provider.dart';
import '../bloc/know_us_provider.dart';
import '../bloc/bible_reading_schedule_provider.dart';
import '../bloc/podcast_provider.dart';
import '../bloc/notification_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/home_responses.dart';
import '../modals/error_response.dart';
import '../modals/know_us_responses.dart';
import '../modals/notification_responses.dart';
import '../widgets/alert.dart';
import '../widgets/spacer.dart';
import '../widgets/daily_bible_reading.dart';
import '../widgets/setting_summary.dart';
import '../widgets/notification_list.dart';
import '../widgets/club_icon.dart';
import '../resources/data_store.dart';
import 'get_to_know_us.dart';
import 'bible_schedule_read.dart';
import 'navigation_drawer.dart';
import 'notifications.dart';

class HomeTabScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  HomeTabScreen({@required this.generalBloc});

  @override
  State<HomeTabScreen> createState() {
    return _HomeTabScreenState(generalBloc: generalBloc);
  }
}

class _HomeTabScreenState extends State<HomeTabScreen>
    with AutomaticKeepAliveClientMixin<HomeTabScreen> {
  ClubColourModeModal colours = Setting().colours();
  final GeneralBloc generalBloc;
  ScrollController scrollController = ScrollController();

  _HomeTabScreenState({@required this.generalBloc});

  List<_HomeOptions> options = [
    _HomeOptions('BIBLE', 'assets/images/icon_home-page-bible.png'),
    _HomeOptions('SONG BOOK', 'assets/images/icon_home-page-songs.png'),
    _HomeOptions('PODCASTS', 'assets/images/icon_home-page-podcasts.png'),
    _HomeOptions(
        'MEETINGS & EVENTS', 'assets/images/icon_home-page-meetings.png'),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (Helper.showTabbar) {
          Helper.showTabbar = false;
          generalBloc.changeDisplayTabbar(false);
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!Helper.showTabbar) {
          Helper.showTabbar = true;
          generalBloc.changeDisplayTabbar(true);
        }
      }
    });
  }

  Future<bool> _onPop() async {
    Helper.HOME_BACK_CLICKED = true;
    Helper.HANDLE_BACK(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    colours = Setting().colours();
    return WillPopScope(
      child: Scaffold(
        appBar: _appBar(),
        body: _body(context),
        endDrawer: GeneralProvider(child: NavigationDrawer()),
        backgroundColor: colours.bgColour(),
      ),
      onWillPop: _onPop,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Home',
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.headlineColour(),
        ),
      ),
      backgroundColor: colours.bgColour(), //colours.headlineColour(),
      systemOverlayStyle: Setting().mode() == ColourModes.day
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      leading: ClubIconWidget(colourMode: Setting().mode()),
      actions: [_notificationIcon(), _menuIcon()],
      bottom: PreferredSize(
        child: Container(
          color: colours.headlineColour(),
          height: 2.0,
        ),
        preferredSize: Size.fromHeight(2.0),
      ),
    );
  }

  Widget _notificationIcon() {
    return GestureDetector(
      child: Container(
        // width: 30,
        // height: 30,
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(10, 0, 7, 0),
        child: Icon(
          Icons.notifications_rounded,
          color: colours.headlineColour(),
          size: 30,
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    NotificationProvider(child: NotificationsScreen())));
      },
    );
  }

  Widget _menuIcon() {
    return GestureDetector(
      child: Container(
        // width: 30,
        // height: 30,
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(7, 0, 15, 0),
        child: Icon(
          Icons.menu_rounded,
          color: colours.headlineColour(),
          size: 30,
        ),
      ),
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }

  Widget _body(BuildContext context) {
    // print('Building Home Tab');
    Helper.RELOAD_HOME_TAB = () {
      setState(() {});
    };
    final HomeBloc homeBloc = HomeProvider.of(context);
    return FutureBuilder(
      future: homeBloc.fetchData(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          // print('data');
          // print(data);
          if (data is HomeDataModal) {
            // print('building list');
            return _viewBuilder(context, homeBloc, data);
          } else if (data is ErrorResponseModel) {
            Alert.defaultAlert(context, 'Error', data.message);
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        }
        return Text(''); //
      },
    );
  }

  Widget _viewBuilder(
      BuildContext context, HomeBloc homeBloc, HomeDataModal homeDataModal) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          _notifications(homeDataModal.notifications),
          DailyBibleReadingWidget(
            homeReadings: homeDataModal.bibleReadings,
            reloadData: () {
              setState(() {});
            },
          ),
          Space(verticle: 50),
          SettingSummaryWidget(
            summary: homeDataModal.summary,
            onReadPressed: () {
              final BibleReadingScheduleBloc bloc =
                  BibleReadingScheduleProvider.of(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BibleScheduleReadScreen(
                          bloc: bloc,
                          readings:
                              homeDataModal.bibleReadings.todayReadings)));
            },
          ),
          Space(verticle: 50),
          homeDataModal.getToKnowUs.length > 0
              ? _knowUs(
                  context, homeDataModal.getToKnowUs[0], homeDataModal.mediaUrl)
              : Container(),
          Space(verticle: 50),
          _gridBuilder(context),
          Space(verticle: 50),
        ],
      ),
    );
  }

  Widget _notifications(List<NotificationModal> notifications) {
    return FutureBuilder(
      future: DataStore().hiddenNotificationIds(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data is List<String>) {
            for (String id in snapshot.data) {
              notifications
                  .removeWhere((element) => element.id.toString() == id);
            }
          }
        }
        return _notificationList(notifications);
      },
    );
  }

  Widget _notificationList(List<NotificationModal> notifications) {
    if ((notifications == null) || (notifications.length == 0)) {
      return Container();
    } else {
      return Column(
        children: [
          _notificationTitle('Notifications'),
          NotificationProvider(
              child: PodcastProvider(
                  child: NotificationList(
            notifications: notifications,
            scorllable: false,
            hide: true,
            onHideNotification: () {
              setState(() {});
            },
          ))),
        ],
      );
    }
  }

  Widget _notificationTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_TIMES,
            color: colours.headlineColour(),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  Widget _knowUs(BuildContext context, KnowUsModal knowUs, String mediaUrl) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: size.width * 0.85,
          color: colours.headlineColour(),
          child: _knowUsHeader(context, knowUs, mediaUrl),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => KnowUsProvider(child: GetToKnowUsScreen())));
      },
    );
  }

  Widget _knowUsHeader(
      BuildContext context, KnowUsModal knowUs, String mediaUrl) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          // width: size.width * 0.9,
          height: size.width * 0.35,
          child: Image.network(mediaUrl + knowUs.mainImage, fit: BoxFit.cover),
        ),
        // Image.network(mediaUrl + podcastLibrary.coverImage, fit: BoxFit.cover),
        //Space(verticle: 12),
        // Expanded(
        /*child: */ Align(
          alignment: Alignment.center,
          child: Text(
            knowUs.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: colours.bgColour(),
            ),
          ),
        ),
        // ),
      ],
    );
  }

  Widget _gridBuilder(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      crossAxisCount: 2,
      crossAxisSpacing: size.width * 0.05,
      mainAxisSpacing: size.width * 0.05,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      children: List.generate(
        options.length,
        (index) {
          return GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: colours.headlineColour(),
                child: _listItem(options[index], size),
              ),
            ),
            onTap: () {
              Helper.TAB_CONTROLLER.animateTo(index + 1);
            },
          );
        },
      ),
    );
  }

  Widget _listItem(_HomeOptions option, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.43,
          height: size.width * 0.43,
          child: Container(
            color: colours.accentColour(),
            child: Image.asset(
              option.imageUrl,
              color: Colors.white,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Image.network(mediaUrl + podcastLibrary.coverImage, fit: BoxFit.cover),
        //Space(verticle: 12),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              option.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colours.bgColour(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeOptions {
  String name;
  String imageUrl;

  _HomeOptions(this.name, this.imageUrl);
}
