import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:intl/intl.dart';
import '../bloc/event_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/error_response.dart';
import '../modals/event_responses.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../widgets/spacer.dart';
import 'event_detail.dart';
import 'navigation_drawer.dart';

class EventsScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  EventsScreen({@required this.generalBloc});

  @override
  State<StatefulWidget> createState() {
    return _EventsScreenState(generalBloc: generalBloc);
  }
}

class _EventsScreenState extends State<EventsScreen> {
  ClubColourModeModal colours = Setting().colours();
  final GeneralBloc generalBloc;
  ScrollController scrollController = ScrollController();

  _EventsScreenState({@required this.generalBloc});

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
      body: _body(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  Widget _body(BuildContext context) {
    final EventBloc eventBloc = EventProvider.of(context);

    // print('Building Meetings Tab');
    return FutureBuilder(
      future: eventBloc.fetchEvents(),
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
          } else if (data is List<EventModal>) {
            return _listBuilder(context, data);
          } else {
            return Center(child: Text('Error, Try again later.'));
          }
        }
      },
    );
  }

  Widget _listBuilder(BuildContext context, List<EventModal> events) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: ListView.builder(
        controller: scrollController,
        itemCount: events.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: _itemDecoration(),
              child: _listItem(context, events[index]),
            ),
            onTap: () {
              // print('Item Selected');
              _listItemSelected(context, events[index]);
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

  Widget _listItem(BuildContext context, EventModal event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _date(event.startDate, event.endDate),
        Space(verticle: 3),
        _name(event.eventName),
        //Space(verticle: 5),
        _description(event.shortDescription),
        //Expanded(child: _optionText(schedule)),
        _continueButton(context),
        Space(verticle: 5),
      ],
    );
  }

  Widget _date(String startDate, String endDate) {
    // Input date Format
    final givenStartFormat = DateFormat("yyyy-MM-dd");
    DateTime givenStartDate = givenStartFormat.parse(startDate);
    final DateFormat newStartFormat = DateFormat('MMMM dd');
    // Output Date Format
    final String formattedStartDate = newStartFormat.format(givenStartDate);

    // Input date Format
    final givenEndFormat = DateFormat("yyyy-MM-dd");
    DateTime givenEndDate = givenEndFormat.parse(endDate);
    final DateFormat newEndFormat = DateFormat('dd, yyyy');
    // Output Date Format
    final String formattedEndDate = newEndFormat.format(givenEndDate);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '$formattedStartDate-$formattedEndDate',
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

  Widget _name(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        name,
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: 22,
          color: colours.headlineColour(),
        ),
      ),
    );
  }

  Widget _description(String description) {
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
          margin: EdgeInsets.zero,
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

  Widget _continueButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 24,
        width: 100,
        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: colours.accentColour(),
        ),
        child: Center(
          child: Text(
            'Read more...',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              color: colours.bgColour(),
            ),
          ),
        ),
      ),
    );
  }

  _listItemSelected(BuildContext context, EventModal event) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EventProvider(
                child: EventDetailScreen(eventId: event.id.toString()))));
  }
}
