import 'package:agape/src/screens/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/discipleship_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/discipleship_responses.dart';
import '../widgets/spacer.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import 'navigation_drawer.dart';

class DiscipleshipLibraryScreen extends StatelessWidget {
  final ClubColourModeModal colours = Setting().colours();
  final String libraryId;
  final String libraryTitle;
  final DiscipleshipBloc discipleshipBloc;

  DiscipleshipLibraryScreen(
      {@required this.libraryId,
      @required this.libraryTitle,
      @required this.discipleshipBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: _backButton(context),
      title: Text(
        libraryTitle,
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

  Widget _body(BuildContext context) {
    //podcastBloc.fetchLibraryDetails(library.id.toString());
    return FutureBuilder(
      future: discipleshipBloc.fetchLibraryDetails(libraryId),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          if (data is DiscipleshipLibraryDetailModal) {
            String headerImage = data.coverImageUrl;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _header(context, headerImage, data.title),
                  _podcastList(
                      context, data.discipleships, headerImage, data.title),
                  Space(verticle: 30),
                ],
              ),
            );
          }
          return Text('Server Response Error');
        } else {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        }
      },
    );
  }

  Widget _header(BuildContext context, String url, String title) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.width * 0.4,
          child: Image.network(url, fit: BoxFit.cover),
        ),
        SizedBox(
          width: size.width,
          height: size.width * 0.4,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Constants.FONT_FAMILY_TIMES,
                  fontSize: 40,
                  color: Colors.white,
                  shadows: <Shadow>[
                    // Shadow(
                    //   offset: Offset(0, 0),
                    //   blurRadius: 5.0,
                    //   color: Colors.grey[800],
                    // ),
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 8.0,
                      color: Colors.grey[900],
                    ),
                    // Shadow(
                    //   offset: Offset(10.0, 10.0),
                    //   blurRadius: 8.0,
                    //   color: Color.fromARGB(125, 0, 0, 255),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _podcastList(BuildContext context,
      List<DiscipleshipModal> discipleships, String headerImage, String title) {
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(right: 10),
      itemCount: discipleships.length,
      itemBuilder: (cntxt, index) {
        String titleImage = headerImage;
        // if (discipleships[index].co != '') {
        //   titleImage = discipleships[index].coverImageUrl;
        // }
        return GestureDetector(
          child: _listItem(discipleships[index], titleImage),
          onTap: () async {
            String mode = Setting().mode() == ColourModes.day ? 'day' : 'night';
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                          title: discipleships[index].title,
                          url: '${discipleships[index].webUrl}&mode=$mode',
                        )));
          },
        );
      },
      separatorBuilder: (cntxt, index) {
        return Divider(height: 2);
      },
    );
  }

  Widget _listItem(DiscipleshipModal discipleship, String headerImage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _listImage(headerImage),
        Space(horizontal: 5),
        Expanded(child: _listInfo(discipleship)),
      ],
    );
  }

  Widget _listImage(String imageUrl) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Center(
        child: SizedBox(
          width: 70,
          height: 70,
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _listInfo(DiscipleshipModal discipleship) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Space(verticle: 20),
        _title(discipleship.title),
        Space(verticle: 2),
        //_description(podcast.shortDescription),
        Space(verticle: 10),
      ],
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: Constants.FONT_FAMILY_FUTURA,
        fontSize: 18,
        color: colours.bodyTextColour(),
      ),
    );
  }

  // Widget _description(String text) {
  //   return Text(
  //     text,
  //     style: TextStyle(
  //       color: colours.bodyTextColour().withOpacity(0.8),
  //       fontFamily: Constants.FONT_FAMILY_FUTURA,
  //       fontSize: 14,
  //     ),
  //   );
  // }
}
