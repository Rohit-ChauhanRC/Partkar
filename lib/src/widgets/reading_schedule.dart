import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import '../bloc/bible_reading_schedule_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/bible_responses.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../screens/bible_schedule_reading.dart';
import '../screens/bible_schedule_read.dart';
import 'spacer.dart';

class ReadingScheduleWidget extends StatefulWidget {
  final BibleReadingScheduleBloc bloc;
  final List<BibleReadingScheduleModal> scheduleList;
  final Function reloadData;
  final GeneralBloc generalBloc;

  ReadingScheduleWidget({
    @required this.bloc,
    @required this.scheduleList,
    @required this.reloadData,
    @required this.generalBloc,
  });

  @override
  State<StatefulWidget> createState() {
    return _ReadingScheduleWidgetState(
      bloc: bloc,
      scheduleList: scheduleList,
      reloadData: reloadData,
      generalBloc: generalBloc,
    );
  }
}

class _ReadingScheduleWidgetState extends State<ReadingScheduleWidget> {
  final ClubColourModeModal colours = Setting().colours();
  final BibleReadingScheduleBloc bloc;
  List<BibleReadingScheduleModal> scheduleList;
  final Function reloadData;
  final GeneralBloc generalBloc;
  ScrollController scrollController = ScrollController();
  bool isloading = false;

  _ReadingScheduleWidgetState({
    @required this.bloc,
    @required this.scheduleList,
    @required this.reloadData,
    @required this.generalBloc,
  });

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return _listBuilder(context);
  }

  void scrollListener() {
    if (scrollController.position.atEdge &&
        (scrollController.position.pixels != 0)) {
      // print('Fetch more data');
      _fetchMoreData();
    }
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
  }

  void _fetchMoreData() async {
    if (!isloading) {
      isloading = true;
      setState(() {});
      // print('Fetching more data');
      String lastDateString = scheduleList.last.date;
      DateTime lastDate =
          DateTime.parse(lastDateString).subtract(Duration(days: 1));
      // print(lastDate.subtract(Duration(days: 1)));
      final givenFormat = DateFormat("yyyy-MM-dd");
      final String formattedDate = givenFormat.format(lastDate);
      var data = await bloc.fetch(formattedDate);
      if (data is List<BibleReadingScheduleModal>) {
        scheduleList += data;
      }
      isloading = false;
      setState(() {});
    }
  }

  Widget _listBuilder(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: ListView.builder(
        controller: scrollController,
        itemCount: scheduleList.length + 1,
        itemBuilder: (context, index) {
          if (index == scheduleList.length) {
            return _paginationLoader();
          }
          return GestureDetector(
            child: Container(
              decoration: _itemDecoration(),
              child: _listItem(context, scheduleList[index]),
            ),
            onTap: () {
              // print('Item Selected');
              _listItemSelected(context, scheduleList[index]);
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

  Widget _paginationLoader() {
    if (isloading) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 60,
          width: 60,
          child: Container(
            margin: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                colours.bodyTextColour(),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 60,
        width: 60,
      );
    }
  }

  Widget _listItem(BuildContext context, BibleReadingScheduleModal schedule) {
    bool readStatus = true;
    for (BibleReadingModal reading in schedule.readings) {
      if (!reading.isRead) {
        readStatus = false;
        break;
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Space(horizontal: 25),
        _date(schedule.dayDate),
        Space(horizontal: 15),
        Expanded(child: _optionText(schedule)),
        Space(horizontal: 5),
        _readStatus(readStatus),
        Space(horizontal: 10),
      ],
    );
  }

  Widget _date(String dayDate) {
    String day = dayDate.split(' ')[0];
    String date = dayDate.split(' ')[1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Space(verticle: 15),
        Text(
          day,
          style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 18,
              color: colours.bodyTextColour()),
        ),
        Text(
          date,
          style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontSize: 26,
              color: colours.bodyTextColour()),
        ),
        Space(verticle: 20),
      ],
    );
  }

  Widget _optionText(BibleReadingScheduleModal schedule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Space(verticle: 15),
        _title(schedule),
        Space(verticle: 2),
        _description(schedule),
        Space(verticle: 10),
      ],
    );
  }

  Widget _title(BibleReadingScheduleModal schedule) {
    return Text(
      schedule.day,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _description(BibleReadingScheduleModal schedule) {
    String descr = '';
    for (BibleReadingModal reading in schedule.readings) {
      if (descr == '') {
        descr = descr + reading.portionShortName;
      } else {
        descr = descr + '; ${reading.portionShortName}';
      }
    }
    return Text(
      descr,
      // overflow: TextOverflow.ellipsis,
      // softWrap: false,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 14,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _readStatus(bool isRead) {
    if (isRead) {
      return Container(
        margin: EdgeInsets.only(top: 25),
        child: Icon(Icons.check_circle, color: colours.accentColour()),
      );
    } else {
      return Container(
        height: 26,
        width: 70,
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: colours.accentColour(),
        ),
        child: Center(
          child: Text(
            'Read',
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              color: colours.bgColour(),
            ),
          ),
        ),
      );
    }
  }

  void _listItemSelected(
      BuildContext context, BibleReadingScheduleModal schedule) async {
    bool readStatus = true;
    for (BibleReadingModal reading in schedule.readings) {
      if (!reading.isRead) {
        readStatus = false;
        break;
      }
    }
    if (readStatus) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  BibleScheduleReadingScreen(bloc: bloc, schedule: schedule)));
    } else {
      bool reload = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => BibleScheduleReadScreen(
                    bloc: bloc,
                    readings: schedule.readings,
                    scheduleId: schedule.scheduleId.toString(),
                  )));
      if ((reload != null) && reload) {
        reloadData();
        // Navigator.pop(context);
      }
    }
  }
}
