import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../bloc/podcast_provider.dart';
import '../bloc/general_provider.dart';
import '../bloc/notification_provider.dart';
import '../modals/podcast_responses.dart';
import '../modals/error_response.dart';
import '../widgets/alert.dart';
import '../widgets/spacer.dart';
// import '../widgets/club_icon.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import 'podcast_library.dart';
import 'navigation_drawer.dart';
import 'notifications.dart';

class PodcastsTabScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  PodcastsTabScreen({@required this.generalBloc});

  @override
  State<PodcastsTabScreen> createState() {
    return _PodcastsTabScreenState(generalBloc: generalBloc);
  }
}

class _PodcastsTabScreenState extends State<PodcastsTabScreen>
    with AutomaticKeepAliveClientMixin<PodcastsTabScreen> {
  ClubColourModeModal colours = Setting().colours();
  ScrollController scrollController = ScrollController();
  final GeneralBloc generalBloc;

  _PodcastsTabScreenState({@required this.generalBloc});

  @override
  bool get wantKeepAlive => true;

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

  Future<bool> _onPop() async {
    Helper.HOME_BACK_CLICKED = true;
    Helper.HANDLE_BACK(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    colours = Setting().colours();
    final PodcastBloc podcastBloc = PodcastProvider.of(context);
    //podcastBloc.fetchLibraries();
    return WillPopScope(
      child: Scaffold(
        appBar: _appBar(),
        body: _body(context, podcastBloc),
        endDrawer: GeneralProvider(child: NavigationDrawer()),
        backgroundColor: colours.bgColour(),
      ),
      onWillPop: _onPop,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Podcasts',
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      iconTheme: IconThemeData(color: colours.bgColour()),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      // leading: ClubIconWidget(),
      actions: [_notificationIcon(), _menuIcon()],
    );
  }

  Widget _notificationIcon() {
    return GestureDetector(
      child: Container(
        // width: 30,
        // height: 30,
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(10, 0, 7, 0),
        child: Icon(
          Icons.notifications_rounded,
          size: 30,
          color: colours.bgColour(),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    NotificationProvider(child: NotificationsScreen())));
      },
    );
  }

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

  Widget _body(BuildContext context, PodcastBloc podcastBloc) {
    // print('Building Podcasts Tab');
    return FutureBuilder(
      future: podcastBloc.fetchLibraries(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data is PodcastLibraries) {
            return _viewBuilder(context, podcastBloc, data);
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

  Widget _viewBuilder(BuildContext context, PodcastBloc podcastBloc,
      PodcastLibraries librariesData) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          _header(context, librariesData.podcastCoverImage),
          Space(verticle: 10),
          _libraries(context, podcastBloc, librariesData),
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

  Widget _libraries(BuildContext context, PodcastBloc podcastBloc,
      PodcastLibraries librariesData) {
    final Size size = MediaQuery.of(context).size;
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 0.7,
      crossAxisCount: 2,
      children: List.generate(
        librariesData.podcastsLibraries.length,
        (index) {
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5),
              child: _library(librariesData.podcastsLibraries[index],
                  librariesData.mediaUrl, size),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PodcastLibraryScreen(
                          libraryId: librariesData.podcastsLibraries[index].id
                              .toString(),
                          libraryTitle:
                              librariesData.podcastsLibraries[index].title,
                          podcastBloc: podcastBloc)));
            },
          );
        },
      ),
    );
  }

  Widget _library(PodcastLibrary podcastLibrary, String mediaUrl, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width * 0.45,
          height: size.width * 0.45,
          child: Image.network(mediaUrl + podcastLibrary.coverImage,
              fit: BoxFit.cover),
        ),
        // Image.network(mediaUrl + podcastLibrary.coverImage, fit: BoxFit.cover),
        Space(verticle: 3),
        Text(
          podcastLibrary.title,
          style: TextStyle(
            fontFamily: Constants.FONT_FAMILY_FUTURA,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colours.bodyTextColour(),
          ),
        ),
        Space(verticle: 1),
        Text(
          podcastLibrary.shortDescription,
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
