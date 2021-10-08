import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'bible_chapters.dart';
import '../bloc/bible_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/error_response.dart';
import '../modals/bible_responses.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import 'navigation_drawer.dart';

class BibleScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  BibleScreen({@required this.generalBloc});

  @override
  State<StatefulWidget> createState() {
    return _BibleScreenState(generalBloc: generalBloc);
  }
}

class _BibleScreenState extends State<BibleScreen>
    with AutomaticKeepAliveClientMixin<BibleScreen> {
  ClubColourModeModal colours = Setting().colours();
  final GeneralBloc generalBloc;
  ScrollController scrollController = ScrollController();

  _BibleScreenState({@required this.generalBloc});

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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    colours = Setting().colours();
    // colours = Setting().colours();
    return Scaffold(
      body: _uiBuilder(context),
      endDrawer: NavigationDrawer(),
      backgroundColor: colours.bgColour(),
    );
  }

  Widget _uiBuilder(BuildContext context) {
    // print('Building Bible Tab');
    final BibleBloc bibleBloc = BibleProvider.of(context);
    bibleBloc.fetchBible();
    return StreamBuilder(
      stream: bibleBloc.bible,
      builder: (context, snapshot) {
        if (!(snapshot.hasData)) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        } else {
          final data = snapshot.data;
          if (data is ErrorResponseModel) {
            return Text(data.message,
                style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA));
          } else if (data is BibleDataModal) {
            //return _bibleList(context, data);
            //return _expandablePanelList(context, data);
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Divider(),
                  _bibleList(context, data.bible),
                  _copyrightText(data.lsmCopyright),
                ],
              ),
            );
          } else {
            return Text('Fetching Data....',
                style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA));
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

  Widget _bibleList(BuildContext context, List<BibleModal> bibles) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: bibles.length,
      itemBuilder: (cntxt, index) {
        //return _listTile(context, bibles[index]);
        return _expandableListTile(context, bibles[index]);
      },
    );
  }

  Widget _expandableListTile(BuildContext context, BibleModal bible) {
    return ExpansionTile(
      title: Text(
        bible.title,
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          color: colours.bodyTextColour(),
        ),
      ),
      children: [
        _books(context, bible),
      ],
    );
  }

  Widget _books(BuildContext context, BibleModal bible) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 3,
      children: List.generate(bible.books.length, (index) {
        return GestureDetector(
          child: Container(
            child: Text(
              bible.books[index].name,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                color: colours.bodyTextColour(),
              ),
            ),
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
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
                    builder: (_) => BibleChaptersScreen(
                        title: bible.books[index].name,
                        chapters: bible.books[index].bookChapters)));
          },
        );
      }),
    );
  }
}
