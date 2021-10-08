import 'package:agape/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import '../widgets/spacer.dart';
import '../widgets/alert.dart';
import '../resources/data_store.dart';
import '../bloc/club_provider.dart';
import '../bloc/login_provider.dart';
import '../bloc/know_us_provider.dart';
import '../bloc/profile_provider.dart';
import '../bloc/app_policy_provider.dart';
import '../bloc/notification_provider.dart';
import '../bloc/general_provider.dart';
import '../bloc/discipleship_provider.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../modals/error_response.dart';
import '../modals/success_responses.dart';
import 'login.dart';
import 'club_selector.dart';
import 'get_to_know_us.dart';
import 'settings.dart';
import 'profile.dart';
import 'podcast_downloads.dart';
import 'about_app.dart';
import 'notifications.dart';
import 'discipleship.dart';

class NavigationDrawer extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();
  @override
  Widget build(BuildContext context) {
    // if (Helper.TAB_CONTROLLER == null) {
    //   print('assigning tab controller');
    //   Helper.TAB_CONTROLLER = DefaultTabController.of(context);
    // }
    final drawerWidth = MediaQuery.of(context).size.width * 0.7;
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        elevation: 0,
        child: Container(
          color: colours.bgColour(),
          child: SafeArea(
            child: _optionList(context),
          ),
        ),
      ),
    );
  }

  Widget _optionList(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        _header(context),
        _optionSettings(context),
        _optionAbout(context),
        _optionHelp(context),
        _optionShare(context),
        _optionHome(context),
        _optionBible(context),
        _optionSongs(context),
        _optionPodcasts(context),
        _optiondiscipleship(context),
        _downloads(context),
        _optionMeetings(context),
        _optionKnowUs(context),
        _optionNotifications(context),
        _optionLogout(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Space(horizontal: 10),
          SizedBox(
            height: 60,
            width: 60,
            child: _userIcon(),
          ),
          Space(horizontal: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _userName(),
              _editProfileButton(),
            ],
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ClubProvider(
                    child: ProfileProvider(child: ProfileScreen()))));
      },
    );
  }

  Widget _userIcon() {
    final double imageSize = 40;
    return FutureBuilder(
      future: DataStore().getUser(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          if ((data.profileImage != null) && (data.profileImage != '')) {
            String profileImageUrl = data.profileImageUrl + data.profileImage;
            return ClipRRect(
              borderRadius: BorderRadius.circular(imageSize),
              child: Image.network(
                profileImageUrl,
                fit: BoxFit.cover,
                width: imageSize,
                height: imageSize,
              ),
            );
          }
        }

        return Center(child: Icon(Icons.account_circle_outlined, size: 40));
      },
    );
  }

  Widget _userName() {
    return FutureBuilder(
      future: DataStore().getUser(),
      builder: (cntxt, snapshot) {
        String name = '';
        if (snapshot.hasData) {
          name = snapshot.data.fullName;
        }
        return Text(
          name,
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 18,
            color: colours.bodyTextColour(),
          ),
        );
      },
    );
  }

  Widget _editProfileButton() {
    return Text(
      'Edit profile',
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _optionSettings(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: Icon(
              Icons.settings_rounded,
              color: colours.bodyTextColour(),
              size: 30,
            ),
          ),
          Space(horizontal: 12),
          Text('Settings', style: _textStyle()),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
        //Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => NotificationProvider(child: SettingsScreen())));
      },
    );
  }

  Widget _optionAbout(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/LOGO.png',
            height: 25,
            width: 25,
            //color: colours.bodyTextColour(),
          ),
          Space(horizontal: 12),
          Text('About the app', style: _textStyle()),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
        //Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AppPolicyProvider(child: AboutAppScreen())));
      },
    );
  }

  Widget _optionHelp(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_help.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 12),
          Text('Help', style: _textStyle()),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
        //Navigator.popUntil(context, (route) => route.isFirst);
      },
    );
  }

  Widget _optionShare(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_share.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 8),
          Text('Share with friends', style: _textStyle()),
        ],
      ),
      onTap: () async {
        Navigator.of(context).pop();
        //Navigator.popUntil(context, (route) => route.isFirst);
        GeneralBloc generalBloc = GeneralProvider.of(context);
        Loader.showLoading(context);
        var res = await generalBloc.shareDetails();
        Navigator.of(context).pop();
        if (res != null) {
          Share.share(res, subject: 'Partaker app');
        }
      },
    );
  }

  Widget _optionHome(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_home.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 8),
          Text('Home', style: _textStyle()),
        ],
      ),
      onTap: () async {
        Navigator.of(context).pop();
        Navigator.popUntil(context, (route) => route.isFirst);
        // DefaultTabController.of(context).animateTo(0);
        await Future.delayed(Duration(microseconds: 1000), () {
          Helper.TAB_CONTROLLER.animateTo(0);
        });
      },
    );
  }

  Widget _optionBible(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_Bible.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 8),
          Text('Bible', style: _textStyle()),
        ],
      ),
      onTap: () async {
        Navigator.of(context).pop();
        Navigator.popUntil(context, (route) => route.isFirst);
        // DefaultTabController.of(context).animateTo(1);
        await Future.delayed(Duration(microseconds: 1000), () {
          Helper.TAB_CONTROLLER.animateTo(1);
        });
      },
    );
  }

  Widget _optionSongs(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_songs.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 8),
          Text('Songs', style: _textStyle()),
        ],
      ),
      onTap: () async {
        Navigator.of(context).pop();
        Navigator.popUntil(context, (route) => route.isFirst);
        // DefaultTabController.of(context).animateTo(2);
        await Future.delayed(Duration(microseconds: 1000), () {
          Helper.TAB_CONTROLLER.animateTo(2);
        });
      },
    );
  }

  Widget _optionPodcasts(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_podcast.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 8),
          Text('Podcasts', style: _textStyle()),
        ],
      ),
      onTap: () async {
        Navigator.of(context).pop();
        Navigator.popUntil(context, (route) => route.isFirst);
        // DefaultTabController.of(context).animateTo(3);
        await Future.delayed(Duration(microseconds: 1000), () {
          Helper.TAB_CONTROLLER.animateTo(3);
        });
      },
    );
  }

  Widget _optiondiscipleship(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_podcast.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 8),
          Text('Discipleship', style: _textStyle()),
        ],
      ),
      onTap: () async {
        Navigator.of(context).pop();
        //Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    DiscipleshipProvider(child: DiscipleshipScreen())));
      },
    );
  }

  Widget _downloads(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: Icon(
              Icons.download_rounded,
              color: colours.bodyTextColour(),
              size: 30,
            ),
          ),
          Space(horizontal: 8),
          Text('Downloads', style: _textStyle()),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
        //Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => PodcastDownloadsScreen()));
      },
    );
  }

  Widget _optionMeetings(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_meetings.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 8),
          Text('Meetings & events', style: _textStyle()),
        ],
      ),
      onTap: () async {
        Navigator.of(context).pop();
        Navigator.popUntil(context, (route) => route.isFirst);
        // DefaultTabController.of(context).animateTo(4);
        await Future.delayed(Duration(microseconds: 1000), () {
          Helper.TAB_CONTROLLER.animateTo(4);
        });
      },
    );
  }

  Widget _optionKnowUs(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_get-to-know-us.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 8),
          Text('Get to know us', style: _textStyle()),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
        //Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => KnowUsProvider(child: GetToKnowUsScreen())));
      },
    );
  }

  Widget _optionNotifications(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: Icon(
              Icons.notifications_rounded,
              color: colours.bodyTextColour(),
              size: 30,
            ),
          ),
          Space(horizontal: 8),
          Text('Notifications', style: _textStyle()),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
        //Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    NotificationProvider(child: NotificationsScreen())));
      },
    );
  }

  Widget _optionLogout(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      dense: true,
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_logout.png',
            height: 25,
            width: 25,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 8),
          Text('Log out', style: _textStyle()),
        ],
      ),
      onTap: () async {
        GeneralBloc generalBloc = GeneralProvider.of(context);
        Loader.showLoading(context);
        var res = await generalBloc.logout();
        Navigator.of(context).pop();
        if (res is SuccessResponseModel) {
          _performLogout(context);
        } else if (res is ErrorResponseModel) {
          Alert.defaultAlert(context, 'Error', res.message);
        } else {
          Alert.defaultAlert(context, 'Error', 'Please try later.');
        }
      },
    );
  }

  void _performLogout(BuildContext context) async {
    Navigator.of(context).pop();
    Navigator.popUntil(context, (route) => route.isFirst);
    DataStore().removeAllData();
    final mediaUrl = await DataStore().getClubMediaUrl();
    final club = await DataStore().getSelectedClub();
    if ((mediaUrl != null) && (club != null)) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (cntxt) => LoginProvider(
                  child: ClubProvider(
                      child: LoginScreen(mediaUrl: mediaUrl, club: club)))));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (cntxt) =>
                  ClubProvider(child: ClubSelectorScreen(fromSplash: true))));
    }
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontFamily: Constants.FONT_FAMILY_FUTURA,
      fontSize: 17,
      color: colours.bodyTextColour(),
    );
  }
}
