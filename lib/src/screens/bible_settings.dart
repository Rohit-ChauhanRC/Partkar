import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../bloc/bible_settings_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/error_response.dart';
import '../modals/bible_responses.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../widgets/spacer.dart';
import '../widgets/loader.dart';
import '../widgets/alert.dart';
import '../widgets/setting_summary.dart';
import 'navigation_drawer.dart';

class BibleSettingsScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  BibleSettingsScreen({@required this.generalBloc});

  @override
  BibleSettingsScreenState createState() =>
      BibleSettingsScreenState(generalBloc: generalBloc);
}

class BibleSettingsScreenState extends State<BibleSettingsScreen> {
  ClubColourModeModal colours = Setting().colours();
  final GeneralBloc generalBloc;
  ScrollController scrollController = ScrollController();
  String _selectedSetting = '';

  BibleSettingsScreenState({@required this.generalBloc});

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

  @override
  Widget build(BuildContext context) {
    colours = Setting().colours();
    return Scaffold(
      body: _uiBuilder(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  Widget _uiBuilder(BuildContext context) {
    // print('Building Bible Settings');
    final BibleSettingsBloc bibleSettingsBloc =
        BibleSettingsProvider.of(context);
    return FutureBuilder(
      future: bibleSettingsBloc.fetch(),
      builder: (settingContext, snapshot) {
        if (!(snapshot.hasData)) {
          //if (snapshot.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        } else {
          final data = snapshot.data;
          if (data is ErrorResponseModel) {
            return Center(child: Text(data.message));
          } else if (data is BibleSettingsModal) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  _listBuilder(bibleSettingsBloc, context, data),
                  Space(verticle: 50),
                  SettingSummaryWidget(
                    summary: data.summary,
                    onReadPressed: () {
                      // print('pressed');
                      DefaultTabController.of(context).animateTo(0);
                    },
                  ),
                  Space(verticle: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: _copyrightText(data.lsmCopyright),
                  ),
                  Space(verticle: 30),
                ],
              ),
            );
          } else {
            return Center(child: Text('Error, Try again later...'));
          }
        }
      },
    );
  }

  Widget _copyrightText(String copyright) {
    return Text(
      copyright,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontStyle: FontStyle.italic,
        fontSize: 14,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _listBuilder(BibleSettingsBloc bloc, BuildContext context,
      BibleSettingsModal settings) {
    if (_selectedSetting == '') _selectedSetting = settings.selectedSetting;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: settings.settings.length,
        itemBuilder: (context, index) {
          // return _listItem(bloc, context, settings.selectedSetting,
          //     settings.settings[index]);
          return _listItem(
              bloc, context, _selectedSetting, settings.settings[index]);
        },
      ),
    );
  }

  Widget _listItem(BibleSettingsBloc bloc, BuildContext context,
      String selectedSetting, BibleSettingModal setting) {
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Space(horizontal: 15),
          _itemIcon(setting, selectedSetting),
          Space(horizontal: 10),
          Expanded(child: _optionText(bloc, setting, selectedSetting)),
        ],
      ),
      onTap: () async {
        final settingType = setting.type; //just_track
        if (settingType == 'just_track') {
          if (setting.chapters.length > 0) {
            final st = setting.chapters[0].id.toString();
            _updateSettings(bloc, st);
          }
          return;
        }
        _updateSettings(bloc, settingType);
      },
    );
  }

  Widget _itemIcon(BibleSettingModal setting, String selectedSetting) {
    bool markSelected = selectedSetting == setting.type;
    IconData icon =
        markSelected ? Icons.check_box : Icons.check_box_outline_blank;

    if (setting.type == 'just_track') {
      if (setting.chapters != null) {
        for (BibleSettingChapterModal chapter in setting.chapters) {
          if (chapter.id.toString() == selectedSetting) {
            icon = Icons.check_box;
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Space(verticle: 15),
        Icon(icon, color: colours.accentColour()),
      ],
    );
  }

  Widget _optionText(BibleSettingsBloc bloc, BibleSettingModal setting,
      String selectedSetting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Space(verticle: 15),
        _title(setting.title),
        Space(verticle: 5),
        _description(setting.description),
        Space(verticle: 10),
        _chapters(bloc, setting.chapters, selectedSetting),
      ],
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _description(String description) {
    return Text(
      description,
      // overflow: TextOverflow.ellipsis,
      // softWrap: false,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 16,
        fontWeight: FontWeight.w200,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _chapters(BibleSettingsBloc bloc,
      List<BibleSettingChapterModal> chapters, String selectedSetting) {
    if (chapters == null) {
      return Container();
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: _chapterItem(chapters[index], selectedSetting),
          onTap: () {
            _updateSettings(bloc, chapters[index].id.toString());
          },
        );
      },
    );
  }

  Widget _chapterItem(
      BibleSettingChapterModal chapter, String selectedSetting) {
    IconData icon = (selectedSetting == chapter.id.toString())
        ? Icons.check_box
        : Icons.check_box_outline_blank;
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.transparent,
      child: Row(
        children: [
          Space(horizontal: 5),
          Icon(icon, color: colours.accentColour()),
          Space(horizontal: 5),
          Text(
            'Start with ${chapter.name}',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              color: colours.bodyTextColour(),
            ),
          )
        ],
      ),
    );
  }

  void _updateSettings(BibleSettingsBloc bloc, String settingType) async {
    _selectedSetting = settingType;
    Loader.showLoading(context);
    var response = await bloc.update(settingType);
    Navigator.pop(context);
    if (response is ErrorResponseModel) {
      Alert.defaultAlert(
          context, 'Error', 'Error while saving settings. Please try later.');
    } else {
      try {
        Helper.RELOAD_HOME_TAB();
      } catch (e) {}
      setState(() {});
    }
  }
}
