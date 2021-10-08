import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../bloc/discipleship_provider.dart';
import '../bloc/general_provider.dart';
// import '../bloc/notification_provider.dart';
import '../modals/discipleship_responses.dart';
import '../modals/error_response.dart';
import '../widgets/alert.dart';
import '../widgets/spacer.dart';
// import '../widgets/club_icon.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import 'discipleship_library.dart';
import 'navigation_drawer.dart';
import 'webview.dart';
// import 'notifications.dart';

class DiscipleshipScreen extends StatefulWidget {
  @override
  State<DiscipleshipScreen> createState() {
    return _DiscipleshipScreenState();
  }
}

class _DiscipleshipScreenState extends State<DiscipleshipScreen>
    with AutomaticKeepAliveClientMixin<DiscipleshipScreen> {
  ClubColourModeModal colours = Setting().colours();
  ScrollController scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    colours = Setting().colours();
    final DiscipleshipBloc discipleshipBloc = DiscipleshipProvider.of(context);
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context, discipleshipBloc),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: _backButton(context),
      title: Text(
        'Discipleship',
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

  // Widget _notificationIcon() {
  //   return GestureDetector(
  //     child: Container(
  //       // width: 30,
  //       // height: 30,
  //       color: Colors.transparent,
  //       padding: EdgeInsets.fromLTRB(10, 0, 7, 0),
  //       child: Icon(
  //         Icons.notifications_rounded,
  //         size: 30,
  //         color: colours.bgColour(),
  //       ),
  //     ),
  //     onTap: () {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (_) =>
  //                   NotificationProvider(child: NotificationsScreen())));
  //     },
  //   );
  // }

  Widget _menuIcon() {
    return GestureDetector(
      child: Container(
        // width: 30,
        // height: 30,
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(7, 0, 15, 0),
        child: Icon(
          Icons.menu_rounded,
          size: 30,
          color: colours.bgColour(),
        ),
      ),
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }

  Widget _body(BuildContext context, DiscipleshipBloc discipleshipBloc) {
    // print('Building Podcasts Tab');
    return FutureBuilder(
      future: discipleshipBloc.fetchLibraries(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data is DiscipleshipLibraries) {
            return _viewBuilder(context, discipleshipBloc, data);
          } else if (data is ErrorResponseModel) {
            Alert.defaultAlert(context, 'Error', data.message);
          }
          return Text('');
        } else {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        }
      },
    );
  }

  Widget _viewBuilder(BuildContext context, DiscipleshipBloc discipleshipBloc,
      DiscipleshipLibraries librariesData) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          _header(context, librariesData.discipleshipCoverImage),
          Space(verticle: 10),
          _libraries(context, discipleshipBloc, librariesData),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String imageUrl) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.width * 0.4,
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }

  Widget _libraries(BuildContext context, DiscipleshipBloc discipleshipBloc,
      DiscipleshipLibraries librariesData) {
    final Size size = MediaQuery.of(context).size;
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 0.7,
      crossAxisCount: 2,
      children: List.generate(
        librariesData.discipleshipLibraries.length,
        (index) {
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5),
              child: _library(librariesData.discipleshipLibraries[index], size),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DiscipleshipLibraryScreen(
                          libraryId: librariesData
                              .discipleshipLibraries[index].id
                              .toString(),
                          libraryTitle:
                              librariesData.discipleshipLibraries[index].title,
                          discipleshipBloc: discipleshipBloc)));
            },
          );
        },
      ),
    );
  }

  Widget _library(DiscipleshipLibrary discipleshipLibrary, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width * 0.45,
          height: size.width * 0.45,
          child: Image.network(discipleshipLibrary.coverImageUrl,
              fit: BoxFit.cover),
        ),
        // Image.network(mediaUrl + podcastLibrary.coverImage, fit: BoxFit.cover),
        Space(verticle: 3),
        Text(
          discipleshipLibrary.title,
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colours.bodyTextColour(),
          ),
        ),
        Space(verticle: 1),
        Text(
          discipleshipLibrary.shortDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 14,
            fontWeight: FontWeight.w200,
            color: colours.bodyTextColour(),
          ),
        )
      ],
    );
  }
}
