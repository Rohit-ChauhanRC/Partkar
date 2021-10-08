import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/notification_provider.dart';
import '../bloc/general_provider.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../widgets/loader.dart';
import '../modals/notification_responses.dart';
import 'navigation_drawer.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  final NotificationBloc bloc;
  final NotificationSettingsModal data;

  NotificationsSettingsScreen({@required this.bloc, @required this.data});

  @override
  State<NotificationsSettingsScreen> createState() {
    return _NotificationsSettingsScreenState(bloc: bloc, data: data);
  }
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  ClubColourModeModal colours = Setting().colours();
  final NotificationBloc bloc;
  NotificationSettingsModal data;

  _NotificationsSettingsScreenState({@required this.bloc, @required this.data});

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
        'Notification Settings',
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
    return ListView.separated(
      itemBuilder: (cntxt, index) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: _listItem(data.notificationSettings[index], index),
        );
      },
      separatorBuilder: (cntxt, index) {
        return Divider(height: 2, color: Colors.grey);
      },
      itemCount: data.notificationSettings.length,
    );
  }

  Widget _listItem(NotificationSettingModal settingOption, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              settingOption.title,
              style: TextStyle(
                color: colours.bodyTextColour(),
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 20,
              ),
            ),
            _mainSwitch(index),
          ],
        ),
        Text(
          settingOption.description,
          style: TextStyle(
            color: colours.bodyTextColour().withOpacity(0.6),
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 16,
          ),
        ),
        _listOptions(settingOption, index),
      ],
    );
  }

  Widget _mainSwitch(int index) {
    int status = data.notificationSettings[index].status;
    if (status == null) {
      return Container();
    } else {
      return Switch(
        value: status == 0 ? false : true,
        activeColor: colours.headlineColour(),
        inactiveThumbColor: Colors.grey[350],
        onChanged: (newValue) async {
          data.notificationSettings[index].status = newValue ? 1 : 0;
          setState(() {});
          Loader.showLoading(context);
          var res = await bloc.updateSettings(
            key: data.notificationSettings[index].key,
            group: data.notificationSettings[index].group,
            status: newValue ? 1 : 0,
          );
          Navigator.pop(context);
          if (res is NotificationSettingsModal) {
            //data = res;
          }
        },
      );
    }
  }

  Widget _listOptions(NotificationSettingModal settingOption, int index) {
    if (settingOption.options == null) {
      return Container();
    } else if (settingOption.options.length == 0) {
      return Container();
    } else {
      return Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: settingOption.options.length,
          itemBuilder: (cntxt, subIndex) {
            return Container(
              padding: EdgeInsets.only(top: 5, left: 20),
              child: _option(
                settingOption.options[subIndex],
                index,
                subIndex,
              ),
            );
          },
        ),
      );
    }
  }

  Widget _option(NotificationOptionModal option, int index, int subIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          option.title,
          style: TextStyle(
            color: colours.bodyTextColour().withOpacity(0.8),
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 18,
          ),
        ),
        _subSwitch(option, index, subIndex),
      ],
    );
  }

  Widget _subSwitch(NotificationOptionModal option, int index, int subIndex) {
    int status = data.notificationSettings[index].options[subIndex].status;
    if (status == null) {
      return Container();
    } else {
      return Switch(
        value: status == 0 ? false : true,
        activeColor: colours.headlineColour(),
        inactiveThumbColor: Colors.grey[350],
        onChanged: (newValue) async {
          data.notificationSettings[index].options[subIndex].status =
              newValue ? 1 : 0;
          setState(() {});
          Loader.showLoading(context);
          var res = await bloc.updateSettings(
            key: data.notificationSettings[index].options[subIndex].key,
            group: data.notificationSettings[index].group,
            status: newValue ? 1 : 0,
          );
          Navigator.pop(context);
          if (res is NotificationSettingsModal) {
            //data = res;
          }
        },
      );
    }
  }
}
