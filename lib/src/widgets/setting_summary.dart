import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../modals/bible_responses.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import 'spacer.dart';

class SettingSummaryWidget extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();
  final BibleSettingsSummaryModal summary;
  final Function onReadPressed;

  SettingSummaryWidget({@required this.summary, @required this.onReadPressed});

  @override
  Widget build(BuildContext context) {
    return _summary(context);
  }

  Widget _summary(BuildContext context) {
    if (summary == null) {
      return Container();
    }
    return Column(
      children: [
        _title(),
        Space(verticle: 5),
        _description(context),
        Space(verticle: 10),
        _daysReadTitle(),
        Space(verticle: 10),
        _todaysReading(),
        Space(verticle: 20),
        _status(),
      ],
    );
  }

  Widget _title() {
    return Text(
      summary.title,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_TIMES,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: colours.headlineColour(),
      ),
    );
  }

  Widget _description(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.7,
      child: Text(
        summary.description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          fontSize: 15,
          fontWeight: FontWeight.w200,
          color: colours.bodyTextColour(),
        ),
      ),
    );
  }

  Widget _daysReadTitle() {
    return Text(
      summary.daysReadTitle,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 13,
        fontWeight: FontWeight.w200,
        color: colours.bodyTextColour(),
      ),
    );
  }

  Widget _todaysReading() {
    Widget readStatus = summary.todayReadingTick
        ? Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.check_circle,
              color: colours.headlineColour(),
            ))
        : TextButton(onPressed: onReadPressed, child: _readButton());
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          child: CustomPaint(
            painter: Arc(
              fillPercent: 1,
              strokeColour: colours.bodyTextColour().withOpacity(0.2),
              strokeWidth: 2,
            ),
            //painter: Arc(fillPercent: 0.75),
          ),
        ),
        Container(
          width: 150,
          height: 150,
          child: CustomPaint(
            painter: Arc(
              fillPercent: summary.readInWeek / summary.noOfDays,
              strokeColour: colours.accentColour(),
              strokeWidth: 3,
            ),
            //painter: Arc(fillPercent: 0.75),
          ),
        ),
        Column(
          children: [
            Text(
              summary.todayReadingText,
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: colours.headlineColour(),
              ),
            ),
            readStatus,
          ],
        ),
      ],
    );
  }

  Widget _readButton() {
    return Container(
      height: 26,
      width: 60,
      // padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
      // margin: EdgeInsets.fromLTRB(8, 8, 8, 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: colours.accentColour(),
      ),
      child: Center(
        child: Text(
          'Read',
          style: TextStyle(
            color: colours.bgColour(),
            fontFamily: Constants.FONT_FAMILY_FUTURA,
          ),
        ),
      ),
    );
  }

  Widget _status() {
    List<BibleReadingListingsModal> statusList = [];
    if (summary.readingListings != null) {
      statusList = summary.readingListings;
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: statusList.length,
      itemBuilder: (cntxt, index) {
        return Container(
          padding: EdgeInsets.fromLTRB(40, 8, 40, 8),
          child: _statusListItem(summary.readingListings[index].label,
              summary.readingListings[index].value),
        );
      },
    );
  }

  Widget _statusListItem(String label, String value) {
    String labeL = label == '' ? '' : '$label: ';
    if ((value == null) || (value == '')) {
      labeL.replaceAll(':', '');
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: labeL,
            style: TextStyle(
              color: colours.bodyTextColour(),
              fontSize: 18,
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: colours.bodyTextColour(),
              fontSize: 18,
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class Arc extends CustomPainter {
  final double fillPercent;
  final Color strokeColour;
  final double strokeWidth;

  Arc(
      {@required this.fillPercent,
      @required this.strokeColour,
      @required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    var start = -math.pi / 2;
    var paint1 = Paint()
      ..color = strokeColour
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    //draw arc
    canvas.drawArc(
        Offset(0, 0) & Size(150, 150),
        start, //radians
        ((-math.pi * 2) * fillPercent), //radians
        false,
        paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
