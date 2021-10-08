import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/meeting_provider.dart';
import '../bloc/event_provider.dart';
import '../bloc/general_provider.dart';
import '../bloc/notification_provider.dart';
import '../utilities/Helper.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
// import '../widgets/club_icon.dart';
import 'meetings.dart';
import 'events.dart';
import 'navigation_drawer.dart';
import 'notifications.dart';

class MeetingsTabScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  MeetingsTabScreen({@required this.generalBloc});

  @override
  State<MeetingsTabScreen> createState() {
    return _MeetingsTabScreenState(generalBloc: generalBloc);
  }
}

class _MeetingsTabScreenState extends State<MeetingsTabScreen>
    with
        AutomaticKeepAliveClientMixin<MeetingsTabScreen>,
        SingleTickerProviderStateMixin {
  ClubColourModeModal colours = Setting().colours();
  final GeneralBloc generalBloc;

  TabController _tabController;

  _MeetingsTabScreenState({@required this.generalBloc});

  @override
  bool get wantKeepAlive => true;

  Future<bool> _onPop() async {
    Helper.HOME_BACK_CLICKED = true;
    Helper.HANDLE_BACK(context);
    return false;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    colours = Setting().colours();
    return WillPopScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(),
              Container(
                height: 35,
                child: _tabbar(),
              )
            ],
          ),
        ),
        body: _body(),
        endDrawer: GeneralProvider(child: NavigationDrawer()),
        backgroundColor: colours.bgColour(),
      ),
      onWillPop: _onPop,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Meetings',
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      iconTheme: IconThemeData(color: colours.bgColour()),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      // leading: ClubIconWidget(),
      actions: [_notificationIcon(), _menuIcon()],
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
          size: 30,
          color: colours.bgColour(),
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
          size: 30,
          color: colours.bgColour(),
        ),
      ),
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }

  Widget _tabbar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.transparent,
      unselectedLabelColor: Colors.white.withOpacity(0.6),
      labelColor: Colors.white,
      labelPadding: EdgeInsets.all(5),
      tabs: [
        //Tab(text: 'rr'),
        _tab('Meetings', 90),
        _tab('Events', 60),
      ],
    );
  }

  Widget _tab(String title, double width) {
    return Container(
      height: 26,
      width: width,
      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: colours.accentColour(),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            color: colours.bgColour(),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        MeetingProvider(child: MeetingsScreen(generalBloc: generalBloc)),
        EventProvider(child: EventsScreen(generalBloc: generalBloc)),
      ],
    );
  }
}
