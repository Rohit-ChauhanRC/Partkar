import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../bloc/notification_provider.dart';
import '../bloc/app_policy_provider.dart';
import '../bloc/general_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../widgets/spacer.dart';
import '../widgets/night_mode_setting.dart';
import '../modals/notification_responses.dart';
import 'notification_settings.dart';
import 'about_app.dart';
// import 'webview.dart';
import 'navigation_drawer.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  ClubColourModeModal colours = Setting().colours();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: _backButton(),
      title: Text(
        'Settings',
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

  Widget _backButton() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: colours.bgColour(),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            Space(verticle: 15),
            _divider(),
            Space(verticle: 15),
            _notificationOption(),
            Space(verticle: 15),
            _divider(),
            Space(verticle: 15),
            _nightModeOption(),
            Space(verticle: 15),
            _divider(),
            Space(verticle: 15),
            _mobileDataOption(),
            Space(verticle: 15),
            _divider(),
            Space(verticle: 15),
            _cachedDataOption(),
            Space(verticle: 15),
            _divider(),
            _optionAbout(context),
            _divider(),
            _optionHelp(context),
            _divider(),
            _optionContactDeveloper(context),
            _divider(),
            Space(verticle: 40),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    // return Container(
    //   margin: EdgeInsets.symmetric(horizontal: 20),
    //   child: Divider(),
    // );
    return Divider(height: 2, color: Colors.grey);
  }

  Widget _title() {
    return Text(
      'Features',
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _notificationOption() {
    NotificationBloc bloc = NotificationProvider.of(context);
    return FutureBuilder(
      future: bloc.fetchSettings(),
      builder: (cntxt, snapshot) {
        String notifStatus = 'On';
        var data = snapshot.data;
        NotificationSettingsModal pushData;
        // print('BUILDER');
        if (snapshot.hasData) {
          // print('has data');
          if (data is NotificationSettingsModal) {
            // print('is setting modal');
            pushData = data;
            if (data.notificationSettings.length > 0) {
              // print('has options');
              int status = data.notificationSettings[0].status;
              if (status != null) {
                // print('the status: $status');
                notifStatus = (status == 0) ? 'Off' : 'On';
              }
            }
          }
        }

        return GestureDetector(
          onTap: () async {
            if (pushData == null) return;
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => NotificationsSettingsScreen(
                        bloc: bloc, data: pushData)));
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: Constants.FONT_FAMILY_FUTURA,
                    fontSize: 18,
                    color: colours.bodyTextColour(),
                  ),
                ),
                pushData == null
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                colours.bodyTextColour())),
                      )
                    : Text(
                        notifStatus,
                        style: TextStyle(
                          fontFamily: Constants.FONT_FAMILY_FUTURA,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _nightModeOption() {
    return FutureBuilder(
      future: DataStore().getSelectedColourMode(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          return NightModeSettingWidget(
            mode: snapshot.data,
            onChange: () {
              setState(() {
                colours = Setting().colours();
              });
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _mobileDataOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mobileDataTitle(),
        Space(verticle: 8),
        _videoPodcastOption(),
        _audioPodcastOption(),
      ],
    );
  }

  Widget _mobileDataTitle() {
    return Text(
      'Use Mobile Data',
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _videoPodcastOption() {
    return Container(
      padding: EdgeInsets.only(left: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Video podcasts',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: colours.bodyTextColour().withOpacity(0.8),
            ),
          ),
          _videoPodcastSwitch(),
        ],
      ),
    );
  }

  Widget _videoPodcastSwitch() {
    return FutureBuilder(
      future: DataStore().getMobileDataStatusForVideoPodcasts(),
      builder: (cntxt, snapshot) {
        bool status = true;
        if (snapshot.hasData) {
          status = snapshot.data;
        }
        return Switch(
          value: status,
          activeColor: colours.headlineColour(),
          inactiveThumbColor: Colors.grey[350],
          onChanged: (newValue) async {
            await DataStore().saveMobileDataStatusForVideoPodcasts(newValue);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _audioPodcastOption() {
    return Container(
      padding: EdgeInsets.only(left: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Audio podcasts',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: colours.bodyTextColour().withOpacity(0.8),
            ),
          ),
          _audioPodcastSwitch(),
        ],
      ),
    );
  }

  Widget _audioPodcastSwitch() {
    return FutureBuilder(
      future: DataStore().getMobileDataStatusForAudioPodcasts(),
      builder: (cntxt, snapshot) {
        bool status = true;
        if (snapshot.hasData) {
          status = snapshot.data;
        }
        return Switch(
          value: status,
          activeColor: colours.headlineColour(),
          inactiveThumbColor: Colors.grey[350],
          onChanged: (newValue) async {
            await DataStore().saveMobileDataStatusForAudioPodcasts(newValue);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _cachedDataOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cachedDataTitle(),
        Space(verticle: 10),
        _cachedData(),
      ],
    );
  }

  Widget _cachedDataTitle() {
    return Text(
      'Cached files',
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _cachedData() {
    return FutureBuilder(
      future: _downloadSize(),
      builder: (cntxt, snapshot) {
        double size = 0;
        if (snapshot.hasData) {
          size = snapshot.data;
        }
        return Text(
          'Currently using ${size.toStringAsFixed(2)} Megabytes',
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 17,
            color: colours.bodyTextColour().withOpacity(0.8),
          ),
        );
      },
    );
    // _downloadSize();
    // return Text(
    //   'Currently using 0 Bytes',
    //   style: TextStyle(
    //     fontFamily: Constants.FONT_FAMILY_FUTURA,
    //     fontSize: 17,
    //     color: colours.bodyTextColour().withOpacity(0.8),
    //   ),
    // );
  }

  Future<double> _downloadSize() async {
    Directory dir = await _getDownloadDirectory();
    final intermediatePath = 'agape_podcast/';
    final dirPath = path.join(dir.path, intermediatePath);
    Directory dr = Directory(dirPath);
    // List<FileSystemEntity> files = dr.listSync();
    // print(dr.path);
    //int fileNum = 0;
    int totalSize = 0;
    try {
      if (dr.existsSync()) {
        dr
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            //fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }

    //print('fileNum: $fileNum, size: $totalSize');
    return (totalSize / 1024) / 1024;
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Widget _optionAbout(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Image.asset(
            'assets/images/LOGO.png',
            height: 30,
            width: 30,
          ),
          Space(horizontal: 10),
          Text(
            'About the app',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: colours.bodyTextColour(),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AppPolicyProvider(child: AboutAppScreen())));
      },
    );
  }

  Widget _optionHelp(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Image.asset(
            'assets/images/icon_help.png',
            height: 30,
            width: 30,
            color: colours.bodyTextColour(),
          ),
          Space(horizontal: 10),
          Text(
            'Help',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: colours.bodyTextColour(),
            ),
          ),
        ],
      ),
      onTap: () {
        //Navigator.of(context).pop();
      },
    );
  }

  Widget _optionContactDeveloper(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          // Image.asset(
          //   'assets/images/icon_help.png',
          //   height: 30,
          //   width: 30,
          //   color: colours.bodyTextColour(),
          // ),
          Icon(
            Icons.mail_rounded,
            color: colours.bodyTextColour(),
            size: 30,
          ),
          Space(horizontal: 10),
          Text(
            'Contact Developer',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: colours.bodyTextColour(),
            ),
          ),
        ],
      ),
      onTap: () async {
        String url = 'https://forms.gle/is6ebe6DyiAf3bK5A';
        if (await canLaunch(url)) {
          launch(url);
        }
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => WebViewScreen(
        //             title: 'Contact Developer',
        //             url: url)));
      },
    );
  }
}
