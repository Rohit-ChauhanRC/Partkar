import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:intl/intl.dart';
import '../bloc/meeting_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/error_response.dart';
import '../modals/meeting_responses.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../widgets/spacer.dart';
import 'navigation_drawer.dart';

class MeetingsScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  MeetingsScreen({@required this.generalBloc});

  @override
  State<StatefulWidget> createState() {
    return _MeetingsScreenState(generalBloc: generalBloc);
  }
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  ClubColourModeModal colours = Setting().colours();
  final GeneralBloc generalBloc;
  ScrollController scrollController = ScrollController();

  _MeetingsScreenState({@required this.generalBloc});

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
    final MeetingBloc meetingBloc = MeetingProvider.of(context);

    return FutureBuilder(
      future: meetingBloc.fetchMeetings(),
      builder: (settingContext, snapshot) {
        if (!(snapshot.hasData)) {
          // if (snapshot.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        } else {
          final data = snapshot.data;
          if (data is ErrorResponseModel) {
            return Center(child: Text(data.message));
          } else if (data is List<MeetingModal>) {
            return _listBuilder(context, data);
          } else {
            return Center(child: Text('Error, Try again later.'));
          }
        }
      },
    );
  }

  Widget _listBuilder(BuildContext context, List<MeetingModal> meetings) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: ListView.builder(
        controller: scrollController,
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: _itemDecoration(),
              child: _listItem(context, meetings[index]),
            ),
            onTap: () {
              // print('Item Selected');
              // _listItemSelected(context, schedule[index]);
            },
          );
        },
      ),
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

  Widget _listItem(BuildContext context, MeetingModal meeting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dateTime(meeting.meetingDate, meeting.startTime),
        Space(verticle: 3),
        _topic(meeting.topic),
        //Space(verticle: 5),
        _description(meeting.description)
        //Expanded(child: _optionText(schedule)),
      ],
    );
  }

  Widget _dateTime(String date, String time) {
    // Input date Format
    final givenFormat = DateFormat("yyyy-MM-dd");
    DateTime givenDate = givenFormat.parse(date);
    final DateFormat newFormat = DateFormat('EEEE, MMMM d, yyyy');
    // Output Date Format
    final String formattedDate = newFormat.format(givenDate);

    // Input date Format
    final givenTimeFormat = DateFormat("HH:mm:ss");
    DateTime givenTime = givenTimeFormat.parse(time);
    final DateFormat newTimeFormat = DateFormat('h:mm a');
    // Output Date Format
    final String formattedTime = newTimeFormat.format(givenTime);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '$formattedDate, $formattedTime',
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: 16,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w200,
          color: colours.bodyTextColour(),
        ),
      ),
    );
  }

  Widget _topic(String topic) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        topic,
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: 18,
          color: colours.headlineColour(),
        ),
      ),
    );
  }

  Widget _description(String description) {
    // return Text(
    //   description,
    //   style: TextStyle(
    //     fontFamily: Constants.FONT_FAMILY_FUTURA,
    //     fontSize: 16,
    //     fontWeight: FontWeight.w200,
    //   ),
    // );
    return Html(
      data: description,
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
}
