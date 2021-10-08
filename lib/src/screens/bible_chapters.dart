import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/bible_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/bible_responses.dart';
import 'bible_chapter.dart';
import 'navigation_drawer.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';

class BibleChaptersScreen extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();
  final String title;
  final List<BookChapterModal> chapters;

  BibleChaptersScreen({@required this.title, @required this.chapters});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _uiBuilder(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: _backButton(context),
      title: Text(
        title,
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

  Widget _backButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: colours.bgColour(),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _uiBuilder(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     Chip(
          //       padding: EdgeInsets.all(0),
          //       label: Text('Reading Schedule'),
          //       backgroundColor: Colors.lightBlueAccent,
          //       labelStyle: TextStyle(fontSize: 12),
          //     ),
          //     Space(horizontal: 10),
          //     Chip(
          //       padding: EdgeInsets.all(0),
          //       label: Text('Bible'),
          //       backgroundColor: Colors.blue,
          //       labelStyle: TextStyle(fontSize: 12),
          //     ),
          //     Space(horizontal: 10),
          //     Chip(
          //       padding: EdgeInsets.all(0),
          //       label: Text('Settings'),
          //       backgroundColor: Colors.lightBlueAccent,
          //       labelStyle: TextStyle(fontSize: 12),
          //     ),
          //   ],
          // ),
          Divider(),
          _chapters(context),
        ],
      ),
    );
  }

  Widget _chapters(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 8,
      //childAspectRatio: 3,
      children: List.generate(chapters.length, (index) {
        return GestureDetector(
          child: Container(
            child: Text(
              (index + 1).toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                color: colours.bodyTextColour(),
              ),
              //textAlign: TextAlign.center,
            ),
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.only(left: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    colours.gradientStartColour(),
                    colours.gradientEndColour(),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BibleProvider(
                        child: BibleChapterScreen(
                            chapters: chapters, selectedIndex: index))));
          },
        );
      }),
    );
  }
}
