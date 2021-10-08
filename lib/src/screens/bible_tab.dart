import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bible_schedule.dart';
import 'bible.dart';
import 'bible_settings.dart';
import 'navigation_drawer.dart';
import 'notifications.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../bloc/bible_settings_provider.dart';
import '../bloc/bible_reading_schedule_provider.dart';
import '../bloc/notification_provider.dart';
import '../bloc/general_provider.dart';
// import '../widgets/club_icon.dart';

class BibleTabScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  BibleTabScreen({@required this.generalBloc});

  @override
  State<BibleTabScreen> createState() {
    return _BibleTabScreenState(generalBloc: generalBloc);
  }
}

class _BibleTabScreenState extends State<BibleTabScreen>
    with AutomaticKeepAliveClientMixin<BibleTabScreen> {
  ClubColourModeModal colours = Setting().colours();
  final GeneralBloc generalBloc;

  _BibleTabScreenState({@required this.generalBloc});

  @override
  bool get wantKeepAlive => true;

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
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 38),
            child: Container(
              // constraints: BoxConstraints(maxHeight: 150),
              // height: kToolbarHeight + 38 + 44,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _appBar(),
                  Container(
                    height: 35,
                    child: _tabbar(),
                    //color: colours.bgColour(),
                  )
                ],
              ),
            ),
          ),
          body: _body(),
          endDrawer: GeneralProvider(child: NavigationDrawer()),
          backgroundColor: colours.bgColour(),
        ),
      ),
      onWillPop: _onPop,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Bible',
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      iconTheme: IconThemeData(color: colours.bgColour()),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      //leading: ClubIconWidget(),
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
      isScrollable: true,
      indicatorColor: Colors.transparent,
      unselectedLabelColor: Colors.white.withOpacity(0.6),
      labelColor: Colors.white,
      labelPadding: EdgeInsets.all(5),
      tabs: [
        //Tab(text: 'rr'),
        _tab('Reading Schedule', 150),
        _tab('Bible', 55),
        _tab('Settings', 74),
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
      children: [
        BibleReadingScheduleProvider(
            child: BibleScheduleScreen(generalBloc: generalBloc)),
        BibleScreen(generalBloc: generalBloc),
        BibleSettingsProvider(
            child: BibleSettingsScreen(generalBloc: generalBloc)),
      ],
    );
  }
}
